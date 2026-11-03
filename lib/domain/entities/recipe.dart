import 'ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final String difficulty;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int servings;
  final String icon;
  final String colorTheme; // 'Olivo', 'Trigo', 'Trufa', 'Terracota', 'Cacao', 'Cúrcuma'
  final String author;
  final bool isFavorite;
  final bool isFeatured;
  final bool isUserCreated;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.icon,
    this.colorTheme = 'Trigo',
    required this.author,
    this.isFavorite = false,
    this.isFeatured = false,
    this.isUserCreated = false,
    required this.ingredients,
    required this.steps,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalTime => prepTime + cookTime;

  Recipe copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? category,
    String? difficulty,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? icon,
    String? colorTheme,
    String? author,
    bool? isFavorite,
    bool? isFeatured,
    bool? isUserCreated,
    List<Ingredient>? ingredients,
    List<String>? steps,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      icon: icon ?? this.icon,
      colorTheme: colorTheme ?? this.colorTheme,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      isFeatured: isFeatured ?? this.isFeatured,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

