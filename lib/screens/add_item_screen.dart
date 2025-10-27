import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../providers/grocery_provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  String _category = 'Produce';
  File? _image;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) setState(() => _image = File(path));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item'), backgroundColor: Colors.green.shade700),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Item Name')),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _category,
              items: ['Produce', 'Dairy', 'Snacks', 'Beverages', 'Bakery', 'Frozen', 'Household']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
            ),
            const SizedBox(height: 10),
            _image != null ? Image.file(_image!, height: 100) : const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Add Image'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (_nameController.text.isEmpty || _quantityController.text.isEmpty) return;
                final newItem = GroceryItem(
                  name: _nameController.text.trim(),
                  category: _category,
                  quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
                  imagePath: _image?.path,
                );
                Provider.of<GroceryProvider>(context, listen: false).addItem(newItem);
                Navigator.pop(context);
              },
              child: const Text('Save Item'),
            ),
          ],
        ),
      ),
    );
  }
}
