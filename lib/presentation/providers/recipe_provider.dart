import 'package:flutter/foundation.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository repository;

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  String? _filterDifficulty;

  RecipeProvider({required this.repository}) {
    loadRecipes();
  }

  // Getters
  List<Recipe> get allRecipes => _recipes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String? get filterDifficulty => _filterDifficulty;

  List<Recipe> get filteredRecipes {
    return _recipes.where((recipe) {
      final matchesCategory = _selectedCategory == 'Todas' ||
          _selectedCategory == 'Rápidas' && (recipe.prepTime + recipe.cookTime) <= 25 ||
          recipe.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesDifficulty = _filterDifficulty == null ||
          _filterDifficulty == 'Todas' ||
          recipe.difficulty.toLowerCase() == _filterDifficulty!.toLowerCase();

      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          recipe.title.toLowerCase().contains(query) ||
          recipe.subtitle.toLowerCase().contains(query) ||
          recipe.category.toLowerCase().contains(query) ||
          recipe.ingredients.any((i) => i.name.toLowerCase().contains(query));

      return matchesCategory && matchesDifficulty && matchesQuery;
    }).toList();
  }

  Recipe? get featuredRecipe {
    for (final r in _recipes) {
      if (r.isFeatured) return r;
    }
    return _recipes.isNotEmpty ? _recipes.first : null;
  }

  Recipe getRecipeById(String id, {Recipe? fallback}) {
    for (final r in _recipes) {
      if (r.id == id) return r;
    }
    return fallback ?? (_recipes.isNotEmpty ? _recipes.first : fallback!);
  }

  List<Recipe> get favoriteRecipes {
    return _recipes.where((r) => r.isFavorite).toList();
  }

  List<Recipe> get userCreatedRecipes {
    return _recipes.where((r) => r.isUserCreated).toList();
  }

  List<Recipe> get quickRecipes {
    return _recipes.where((r) => (r.prepTime + r.cookTime) <= 25).toList();
  }

  Map<String, int> get categoryCounts {
    final Map<String, int> counts = {
      'Desayunos': 0,
      'Pastas': 0,
      'Almuerzos': 0,
      'Ensaladas': 0,
      'Postres': 0,
    };
    for (final r in _recipes) {
      if (counts.containsKey(r.category)) {
        counts[r.category] = (counts[r.category] ?? 0) + 1;
      } else {
        counts[r.category] = 1;
      }
    }
    return counts;
  }

  String get mostFavoriteCategory {
    final favs = favoriteRecipes;
    if (favs.isEmpty) return 'Pastas';
    final Map<String, int> freq = {};
    for (final r in favs) {
      freq[r.category] = (freq[r.category] ?? 0) + 1;
    }
    String best = 'Pastas';
    int max = 0;
    freq.forEach((cat, count) {
      if (count > max) {
        max = count;
        best = cat;
      }
    });
    return best;
  }

  // Actions
  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await repository.getAllRecipes();
    } catch (e) {
      _error = 'Error al cargar las recetas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFilterDifficulty(String? difficulty) {
    _filterDifficulty = difficulty;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final updated = await repository.toggleFavorite(id);
      final index = _recipes.indexWhere((r) => r.id == id);
      if (index != -1) {
        _recipes[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = 'No se pudo actualizar favorito: $e';
      notifyListeners();
    }
  }

  Future<bool> createRecipe(Recipe recipe) async {
    _isLoading = true;
    notifyListeners();
    try {
      final created = await repository.createRecipe(recipe);
      _recipes.insert(0, created);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al crear la receta: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updated = await repository.updateRecipe(recipe);
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar la receta: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRecipe(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final ok = await repository.deleteRecipe(id);
      if (ok) {
        _recipes.removeWhere((r) => r.id == id);
      }
      _isLoading = false;
      notifyListeners();
      return ok;
    } catch (e) {
      _error = 'Error al eliminar la receta: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
