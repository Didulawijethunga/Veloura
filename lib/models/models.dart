import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Product ────────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
    this.rating = 4.5,
    this.reviewCount = 128,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;
  double get discountPercent =>
      isOnSale ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  /// Construct from a Firestore document snapshot
  factory Product.fromMap(String id, Map<String, dynamic> map) => Product(
        id: id,
        name: map['name'] as String? ?? '',
        brand: map['brand'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        originalPrice: map['originalPrice'] != null
            ? (map['originalPrice'] as num).toDouble()
            : null,
        imageUrl: map['imageUrl'] as String? ?? '',
        category: map['category'] as String? ?? 'All',
        description: map['description'] as String? ?? '',
        sizes: List<String>.from(map['sizes'] ?? []),
        colors: List<String>.from(map['colors'] ?? []),
        rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
        reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'brand': brand,
        'price': price,
        'originalPrice': originalPrice,
        'imageUrl': imageUrl,
        'category': category,
        'description': description,
        'sizes': sizes,
        'colors': colors,
        'rating': rating,
        'reviewCount': reviewCount,
      };
}

// ─── CartItem ───────────────────────────────────────────────────────────────

class CartItem {
  final Product product;
  int quantity;
  String selectedSize;
  String selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() => {
        'productId': product.id,
        'productName': product.name,
        'productBrand': product.brand,
        'productPrice': product.price,
        'productOriginalPrice': product.originalPrice,
        'productImageUrl': product.imageUrl,
        'productCategory': product.category,
        'productDescription': product.description,
        'productSizes': product.sizes,
        'productColors': product.colors,
        'productRating': product.rating,
        'productReviewCount': product.reviewCount,
        'quantity': quantity,
        'selectedSize': selectedSize,
        'selectedColor': selectedColor,
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        product: Product(
          id: map['productId'] as String,
          name: map['productName'] as String,
          brand: map['productBrand'] as String,
          price: (map['productPrice'] as num).toDouble(),
          originalPrice: map['productOriginalPrice'] != null
              ? (map['productOriginalPrice'] as num).toDouble()
              : null,
          imageUrl: map['productImageUrl'] as String,
          category: map['productCategory'] as String,
          description: map['productDescription'] as String,
          sizes: List<String>.from(map['productSizes'] ?? []),
          colors: List<String>.from(map['productColors'] ?? []),
          rating: (map['productRating'] as num?)?.toDouble() ?? 4.5,
          reviewCount: (map['productReviewCount'] as num?)?.toInt() ?? 0,
        ),
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        selectedSize: map['selectedSize'] as String,
        selectedColor: map['selectedColor'] as String,
      );
}

// ─── Order ──────────────────────────────────────────────────────────────────

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String status;
  final DateTime date;
  final String deliveryAddress;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    this.shipping = 0,
    required this.tax,
    required this.total,
    required this.status,
    required this.date,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toMap() => {
        'items': items.map((i) => i.toMap()).toList(),
        'subtotal': subtotal,
        'shipping': shipping,
        'tax': tax,
        'total': total,
        'status': status,
        'date': Timestamp.fromDate(date),
        'deliveryAddress': deliveryAddress,
      };

  factory Order.fromMap(String id, Map<String, dynamic> map) => Order(
        id: id,
        items: (map['items'] as List<dynamic>? ?? [])
            .map((i) => CartItem.fromMap(Map<String, dynamic>.from(i as Map)))
            .toList(),
        subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
        shipping: (map['shipping'] as num?)?.toDouble() ?? 0,
        tax: (map['tax'] as num?)?.toDouble() ?? 0,
        total: (map['total'] as num?)?.toDouble() ?? 0,
        status: map['status'] as String? ?? 'Processing',
        date: map['date'] is Timestamp
            ? (map['date'] as Timestamp).toDate()
            : DateTime.now(),
        deliveryAddress: map['deliveryAddress'] as String? ?? '',
      );
}

// ─── Sample Products (used for Firestore seeding) ──────────────────────────

final List<Product> sampleProducts = [
  const Product(
    id: 'p1',
    name: 'Denim Jacket',
    brand: 'Veloura',
    price: 89.99,
    originalPrice: 120.00,
    imageUrl: 'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=400',
    category: 'Women',
    description: 'A classic denim jacket with a modern cut. Perfect for layering over any outfit, featuring premium washed denim fabric.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Blue', 'Black', 'White'],
    rating: 4.7,
    reviewCount: 245,
  ),
  const Product(
    id: 'p2',
    name: 'Wide Leg Jeans',
    brand: 'Veloura',
    price: 69.99,
    originalPrice: 95.00,
    imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
    category: 'Women',
    description: 'Trendy wide-leg jeans with a high waist silhouette. Made from sustainable denim blend.',
    sizes: ['24', '26', '28', '30', '32'],
    colors: ['Light Blue', 'Dark Blue', 'Black'],
    rating: 4.5,
    reviewCount: 312,
  ),
  const Product(
    id: 'p3',
    name: 'Trench Coat',
    brand: 'Veloura',
    price: 199.99,
    originalPrice: 280.00,
    imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    category: 'Women',
    description: 'A timeless trench coat featuring a double-breasted design. Water-resistant fabric for all-weather wear.',
    sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Beige', 'Khaki', 'Black'],
    rating: 4.8,
    reviewCount: 156,
  ),
  const Product(
    id: 'p4',
    name: 'Mini Dress',
    brand: 'Veloura',
    price: 54.99,
    imageUrl: 'https://images.unsplash.com/photo-1596783074918-c84cb06531ca?w=400',
    category: 'Women',
    description: 'A flirty mini dress with a smocked bodice and flutter sleeves. Perfect for summer occasions.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['Floral', 'Pink', 'Yellow'],
    rating: 4.3,
    reviewCount: 87,
  ),
  const Product(
    id: 'p5',
    name: 'Floral Midi Skirt',
    brand: 'Veloura',
    price: 49.99,
    originalPrice: 72.00,
    imageUrl: 'https://images.unsplash.com/photo-1571513722275-4b41940f54b8?w=400',
    category: 'Women',
    description: 'A beautiful floral midi skirt with an A-line silhouette. Features a comfortable elastic waistband and flowy fabric.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Floral Blue', 'Floral Pink', 'Floral Green'],
    rating: 4.6,
    reviewCount: 178,
  ),
  const Product(
    id: 'p6',
    name: 'Ribbed Knit Sweater',
    brand: 'Veloura',
    price: 64.99,
    imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400',
    category: 'Women',
    description: 'A cozy ribbed knit sweater in a relaxed fit. Made from a soft wool-blend that keeps you warm all season.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['Cream', 'Sage', 'Dusty Rose', 'Camel'],
    rating: 4.8,
    reviewCount: 234,
  ),
  const Product(
    id: 'p7',
    name: 'Linen Blazer',
    brand: 'Veloura',
    price: 119.99,
    originalPrice: 160.00,
    imageUrl: 'https://images.unsplash.com/photo-1548624313-0396c75e4b1a?w=400',
    category: 'Women',
    description: 'A relaxed linen blazer that transitions effortlessly from office to weekend. Lightweight and breathable.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['White', 'Beige', 'Black', 'Navy'],
    rating: 4.7,
    reviewCount: 145,
  ),
  const Product(
    id: 'p8',
    name: 'Wrap Maxi Dress',
    brand: 'Veloura',
    price: 79.99,
    imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400',
    category: 'Women',
    description: 'An elegant wrap maxi dress that flatters every figure.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Floral', 'Navy', 'Emerald'],
    rating: 4.5,
    reviewCount: 302,
  ),
  const Product(
    id: 'p9',
    name: 'High-Rise Leggings',
    brand: 'Veloura',
    price: 44.99,
    imageUrl: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=400',
    category: 'Women',
    description: 'Premium high-rise leggings with four-way stretch. Squat-proof fabric with a wide waistband.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Black', 'Navy', 'Burgundy', 'Dark Green'],
    rating: 4.9,
    reviewCount: 521,
  ),
  const Product(
    id: 'p10',
    name: 'Satin Slip Dress',
    brand: 'Veloura',
    price: 74.99,
    originalPrice: 99.99,
    imageUrl: 'https://images.unsplash.com/photo-1568252542512-9fe8fe9c87bb?w=400',
    category: 'Women',
    description: 'A luxurious satin slip dress with delicate lace trim.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['Champagne', 'Blush', 'Black', 'Sage'],
    rating: 4.4,
    reviewCount: 167,
  ),
  const Product(
    id: 'p11',
    name: 'Slim Chinos',
    brand: 'Veloura',
    price: 59.99,
    imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
    category: 'Men',
    description: 'Classic slim-fit chinos crafted from premium cotton twill.',
    sizes: ['28', '30', '32', '34', '36'],
    colors: ['Navy', 'Khaki', 'Olive'],
    rating: 4.4,
    reviewCount: 98,
  ),
  const Product(
    id: 'p12',
    name: 'Oxford Shirt',
    brand: 'Veloura',
    price: 79.99,
    originalPrice: 110.00,
    imageUrl: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=400',
    category: 'Men',
    description: 'A premium Oxford shirt with a button-down collar. Made from breathable 100% cotton.',
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['White', 'Blue', 'Pink', 'Grey'],
    rating: 4.6,
    reviewCount: 203,
  ),
  const Product(
    id: 'p13',
    name: 'Bomber Jacket',
    brand: 'Veloura',
    price: 139.99,
    originalPrice: 180.00,
    imageUrl: 'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=400',
    category: 'Men',
    description: 'A sleek bomber jacket with ribbed cuffs and hem.',
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Olive', 'Black', 'Navy'],
    rating: 4.7,
    reviewCount: 189,
  ),
  const Product(
    id: 'p14',
    name: 'Slim Fit Suit',
    brand: 'Veloura',
    price: 299.99,
    originalPrice: 420.00,
    imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400',
    category: 'Men',
    description: 'A sharp slim-fit suit crafted from a wool-blend fabric.',
    sizes: ['38R', '40R', '42R', '44R', '46R'],
    colors: ['Charcoal', 'Navy', 'Black'],
    rating: 4.8,
    reviewCount: 112,
  ),
  const Product(
    id: 'p15',
    name: 'Merino Crew Neck',
    brand: 'Veloura',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
    category: 'Men',
    description: 'A premium merino wool crew neck sweater.',
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Camel', 'Navy', 'Charcoal', 'Burgundy'],
    rating: 4.9,
    reviewCount: 278,
  ),
  const Product(
    id: 'p16',
    name: 'Cargo Pants',
    brand: 'Veloura',
    price: 74.99,
    originalPrice: 99.99,
    imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400',
    category: 'Men',
    description: 'Modern cargo pants with a slim taper and functional pockets.',
    sizes: ['28', '30', '32', '34', '36', '38'],
    colors: ['Olive', 'Black', 'Khaki', 'Grey'],
    rating: 4.5,
    reviewCount: 156,
  ),
  const Product(
    id: 'p17',
    name: 'Linen Shirt',
    brand: 'Veloura',
    price: 64.99,
    imageUrl: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400',
    category: 'Men',
    description: 'A lightweight linen shirt perfect for warm days.',
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['White', 'Sky Blue', 'Sand', 'Sage'],
    rating: 4.6,
    reviewCount: 143,
  ),
  const Product(
    id: 'p18',
    name: 'Selvedge Denim Jeans',
    brand: 'Veloura',
    price: 129.99,
    imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
    category: 'Men',
    description: 'Premium Japanese selvedge denim jeans with a straight cut.',
    sizes: ['28', '30', '32', '34', '36'],
    colors: ['Raw Indigo', 'Dark Wash', 'Black'],
    rating: 4.8,
    reviewCount: 94,
  ),
  const Product(
    id: 'p19',
    name: 'Graphic Tee',
    brand: 'Veloura',
    price: 34.99,
    imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=400',
    category: 'Kids',
    description: 'Fun and comfortable graphic tee for kids. Made from soft 100% organic cotton.',
    sizes: ['4Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['White', 'Grey', 'Navy'],
    rating: 4.7,
    reviewCount: 134,
  ),
  const Product(
    id: 'p20',
    name: 'Denim Overalls',
    brand: 'Veloura',
    price: 44.99,
    imageUrl: 'https://images.unsplash.com/photo-1519278409-1f56fdda7fe5?w=400',
    category: 'Kids',
    description: 'Adorable and durable denim overalls for kids.',
    sizes: ['3Y', '4Y', '5Y', '6Y', '7Y', '8Y'],
    colors: ['Blue Denim', 'Light Wash'],
    rating: 4.8,
    reviewCount: 201,
  ),
  const Product(
    id: 'p21',
    name: 'Rainbow Hoodie',
    brand: 'Veloura Kids',
    price: 39.99,
    originalPrice: 55.00,
    imageUrl: 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400',
    category: 'Kids',
    description: 'A colorful and cozy hoodie kids will love.',
    sizes: ['4Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Rainbow', 'Pink', 'Blue'],
    rating: 4.9,
    reviewCount: 317,
  ),
  const Product(
    id: 'p22',
    name: 'Track Suit Set',
    brand: 'Veloura Sport',
    price: 54.99,
    originalPrice: 75.00,
    imageUrl: 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=400',
    category: 'Kids',
    description: 'A matching track suit set for active kids.',
    sizes: ['4Y', '6Y', '8Y', '10Y', '12Y', '14Y'],
    colors: ['Navy/White', 'Black/Red', 'Grey/Green'],
    rating: 4.6,
    reviewCount: 156,
  ),
  const Product(
    id: 'p23',
    name: 'Leather Bag',
    brand: 'Veloura',
    price: 149.99,
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
    category: 'Accessories',
    description: 'A luxurious leather tote bag crafted from genuine Italian leather.',
    sizes: ['One Size'],
    colors: ['Brown', 'Black', 'Tan'],
    rating: 4.9,
    reviewCount: 189,
  ),
  const Product(
    id: 'p24',
    name: 'Silk Scarf',
    brand: 'Veloura',
    price: 59.99,
    originalPrice: 80.00,
    imageUrl: 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=400',
    category: 'Accessories',
    description: 'A luxurious silk scarf with a vibrant print.',
    sizes: ['One Size'],
    colors: ['Floral', 'Abstract Blue', 'Classic Paisley'],
    rating: 4.7,
    reviewCount: 132,
  ),
  const Product(
    id: 'p25',
    name: 'Leather Belt',
    brand: 'Veloura',
    price: 44.99,
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    category: 'Accessories',
    description: 'A classic full-grain leather belt with a polished metal buckle.',
    sizes: ['S (28-30)', 'M (32-34)', 'L (36-38)', 'XL (40-42)'],
    colors: ['Black', 'Brown', 'Tan'],
    rating: 4.8,
    reviewCount: 245,
  ),
  const Product(
    id: 'p26',
    name: 'Canvas Tote Bag',
    brand: 'Veloura',
    price: 34.99,
    imageUrl: 'https://images.unsplash.com/photo-1544816565-aa8c1166648f?w=400',
    category: 'Accessories',
    description: 'A durable canvas tote bag with an interior zip pocket.',
    sizes: ['One Size'],
    colors: ['Natural', 'Black', 'Navy', 'Olive'],
    rating: 4.7,
    reviewCount: 389,
  ),
  const Product(
    id: 'p27',
    name: 'Sunglasses',
    brand: 'Veloura',
    price: 89.99,
    originalPrice: 120.00,
    imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
    category: 'Accessories',
    description: 'Classic oversized sunglasses with UV400 protection.',
    sizes: ['One Size'],
    colors: ['Black', 'Tortoise', 'Clear'],
    rating: 4.5,
    reviewCount: 214,
  ),
];
