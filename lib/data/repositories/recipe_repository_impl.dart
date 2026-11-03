import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../models/recipe_model.dart';
import '../services/recipe_local_service.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeLocalService localService;

  RecipeRepositoryImpl({required this.localService});

  @override
  Future<List<Recipe>> getAllRecipes() async {
    final list = await localService.loadRecipes();
    return List<Recipe>.from(list);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    final list = await localService.loadRecipes();
    for (final r in list) {
      if (r.id == id) return r;
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
    if (index == -1) {
      throw Exception('Receta no encontrada');
    }
    final current = list[index];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    list[index] = RecipeModel.fromEntity(updated);
    await localService.saveAllRecipes(list);
    return updated;
  }
}
