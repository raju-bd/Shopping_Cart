import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  Product({
    required this.name,
    required this.price,
    required this.category,
    this.quantity = 0,
  });

  final String name;
  final int price;
  final String category;
  final int quantity;

  Product copyWith({String? name, int? price, String? category, int? quantity}) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Shopping Cart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShoppingCartHomePage(),
    );
  }
}

class ShoppingCartHomePage extends StatefulWidget {
  const ShoppingCartHomePage({super.key});

  @override
  State<ShoppingCartHomePage> createState() => _ShoppingCartHomePageState();
}

class _ShoppingCartHomePageState extends State<ShoppingCartHomePage> {
  // This local list works as the full product catalog for the shopping cart.
  List<Product> _products = [
    Product(name: 'T-Shirt', price: 500, category: 'Clothes'),
    Product(name: 'Shoes', price: 1500, category: 'Fashion'),
    Product(name: 'Watch', price: 2000, category: 'Accessories'),
    Product(name: 'Bag', price: 1000, category: 'Fashion'),
  ];

  final List<String> _categories = ['All', 'Clothes', 'Fashion', 'Accessories'];
  String _selectedCategory = 'All';
  String _searchText = '';

  // Search and category filters are combined to narrow the visible product list.
  List<Product> get _filteredProducts {
    final query = _searchText.trim().toLowerCase();

    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty || product.name.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get totalItems {
    return _products.fold<int>(0, (sum, product) => sum + product.quantity);
  }

  int get subtotal {
    return _products.fold<int>(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  int get discount {
    return subtotal >= 3000 ? (subtotal * 10) ~/ 100 : 0;
  }

  int get grandTotal => subtotal - discount;

  Widget _summaryRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: highlight ? Colors.deepPurple.shade900 : Colors.grey.shade700,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: highlight ? Colors.deepPurple : Colors.black87,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(String productName, int change) {
    setState(() {
      final index = _products.indexWhere((product) => product.name == productName);
      if (index == -1) {
        return;
      }

      final nextQuantity = _products[index].quantity + change;
      if (nextQuantity < 0) {
        return;
      }

      _products[index] = _products[index].copyWith(quantity: nextQuantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Shopping Cart'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search is case-insensitive so users can quickly find a product.
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // A category dropdown keeps the product browser easy to navigate.
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching products found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView(
                      children: _filteredProducts.map((product) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Price: ৳${product.price}'),
                                      Text('Category: ${product.category}'),
                                      const SizedBox(height: 6),
                                      Text('Quantity: ${product.quantity}'),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _updateQuantity(product.name, 1),
                                      icon: const Icon(Icons.add),
                                      tooltip: 'Increase quantity',
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _updateQuantity(product.name, -1),
                                      icon: const Icon(Icons.remove),
                                      tooltip: 'Decrease quantity',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 12),

            // Summary values update every time quantity changes and are presented in a clean, modern card.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEEE7FF), Color(0xFFF8F1FF)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.deepPurple.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Cart Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.deepPurple.withValues(alpha: 0.15)),
                  const SizedBox(height: 8),
                  _summaryRow('Total Items: $totalItems', ''),
                  _summaryRow('Subtotal: ৳$subtotal', ''),
                  _summaryRow('Discount: ৳$discount', ''),
                  Divider(color: Colors.deepPurple.withValues(alpha: 0.15)),
                  const SizedBox(height: 8),
                  _summaryRow('Grand Total: ৳$grandTotal', '', highlight: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
