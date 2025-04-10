import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/more/favorite_dish/favorite_dishes_page.dart';
import 'package:nutri_mealo/pages/more/grocery_list_page.dart';
import 'package:nutri_mealo/pages/more/previous_meal_plan/previous_meal_plan_page.dart';
import 'package:nutri_mealo/pages/more/recipes/recipes_page.dart';

class MoreHomePage extends StatefulWidget {
  const MoreHomePage({super.key});

  @override
  State<MoreHomePage> createState() => _MoreHomePageState();
}

class _MoreHomePageState extends State<MoreHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          const Text(
            'More options',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildOptionCard(
            Icons.calendar_today,
            'Previous Meal Plans',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PreviousMealPlanPage()),
            ),
          ),
          _buildOptionCard(
            Icons.menu_book,
            'Recipes',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RecipesPage()),
            ),
          ),
          _buildOptionCard(
            Icons.favorite,
            'Favorite Dishes',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoriteDishesPage()),
            ),
          ),
          _buildOptionCard(
            Icons.shopping_cart,
            'Grocery List',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GroceryListPage()),
            ),
          ),
        ],
      ),
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
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

  Widget _buildOptionCard(IconData icon, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          leading: Icon(icon, size: 30, color: Colors.black87),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right_outlined),
            onPressed: onPressed,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
