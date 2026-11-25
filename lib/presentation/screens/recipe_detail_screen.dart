import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/services/culinary_translator.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/culina_food_graphic.dart';
import 'cooking_mode_screen.dart';
import 'create_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _currentServings;
  late List<bool> _checkedIngredients;

  @override
  void initState() {
    super.initState();
    _currentServings = widget.recipe.servings > 0 ? widget.recipe.servings : 4;
    _checkedIngredients = List.filled(widget.recipe.ingredients.length, false);
  }

  String _formatUnitForAmount(String amount, String unit) {
    if (amount == '1') {
      final lower = unit.trim().toLowerCase();
      if (lower == 'unidades') return 'unidad';
      if (lower == 'dientes') return 'diente';
      if (lower == 'cucharadas') return 'cucharada';
      if (lower == 'cucharaditas') return 'cucharadita';
      if (lower == 'tazas') return 'taza';
      if (lower == 'rebanadas') return 'rebanada';
      if (lower == 'piezas') return 'pieza';
      if (lower == 'ramitas') return 'ramita';
      if (lower == 'hojas') return 'hoja';
      if (lower == 'puñados') return 'puñado';
    }
    return unit;
  }

  void _shareRecipe(Recipe recipe) {
    HapticFeedback.lightImpact();
    final buffer = StringBuffer();
    buffer.writeln('🍽️ ${recipe.title}');
    if (recipe.subtitle.isNotEmpty) buffer.writeln('${recipe.subtitle}\n');
    buffer.writeln('⏱️ Tiempo: ${recipe.totalTime} min (${recipe.prepTime}m prep / ${recipe.cookTime}m cocción)');
    buffer.writeln('👨‍🍳 Dificultad: ${recipe.difficulty} | Porciones: $_currentServings\n');
    buffer.writeln('🛒 Ingredientes:');
    for (final ing in recipe.ingredients) {
      final amount = ing.formatAmountForServings(recipe.servings, _currentServings);
      final translatedName = CulinaryTranslator.translateIngredientName(ing.name);
      final unitLabel = _formatUnitForAmount(amount, ing.unit);
      buffer.writeln(' • $translatedName: $amount $unitLabel'.trim());
    }
    buffer.writeln('\n👨‍🍳 Pasos de preparación:');
    for (var i = 0; i < recipe.steps.length; i++) {
      final step = CulinaryTranslator.translateInstructionStep(recipe.steps[i]);
      buffer.writeln(' ${i + 1}. $step');
    }
    buffer.writeln('\n— Compartido desde Culina');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ficha de receta e ingredientes copiada al portapapeles'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final currentRecipe = recipeProvider.getRecipeById(
      widget.recipe.id,
      fallback: widget.recipe,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textMutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          currentRecipe.category,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            color: textColor,
            tooltip: 'Compartir receta',
            onPressed: () => _shareRecipe(currentRecipe),
          ),
          IconButton(
            icon: Icon(
              currentRecipe.isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: currentRecipe.isFavorite ? AppColors.orangeAccent : textColor,
              size: 22,
            ),
            tooltip: 'Guardar receta',
            onPressed: () {
              HapticFeedback.lightImpact();
              recipeProvider.toggleFavorite(currentRecipe.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    !currentRecipe.isFavorite ? 'Añadida a guardadas' : 'Eliminada de guardadas',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ilustración principal de la receta
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Container(
                        color: isDark ? const Color(0xFF282522) : const Color(0xFFF7F5EE),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: CulinaFoodGraphic(
                          icon: currentRecipe.icon,
                          colorTheme: currentRecipe.colorTheme,
                          size: 180,
                          showBackground: false,
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            currentRecipe.category,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      if (currentRecipe.isFavorite)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.orangeAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bookmark_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Título y subtítulo
              Text(
                currentRecipe.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.25,
                ),
              ),
              if (currentRecipe.subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '“${currentRecipe.subtitle}”',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: textMutedColor,
                  ),
                ),
              ],
              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.person_outline_rounded, size: 15, color: textMutedColor),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Por ${currentRecipe.author}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textMutedColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('·', style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF282522) : const Color(0xFFF3EFEA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentRecipe.difficulty,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barra de Tiempos Clara con Iconos
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeMetric(
                      icon: Icons.hourglass_top_rounded,
                      label: 'PREPARACIÓN',
                      value: '${currentRecipe.prepTime} min',
                      textColor: textColor,
                      mutedColor: textMutedColor,
                    ),
                    Container(height: 28, width: 1, color: borderColor),
                    _buildTimeMetric(
                      icon: Icons.local_fire_department_rounded,
                      label: 'COCCIÓN',
                      value: '${currentRecipe.cookTime} min',
                      textColor: textColor,
                      mutedColor: textMutedColor,
                    ),
                    Container(height: 28, width: 1, color: borderColor),
                    _buildTimeMetric(
                      icon: Icons.timer_outlined,
                      label: 'TIEMPO TOTAL',
                      value: '${currentRecipe.totalTime} min',
                      textColor: isDark ? const Color(0xFFDDA743) : AppColors.orangeAccent,
                      mutedColor: textMutedColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Calculadora de Porciones en Vivo (Super Intuitiva)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF332A15) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF785E28) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🍽️ ', style: TextStyle(fontSize: 13)),
                              Flexible(
                                child: Text(
                                  'Calculadora de Porciones',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ajusta con + o - para recalcular ingredientes',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? const Color(0xFFE5D5A5) : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF785E28) : const Color(0xFFFDE68A),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            color: _currentServings > 1 ? textColor : textMutedColor,
                            onPressed: _currentServings > 1
                                ? () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _currentServings--);
                                  }
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '$_currentServings',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            color: textColor,
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              setState(() => _currentServings++);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Descripción sobre este plato
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SOBRE ESTA PREPARACIÓN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentRecipe.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Checklist Interactivo de Ingredientes
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LISTA DE INGREDIENTES',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF282522) : const Color(0xFFF3EFEA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Para $_currentServings ${_currentServings == 1 ? "porción" : "porciones"}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca un ingrediente para marcarlo mientras preparas la mesada',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: textMutedColor,
                      ),
                    ),
                    const SizedBox(height: 14),

                    ...currentRecipe.ingredients.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ingredient = entry.value;
                      final isChecked = index < _checkedIngredients.length
                          ? _checkedIngredients[index]
                          : false;

                      final scaledAmount = ingredient.formatAmountForServings(
                        currentRecipe.servings,
                        _currentServings,
                      );
                      final displayName = CulinaryTranslator.translateIngredientName(ingredient.name);
                      final unitLabel = _formatUnitForAmount(scaledAmount, ingredient.unit);

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (index < _checkedIngredients.length) {
                              _checkedIngredients[index] = !_checkedIngredients[index];
                            }
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isChecked
                                ? (isDark ? const Color(0xFF1E2822) : const Color(0xFFF4F9F5))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                isChecked
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 20,
                                color: isChecked
                                    ? const Color(0xFF059669)
                                    : (isDark ? Colors.white38 : AppColors.textMuted),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  displayName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    color: isChecked ? textMutedColor : textColor,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF282522) : const Color(0xFFF3EFEA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$scaledAmount $unitLabel'.trim(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isChecked ? textMutedColor : textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pasos de Preparación Numerados
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASOS DE PREPARACIÓN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? const Color(0xFFDDA743) : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...currentRecipe.steps.asMap().entries.map((entry) {
                      final stepNum = entry.key + 1;
                      final instruction = entry.value;
                      final displayInstruction = CulinaryTranslator.translateInstructionStep(instruction);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF332A15) : const Color(0xFFF3EFE9),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$stepNum',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? const Color(0xFFFDE68A) : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                displayInstruction,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  height: 1.5,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botón destacado: Iniciar Modo Cocina Paso a Paso
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CookingModeScreen(
                          recipe: currentRecipe,
                          servings: _currentServings,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.soup_kitchen_rounded, size: 22),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Iniciar Modo Cocina Paso a Paso',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'Vista ampliada y temporizador integrado',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              if (currentRecipe.isUserCreated)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CreateRecipeScreen(recipeToEdit: currentRecipe),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Editar esta receta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: mutedColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: mutedColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
