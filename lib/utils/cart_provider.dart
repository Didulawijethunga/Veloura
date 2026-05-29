import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _userId;
  final List<CartItem> _items = [];
  final List<Product> _wishlist = [];
  List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Product> get wishlist => _wishlist;
  List<Order> get orders => _orders;

  int get itemCount => _items.fold(0, (acc, i) => acc + i.quantity);
  double get subtotal => _items.fold(0.0, (acc, i) => acc + i.totalPrice);
  double get shipping => subtotal > 50 ? 0.0 : 4.99;
  double get tax => subtotal * 0.1;
  double get total => subtotal + shipping + tax;

  // Called by ChangeNotifierProxyProvider whenever AuthProvider updates
  void setUserId(String? uid) {
    if (_userId == uid) return;
    _userId = uid;
    _items.clear();
    _orders.clear();
    if (uid != null) {
      _loadCart();
      _loadOrders();
    } else {
      notifyListeners();
    }
  }

  // ── Cart persistence ─────────────────────────────────────────────────────

  Future<void> _loadCart() async {
    if (_userId == null) return;
    try {
      final snap = await _db
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .get();
      _items.clear();
      for (final doc in snap.docs) {
        _items.add(CartItem.fromMap(doc.data()));
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _persistCart() async {
    if (_userId == null) return;
    try {
      final cartRef =
          _db.collection('users').doc(_userId).collection('cart');
      final existing = await cartRef.get();
      final batch = _db.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      for (int i = 0; i < _items.length; i++) {
        batch.set(cartRef.doc('item_$i'), _items[i].toMap());
      }
      await batch.commit();
    } catch (_) {}
  }

  // ── Cart operations ───────────────────────────────────────────────────────

  Future<void> addToCart(
      Product product, String size, String color) async {
    final idx = _items.indexWhere(
        (i) => i.product.id == product.id && i.selectedSize == size);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(
          product: product, selectedSize: size, selectedColor: color));
    }
    notifyListeners();
    await _persistCart();
  }

  Future<void> removeFromCart(int index) async {
    _items.removeAt(index);
    notifyListeners();
    await _persistCart();
  }

  Future<void> updateQuantity(int index, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(index);
    } else {
      _items[index].quantity = quantity;
      notifyListeners();
      await _persistCart();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _persistCart();
  }

  // ── Wishlist (local only) ─────────────────────────────────────────────────

  bool isInWishlist(Product product) =>
      _wishlist.any((p) => p.id == product.id);

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  Future<void> _loadOrders() async {
    if (_userId == null) return;
    try {
      final snap = await _db
          .collection('orders')
          .where('userId', isEqualTo: _userId)
          .orderBy('date', descending: true)
          .get();
      _orders = snap.docs
          .map((doc) => Order.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> placeOrder(String address) async {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_items),
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      status: 'Processing',
      date: DateTime.now(),
      deliveryAddress: address,
    );

    // Save to Firestore if logged in
    if (_userId != null) {
      try {
        final docRef = await _db.collection('orders').add({
          ...order.toMap(),
          'userId': _userId,
        });
        // Use the Firestore-generated ID
        final savedOrder = Order.fromMap(docRef.id, {
          ...order.toMap(),
          'userId': _userId,
        });
        _orders.insert(0, savedOrder);
      } catch (_) {
        _orders.insert(0, order);
      }
    } else {
      _orders.insert(0, order);
    }

    await clearCart();
  }
}
