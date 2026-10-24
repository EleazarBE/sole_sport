import 'package:flutter/material.dart';

void main() {
  runApp(const SoleSportApp());
}

class SoleSportApp extends StatelessWidget {
  const SoleSportApp({super.key});

  static const Color navy = Color(0xFF20263D);
  static const Color teal = Color(0xFF49E3AD);
  static const Color cream = Color(0xFFF4F3EF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOLE//SPORT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: teal,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ShoeStorePage(),
    );
  }
}

class ShoeStorePage extends StatefulWidget {
  const ShoeStorePage({super.key});

  @override
  State<ShoeStorePage> createState() => _ShoeStorePageState();
}

class _ShoeStorePageState extends State<ShoeStorePage> {
  int cartCount = 0;
  String selectedCategory = 'All';
  String searchQuery = '';
  final List<Map<String, dynamic>> cartItems = [];

  void addToCart(String shoeName, double shoePrice) {
    setState(() {
      cartItems.add({'name': shoeName, 'price': shoePrice});

      cartCount = cartItems.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$shoeName added to cart!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOLE//SPORT',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),

        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (sheetContext) {
                  final double totalPrice = cartItems.fold<double>(
                    0.0,
                    (total, item) => total + (item['price'] as double),
                  );
                  return SizedBox(
                    height: MediaQuery.of(sheetContext).size.height * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Shopping Cart',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: cartItems.isEmpty
                                ? const Center(
                                    child: Text('Your cart is empty.'),
                                  )
                                : ListView.builder(
                                    itemCount: cartItems.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.shopping_bag_outlined,
                                        ),
                                        title: Text(
                                          cartItems[index]['name'] as String,
                                        ),
                                        subtitle: Text(
                                          'RM ${(cartItems[index]['price'] as double).toStringAsFixed(2)}',
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                          tooltip: 'Remove from cart',
                                          onPressed: () {
                                            setState(() {
                                              cartItems.removeAt(index);
                                              cartCount = cartItems.length;
                                            });

                                            Navigator.of(context).pop();

                                            ScaffoldMessenger.of(
                                              this.context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Product removed from cart',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const Divider(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'RM ${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: SoleSportApp.navy,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: cartItems.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        cartItems.clear();
                                        cartCount = 0;
                                      });

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cart cleared successfully',
                                              ),
                                            ),
                                          );
                                    },
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Clear Cart'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: cartItems.isEmpty
                                  ? null
                                  : () {
                                      final orderTotal = cartItems.fold<double>(
                                        0.0,
                                        (total, item) =>
                                            total + (item['price'] as double),
                                      );

                                      final orderCount = cartItems.length;

                                      setState(() {
                                        cartItems.clear();
                                        cartCount = 0;
                                      });

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(
                                        this.context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Order confirmed! $orderCount item(s) — '
                                            'RM ${orderTotal.toStringAsFixed(2)}',
                                          ),
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );
                                    },
                              icon: const Icon(Icons.shopping_bag_outlined),
                              label: const Text('Checkout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SoleSportApp.navy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Badge(
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 700 ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: SoleSportApp.navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        color: SoleSportApp.teal,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'FIND YOUR\nNEXT STEP.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Gear up. Move faster.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: SoleSportApp.navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STEP INTO\nYOUR NEXT LEVEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Find your perfect pair.',
                            style: TextStyle(
                              color: Color(0xFFCDD3E0),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: SoleSportApp.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'MOVE WITH CONFIDENCE',
                              style: TextStyle(
                                color: SoleSportApp.navy,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.directions_run,
                      color: SoleSportApp.teal,
                      size: 72,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'Popular Sneakers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: SoleSportApp.navy,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                children: ['All', 'Running', 'Basketball', 'Lifestyle'].map((
                  category,
                ) {
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFF49E3AD),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),

              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search sneakers...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Your next favourite pair starts here.',
                style: TextStyle(color: Colors.black54),
              ),

              if ((selectedCategory == 'All' ||
                      selectedCategory == 'Running') &&
                  ('runner x1 road running'.contains(searchQuery))) ...[
                const SizedBox(height: 20),
                ShoeCard(
                  name: 'RUNNER X1',
                  category: 'Road Running',
                  price: 259.00,
                  icon: Icons.directions_run,
                  imagePath: 'assets/images/runner_x1.png',
                  onAddToCart: () => addToCart('RUNNER X1', 259.00),
                ),
              ],

              if ((selectedCategory == 'All' ||
                      selectedCategory == 'Basketball') &&
                  ('street flex lifestyle'.contains(searchQuery))) ...[
                const SizedBox(height: 16),
                ShoeCard(
                  name: 'COURT PRO',
                  category: 'Basketball',
                  price: 329.00,
                  icon: Icons.sports_basketball,
                  imagePath: 'assets/images/court_pro.png',
                  onAddToCart: () => addToCart('COURT PRO', 329.00),
                ),
              ],

              if ((selectedCategory == 'All' ||
                      selectedCategory == 'Lifestyle') &&
                  ('court pro basketball'.contains(searchQuery))) ...[
                const SizedBox(height: 16),
                ShoeCard(
                  name: 'STREET FLEX',
                  category: 'Lifestyle',
                  price: 199.00,
                  icon: Icons.directions_walk,
                  imagePath: 'assets/images/street_flex.png',
                  onAddToCart: () => addToCart('STREET FLEX', 199.00),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ShoeCard extends StatelessWidget {
  const ShoeCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.onAddToCart,
  });

  final String name;
  final String category;
  final double price;
  final IconData icon;
  final String imagePath;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFE9EDF3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(icon, size: 46, color: SoleSportApp.navy);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: 0.5,
                      color: SoleSportApp.navy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EDF3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: SoleSportApp.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RM ${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: SoleSportApp.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAddToCart,
              icon: const Icon(Icons.add_shopping_cart),
              color: SoleSportApp.navy,
              tooltip: 'Add to cart',
            ),
          ],
        ),
      ),
    );
  }
}
