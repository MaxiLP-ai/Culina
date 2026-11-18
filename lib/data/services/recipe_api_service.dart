import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import 'api_config.dart';

class RecipeApiService {
  final http.Client client;

  RecipeApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<RecipeModel>?> fetchRecipes() async {
    if (!ApiConfig.isConfigured) return null;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipesEndpoint}');
      final response = await client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List<dynamic> list = decoded is List ? decoded : (decoded['data'] ?? []);
        return list.map((item) => RecipeModel.fromMap(item as Map<String, dynamic>)).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<RecipeModel?> fetchRecipeById(String id) async {
    if (!ApiConfig.isConfigured) return null;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipesEndpoint}/$id');
      final response = await client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic> data = decoded is Map<String, dynamic> && decoded.containsKey('data')
            ? decoded['data']
            : decoded;
        return RecipeModel.fromMap(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<RecipeModel?> createRecipe(RecipeModel recipe) async {
    if (!ApiConfig.isConfigured) return null;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipesEndpoint}');
      final response = await client
          .post(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(recipe.toMap()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic> data = decoded is Map<String, dynamic> && decoded.containsKey('data')
            ? decoded['data']
            : decoded;
        return RecipeModel.fromMap(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<RecipeModel?> updateRecipe(RecipeModel recipe) async {
    if (!ApiConfig.isConfigured) return null;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipesEndpoint}/${recipe.id}');
      final response = await client
          .put(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(recipe.toMap()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic> data = decoded is Map<String, dynamic> && decoded.containsKey('data')
            ? decoded['data']
            : decoded;
        return RecipeModel.fromMap(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool?> deleteRecipe(String id) async {
    if (!ApiConfig.isConfigured) return null;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipesEndpoint}/$id');
      final response = await client
          .delete(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.requestTimeout);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return null;
    }
  }
}
