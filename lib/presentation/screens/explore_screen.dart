import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card_item.dart';
import 'recipe_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'name': 'Todas', 'icon': '🍽️'},
    {'name': 'Desayunos', 'icon': '🥐'},
    {'name': 'Pastas', 'icon': '🍝'},
    {'name': 'Almuerzos', 'icon': '🍲'},
    {'name': 'Ensaladas', 'icon': '🥗'},
    {'name': 'Postres', 'icon': '🍰'},
    {'name': 'Rápidas', 'icon': '⚡'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context, RecipeProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        String? tempDifficulty = provider.filterDifficulty;
        int? tempMaxTime = provider.filterMaxTime;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
        final borderColor = isDark ? AppColors.borderDark : AppColors.border;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicador de arrastre superior
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filtros de Búsqueda',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Personaliza los resultados a tu gusto',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Dificultad
                    Text(
                      'NIVEL DE DIFICULTAD',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: ['Todas', 'Fácil', 'Media', 'Difícil'].map((diff) {
                        final isSelected = (tempDifficulty ?? 'Todas') == diff;
                        return ChoiceChip(
                          label: Text(diff),
                          selected: isSelected,
                          selectedColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                          backgroundColor: isDark ? const Color(0xFF282522) : const Color(0xFFF4EFEA),
                          labelStyle: TextStyle(
                            color: isSelected ? (isDark ? Colors.black : Colors.white) : textColor,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setModalState(() {
                              tempDifficulty = diff == 'Todas' ? null : diff;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Tiempo máximo
                    Text(
                      'TIEMPO TOTAL DE PREPARACIÓN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        {'label': 'Sin límite', 'value': null},
                        {'label': '< 15 min', 'value': 15},
                        {'label': '< 30 min', 'value': 30},
                        {'label': '< 45 min', 'value': 45},
                      ].map((item) {
                        final isSelected = tempMaxTime == item['value'];
                        return ChoiceChip(
                          label: Text(item['label'] as String),
                          selected: isSelected,
                          selectedColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                          backgroundColor: isDark ? const Color(0xFF282522) : const Color(0xFFF4EFEA),
                          labelStyle: TextStyle(
                            color: isSelected ? (isDark ? Colors.black : Colors.white) : textColor,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setModalState(() {
                              tempMaxTime = item['value'] as int?;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              provider.clearAllFilters();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textColor,
                              side: BorderSide(color: borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Limpiar Filtros'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              provider.setFilterDifficulty(tempDifficulty);
                              provider.setFilterMaxTime(tempMaxTime);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Aplicar Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.filteredRecipes;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textMutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final hasActiveFilters = recipeProvider.filterDifficulty != null ||
        recipeProvider.filterMaxTime != null ||
        recipeProvider.selectedCategory != 'Todas';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera superior
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explorar Recetas',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Descubre platos por ingrediente, tiempo o categoría',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: textMutedColor,
                    ),
                  ),
                ],
              ),
            ),

            // Barra de Búsqueda Intuitiva con botón de Filtros integrado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => recipeProvider.setSearchQuery(val),
                        style: TextStyle(color: textColor, fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: 'Buscar pasta, pollo, tarta, ensalada...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : AppColors.textMuted,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppColors.orangeAccent,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  color: textMutedColor,
                                  onPressed: () {
                                    _searchController.clear();
                                    recipeProvider.setSearchQuery('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Botón de Filtros con badge de estado
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showFilterModal(context, recipeProvider);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: hasActiveFilters
                            ? (isDark ? const Color(0xFFDDA743) : AppColors.darkButton)
                            : cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: hasActiveFilters
                              ? (isDark ? const Color(0xFFDDA743) : AppColors.darkButton)
                              : borderColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: hasActiveFilters
                                  ? (isDark ? Colors.black : Colors.white)
                                  : textColor,
                            ),
                            if (hasActiveFilters)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.orangeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chips Horizontales de Categorías
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = recipeProvider.selectedCategory.toLowerCase() == cat['name']!.toLowerCase();

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      recipeProvider.setSelectedCategory(cat['name']!);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFFDDA743) : AppColors.darkButton)
                            : cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? const Color(0xFFDDA743) : AppColors.darkButton)
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat['icon']!, style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 6),
                          Text(
                            cat['name']!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected
                                  ? (isDark ? Colors.black : Colors.white)
                                  : textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Fila de chips de filtros activos si los hay
            if (hasActiveFilters)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (recipeProvider.selectedCategory != 'Todas')
                      _buildRemovableFilterChip(
                        label: 'Categoría: ${recipeProvider.selectedCategory}',
                        onRemove: () => recipeProvider.setSelectedCategory('Todas'),
                        isDark: isDark,
                      ),
                    if (recipeProvider.filterDifficulty != null)
                      _buildRemovableFilterChip(
                        label: 'Dificultad: ${recipeProvider.filterDifficulty}',
                        onRemove: () => recipeProvider.setFilterDifficulty(null),
                        isDark: isDark,
                      ),
                    if (recipeProvider.filterMaxTime != null)
                      _buildRemovableFilterChip(
                        label: 'Tiempo: < ${recipeProvider.filterMaxTime} min',
                        onRemove: () => recipeProvider.setFilterMaxTime(null),
                        isDark: isDark,
                      ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        recipeProvider.clearAllFilters();
                      },
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      child: Text(
                        'Limpiar todo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Contador de resultados
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
              child: Text(
                'Mostrando ${recipes.length} ${recipes.length == 1 ? "receta" : "recetas"}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMutedColor,
                ),
              ),
            ),

            // Lista de Recetas
            Expanded(
              child: recipeProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                        ),
                      ),
                    )
                  : recipes.isEmpty
                      ? _buildEmptyState(context, recipeProvider, isDark, textColor, textMutedColor)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return RecipeCardItem(
                              recipe: recipe,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                                  ),
                                );
                              },
                              onToggleFavorite: () {
                                recipeProvider.toggleFavorite(recipe.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      !recipe.isFavorite
                                          ? 'Guardada en favoritos'
                                          : 'Eliminada de favoritos',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableFilterChip({
    required String label,
    required VoidCallback onRemove,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 3, 4, 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF785E28) : const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onRemove();
            },
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    RecipeProvider provider,
    bool isDark,
    Color textColor,
    Color textMutedColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍳', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'No encontramos resultados',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Intenta buscar con otros ingredientes o limpia los filtros activos para ver todo el catálogo.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: textMutedColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                _searchController.clear();
                provider.clearAllFilters();
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Restablecer Búsqueda'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
