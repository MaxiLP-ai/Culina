import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/recipe.dart';
import '../theme/app_theme.dart';
import 'culina_food_graphic.dart';

class FeaturedRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const FeaturedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textMutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de la tarjeta destacada
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF332A15) : AppColors.yellowBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF785E28) : AppColors.yellowBadgeBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⭐ ', style: TextStyle(fontSize: 11)),
                      Text(
                        'PLATO DEL DÍA',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFFFDE68A) : AppColors.yellowBadgeText,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggleFavorite();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      recipe.isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: recipe.isFavorite ? AppColors.orangeAccent : textMutedColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Gráfico de comida central
            CulinaFoodGraphic(
              icon: recipe.icon,
              colorTheme: recipe.colorTheme,
              size: 155,
            ),
            const SizedBox(height: 14),

            // Badges informativos
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildBadge(
                  icon: Icons.restaurant_menu_rounded,
                  label: recipe.category,
                  color: isDark ? const Color(0xFF282522) : const Color(0xFFF4EFEA),
                  textColor: textColor,
                ),
                _buildBadge(
                  icon: Icons.timer_outlined,
                  label: '${recipe.totalTime} min',
                  color: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
                  textColor: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                ),
                _buildBadge(
                  icon: Icons.bolt_rounded,
                  label: recipe.difficulty,
                  color: isDark ? const Color(0xFF1E3A2F) : const Color(0xFFECFDF5),
                  textColor: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857),
                ),
                _buildBadge(
                  icon: Icons.group_outlined,
                  label: '${recipe.servings} porc.',
                  color: isDark ? const Color(0xFF282522) : const Color(0xFFF4EFEA),
                  textColor: textColor,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Título
            Text(
              recipe.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),

            // Subtítulo
            Text(
              recipe.subtitle.isNotEmpty ? recipe.subtitle : recipe.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: textMutedColor,
              ),
            ),
            const SizedBox(height: 14),

            // Botón de acción destacado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver Receta y Cocinar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
