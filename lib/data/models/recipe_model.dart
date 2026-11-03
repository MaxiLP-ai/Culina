import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.description,
    required super.category,
    required super.difficulty,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    required super.icon,
    super.colorTheme = 'Trigo',
    required super.author,
    super.isFavorite = false,
    super.isFeatured = false,
    super.isUserCreated = false,
    required super.ingredients,
    required super.steps,
    super.createdAt,
  });

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      title: recipe.title,
      subtitle: recipe.subtitle,
      description: recipe.description,
      category: recipe.category,
      difficulty: recipe.difficulty,
      prepTime: recipe.prepTime,
      cookTime: recipe.cookTime,
      servings: recipe.servings,
      icon: recipe.icon,
      colorTheme: recipe.colorTheme,
      author: recipe.author,
      isFavorite: recipe.isFavorite,
      isFeatured: recipe.isFeatured,
      isUserCreated: recipe.isUserCreated,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      createdAt: recipe.createdAt,
    );
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Almuerzos',
      difficulty: map['difficulty'] as String? ?? 'Fácil',
      prepTime: (map['prepTime'] as num?)?.toInt() ?? 15,
      cookTime: (map['cookTime'] as num?)?.toInt() ?? 20,
      servings: (map['servings'] as num?)?.toInt() ?? 2,
      icon: map['icon'] as String? ?? '🍲',
      colorTheme: map['colorTheme'] as String? ?? 'Trigo',
      author: map['author'] as String? ?? 'Matías Tapia',
      isFavorite: map['isFavorite'] as bool? ?? false,
      isFeatured: map['isFeatured'] as bool? ?? false,
      isUserCreated: map['isUserCreated'] as bool? ?? false,
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (map['steps'] as List<dynamic>?)
              ?.map((step) => step.toString())
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'icon': icon,
      'colorTheme': colorTheme,
      'author': author,
      'isFavorite': isFavorite,
      'isFeatured': isFeatured,
      'isUserCreated': isUserCreated,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'steps': steps,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

