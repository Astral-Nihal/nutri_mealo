import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/stats/disliked_dish_page.dart';
import 'package:nutri_mealo/pages/stats/liked_dish_page.dart';

class DishManagerPage extends StatefulWidget {
  final int initialTabIndex; // 0 = Liked, 1 = Disliked

  const DishManagerPage({super.key, this.initialTabIndex = 0});

  @override
  State<DishManagerPage> createState() => _DishManagerPageState();
}

class _DishManagerPageState extends State<DishManagerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> likedDishes = [
    'Idli with Sambar',
    'Masala Dosa',
    'Chicken Chettinad',
    'Mutton Kuzhambu',
    'Kothu Parotta',
    'Medu Vada',
    'Rasam with Rice',
    'Thayir Sadam (Curd Rice)',
    'Pongal with Gotsu',
    'Sambar Sadam',
  ];

  List<String> dislikedDishes = [
    'Bitter Gourd Fry (Pavakkai Varuval)',
    'Ragi Kali with Karuvattu Kuzhambu',
    'Neem Flower Rasam (Veppam Poo Rasam)',
    'Kambu Koozh (Pearl Millet Gruel)',
    'Agathi Keerai Poriyal',
    'Sundakkai Kuzhambu (Turkey Berry Curry)',
    'Arisi Upma (Plain Rice Upma)',
    'Ulundhu Kali (Black Gram Sweet)',
    'Pidi Karunai Masiyal',
    'Vazhaithandu Juice (Banana Stem Juice)',
  ];

  void moveToDisliked(String dish) {
    setState(() {
      likedDishes.remove(dish);
      dislikedDishes.add(dish);
    });
  }

  void moveToLiked(String dish) {
    setState(() {
      dislikedDishes.remove(dish);
      likedDishes.add(dish);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Add this line
      appBar: AppBar(
        title: const Text(
          'Nutri-mealo',
          style: TextStyle(
            color: Color(0xff16C47F),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xff16C47F),
          unselectedLabelColor: Colors.black54,
          tabs: const [Tab(text: 'Liked'), Tab(text: 'Disliked')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LikedDishPage(dishes: likedDishes, onMoveToDisliked: moveToDisliked),
          DislikedDishPage(dishes: dislikedDishes, onMoveToLiked: moveToLiked),
        ],
      ),
    );
  }
}
