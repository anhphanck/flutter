import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package

// Model
class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

// ViewModel
class ItemListViewModel extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item newItem) {
    _items.add(newItem);
    notifyListeners();
  }
}

// View
class ItemListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ItemListViewModel>(context); // Lấy ViewModel từ Provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách mục'),
      ),
      body: ListView.builder(
        itemCount: viewModel.items.length,
        itemBuilder: (context, index) {
          final item = viewModel.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('ID: ${item.id}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mở màn hình thêm mục mới
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemView()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ItemListViewModel>(context, listen: false); // Lấy ViewModel từ Provider

    final TextEditingController _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mới mục'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên mục'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Thêm mục mới vào danh sách và quay lại màn hình trước đó
                final newItem = Item(id: viewModel.items.length + 1, name: _nameController.text);
                viewModel.addItem(newItem);
                Navigator.pop(context);
              },
              child: Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemListViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListView(),
    );
  }
}
