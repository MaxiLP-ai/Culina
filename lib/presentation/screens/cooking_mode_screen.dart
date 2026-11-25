import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/recipe.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/culina_food_graphic.dart';

class CookingModeScreen extends StatefulWidget {
  final Recipe recipe;
  final int servings;

  const CookingModeScreen({
    super.key,
    required this.recipe,
    required this.servings,
  });

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  int _currentStepIndex = 0;

  // Temporizador de cocina interactivo
  Timer? _timer;
  int _remainingSeconds = 0;
  int _initialTimerSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    // Sugerencia inicial basada en el tiempo de coccion de la receta
    final defaultMinutes = widget.recipe.cookTime > 0 ? widget.recipe.cookTime : 5;
    _setTimerMinutes(defaultMinutes);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setTimerMinutes(int minutes) {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = minutes * 60;
      _initialTimerSeconds = _remainingSeconds;
      _isTimerRunning = false;
    });
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isTimerRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        HapticFeedback.heavyImpact();
        _showTimerAlert();
      }
    });
  }

  void _pauseTimer() {
    HapticFeedback.selectionClick();
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    HapticFeedback.selectionClick();
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _initialTimerSeconds;
      _isTimerRunning = false;
    });
  }

  void _showTimerAlert() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.alarm_on_rounded, color: AppColors.orangeAccent, size: 28),
            const SizedBox(width: 8),
            Text(
              '¡Tiempo completado!',
              style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'El temporizador de cocina ha llegado a cero. Revisa el estado de tu preparación.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkButton),
            child: const Text('Entendido', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTimerTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showIngredientsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final dividerColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredientes Necesarios',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Calculado para ${widget.servings} ${widget.servings == 1 ? "porción" : "porciones"}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: textPrimary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: dividerColor),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.recipe.ingredients.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: dividerColor),
                    itemBuilder: (context, index) {
                      final item = widget.recipe.ingredients[index];
                      final amount = item.formatAmountForServings(widget.recipe.servings, widget.servings);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$amount ${item.unit}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFFDDA743) : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _finishCooking() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CulinaFoodGraphic(
              icon: widget.recipe.icon,
              colorTheme: widget.recipe.colorTheme,
              size: 80,
              showBackground: false,
            ),
            const SizedBox(height: 16),
            Text(
              '¡Buen Provecho!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completaste todos los pasos de "${widget.recipe.title}". Disfruta de tu creación artesanal.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Back to recipe details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Volver a la receta', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final steps = widget.recipe.steps;
    final totalSteps = steps.isNotEmpty ? steps.length : 1;
    final progress = (totalSteps > 0) ? (_currentStepIndex + 1) / totalSteps : 1.0;
    final currentInstruction = steps.isNotEmpty ? steps[_currentStepIndex] : 'Preparar los ingredientes y servir al gusto.';

    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textMuted = isDark ? AppColors.textSecondaryDark.withValues(alpha: 0.7) : AppColors.textMuted;
    final accentColor = isDark ? const Color(0xFFDDA743) : AppColors.darkButton;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MODO COCINA GUIADA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.orangeAccent,
              ),
            ),
            Text(
              widget.recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _showIngredientsSheet,
            icon: const Icon(Icons.kitchen_rounded, size: 18),
            label: const Text('Ingredientes'),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso lineal
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? const Color(0xFF38322D) : AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
              ),
              minHeight: 4,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge del paso actual y porcentaje
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFFDDA743) : AppColors.darkButton,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Paso ${_currentStepIndex + 1} de $totalSteps',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF1E1A17) : Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2825) : const Color(0xFFF3EFE9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(progress * 100).toInt()}% completado',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tarjeta principal con la instrucción del paso en tamaño amplio y legible
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${_currentStepIndex + 1}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? const Color(0xFFDDA743) : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Instrucción a seguir',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentInstruction,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Temporizador integrado para cocinar
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                    color: AppColors.orangeAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Temporizador de Cocina',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _isTimerRunning
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : (isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _isTimerRunning ? '● En marcha' : 'Pausado',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _isTimerRunning ? Colors.green : textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Tiempo digital grande
                          Text(
                            _formatTimerTime(_remainingSeconds),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                              color: _isTimerRunning
                                  ? AppColors.orangeAccent
                                  : textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Botones de control del temporizador
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filledTonal(
                                onPressed: _resetTimer,
                                icon: const Icon(Icons.replay_rounded),
                                tooltip: 'Reiniciar temporizador',
                                style: IconButton.styleFrom(
                                  backgroundColor: isDark ? const Color(0xFF38322D) : const Color(0xFFF3EFE9),
                                  foregroundColor: textPrimary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                                icon: Icon(_isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                                label: Text(
                                  _isTimerRunning ? 'Pausar' : 'Iniciar',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isTimerRunning
                                      ? AppColors.orangeAccent
                                      : accentColor,
                                  foregroundColor: (_isTimerRunning || !isDark) ? Colors.white : const Color(0xFF1E1A17),
                                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Ajustes rápidos de minutos (+1, +3, +5, +10, +15)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: [1, 3, 5, 10, 15].map((mins) {
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  _setTimerMinutes(mins);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2C2825) : const Color(0xFFF8F6F2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Text(
                                    '+$mins min',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controles de navegación inferior (Paso anterior / Siguiente / Finalizar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  if (_currentStepIndex > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _currentStepIndex--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: BorderSide(color: borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('← Anterior'),
                      ),
                    ),
                  if (_currentStepIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStepIndex < totalSteps - 1) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _currentStepIndex++;
                          });
                        } else {
                          _finishCooking();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: isDark ? const Color(0xFF1E1A17) : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentStepIndex < totalSteps - 1 ? 'Siguiente Paso →' : '¡Completar Receta! 🎉',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

