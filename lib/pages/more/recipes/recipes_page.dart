import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_mealo/pages/more/recipes/recipe_detail_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> allRecipes = [
    'Idli with Sambar',
    'Kothu Parotta',
    'Curd Rice',
    'Masala Dosa',
    'Chicken Chettinad',
    'Ragi Kali',
    'Sambar Sadam',
    'Pongal with Gotsu',
    'Vegetable Upma',
    'Chapati with Kurma',
    'Lemon Rice',
    'Vegetable Biryani',
    'Paneer Butter Masala',
    'Tomato Rasam',
    'Aloo Fry',
  ];

  late final List<String> todaysRecipes = getTodaysRecipes();

  List<String> getTodaysRecipes() {
    final today = DateTime.now();
    final seed = int.parse(DateFormat('yyyyMMdd').format(today));
    final random = Random(seed);
    final shuffled = List<String>.from(allRecipes)..shuffle(random);
    return shuffled.take(5).toList();
  }

  final List<String> otherRecipes = [
    'Masala Dosa',
    'Chicken Chettinad',
    'Ragi Kali',
    'Sambar Sadam',
    'Pongal with Gotsu',
  ];

  List<String> _filterRecipes(List<String> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    return recipes
        .where(
          (recipe) => recipe.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Nutri-mealo',
            style: TextStyle(
              color: Color(0xff16C47F),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Recipes',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Recipes Needed for Today ($today)",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildRecipeList(_filterRecipes(todaysRecipes)),
                    const SizedBox(height: 24),
                    const Text(
                      "Other Recipes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildRecipeList(_filterRecipes(otherRecipes)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search recipes...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchQuery.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  List<Widget> _buildRecipeList(List<String> recipes) {
    return recipes.map((recipe) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailPage(recipeName: recipe),
            ),
          );
        },
        child: _recipeCard(icon: Icons.restaurant_menu, title: recipe),
      );
    }).toList();
  }

  Widget _recipeCard({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          leading: Icon(icon, size: 30),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
        ),
      ),
    );
  }
}
