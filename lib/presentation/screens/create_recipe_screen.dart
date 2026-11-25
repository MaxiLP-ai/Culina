import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'recipe_detail_screen.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;

  const CreateRecipeScreen({
    super.key,
    this.recipeToEdit,
  });

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;

  late String _category;
  late String _difficulty;
  late String _selectedIcon;
  late String _selectedColorTheme;

  final List<Ingredient> _ingredients = [];
  final List<String> _steps = [];

  final List<String> _availableIcons = [
    '🥖', '🍲', '🥗', '🥑', '🥔', '🍕',
    '🥪', '🥩', '🍝', '🧀', '🍄', '🥕',
  ];

  final List<String> _availableColors = [
    'Olivo',
    'Trigo',
    'Trufa',
    'Terracota',
    'Cacao',
    'Cúrcuma',
  ];

  final List<String> _categories = [
    'Almuerzos',
    'Desayunos',
    'Pastas',
    'Ensaladas',
    'Postres',
  ];

  final List<String> _difficulties = ['Fácil', 'Media', 'Difícil'];

  bool get isEditing => widget.recipeToEdit != null;

  @override
  void initState() {
    super.initState();
    final r = widget.recipeToEdit;
    _titleController = TextEditingController(text: r?.title ?? '');
    _subtitleController = TextEditingController(text: r?.subtitle ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _prepTimeController = TextEditingController(text: r?.prepTime.toString() ?? '15');
    _cookTimeController = TextEditingController(text: r?.cookTime.toString() ?? '20');
    _servingsController = TextEditingController(text: r?.servings.toString() ?? '2');

    _category = r?.category ?? 'Almuerzos';
    _difficulty = r?.difficulty ?? 'Fácil';
    _selectedIcon = r?.icon ?? '🍲';
    _selectedColorTheme = r?.colorTheme ?? 'Trigo';

    if (r != null) {
      _ingredients.addAll(r.ingredients);
      _steps.addAll(r.steps);
    } else {
      _ingredients.addAll([
        Ingredient(name: 'Ingrediente principal fresco', baseAmount: 300, unit: 'g'),
        Ingredient(name: 'Aceite de oliva extra virgen', baseAmount: 2, unit: 'cdas'),
        Ingredient(name: 'Sal marina y especias al gusto', baseAmount: 1, unit: 'pizca'),
      ]);
      _steps.addAll([
        'Lavar y acondicionar todos los ingredientes en la mesada.',
        'Cocinar a fuego lento para integrar los aromas y sabores artesanales.',
        'Servir caliente y decorar con hierbas frescas recién cortadas.',
      ]);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  Recipe _buildCurrentRecipe({String? tempId}) {
    final userProvider = context.read<UserProvider>();
    final authorName = userProvider.user?.name ?? 'Matías Tapia';

    return Recipe(
      id: widget.recipeToEdit?.id ?? tempId ?? 'receta-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim().isEmpty ? 'Nueva Receta' : _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Una deliciosa preparación artesanal elaborada con esmero y técnica culinaria tradicional.'
          : _descriptionController.text.trim(),
      category: _category,
      difficulty: _difficulty,
      prepTime: int.tryParse(_prepTimeController.text) ?? 15,
      cookTime: int.tryParse(_cookTimeController.text) ?? 20,
      servings: int.tryParse(_servingsController.text) ?? 2,
      icon: _selectedIcon,
      colorTheme: _selectedColorTheme,
      author: widget.recipeToEdit?.author ?? authorName,
      isFavorite: widget.recipeToEdit?.isFavorite ?? false,
      isFeatured: widget.recipeToEdit?.isFeatured ?? false,
      isUserCreated: true,
      ingredients: List.from(_ingredients),
      steps: List.from(_steps),
      createdAt: widget.recipeToEdit?.createdAt ?? DateTime.now(),
    );
  }

  void _previewRecipe() {
    final preview = _buildCurrentRecipe(tempId: 'preview');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(recipe: preview),
      ),
    );
  }

  void _adjustPrepTime(int delta) {
    final current = int.tryParse(_prepTimeController.text) ?? 15;
    final updated = (current + delta).clamp(0, 360);
    setState(() {
      _prepTimeController.text = updated.toString();
    });
  }

  void _adjustCookTime(int delta) {
    final current = int.tryParse(_cookTimeController.text) ?? 20;
    final updated = (current + delta).clamp(0, 360);
    setState(() {
      _cookTimeController.text = updated.toString();
    });
  }

  void _adjustServings(int delta) {
    final current = int.tryParse(_servingsController.text) ?? 2;
    final updated = (current + delta).clamp(1, 30);
    setState(() {
      _servingsController.text = updated.toString();
    });
  }

  void _addIngredientDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '100');
    final unitCtrl = TextEditingController(text: 'g');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Agregar Ingrediente', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del ingrediente'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: unitCtrl,
                    decoration: const InputDecoration(labelText: 'Unidad (g, ml, cda)'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _ingredients.add(
                    Ingredient(
                      name: nameCtrl.text.trim(),
                      baseAmount: double.tryParse(amountCtrl.text) ?? 1.0,
                      unit: unitCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkButton),
            child: const Text('Agregar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addStepDialog() {
    final stepCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Agregar Paso', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: stepCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Descripción del paso',
            hintText: 'Explica con detalle la técnica...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (stepCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _steps.add(stepCtrl.text.trim());
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkButton),
            child: const Text('Agregar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente')),
      );
      return;
    }

    final provider = context.read<RecipeProvider>();
    final recipe = _buildCurrentRecipe();

    bool success;
    if (isEditing) {
      success = await provider.updateRecipe(recipe);
    } else {
      success = await provider.createRecipe(recipe);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? '¡Receta actualizada con éxito!' : '¡Receta creada con éxito!'),
          backgroundColor: AppColors.darkButton,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al guardar la receta'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textMuted = isDark ? AppColors.textSecondaryDark.withValues(alpha: 0.7) : AppColors.textMuted;
    final accentColor = isDark ? const Color(0xFFDDA743) : AppColors.darkButton;
    final inputBg = isDark ? const Color(0xFF2C2825) : const Color(0xFFFAF9F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? 'Editar Receta' : 'Nueva Receta',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Title & Subtitle + Previsualizar Button
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Editar Receta' : 'Nueva Receta',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Crea o ajusta tu preparación culinaria',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _previewRecipe,
                    icon: Icon(Icons.visibility_outlined, size: 16, color: textPrimary),
                    label: Text(
                      'Previsualizar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: borderColor),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Section 1: Información Principal
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. INFORMACIÓN PRINCIPAL',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Nombre de la Receta *',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary),
                        decoration: _inputDecoration('ej. Risotto de Portobello y Salvia', inputBg, borderColor, textMuted, accentColor),
                        validator: (v) => v == null || v.trim().isEmpty ? 'El nombre es obligatorio' : null,
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Subtítulo o Frase Breve',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _subtitleController,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary),
                        decoration: _inputDecoration('ej. Arroz arborio cremoso con vino blanco seco', inputBg, borderColor, textMuted, accentColor),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Historia o Detalles del Plato',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary),
                        decoration: _inputDecoration('Describe el origen o maridaje perfecto...', inputBg, borderColor, textMuted, accentColor),
                      ),
                      const SizedBox(height: 16),

                      // Categoría y Dificultad
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categoría',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _category,
                                  dropdownColor: cardBg,
                                  decoration: _dropdownDecoration(inputBg, borderColor, accentColor),
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: textSecondary),
                                  items: _categories.map((c) {
                                    return DropdownMenuItem(
                                      value: c,
                                      child: Text(c, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _category = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dificultad',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _difficulty,
                                  dropdownColor: cardBg,
                                  decoration: _dropdownDecoration(inputBg, borderColor, accentColor),
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: textSecondary),
                                  items: _difficulties.map((d) {
                                    return DropdownMenuItem(
                                      value: d,
                                      child: Text(d, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _difficulty = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Steppers for Prep, Cook, and Servings
                      Row(
                        children: [
                          Expanded(
                            child: _buildStepperField(
                              label: 'Prep (min)',
                              controller: _prepTimeController,
                              onDecrement: () => _adjustPrepTime(-5),
                              onIncrement: () => _adjustPrepTime(5),
                              isDark: isDark,
                              inputBg: inputBg,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStepperField(
                              label: 'Cocción (min)',
                              controller: _cookTimeController,
                              onDecrement: () => _adjustCookTime(-5),
                              onIncrement: () => _adjustCookTime(5),
                              isDark: isDark,
                              inputBg: inputBg,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStepperField(
                              label: 'Porciones',
                              controller: _servingsController,
                              onDecrement: () => _adjustServings(-1),
                              onIncrement: () => _adjustServings(1),
                              isDark: isDark,
                              inputBg: inputBg,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Ícono y Color
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. ÍCONO Y COLOR ARTESANAL',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _availableIcons.map((icon) {
                        final isSelected = _selectedIcon == icon;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedIcon = icon);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? const Color(0xFF423722) : const Color(0xFFFEF3C7))
                                  : inputBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFD97706)
                                    : borderColor,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(icon, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableColors.map((colorName) {
                        final isSelected = _selectedColorTheme == colorName;
                        final color = AppColors.getThemeColor(colorName);

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedColorTheme = colorName);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9))
                                  : inputBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? accentColor : borderColor,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  colorName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: Ingredientes
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '3. INGREDIENTES (${_ingredients.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: textMuted,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addIngredientDialog,
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Agregar', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._ingredients.asMap().entries.map((entry) {
                      final i = entry.key;
                      final ing = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: textMuted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${ing.formatAmountForServings(1, 1)} ${ing.unit} ${ing.name}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close_rounded, size: 16, color: textMuted),
                              onPressed: () => setState(() => _ingredients.removeAt(i)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 4: Pasos
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '4. PASOS DE PREPARACIÓN (${_steps.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: textMuted,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addStepDialog,
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Agregar', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9),
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFFDDA743) : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                step,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close_rounded, size: 16, color: textMuted),
                              onPressed: () => setState(() => _steps.removeAt(i)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: isDark ? const Color(0xFF1E1A17) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? 'Actualizar Receta' : 'Guardar Receta',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required bool isDark,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onDecrement();
                },
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Icon(Icons.remove_rounded, size: 14, color: textSecondary),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onIncrement();
                },
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                child: Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Icon(Icons.add_rounded, size: 14, color: textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, Color fillColor, Color borderColor, Color hintColor, Color focusColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: hintColor,
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
    );
  }

  InputDecoration _dropdownDecoration(Color fillColor, Color borderColor, Color focusColor) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
    );
  }
}
