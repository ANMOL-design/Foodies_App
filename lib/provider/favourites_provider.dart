import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodies/models/meals.dart';

// Making a class that notify the Widget on change of a value
class FavouriteMealNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealNotifier()
      : super([]); // Initialize favourite meals with empty list

  // Making a function to add or rm meals from favourites
  bool toggleMealFavouriteStatus(Meal meal) {
    // this class gave us STATE in which values is stored
    // NOTE: We can't use add or remove methods in States this is drawback of riverpod
    final mealIsFavourite = state.contains(meal);

    if (mealIsFavourite) {
      state = state.where((element) => element.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

// Now we connect this Notifer Class to Provider to change or manipulate values
final favouriteMealProvider =
    StateNotifierProvider<FavouriteMealNotifier, List<Meal>>((ref) {
  return FavouriteMealNotifier();
});
