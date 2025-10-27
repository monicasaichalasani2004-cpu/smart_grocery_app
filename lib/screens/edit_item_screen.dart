import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../providers/grocery_provider.dart';

class EditItemScreen extends StatefulWidget {
  final GroceryItem item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late String _category;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
    _category = widget.item.category;
    if (widget.item.imagePath != null && widget.item.imagePath!.isNotEmpty) {
      _image = File(widget.item.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) setState(() => _image = File(path));
    }
  }

  void _saveItem() async {
    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) return;

    final updatedItem = GroceryItem(
      id: widget.item.id,
      name: _nameController.text.trim(),
      category: _category,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      imagePath: _image?.path,
      isPurchased: widget.item.isPurchased,
    );

    await Provider.of<GroceryProvider>(context, listen: false).updateItem(updatedItem);
    if (context.mounted) Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Edit Item'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveItem,
          ),
        ],
      ),
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
              label: const Text('Change Image'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _saveItem,
              child: const Text('Update Item'),
            ),
          ],
        ),
      ),
    );
  }
}
