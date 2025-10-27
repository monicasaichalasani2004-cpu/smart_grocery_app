import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/grocery_item.dart';

class GroceryProvider with ChangeNotifier {
  List<GroceryItem> _items = [];
  final DBHelper _dbHelper = DBHelper();

  List<GroceryItem> get items => _items;

  Future<void> fetchItems() async {
    _items = await _dbHelper.getItems();
    notifyListeners();
  }

  Future<void> addItem(GroceryItem item) async {
    await _dbHelper.insertItem(item);
    await fetchItems();
  }

  Future<void> updateItem(GroceryItem item) async {
    await _dbHelper.updateItem(item);
    await fetchItems();
  }

  Future<void> deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    await fetchItems();
  }

  Future<void> togglePurchased(int id, bool isPurchased) async {
    await _dbHelper.updatePurchasedStatus(id, isPurchased);
    await fetchItems();
  }
}
