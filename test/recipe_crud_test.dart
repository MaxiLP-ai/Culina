import 'package:flutter_test/flutter_test.dart';
import 'package:culina/domain/entities/ingredient.dart';
import 'package:culina/domain/entities/recipe.dart';
import 'package:culina/domain/repositories/recipe_repository.dart';
import 'package:culina/presentation/providers/recipe_provider.dart';

class MockRecipeRepository implements RecipeRepository {
  final List<Recipe> _mockRecipes = [];

  MockRecipeRepository() {
    _mockRecipes.addAll([
      Recipe(
        id: 'receta-1',
        title: 'Tostada Rústica con Burrata y Tomates Asados',
        subtitle: 'Pan de masa madre tostado, burrata cremosa y albahaca fresca',
        description: 'Receta italiana campestre.',
        category: 'Desayunos',
        difficulty: 'Fácil',
        prepTime: 10,
        cookTime: 15,
        servings: 2,
        icon: '🥖',
        colorTheme: 'Trigo',
        author: 'Camila Rossi',
        isFavorite: true,
        isFeatured: true,
        ingredients: [
          Ingredient(name: 'Pan', baseAmount: 2, unit: 'unidades'),
          Ingredient(name: 'Burrata', baseAmount: 1, unit: 'pieza'),
        ],
        steps: ['Tostar pan', 'Servir con burrata'],
      ),
      Recipe(
        id: 'receta-2',
        title: 'Tagliatelle al Huevo Artesanales',
        subtitle: 'Pasta fresca hecha a mano',
        description: 'Auténtica pasta fresca.',
        category: 'Pastas',
        difficulty: 'Media',
        prepTime: 25,
        cookTime: 10,
        servings: 2,
        icon: '🍝',
        colorTheme: 'Trigo',
        author: 'Matías Tapia',
        isFavorite: true,
        isUserCreated: true,
        ingredients: [
          Ingredient(name: 'Harina', baseAmount: 200, unit: 'g'),
          Ingredient(name: 'Huevos', baseAmount: 2, unit: 'unidades'),
        ],
        steps: ['Amasar', 'Cocinar pasta'],
      ),
    ]);
  }

  @override
  Future<List<Recipe>> getAllRecipes() async => List.from(_mockRecipes);

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      return _mockRecipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    _mockRecipes.insert(0, recipe);
    return recipe;
  }

  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    final idx = _mockRecipes.indexWhere((r) => r.id == recipe.id);
    if (idx != -1) {
      _mockRecipes[idx] = recipe;
    }
    return recipe;
  }

  @override
  Future<bool> deleteRecipe(String id) async {
    final prev = _mockRecipes.length;
    _mockRecipes.removeWhere((r) => r.id == id);
    return _mockRecipes.length != prev;
  }

  @override
  Future<Recipe> toggleFavorite(String id) async {
    final idx = _mockRecipes.indexWhere((r) => r.id == id);
    final current = _mockRecipes[idx];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    _mockRecipes[idx] = updated;
    return updated;
  }
}

void main() {
  group('Culina Domain & CRUD Tests', () {
    test('Ingredient scaling calculates portions accurately', () {
      final ingredient = Ingredient(name: 'Harina', baseAmount: 200, unit: 'g');

      // For 2 base servings -> 4 servings should double to 400g
      expect(ingredient.getAmountForServings(2, 4), 400.0);
      expect(ingredient.formatAmountForServings(2, 4), '400');

      // For 2 base servings -> 1 serving should be 100g
      expect(ingredient.getAmountForServings(2, 1), 100.0);
      expect(ingredient.formatAmountForServings(2, 1), '100');
    });

    test('RecipeProvider CREATE (Crear nueva receta)', () async {
      final repo = MockRecipeRepository();
      final provider = RecipeProvider(repository: repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final newRecipe = Recipe(
        id: 'nueva-1',
        title: 'Focaccia al Romero',
        subtitle: 'Pan rústico italiano',
        description: 'Masa fermentada',
        category: 'Desayunos',
        difficulty: 'Media',
        prepTime: 30,
        cookTime: 20,
        servings: 4,
        icon: '🥖',
        colorTheme: 'Trigo',
        author: 'Matías Tapia',
        isUserCreated: true,
        ingredients: [
          Ingredient(name: 'Harina', baseAmount: 400, unit: 'g'),
        ],
        steps: ['Hornear'],
      );

      final success = await provider.createRecipe(newRecipe);
      expect(success, true);
      expect(provider.allRecipes.length, 3);
      expect(provider.allRecipes.first.title, 'Focaccia al Romero');
    });

    test('RecipeProvider READ (Lectura y filtrado)', () async {
      final repo = MockRecipeRepository();
      final provider = RecipeProvider(repository: repo);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.allRecipes.length, 2);
      expect(provider.favoriteRecipes.length, 2);

      // Filter by category
      provider.setSelectedCategory('Pastas');
      expect(provider.filteredRecipes.length, 1);
      expect(provider.filteredRecipes.first.category, 'Pastas');

      // Filter by search query
      provider.setSelectedCategory('Todas');
      provider.setSearchQuery('burrata');
      expect(provider.filteredRecipes.length, 1);
      expect(provider.filteredRecipes.first.title.contains('Burrata'), true);
    });

    test('RecipeProvider UPDATE (Actualizar receta y toggle favoritos)', () async {
      final repo = MockRecipeRepository();
      final provider = RecipeProvider(repository: repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final original = provider.allRecipes.first;
      final updated = original.copyWith(title: 'Tostada Rústica Suprema');

      final success = await provider.updateRecipe(updated);
      expect(success, true);
      expect(provider.allRecipes.first.title, 'Tostada Rústica Suprema');

      // Toggle favorite
      await provider.toggleFavorite(original.id);
      expect(provider.allRecipes.first.isFavorite, false);
      expect(provider.favoriteRecipes.length, 1);
    });

    test('RecipeProvider DELETE (Eliminar receta)', () async {
      final repo = MockRecipeRepository();
      final provider = RecipeProvider(repository: repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await provider.deleteRecipe('receta-2');
      expect(success, true);
      expect(provider.allRecipes.length, 1);
      expect(provider.allRecipes.any((r) => r.id == 'receta-2'), false);
    });
  });
}

