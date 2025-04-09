import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/more/recipes/recipes_page.dart';

class LikedDishPage extends StatefulWidget {
  final List<String> dishes;
  final Function(String) onMoveToDisliked;

  const LikedDishPage({
    super.key,
    required this.dishes,
    required this.onMoveToDisliked,
  });

  @override
  State<LikedDishPage> createState() => _LikedDishPageState();
}

class _LikedDishPageState extends State<LikedDishPage> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        _titleRow(),
        const SizedBox(height: 16),
        ...widget.dishes.map((dish) => _dishCard(dish)),
      ],
    );
  }

  Widget _titleRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Liked Dishes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              isEditMode ? Icons.edit_off : Icons.edit,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _dishCard(String dishName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: const Icon(Icons.restaurant_menu, size: 30),
          title: Text(
            dishName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing:
              isEditMode
                  ? IconButton(
                    icon: const Icon(Icons.thumb_down, color: Colors.black),
                    onPressed: () => widget.onMoveToDisliked(dishName),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xff16C47F),
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                  : IconButton(
                    icon: const Icon(Icons.menu_book, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecipesPage()),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xff16C47F),
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
