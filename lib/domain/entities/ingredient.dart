class Ingredient {
  final String name;
  final double baseAmount;
  final String unit;
  bool isChecked;

  Ingredient({
    required this.name,
    required this.baseAmount,
    required this.unit,
    this.isChecked = false,
  });

  double getAmountForServings(int baseServings, int targetServings) {
    if (baseServings <= 0) return baseAmount;
    return (baseAmount / baseServings) * targetServings;
  }

  String formatAmountForServings(int baseServings, int targetServings) {
    final amount = getAmountForServings(baseServings, targetServings);
    if (amount == 0) return '';
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(1);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'baseAmount': baseAmount,
      'unit': unit,
      'isChecked': isChecked,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String? ?? '',
      baseAmount: (map['baseAmount'] as num?)?.toDouble() ?? 1.0,
      unit: map['unit'] as String? ?? '',
      isChecked: map['isChecked'] as bool? ?? false,
    );
  }

  Ingredient copyWith({
    String? name,
    double? baseAmount,
    String? unit,
    bool? isChecked,
  }) {
    return Ingredient(
      name: name ?? this.name,
      baseAmount: baseAmount ?? this.baseAmount,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

