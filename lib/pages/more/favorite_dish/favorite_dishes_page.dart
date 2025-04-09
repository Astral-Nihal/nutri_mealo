import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/more/recipes/recipe_detail_page.dart';

class FavoriteDishesPage extends StatefulWidget {
  const FavoriteDishesPage({super.key});

  @override
  State<FavoriteDishesPage> createState() => _FavoriteDishesPageState();
}

class _FavoriteDishesPageState extends State<FavoriteDishesPage> {
  bool _isEditMode = false;

  final List<String> allDishes = [
    'Masala Dosa',
    'Paneer Butter Masala',
    'Chicken Chettinad',
    'Curd Rice',
    'Ragi Kali',
  ];

  final Set<String> favoriteDishes = {'Masala Dosa', 'Paneer Butter Masala'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCommonAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRow(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children:
                    allDishes.map((dish) {
                      final isFav = favoriteDishes.contains(dish);
                      final showCard = _isEditMode || isFav;

                      if (!showCard) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black54),
                          ),
                          color: Colors.grey.shade200,
                          child: ListTile(
                            leading: const Icon(
                              Icons.restaurant_menu,
                              size: 30,
                            ),
                            title: Text(
                              dish,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing:
                                _isEditMode
                                    ? IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red.shade400,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isFav) {
                                            favoriteDishes.remove(dish);
                                          } else {
                                            favoriteDishes.add(dish);
                                          }
                                        });
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xff16C47F,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    )
                                    : IconButton(
                                      icon: const Icon(
                                        Icons.menu_book,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => RecipeDetailPage(
                                                  recipeName: dish,
                                                ),
                                          ),
                                        );
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xff16C47F,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Favorite Dishes',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        IconButton(
          icon: Icon(_isEditMode ? Icons.edit_off : Icons.edit),
          onPressed: () {
            setState(() {
              _isEditMode = !_isEditMode;
            });
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildCommonAppBar() {
    return AppBar(
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
    );
  }
}
