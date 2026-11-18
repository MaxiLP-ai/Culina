class CulinaryTranslator {
  static final Map<String, String> _exactTitles = {
    'mediterranean pasta salad': 'Ensalada de Pasta Mediterránea',
    'spaghetti bolognese': 'Espaguetis a la Boloñesa Tradicional',
    'lasagna': 'Lasaña Clásica Artesanal',
    'lasagne': 'Lasaña Tradicional al Horno',
    'fettuccine alfredo': 'Fettuccine Alfredo Cremoso',
    'arrabiata': 'Penne all’Arrabbiata con Tomates y Albahaca',
    'chili con carne': 'Chili con Carne y Frijoles Rústico',
    'beef and mustard pie': 'Pastel Rústico de Carne y Mostaza',
    'beef brenton': 'Estofado de Carne Bourguignon',
    'chicken & mushroom hotpot': 'Cazuela de Pollo y Champiñones',
    'chicken marengo': 'Pollo Marengo con Tomates y Romero',
    'chicken fajitas': 'Fajitas de Pollo con Pimientos Asados',
    'teriyaki chicken casserole': 'Cazuela de Pollo Teriyaki con Sésamo',
    'apple frangipan tart': 'Tarta Rústica de Manzana y Almendras',
    'apple & blackberry crumble': 'Crumble Artesanal de Manzana y Moras',
    'pancakes': 'Panqueques Dorados de Avena y Miel',
    'chocolate gateau': 'Gâteau Artesanal de Chocolate Intenso',
    'french onion soup': 'Sopa de Cebolla Gratinada a la Francesa',
    'ratatouille': 'Ratatouille Campestre con Vegetales de Estación',
    'guacamole': 'Guacamole Rústico con Cilantro y Lima',
  };

  static final Map<String, String> _titleWords = {
    'salad': 'Ensalada',
    'pasta': 'Pasta',
    'soup': 'Sopa',
    'pie': 'Pastel',
    'tart': 'Tarta',
    'cake': 'Tarta',
    'bread': 'Pan',
    'chicken': 'Pollo',
    'beef': 'Carne',
    'pork': 'Cerdo',
    'fish': 'Pescado',
    'salmon': 'Salmón',
    'tuna': 'Atún',
    'shrimp': 'Camarones',
    'prawns': 'Langostinos',
    'stew': 'Estofado',
    'casserole': 'Cazuela',
    'curry': 'Curry',
    'rice': 'Arroz',
    'roasted': 'Asado',
    'roast': 'Asado',
    'fried': 'Frito',
    'grilled': 'a la Parrilla',
    'baked': 'al Horno',
    'creamy': 'Cremoso',
    'spicy': 'Picante',
    'sweet': 'Dulce',
    'and': 'y',
    'with': 'con',
    'garlic': 'al Ajillo',
    'lemon': 'al Limón',
    'herb': 'a las Hierbas',
    'mushroom': 'con Champiñones',
    'mushrooms': 'con Champiñones',
    'cheese': 'con Queso',
  };

  static final Map<String, String> _ingredients = {
    'olive oil': 'Aceite de oliva extra virgen',
    'extra virgin olive oil': 'Aceite de oliva extra virgen',
    'vegetable oil': 'Aceite vegetal',
    'sunflower oil': 'Aceite de girasol',
    'butter': 'Mantequilla sin sal',
    'unsalted butter': 'Mantequilla sin sal',
    'garlic': 'Dientes de ajo',
    'garlic cloves': 'Dientes de ajo',
    'clove garlic': 'Diente de ajo',
    'onion': 'Cebolla blanca',
    'onions': 'Cebollas',
    'red onion': 'Cebolla morada',
    'spring onions': 'Cebollines / Cebolla de verdeo',
    'shallots': 'Echalotes',
    'tomato': 'Tomate maduro',
    'tomatoes': 'Tomates maduros',
    'cherry tomatoes': 'Tomates cherry dulces',
    'baby plum tomatoes': 'Tomates ciruela cherry',
    'tomato puree': 'Puré de tomates concentrado',
    'chopped tomatoes': 'Tomates triturados en conserva',
    'plum tomatoes': 'Tomates perita maduros',
    'flour': 'Harina de trigo fina',
    'plain flour': 'Harina de trigo tradicional',
    'self-raising flour': 'Harina leudante para repostería',
    'all purpose flour': 'Harina de trigo de uso común',
    'egg': 'Huevo de campo',
    'eggs': 'Huevos de campo frescos',
    'egg yolk': 'Yema de huevo',
    'egg white': 'Clara de huevo',
    'salt': 'Sal marina fina',
    'sea salt': 'Sal marina gruesa',
    'pepper': 'Pimienta negra molida',
    'black pepper': 'Pimienta negra recién molida',
    'water': 'Agua pura',
    'milk': 'Leche entera fresca',
    'heavy cream': 'Crema de leche espesa',
    'double cream': 'Crema de leche para batir',
    'sour cream': 'Crema agria',
    'cheese': 'Queso rallado',
    'cheddar cheese': 'Queso Cheddar curado',
    'parmesan': 'Queso Parmesano Reggiano',
    'parmesan cheese': 'Queso Parmigiano Reggiano rallado',
    'mozzarella': 'Queso mozzarella fresco',
    'mozzarella balls': 'Bolas de queso mozzarella de búfala',
    'feta cheese': 'Queso Feta griego',
    'chicken': 'Carne de pollo',
    'chicken breasts': 'Pechugas de pollo deshuesadas',
    'chicken breast': 'Pechuga de pollo fresca',
    'chicken thighs': 'Muslos de pollo',
    'chicken stock': 'Caldo casero de pollo',
    'beef': 'Carne de res seleccionada',
    'minced beef': 'Carne picada de res magra',
    'beef stock': 'Caldo concentrado de carne',
    'pork': 'Carne de cerdo magra',
    'bacon': 'Panceta ahumada crujiente',
    'tuna': 'Lomos de atún al natural',
    'salmon': 'Filete de salmón rosado',
    'farfalle': 'Pasta farfalle artesanal',
    'spaghetti': 'Espaguetis al dente',
    'penne': 'Penne rigate',
    'fusilli': 'Pasta fusilli',
    'pasta': 'Pasta seca artesanal',
    'rice': 'Arroz blanco de grano fino',
    'basmati rice': 'Arroz basmati aromático',
    'sugar': 'Azúcar blanco refinado',
    'brown sugar': 'Azúcar rubia o mascabo',
    'caster sugar': 'Azúcar glas fina',
    'honey': 'Miel pura de abejas',
    'basil': 'Hojas de albahaca fresca',
    'fresh basil': 'Hojas de albahaca fresca de huerta',
    'parsley': 'Perejil fresco picado',
    'fresh parsley': 'Perejil fresco picado fino',
    'coriander': 'Cilantro fresco',
    'cilantro': 'Cilantro fresco aromático',
    'oregano': 'Orégano seco molido',
    'thyme': 'Ramas de tomillo fresco',
    'rosemary': 'Hojas de romero fresco',
    'green olives': 'Aceitunas verdes deshuesadas',
    'black olives': 'Aceitunas negras descarozadas',
    'mushrooms': 'Champiñones frescos fileteados',
    'lemon': 'Limón fresco entero',
    'lemon juice': 'Jugo de limón recién exprimido',
    'lime': 'Lima fresca',
    'lime juice': 'Jugo de lima fresca',
    'avocado': 'Palta / Aguacate maduro cremoso',
    'red pepper': 'Pimiento rojo dulce',
    'green pepper': 'Pimiento verde crocante',
    'carrots': 'Zanahorias frescas ralladas',
    'carrot': 'Zanahoria fresca en cubos',
    'potatoes': 'Papas / Patatas medianas peladas',
    'potato': 'Papa / Patata pelada',
  };

  static final Map<String, String> _units = {
    'tablespoon': 'cucharada',
    'tablespoons': 'cucharadas',
    'tbsp': 'cdas.',
    'teaspoon': 'cucharadita',
    'teaspoons': 'cucharaditas',
    'tsp': 'cdtas.',
    'cup': 'taza',
    'cups': 'tazas',
    'g': 'gramos',
    'kg': 'kg',
    'ml': 'ml',
    'litres': 'litros',
    'liter': 'litro',
    'pinch': 'pizca',
    'pinches': 'pizcas',
    'to taste': 'al gusto',
    'clove': 'diente',
    'cloves': 'dientes',
    'slice': 'rebanada',
    'slices': 'rebanadas',
    'piece': 'pieza',
    'pieces': 'piezas',
    'bunch': 'ramillete',
    'handful': 'puñado',
    'sprig': 'ramita',
    'sprigs': 'ramitas',
  };

  static final Map<String, String> _areasInSpanish = {
    'italian': 'Italiana',
    'french': 'Francesa',
    'spanish': 'Española',
    'mexican': 'Mexicana',
    'japanese': 'Japonesa',
    'chinese': 'China',
    'thai': 'Tailandesa',
    'indian': 'India',
    'greek': 'Griega',
    'british': 'Británica',
    'american': 'Americana',
    'mediterranean': 'Mediterránea',
    'moroccan': 'Marroquí',
    'turkish': 'Turca',
  };

  static String translateTitle(String rawTitle) {
    final clean = rawTitle.trim();
    final lower = clean.toLowerCase();

    if (_exactTitles.containsKey(lower)) {
      return _exactTitles[lower]!;
    }

    final words = clean.split(' ');
    final translatedWords = words.map((w) {
      final wLower = w.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (_titleWords.containsKey(wLower)) {
        return _titleWords[wLower]!;
      }
      return w;
    }).toList();

    return translatedWords.join(' ');
  }

  static String translateArea(String rawArea) {
    final lower = rawArea.trim().toLowerCase();
    return _areasInSpanish[lower] ?? rawArea.trim();
  }

  static String translateSubtitle(String area, String category) {
    final areaEsp = translateArea(area);
    if (areaEsp.isNotEmpty) {
      return 'Especialidad culinaria tradicional de cocina $areaEsp';
    }
    return 'Receta casera artesanal con ingredientes frescos';
  }

  static String translateDescription(String area, String category) {
    final areaEsp = translateArea(area);
    if (areaEsp.isNotEmpty) {
      return 'Plato emblemático de la gastronomía $areaEsp. Preparado paso a paso con ingredientes seleccionados para resaltar sabores limpios y auténticos.';
    }
    return 'Preparación artesanal equilibrada, ideal para compartir en la mesa familiar y disfrutar de la cocina casera.';
  }

  static String translateIngredientName(String rawName) {
    final clean = rawName.trim();
    final lower = clean.toLowerCase();

    if (_ingredients.containsKey(lower)) {
      return _ingredients[lower]!;
    }

    for (final entry in _ingredients.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    return clean;
  }

  static String translateUnit(String rawUnit) {
    var unit = rawUnit.trim();
    for (final entry in _units.entries) {
      final reg = RegExp('\\b${entry.key}\\b', caseSensitive: false);
      if (reg.hasMatch(unit)) {
        unit = unit.replaceAll(reg, entry.value);
      }
    }
    return unit.isNotEmpty ? unit : 'al gusto';
  }

  static String translateInstructionStep(String step) {
    var s = step.trim();
    if (s.isEmpty) return s;

    // Reemplazos de frases completas de cocina
    final replacements = [
      ['Bring a large saucepan of salted water to the boil', 'Pon a hervir abundante agua con sal en una olla grande'],
      ['Preheat the oven to', 'Precalienta el horno a'],
      ['Heat the olive oil in a large pan', 'Calienta el aceite de oliva en una sartén amplia'],
      ['Heat the oil in a pan', 'Calienta el aceite en una sartén'],
      ['Heat the butter in a pan', 'Derrite la mantequilla en una sartén a fuego medio'],
      ['Season with salt and pepper', 'Sazona al gusto con sal y pimienta negra'],
      ['Sprinkle with black pepper', 'Espolvorea con pimienta negra recién molida'],
      ['Cook for about', 'Cocina durante aproximadamente'],
      ['Cook for', 'Cocina durante'],
      ['Bake for', 'Hornea durante'],
      ['Simmer for', 'Cocina a fuego lento durante'],
      ['Stir well', 'Revuelve bien todos los ingredientes'],
      ['Stir occasionally', 'Revuelve de forma ocasional'],
      ['Meanwhile', 'Mientras tanto'],
      ['Drain into a colander', 'Escurre la preparación en un colador'],
      ['Drain the pasta', 'Escurre la pasta al dente'],
      ['Add the pasta', 'Añade la pasta'],
      ['Add the garlic', 'Incorpora los dientes de ajo picados'],
      ['Add the onions', 'Agrega la cebolla picada'],
      ['Add the tomatoes', 'Incorpora los tomates'],
      ['Slice the', 'Corta en rodajas el/la'],
      ['Chop the', 'Pica finamente el/la'],
      ['Wash the', 'Lava con cuidado el/la'],
      ['Mix well', 'Mezcla homogéneamente'],
      ['Serve hot', 'Sirve caliente de inmediato'],
      ['Serve immediately', 'Sirve de inmediato en platos hondos'],
      ['just before serving', 'justo antes de servir'],
      ['minutes', 'minutos'],
      ['minute', 'minuto'],
      ['hours', 'horas'],
      ['hour', 'hora'],
    ];

    for (final pair in replacements) {
      s = s.replaceAll(RegExp(pair[0], caseSensitive: false), pair[1]);
    }

    // Capitalizar primera letra
    if (s.isNotEmpty) {
      s = s[0].toUpperCase() + s.substring(1);
    }

    return s;
  }
}

