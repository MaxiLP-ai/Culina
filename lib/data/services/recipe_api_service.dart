import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/ingredient.dart';
import '../models/recipe_model.dart';
import 'api_config.dart';
import 'culinary_translator.dart';

class RecipeApiService {
  final http.Client client;

  RecipeApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<RecipeModel>?> fetchRecipes({String query = ''}) async {
    try {
      if (query.trim().isNotEmpty) {
        final uri = Uri.parse(
          '${ApiConfig.theMealDbBaseUrl}${ApiConfig.searchEndpoint}${Uri.encodeComponent(query.trim())}',
        );
        final response = await client
            .get(uri, headers: ApiConfig.defaultHeaders)
            .timeout(ApiConfig.requestTimeout);

        if (response.statusCode == 200) {
          final dynamic decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic> && decoded['meals'] != null) {
            final List<dynamic> meals = decoded['meals'];
            return meals
                .map((item) => _parseMealDbItem(item as Map<String, dynamic>))
                .toList();
          }
        }
        return [];
      }

      // Consulta múltiple concurrente para obtener un catálogo amplio y variado (100+ recetas)
      final letters = ['p', 'b', 'c', 's', 'm'];
      final results = await Future.wait(
        letters.map((letter) => _fetchByLetter(letter)),
      );

      final Map<String, RecipeModel> uniqueMap = {};
      for (final list in results) {
        if (list != null) {
          for (final recipe in list) {
            uniqueMap[recipe.id] = recipe;
          }
        }
      }

      if (uniqueMap.isNotEmpty) {
        return uniqueMap.values.toList();
      }

      // Respaldo simple a endpoint estándar
      final uri = Uri.parse('${ApiConfig.theMealDbBaseUrl}${ApiConfig.searchEndpoint}');
      final response = await client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['meals'] != null) {
          final List<dynamic> meals = decoded['meals'];
          return meals
              .map((item) => _parseMealDbItem(item as Map<String, dynamic>))
              .toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<RecipeModel>?> _fetchByLetter(String letter) async {
    try {
      final uri = Uri.parse('${ApiConfig.theMealDbBaseUrl}/search.php?f=$letter');
      final response = await client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['meals'] != null) {
          final List<dynamic> meals = decoded['meals'];
          return meals
              .map((item) => _parseMealDbItem(item as Map<String, dynamic>))
              .toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<RecipeModel?> fetchRecipeById(String id) async {
    try {
      final cleanId = id.startsWith('mealdb-') ? id.replaceFirst('mealdb-', '') : id;
      final uri = Uri.parse('${ApiConfig.theMealDbBaseUrl}${ApiConfig.lookupEndpoint}$cleanId');
      final response = await client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['meals'] != null) {
          final List<dynamic> meals = decoded['meals'];
          if (meals.isNotEmpty) {
            return _parseMealDbItem(meals.first as Map<String, dynamic>);
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  RecipeModel _parseMealDbItem(Map<String, dynamic> item) {
    final rawId = item['idMeal']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final id = 'mealdb-$rawId';
    final rawTitle = (item['strMeal'] as String?)?.trim() ?? 'Receta Gourmet';
    final title = CulinaryTranslator.translateTitle(rawTitle);
    final area = (item['strArea'] as String?)?.trim() ?? '';
    final areaSpanish = CulinaryTranslator.translateArea(area);
    final rawCategory = (item['strCategory'] as String?)?.trim() ?? 'Almuerzos';

    // Clasificación a las categorías de Culina
    String category = 'Almuerzos';
    final catLower = rawCategory.toLowerCase();
    if (catLower.contains('pasta')) {
      category = 'Pastas';
    } else if (catLower.contains('breakfast')) {
      category = 'Desayunos';
    } else if (catLower.contains('dessert')) {
      category = 'Postres';
    } else if (catLower.contains('salad') || catLower.contains('side')) {
      category = 'Ensaladas';
    } else {
      category = 'Almuerzos';
    }

    // Icono y tema visual artesanal
    String icon = '🍲';
    String colorTheme = 'Terracota';
    if (category == 'Pastas') {
      icon = '🍝';
      colorTheme = 'Trigo';
    } else if (category == 'Desayunos') {
      icon = '🥐';
      colorTheme = 'Trigo';
    } else if (category == 'Postres') {
      icon = '🍰';
      colorTheme = 'Cacao';
    } else if (category == 'Ensaladas') {
      icon = '🥗';
      colorTheme = 'Olivo';
    }

    // Extracción y traducción de ingredientes y cantidades
    final List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final name = item['strIngredient$i'] as String?;
      final measure = item['strMeasure$i'] as String?;

      if (name != null && name.trim().isNotEmpty) {
        final cleanName = name.trim();
        final cleanMeasure = (measure ?? '').trim();

        double baseAmount = 1;
        String rawUnit = cleanMeasure;

        final match = RegExp(r'^(\d+(?:\.\d+)?|\d+/\d+)').firstMatch(cleanMeasure);
        if (match != null) {
          final numberPart = match.group(1)!;
          if (numberPart.contains('/')) {
            final parts = numberPart.split('/');
            final num = double.tryParse(parts[0]) ?? 1;
            final den = double.tryParse(parts[1]) ?? 1;
            baseAmount = num / den;
          } else {
            baseAmount = double.tryParse(numberPart) ?? 1;
          }
          rawUnit = cleanMeasure.substring(match.end).trim();
          if (rawUnit.isEmpty) rawUnit = 'unidades';
        } else {
          rawUnit = cleanMeasure.isNotEmpty ? cleanMeasure : 'al gusto';
        }

        final translatedName = CulinaryTranslator.translateIngredientName(cleanName);
        final translatedUnit = CulinaryTranslator.translateUnit(rawUnit);

        ingredients.add(
          Ingredient(
            name: translatedName,
            baseAmount: baseAmount > 0 ? baseAmount : 1,
            unit: translatedUnit,
          ),
        );
      }
    }

    // Extracción y traducción de pasos de preparación
    final instructions = item['strInstructions'] as String? ?? '';
    final rawSteps = instructions
        .split(RegExp(r'\r?\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 5 && !RegExp(r'^(step\s*\d+|paso\s*\d+)', caseSensitive: false).hasMatch(s))
        .toList();

    final translatedSteps = rawSteps.isNotEmpty
        ? rawSteps.map((s) => CulinaryTranslator.translateInstructionStep(s)).toList()
        : [
            instructions.isNotEmpty
                ? CulinaryTranslator.translateInstructionStep(instructions)
                : 'Preparar los ingredientes frescos y cocinar siguiendo la técnica tradicional.'
          ];

    final difficulty = ingredients.length <= 6
        ? 'Fácil'
        : ingredients.length <= 11
            ? 'Media'
            : 'Difícil';

    final prepTime = (10 + (ingredients.length * 1.5).round()).clamp(10, 40);
    final cookTime = (15 + (translatedSteps.length * 2.5).round()).clamp(10, 50);

    return RecipeModel(
      id: id,
      title: title,
      subtitle: CulinaryTranslator.translateSubtitle(area, category),
      description: CulinaryTranslator.translateDescription(area, category),
      category: category,
      difficulty: difficulty,
      prepTime: prepTime,
      cookTime: cookTime,
      servings: 4,
      icon: icon,
      colorTheme: colorTheme,
      author: areaSpanish.isNotEmpty ? 'Cocina $areaSpanish' : 'TheMealDB Chef',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: ingredients.isNotEmpty
          ? ingredients
          : [Ingredient(name: 'Ingredientes tradicionales', baseAmount: 1, unit: 'porción')],
      steps: translatedSteps,
      createdAt: DateTime.now(),
    );
  }
}
