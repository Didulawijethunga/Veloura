import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  String? get error => _error;

  List<Product> getByCategory(String category) {
    if (category == 'All') return _products;
    // Handle display label → model category mapping
    final map = {'Woman': 'Women'};
    final modelCat = map[category] ?? category;
    return _products.where((p) => p.category == modelCat).toList();
  }

  List<Product> search(String query) {
    if (query.isEmpty) return _products;
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  List<Product> searchInCategory(String category, String query) {
    final base = getByCategory(category);
    if (query.isEmpty) return base;
    final q = query.toLowerCase();
    return base
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q))
        .toList();
  }

  Future<void> loadProducts() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snap = await _db.collection('products').get();
      if (snap.docs.isEmpty) {
        // Firestore is empty — seed from sample data and try once more
        await seedProducts();
        final seeded = await _db.collection('products').get();
        _products = seeded.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()))
            .toList();
      } else {
        _products =
            snap.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
      }
    } catch (e) {
      // Fallback to local sample products if Firestore is unreachable
      _products = sampleProducts;
      _error = 'Using offline product data.';
    }

    _hasLoaded = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Uploads all sample products to Firestore in a single batch.
  Future<void> seedProducts() async {
    try {
      final batch = _db.batch();
      for (final product in sampleProducts) {
        final ref = _db.collection('products').doc(product.id);
        batch.set(ref, product.toMap());
      }
      await batch.commit();
    } catch (_) {}
  }
}
