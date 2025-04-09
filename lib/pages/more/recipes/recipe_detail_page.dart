import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeName;

  const RecipeDetailPage({super.key, required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Recipe',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              recipeName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 1 cup rice\n• 1/2 cup dal\n• 1 tsp mustard seeds\n• Curry leaves\n• Salt to taste\n• Ghee or oil',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Rinse and soak rice and dal for 30 mins.\n'
              '2. Heat ghee in a pan. Add mustard seeds and curry leaves.\n'
              '3. Add soaked rice and dal. Add 3 cups of water.\n'
              '4. Add salt, cover, and cook until soft.\n'
              '5. Serve hot with ghee or chutney.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
