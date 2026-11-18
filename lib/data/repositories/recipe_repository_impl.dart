import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../models/recipe_model.dart';
import '../services/recipe_api_service.dart';
import '../services/recipe_local_service.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeLocalService localService;
  final RecipeApiService? apiService;

  RecipeRepositoryImpl({
    required this.localService,
    this.apiService,
  });

  @override
  Future<List<Recipe>> getAllRecipes() async {
    final localList = await localService.loadRecipes();
    final userCreated = localList.where((r) => r.isUserCreated).toList();
    final favoriteIds = localList.where((r) => r.isFavorite).map((r) => r.id).toSet();

    // Consultamos la API externa (TheMealDB)
    if (apiService != null) {
      final remoteList = await apiService!.fetchRecipes();
      if (remoteList != null && remoteList.isNotEmpty) {
        final adjustedRemote = remoteList.map((r) {
          if (favoriteIds.contains(r.id)) {
            return r.copyWith(isFavorite: true);
          }
          return r;
        }).toList();

        // Mantenemos al inicio las recetas creadas por el usuario y luego las de la API
        final combined = <Recipe>[...userCreated, ...adjustedRemote];
        return combined;
      }
    }

    // Fallback elegante a la base de datos local
    return List<Recipe>.from(localList);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    final list = await localService.loadRecipes();
    for (final r in list) {
      if (r.id == id) return r;
    }

    if (apiService != null) {
      final remoteRecipe = await apiService!.fetchRecipeById(id);
      if (remoteRecipe != null) return remoteRecipe;
    }

    return null;
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    final list = await localService.loadRecipes();
    final model = RecipeModel.fromEntity(recipe);
    list.insert(0, model);
    await localService.saveAllRecipes(list);
    return model;
  }

  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    final list = await localService.loadRecipes();
    final index = list.indexWhere((r) => r.id == recipe.id);
    final model = RecipeModel.fromEntity(recipe);
    if (index != -1) {
      list[index] = model;
    } else {
      list.insert(0, model);
    }
    await localService.saveAllRecipes(list);
    return model;
  }

  @override
  Future<bool> deleteRecipe(String id) async {
    final list = await localService.loadRecipes();
    final initialCount = list.length;
    list.removeWhere((r) => r.id == id);
    if (list.length != initialCount) {
      await localService.saveAllRecipes(list);
      return true;
    }
    return false;
  }

  @override
  Future<Recipe> toggleFavorite(String id) async {
    final list = await localService.loadRecipes();
    final index = list.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = list[index];
      final updated = current.copyWith(isFavorite: !current.isFavorite);
      list[index] = RecipeModel.fromEntity(updated);
      await localService.saveAllRecipes(list);
      return updated;
    }

    if (apiService != null) {
      final remote = await apiService!.fetchRecipeById(id);
      if (remote != null) {
        final favorited = remote.copyWith(isFavorite: true);
        list.add(RecipeModel.fromEntity(favorited));
        await localService.saveAllRecipes(list);
        return favorited;
      }
    }

    throw Exception('Receta no encontrada');
  }
}
