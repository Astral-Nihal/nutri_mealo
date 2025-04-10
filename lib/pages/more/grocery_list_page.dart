import 'package:flutter/material.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _groceries = [
    {'name': 'Tomatoes', 'bought': false},
    {'name': 'Spinach', 'bought': false},
    {'name': 'Chicken Breast', 'bought': false},
    {'name': 'Milk', 'bought': false},
    {'name': 'Oats', 'bought': false},
    {'name': 'Bananas', 'bought': false},
    {'name': 'Cheese', 'bought': false},
    {'name': 'Carrots', 'bought': false},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredGroceries =
        _groceries
            .where(
              (item) => item['name'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

    final unboughtItems =
        filteredGroceries.where((item) => !item['bought']).toList();
    final boughtItems =
        filteredGroceries.where((item) => item['bought']).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: commonAppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Grocery List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search groceries...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    ...unboughtItems.map((item) => groceryTile(item, false)),
                    if (boughtItems.isNotEmpty) const SizedBox(height: 20),
                    ...boughtItems.map((item) => groceryTile(item, true)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget groceryTile(Map<String, dynamic> item, bool bought) {
    return Opacity(
      opacity: bought ? 0.4 : 1.0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        title: Text(
          item['name'],
          style: TextStyle(
            decoration:
                bought ? TextDecoration.lineThrough : TextDecoration.none,
            fontSize: 18,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            bought ? Icons.check_circle : Icons.radio_button_unchecked,
            color: bought ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              item['bought'] = !item['bought'];
            });
          },
        ),
      ),
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'Nutri-mealo',
        style: TextStyle(
          color: Color(0xff16C47F),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
