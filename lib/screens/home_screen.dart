import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grocery_provider.dart';
import '../models/grocery_item.dart';
import 'add_item_screen.dart';
import 'edit_item_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  final List<Map<String, String>> categories = [
    {'name': 'All', 'image': 'assets/images/all.png'},
    {'name': 'Produce', 'image': 'assets/images/produce.png'},
    {'name': 'Dairy', 'image': 'assets/images/dairy.png'},
    {'name': 'Snacks', 'image': 'assets/images/snacks.png'},
    {'name': 'Beverages', 'image': 'assets/images/beverages.png'},
    {'name': 'Bakery', 'image': 'assets/images/bakery.png'},
    {'name': 'Frozen', 'image': 'assets/images/frozen.png'},
    {'name': 'Household', 'image': 'assets/images/household.png'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<GroceryProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GroceryProvider>(context);
    final items = selectedCategory == 'All'
        ? provider.items
        : provider.items.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Grocery App'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Selector with images
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: categories.map((category) {
                final bool isSelected = selectedCategory == category['name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = category['name']!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.green.shade200,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            category['image']!,
                            width: 35,
                            height: 35,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Grocery List
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No items found. Add some groceries!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final GroceryItem item = items[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => EditItemScreen(item: item)));
                        },
                        child: Card(
                          color: Colors.green.shade50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item.imagePath != null && File(item.imagePath!).existsSync()
                                  ? Image.file(File(item.imagePath!), width: 55, height: 55, fit: BoxFit.cover)
                                  : Image.asset('assets/images/${item.category.toLowerCase()}.png',
                                      width: 55, height: 55, fit: BoxFit.cover),
                            ),
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text('Qty: ${item.quantity} | ${item.category}'),
                            trailing: Checkbox(
                              value: item.isPurchased,
                              onChanged: (value) {
                                if (value != null) provider.togglePurchased(item.id!, value);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
