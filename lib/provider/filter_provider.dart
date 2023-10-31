import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodies/provider/meals_provider.dart';

enum Filter { glutenfree, lactosefree, vegetarian, vegan }

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  // Initialize the class
  FilterNotifier()
      : super({
          Filter.glutenfree: false,
          Filter.lactosefree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setAllFilter(Map<Filter, bool> choosenFilter) {
    state = choosenFilter;
  }

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; //not allowed => mutating State
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
    (ref) => FilterNotifier());

// Connecting Multiple Provider with eachother
final filteredMealProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilter = ref.watch(filterProvider);

  return meals.where((meal) {
    if (activeFilter[Filter.glutenfree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilter[Filter.lactosefree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilter[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilter[Filter.vegan]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
