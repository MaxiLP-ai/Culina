import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:culina/data/services/recipe_api_service.dart';

void main() {
  group('TheMealDB API Service Tests', () {
    test('RecipeApiService translates TheMealDB response into Spanish RecipeModel', () async {
      final mockJson = jsonEncode({
        'meals': [
          {
            'idMeal': '52777',
            'strMeal': 'Mediterranean Pasta Salad',
            'strCategory': 'Pasta',
            'strArea': 'Italian',
            'strInstructions': 'Cook for 10 minutes.\r\nChop the tomatoes.\r\nMix well all ingredients.',
            'strIngredient1': 'Pasta',
            'strMeasure1': '200 g',
            'strIngredient2': 'Tomatoes',
            'strMeasure2': '100 g',
            'strIngredient3': '',
            'strMeasure3': '',
          }
        ]
      });

      final mockClient = MockClient((request) async {
        return http.Response(mockJson, 200);
      });

      final service = RecipeApiService(client: mockClient);
      final recipes = await service.fetchRecipes();

      expect(recipes, isNotNull);
      expect(recipes!.length, 1);

      final recipe = recipes.first;
      expect(recipe.id, 'mealdb-52777');
      expect(recipe.title, 'Ensalada de Pasta Mediterránea');
      expect(recipe.category, 'Pastas');
      expect(recipe.icon, '🍝');
      expect(recipe.author, 'Cocina Italiana');
      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].name, 'Pasta seca artesanal');
      expect(recipe.ingredients[0].baseAmount, 200.0);
      expect(recipe.ingredients[0].unit, 'gramos');
      expect(recipe.ingredients[1].name, 'Tomates maduros');
      expect(recipe.steps.length, 3);
      expect(recipe.steps[0].contains('minutos'), true);
      expect(recipe.steps[2].contains('Mezcla'), true);
    });
  });
}
