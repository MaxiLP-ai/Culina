import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/featured_recipe_card.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final recipeProvider = context.watch<RecipeProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textMutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final user = userProvider.user;
    final userName = user?.name.split(' ').first ?? 'Matias';
    final userInitials = user?.initials ?? 'MT';

    final featured = recipeProvider.featuredRecipe;
    final quickRecipes = recipeProvider.quickRecipes;
    final categoryCounts = recipeProvider.categoryCounts;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => recipeProvider.loadRecipes(),
          color: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra superior de navegación y perfil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Culina',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Cocina artesanal paso a paso',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: textMutedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded, size: 22),
                            color: textColor,
                            tooltip: 'Buscar recetas',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => onNavigateTab(1),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => onNavigateTab(4),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF785E28) : const Color(0xFFFDE68A),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  userInitials,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tarjeta de Saludo e Invitación a Buscar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, $userName! 👋',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '¿Qué te gustaría preparar hoy?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: textMutedColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Buscador visual interactivo con atajo rápido
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onNavigateTab(1);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF282522) : const Color(0xFFFAF9F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                size: 19,
                                color: AppColors.orangeAccent,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Buscar pastas, ensaladas, postres...',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: isDark ? Colors.white54 : AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF332A15) : const Color(0xFFF3EFEA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 13,
                                      color: isDark ? const Color(0xFFFDE68A) : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Filtros',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFFFDE68A) : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Sección de Categorías
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXPLORAR CATEGORÍAS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          recipeProvider.setSelectedCategory('Todas');
                          onNavigateTab(1);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver catálogo',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.orangeAccent,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: AppColors.orangeAccent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Carrusel horizontal de categorías
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChipItem(
                        label: 'Desayunos',
                        icon: '🥐',
                        count: categoryCounts['Desayunos'] ?? 0,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Desayunos');
                          onNavigateTab(1);
                        },
                      ),
                      CategoryChipItem(
                        label: 'Pastas',
                        icon: '🍝',
                        count: categoryCounts['Pastas'] ?? 0,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Pastas');
                          onNavigateTab(1);
                        },
                      ),
                      CategoryChipItem(
                        label: 'Almuerzos',
                        icon: '🍲',
                        count: categoryCounts['Almuerzos'] ?? 0,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Almuerzos');
                          onNavigateTab(1);
                        },
                      ),
                      CategoryChipItem(
                        label: 'Ensaladas',
                        icon: '🥗',
                        count: categoryCounts['Ensaladas'] ?? 0,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Ensaladas');
                          onNavigateTab(1);
                        },
                      ),
                      CategoryChipItem(
                        label: 'Postres',
                        icon: '🍰',
                        count: categoryCounts['Postres'] ?? 0,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Postres');
                          onNavigateTab(1);
                        },
                      ),
                      CategoryChipItem(
                        label: 'Rápidas',
                        icon: '⚡',
                        count: quickRecipes.length,
                        isSelected: false,
                        onTap: () {
                          recipeProvider.setSelectedCategory('Rápidas');
                          onNavigateTab(1);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Receta recomendada del día
                if (featured != null)
                  FeaturedRecipeCard(
                    recipe: featured,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recipe: featured),
                        ),
                      );
                    },
                    onToggleFavorite: () {
                      recipeProvider.toggleFavorite(featured.id);
                      final isFav = !featured.isFavorite;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav ? 'Guardada en tus favoritos' : 'Eliminada de favoritos',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 20),

                // Sección: Listas en menos de 25 minutos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⚡ ', style: TextStyle(fontSize: 14)),
                            Flexible(
                              child: Text(
                                'Listas en menos de 25 min',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          recipeProvider.setSelectedCategory('Rápidas');
                          onNavigateTab(1);
                        },
                        child: Text(
                          'Ver todas',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Carrusel horizontal de recetas rápidas
                SizedBox(
                  height: 185,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: quickRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = quickRecipes[index];
                      return _buildQuickRecipeCard(context, recipe, recipeProvider, isDark, cardBg, borderColor, textColor, textMutedColor);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickRecipeCard(
    BuildContext context,
    Recipe recipe,
    RecipeProvider provider,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMutedColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282522) : const Color(0xFFF7F5EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  recipe.icon,
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 10, color: Color(0xFF92400E)),
                      const SizedBox(width: 3),
                      Text(
                        '${recipe.totalTime}m',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  recipe.difficulty,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textMutedColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
