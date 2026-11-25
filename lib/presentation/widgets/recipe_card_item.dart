import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/recipe.dart';
import '../theme/app_theme.dart';
import 'culina_food_graphic.dart';

class RecipeCardItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RecipeCardItem({
    super.key,
    required this.recipe,
    required this.onTap,
    this.onToggleFavorite,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textMutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    // Colores semánticos de dificultad
    Color diffBg;
    Color diffText;
    if (recipe.difficulty == 'Fácil') {
      diffBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
      diffText = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
    } else if (recipe.difficulty == 'Media') {
      diffBg = isDark ? const Color(0xFF78350F) : const Color(0xFFFFFBEB);
      diffText = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
    } else {
      diffBg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
      diffText = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ilustración de comida con botón flotante de favorito
                Stack(
                  children: [
                    CulinaFoodGraphic(
                      icon: recipe.icon,
                      colorTheme: recipe.colorTheme,
                      size: 140,
                    ),
                    Positioned(
                      top: 10,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onToggleFavorite?.call();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF282522) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            recipe.isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: recipe.isFavorite ? AppColors.orangeAccent : (isDark ? Colors.white70 : AppColors.textMuted),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Etiqueta de porciones en la imagen
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🍽️ ', style: TextStyle(fontSize: 10)),
                            Text(
                              '${recipe.servings} ${recipe.servings == 1 ? "porción" : "porciones"}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Fila de Badges Semánticos Claros (Categoría, Tiempo, Dificultad)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // Categoría
                    _buildPill(
                      icon: Icons.restaurant_menu_rounded,
                      label: recipe.category,
                      bgColor: isDark ? const Color(0xFF282522) : const Color(0xFFF4EFEA),
                      textColor: textColor,
                    ),
                    // Tiempo
                    _buildPill(
                      icon: Icons.timer_outlined,
                      label: '${recipe.totalTime} min',
                      bgColor: isDark ? const Color(0xFF332A15) : const Color(0xFFFEF3C7),
                      textColor: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                    ),
                    // Dificultad
                    _buildPill(
                      icon: Icons.bolt_rounded,
                      label: recipe.difficulty,
                      bgColor: diffBg,
                      textColor: diffText,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Título de la receta
                Text(
                  recipe.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtítulo o descripción breve
                Text(
                  recipe.subtitle.isNotEmpty ? recipe.subtitle : recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    height: 1.4,
                    color: textMutedColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Pie de tarjeta: Autor y acciones
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 14, color: textMutedColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              recipe.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textMutedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    if (onEdit != null || onDelete != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              color: textMutedColor,
                              tooltip: 'Editar',
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              onPressed: onEdit,
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18),
                              color: Colors.redAccent,
                              tooltip: 'Eliminar',
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              onPressed: onDelete,
                            ),
                        ],
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver preparación',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orangeAccent,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.orangeAccent),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
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
