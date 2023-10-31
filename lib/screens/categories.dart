import 'package:flutter/material.dart';
import 'package:foodies/data/dummy_data.dart';
import 'package:foodies/models/meals.dart';
import 'package:foodies/screens/meals.dart';
import 'package:foodies/models/category.dart';
import 'package:foodies/widgets/category_grid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// Added a Mixin which is kind of Multi Inheritance feature in flutter
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController; // late creates the variable but wait until it initialze

  @override
  void initState() {
    super.initState();

    // this line make an animation which run 60 fps
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController
        .forward(); // Starts the Animation .stop() will pause it
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => MealScreen(
              title: category.title,
              meals: filteredMeals,
            )),
      ),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: ((context, child) => Padding(
            padding: EdgeInsets.only(
              top: 100 - _animationController.value * 100,
            ),
            child: child,
          )),
      // builder: ((context, child) => SlideTransition(
      //       position: Tween(
      //         begin: const Offset(0, 0.1),
      //         end: const Offset(0, 0),
      //       ).animate(
      //         CurvedAnimation(
      //             parent: _animationController, curve: Curves.easeInOut),
      //       ),
      //     )),
      child: GridView(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: [
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              )
          ]),
    );
  }
}
