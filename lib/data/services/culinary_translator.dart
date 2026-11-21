class CulinaryTranslator {
  // Diccionario exhaustivo de títulos exactos para platos internacionales frecuentes
  static final Map<String, String> _exactTitles = {
    // Platos de Pasta y Cocina Italiana
    'mediterranean pasta salad': 'Ensalada de Pasta Mediterránea',
    'spaghetti bolognese': 'Espaguetis a la Boloñesa Tradicional',
    'lasagna': 'Lasaña Clásica Artesanal',
    'lasagne': 'Lasaña Tradicional al Horno',
    'fettuccine alfredo': 'Fettuccine Alfredo Cremoso',
    'arrabiata': 'Penne all’Arrabbiata con Tomates y Albahaca',
    'pasta alla genovese': 'Pasta al Pesto Genovés con Albahaca',
    'cacio e pepe': 'Espaguetis Cacio e Pepe con Pimienta Negra',
    'carbonara': 'Espaguetis a la Carbonara Clásica',
    'seafood pasta': 'Pasta Artesanal con Frutos de Mar',
    'penne arrabiata': 'Penne all’Arrabbiata Picante',
    'pilchard puttanesca': 'Pasta a la Puttanesca con Sardinas y Aceitunas',
    'pizza express margherita': 'Pizza Margarita Artesanal con Albahaca',

    // Carnes y Estofados (Beef & Meat)
    'beef wellington': 'Solomillo de Res Wellington en Hojaldre',
    'beef bourguignon': 'Estofado Bourguignon de Res al Vino Tinto',
    'beef stroganoff': 'Stroganoff de Res con Champiñones',
    'beef and mustard pie': 'Pastel Rústico de Carne y Mostaza',
    'beef and oyster pie': 'Pastel Tradicional de Carne y Ostras',
    'beef rendang': 'Rendang de Res Caramelizado con Coco',
    'beef sunday roast': 'Asado Dominical Tradicional de Res',
    'beef brisket pot roast': 'Asado a la Olla de Pecho de Res',
    'beef dumpling stew': 'Estofado de Carne con Albóndigas Tiernas',
    'beef pumpkin stew': 'Estofado de Carne con Calabaza Dulce',
    'beef empanadas': 'Empanadas Criollas de Carne Caseras',
    'beef lo mein': 'Fideos Lo Mein Salteados con Carne',
    'beef pho': 'Sopa Tradicional Vietnamita Pho de Res',
    'beef mechado': 'Carne Mechada en Salsa de Tomate',
    'beef caldereta': 'Caldereta Filipina de Res con Pimientos',
    'beef asado': 'Asado de Res a la Cacerola',
    'beef and broccoli stir-fry': 'Salteado Wok de Carne y Brócoli',
    'chili con carne': 'Chili con Carne y Frijoles Rústico',
    'belgian meatballs in liège syrup sauce': 'Albóndigas Belgas en Salsa de Jarabe de Lieja',
    'belgian stoemp': 'Puré Rústico Belga con Vegetales (Stoemp)',
    'shepherd\'s pie': 'Pastel de Pastor con Puré de Papas Gratinado',
    'cottage pie': 'Pastel Tradicional de Carne Picada y Papas',

    // Aves (Chicken)
    'chicken & mushroom hotpot': 'Cazuela de Pollo con Champiñones',
    'chicken marengo': 'Pollo Marengo con Tomates y Romero',
    'chicken fajitas': 'Fajitas de Pollo con Pimientos Asados',
    'teriyaki chicken casserole': 'Cazuela de Pollo Teriyaki con Sésamo',
    'chicken couscous': 'Cuscús con Pollo y Verduras Especiadas',
    'chicken enchilada casserole': 'Cazuela de Enchiladas de Pollo Gratinadas',
    'chicken handi': 'Curry Cremoso de Pollo en Cazuela Handi',
    'chicken parmigiana': 'Pechuga de Pollo a la Parmesana Gratinada',
    'chicken alfredo': 'Fettuccine Alfredo con Tiras de Pollo',
    'chicken tikka masala': 'Pollo Tikka Masala con Especias Aromáticas',
    'butter chicken': 'Pollo a la Mantequilla con Salsa Cremosa de Tomate',
    'brown stew chicken': 'Guiso Caribeño de Pollo con Especias',
    'piri-piri chicken and slaw': 'Pollo Piri-Piri Especiado con Ensalada',
    'tandoori chicken': 'Pollo Tandoori Marinado al Horno',

    // Pescados y Mariscos (Fish & Seafood)
    'pan-fried hake, white bean & chorizo broth': 'Merluza a la Plancha con Caldo de Porotos y Chorizo',
    'baked salmon with fennel & tomatoes': 'Salmón Horneado con Hinojo y Tomates',
    'bang bang prawn salad': 'Ensalada Bang Bang de Langostinos Crujientes',
    'bangladeshi fish curry with daikon': 'Curry de Pescado con Rábano Daikon',
    'barramundi with moroccan spices': 'Pescado Barramundi a las Especias Marroquíes',
    'fish and chips': 'Pescado Rebozado Clásico con Papas Fritas',
    'fish pie': 'Pastel Rústico de Pescado Gratinado',
    'shrimp chow mein': 'Fideos Chow Mein Salteados con Camarones',
    'paella': 'Paella Valenciana Tradicional de Mariscos',

    // Postres y Dulces (Desserts & Baking)
    'pancakes': 'Panqueques Dorados con Miel y Avena',
    'banana pancakes': 'Panqueques de Plátano y Avena',
    'beetroot pancakes': 'Panqueques Rústicos de Remolacha',
    'apple frangipan tart': 'Tarta Rústica de Manzana y Frangipane',
    'apple & blackberry crumble': 'Crumble Artesanal de Manzana y Moras',
    'apple pie': 'Pastel Casero de Manzana Especiado',
    'chocolate gateau': 'Gâteau Artesanal de Chocolate Intenso',
    'chocolate souffle': 'Soufflé Esponjoso de Chocolate Negro',
    'passion fruit mousse': 'Mousse Refrescante de Maracuyá',
    'peanut butter cheesecake': 'Tarta de Queso con Mantequilla de Maní',
    'peanut butter cookies': 'Galletas Caseras de Mantequilla de Maní',
    'pear tarte tatin': 'Tarta Tatin Caramelizada de Peras',
    'pistachio cake': 'Bizcocho Esponjoso de Pistacho',
    'pistachio kunafa chocolate cake and cupcakes': 'Tarta de Chocolate con Pistacho y Masa Kunafa',
    'polish chocolate & walnut cake': 'Pastel Polaco de Chocolate y Nueces',
    'bakewell tart': 'Tarta Británica Bakewell con Almendras',
    'battenberg cake': 'Pastel Battenberg Ajedrezado de Almendra',
    'baklava with spiced nuts, ricotta & chocolate': 'Baklava de Frutos Secos con Ricotta y Chocolate',
    'bread and butter pudding': 'Pudín Británico de Pan y Mantequilla',
    'blackberry fool': 'Copa Cremosa de Moras y Nata',
    'parkin cake': 'Bizcocho Rústico de Jengibre y Miel (Parkin)',
    'tiramisu': 'Tiramisú Clásico con Mascarpone y Café',

    // Platos Típicos, Entradas y Vegetales
    'pisto con huevos': 'Pisto Manchego Tradicional con Huevos',
    'patatas bravas': 'Patatas Bravas Crujientes con Salsa Picante',
    'french onion soup': 'Sopa de Cebolla Gratinada a la Francesa',
    'ratatouille': 'Ratatouille Campestre con Vegetales de Estación',
    'guacamole': 'Guacamole Rústico con Cilantro y Lima',
    'pa amb tomaquet (bread with tomato)': 'Pa amb Tomàquet (Pan Rústico con Tomate y Aceite)',
    'papas chorreadas recipe (potatoes with cream and cheese sauce)': 'Papas Chorreadas con Crema y Queso',
    'pastel de choclo': 'Pastel de Choclo Chileno Tradicional',
    'pastel de papas (chilean potato pie)': 'Pastel de Papas Tradicional',
    'pad thai': 'Fideos Pad Thai Salteados con Maní y Lima',
    'pad see ew': 'Fideos de Arroz Tailandeses Salteados con Soja',
    'padron peppers': 'Pimientos de Padrón Asados con Sal Marina',
    'pan de yucca': 'Panecillos de Yuca y Queso Horneados',
    'baked yuca fries': 'Papas de Yuca Horneadas y Crujientes',
    'papaya salad': 'Ensalada Tailandesa Refrescante de Papaya',
    'paracuca (roasted peanuts)': 'Maní Tostado Crocante (Paracuca)',
    'paszteciki (polish pasties)': 'Pastelillos Polacos Rellenos al Horno',
    'piernik (polish gingerbread)': 'Pan de Especias Polaco con Jengibre',
    'pierogi (polish dumplings)': 'Pierogi Rellenos de Papa y Queso',
    'plantain rolls': 'Rollitos Dorados de Plátano Macho',
    'bean & sausage hotpot': 'Cazuela Rústica de Porotos con Salchicha',
    'barbecue pork buns': 'Bollos al Vapor Rellenos de Cerdo Barbacoa',
    'bbq pork sloppy joes': 'Sándwich Desmenuzado de Cerdo a la Barbacoa',
    'beavertails': 'Masa Dulce Frita Canadiense con Canela y Azúcar',
    'beetroot soup (borscht)': 'Sopa Tradicional de Remolacha (Borsch)',
    'baba ghanoush': 'Berenjena Asada Ahumada (Baba Ghanoush)',
    'baingan bharta': 'Puré Especiado de Berenjenas Asadas',
    'bajan salt bread recipe': 'Panecillos Rústicos Salados de Barbados',
    'bajan sweet bread': 'Pan Dulce Tradicional con Coco de Barbados',
    'baked brie with sorrel jam': 'Queso Brie Horneado con Mermelada',
  };

  // Mapeo léxico de términos para construcción sintáctica española
  static final Map<String, String> _coreTerms = {
    // Tipos de preparación (Plato)
    'cheesecake': 'Tarta de Queso',
    'cake': 'Tarta',
    'pie': 'Pastel',
    'tart': 'Tarta',
    'crumble': 'Crumble',
    'pancakes': 'Panqueques',
    'pancake': 'Panqueque',
    'salad': 'Ensalada',
    'soup': 'Sopa',
    'stew': 'Estofado',
    'casserole': 'Cazuela',
    'hotpot': 'Cazuela',
    'curry': 'Curry',
    'risotto': 'Risotto',
    'pasta': 'Pasta',
    'pudding': 'Pudín',
    'mousse': 'Mousse',
    'burger': 'Hamburguesa',
    'sandwich': 'Sándwich',
    'roast': 'Asado',
    'broth': 'Caldo',
    'sauce': 'Salsa',
    'bread': 'Pan',
    'cookies': 'Galletas',
    'biscuits': 'Galletas',
    'rolls': 'Rollitos',
    'roll': 'Rollito',
    'skewers': 'Brochetas',
    'noodles': 'Fideos',
    'meatballs': 'Albóndigas',
    'dumplings': 'Empanadillas',
    'stir-fry': 'Salteado Wok',
    'enchiladas': 'Enchiladas',
    'fajitas': 'Fajitas',
    'buns': 'Bollos',

    // Métodos de cocción y adjetivos
    'baked': 'Horneado/a',
    'pan-fried': 'a la Plancha',
    'fried': 'Frito/a',
    'roasted': 'Asado/a',
    'grilled': 'a la Parrilla',
    'steamed': 'al Vapor',
    'slow-cooked': 'a Fuego Lento',
    'braised': 'Braseado/a',
    'crispy': 'Crocante',
    'creamy': 'Cremoso/a',
    'spicy': 'Picante',
    'sweet': 'Dulce',

    // Ingredientes principales
    'chicken': 'Pollo',
    'beef': 'Carne de Res',
    'pork': 'Cerdo',
    'fish': 'Pescado',
    'salmon': 'Salmón',
    'tuna': 'Atún',
    'hake': 'Merluza',
    'cod': 'Bacalao',
    'prawns': 'Langostinos',
    'shrimp': 'Camarones',
    'lamb': 'Cordero',
    'duck': 'Pato',
    'turkey': 'Pavo',
    'sausage': 'Salchicha',
    'bacon': 'Panceta',
    'chorizo': 'Chorizo',
    'mushroom': 'Champiñones',
    'mushrooms': 'Champiñones',
    'tomato': 'Tomate',
    'tomatoes': 'Tomates',
    'potato': 'Papas',
    'potatoes': 'Papas',
    'sweet potato': 'Batata',
    'yuca': 'Yuca',
    'cheese': 'Queso',
    'brie': 'Queso Brie',
    'ricotta': 'Ricotta',
    'spinach': 'Espinacas',
    'garlic': 'Ajo',
    'onion': 'Cebolla',
    'onions': 'Cebollas',
    'corn': 'Maíz',
    'pumpkin': 'Calabaza',
    'carrot': 'Zanahoria',
    'carrots': 'Zanahorias',
    'beetroot': 'Remolacha',
    'broccoli': 'Brócoli',
    'cabbage': 'Repollo',
    'cauliflower': 'Coliflor',
    'peas': 'Arvejas',
    'beans': 'Porotos',
    'white bean': 'Porotos Blancos',
    'lentils': 'Lentejas',
    'rice': 'Arroz',
    'couscous': 'Cuscús',
    'vegetable': 'Vegetales',
    'vegetables': 'Vegetales',
    'apple': 'Manzana',
    'banana': 'Plátano',
    'blueberry': 'Arándanos',
    'blackberry': 'Moras',
    'strawberry': 'Frutillas',
    'peach': 'Durazno',
    'pear': 'Pera',
    'passion fruit': 'Maracuyá',
    'lemon': 'Limón',
    'lime': 'Lima',
    'orange': 'Naranja',
    'chocolate': 'Chocolate',
    'peanut butter': 'Mantequilla de Maní',
    'pistachio': 'Pistacho',
    'walnut': 'Nueces',
    'almond': 'Almendras',
    'vanilla': 'Vainilla',
    'honey': 'Miel',
    'ginger': 'Jengibre',
    'mustard': 'Mostaza',
    'pepper': 'Pimienta',
    'fennel': 'Hinojo',
    'papaya': 'Papaya',
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
    'filipino': 'Filipina',
    'canadian': 'Canadiense',
    'polish': 'Polaca',
    'jamaican': 'Jamaiquina',
    'vietnamese': 'Vietnamita',
    'dutch': 'Holandesa',
  };

  static String translateTitle(String rawTitle) {
    var clean = rawTitle.trim();
    if (clean.isEmpty) return 'Receta Artesanal';

    final lower = clean.toLowerCase();

    // 1. Coincidencia exacta directa
    if (_exactTitles.containsKey(lower)) {
      return _exactTitles[lower]!;
    }

    // 2. Limpieza de aclaraciones entre paréntesis ya redundantes
    clean = clean.replaceAll(RegExp(r'\s*\([^)]*\)\s*$'), '').trim();
    final lowerClean = clean.toLowerCase();
    if (_exactTitles.containsKey(lowerClean)) {
      return _exactTitles[lowerClean]!;
    }

    // 3. Reglas de sintaxis culinaria: Detectar "DishType" al final
    // En inglés: [Ingrediente/Modificador] + [Tipo de Plato]
    // En español: [Tipo de Plato] de/con [Ingrediente/Modificador]
    for (final dishEntry in [
      MapEntry('cheesecake', 'Tarta de Queso con '),
      MapEntry('cake', 'Tarta de '),
      MapEntry('pie', 'Pastel de '),
      MapEntry('tart', 'Tarta de '),
      MapEntry('crumble', 'Crumble de '),
      MapEntry('pancakes', 'Panqueques de '),
      MapEntry('pancake', 'Panqueque de '),
      MapEntry('salad', 'Ensalada de '),
      MapEntry('soup', 'Sopa de '),
      MapEntry('stew', 'Estofado de '),
      MapEntry('casserole', 'Cazuela de '),
      MapEntry('hotpot', 'Cazuela de '),
      MapEntry('curry', 'Curry de '),
      MapEntry('broth', 'Caldo de '),
      MapEntry('pudding', 'Pudín de '),
      MapEntry('mousse', 'Mousse de '),
      MapEntry('burger', 'Hamburguesa de '),
      MapEntry('sandwich', 'Sándwich de '),
      MapEntry('stir-fry', 'Salteado de '),
      MapEntry('cookies', 'Galletas de '),
      MapEntry('biscuits', 'Galletas de '),
      MapEntry('rolls', 'Rollitos de '),
    ]) {
      final dishKeyword = dishEntry.key;
      final dishPrefixSpanish = dishEntry.value;

      if (lowerClean.endsWith(' $dishKeyword')) {
        final modifier = clean.substring(0, clean.length - dishKeyword.length - 1).trim();
        final translatedModifier = _translateWords(modifier);
        return '$dishPrefixSpanish$translatedModifier';
      }
    }

    // 4. Regla: "[Cooking] [MainIngredient] with [Side]"
    // Ej: "Baked salmon with fennel & tomatoes" -> "Salmón Horneado con Hinojo y Tomates"
    final withMatch = RegExp(r'^(baked|roasted|grilled|pan-fried|fried)\s+(.+?)\s+with\s+(.+)$', caseSensitive: false)
        .firstMatch(clean);
    if (withMatch != null) {
      final method = _coreTerms[withMatch.group(1)!.toLowerCase()] ?? withMatch.group(1)!;
      final main = _translateWords(withMatch.group(2)!);
      final side = _translateWords(withMatch.group(3)!.replaceAll('&', 'y'));
      return '$main $method con $side';
    }

    // 5. Traducción sistemática de palabras con conectores en español
    return _translateWords(clean);
  }

  static String _translateWords(String text) {
    final tokens = text.split(RegExp(r'\s+'));
    final result = <String>[];

    for (var i = 0; i < tokens.length; i++) {
      final rawToken = tokens[i];
      final cleanToken = rawToken.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚñÑ-]'), '');
      final lower = cleanToken.toLowerCase();

      // Chequear pares de dos palabras (ej. "peanut butter", "white bean", "passion fruit")
      if (i < tokens.length - 1) {
        final nextRaw = tokens[i + 1];
        final nextClean = nextRaw.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚñÑ-]'), '');
        final bigram = '$lower ${nextClean.toLowerCase()}';
        if (_coreTerms.containsKey(bigram)) {
          result.add(_coreTerms[bigram]!);
          i++; // consumir siguiente palabra
          continue;
        }
      }

      if (_coreTerms.containsKey(lower)) {
        result.add(_coreTerms[lower]!);
      } else if (lower == 'and' || lower == '&') {
        result.add('y');
      } else if (lower == 'with') {
        result.add('con');
      } else if (lower == 'in') {
        result.add('en');
      } else if (lower == 'style') {
        result.add('al estilo');
      } else {
        result.add(rawToken);
      }
    }

    var assembled = result.join(' ');
    // Ajustar mayúscula inicial
    if (assembled.isNotEmpty) {
      assembled = assembled[0].toUpperCase() + assembled.substring(1);
    }
    return assembled;
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

    final replacements = [
      ['Bring a large saucepan of salted water to the boil', 'Pon a hervir abundante agua con sal en una olla grande'],
      ['Bring a large pot of salted water to the boil', 'Pon a hervir abundante agua con sal en una olla grande'],
      ['Bring to the boil', 'Lleva a ebullición'],
      ['Preheat the oven to', 'Precalienta el horno a'],
      ['Heat the olive oil in a large pan', 'Calienta el aceite de oliva en una sartén amplia'],
      ['Heat the olive oil in a pan', 'Calienta el aceite de oliva en una sartén'],
      ['Heat the oil in a large pan', 'Calienta el aceite en una sartén amplia'],
      ['Heat the oil in a pan', 'Calienta el aceite en una sartén'],
      ['Heat the butter in a pan', 'Derrite la mantequilla en una sartén a fuego medio'],
      ['Season with salt and pepper', 'Sazona al gusto con sal y pimienta negra'],
      ['Season with salt', 'Sazona con sal al gusto'],
      ['Sprinkle with black pepper', 'Espolvorea con pimienta negra recién molida'],
      ['Cook for about', 'Cocina durante aproximadamente'],
      ['Cook for', 'Cocina durante'],
      ['Bake for about', 'Hornea durante aproximadamente'],
      ['Bake for', 'Hornea durante'],
      ['Simmer for about', 'Cocina a fuego lento durante aproximadamente'],
      ['Simmer for', 'Cocina a fuego lento durante'],
      ['Stir well', 'Revuelve bien todos los ingredientes'],
      ['Stir occasionally', 'Revuelve de forma ocasional'],
      ['Meanwhile', 'Mientras tanto'],
      ['Drain into a colander', 'Escurre la preparación en un colador'],
      ['Drain the pasta', 'Escurre la pasta al dente'],
      ['Add the pasta', 'Añade la pasta'],
      ['Add the garlic', 'Incorpora los dientes de ajo picados'],
      ['Add the onions', 'Agrega la cebolla picada'],
      ['Add the onion', 'Agrega la cebolla picada'],
      ['Add the tomatoes', 'Incorpora los tomates maduros'],
      ['Add the chicken', 'Incorpora el pollo'],
      ['Add the beef', 'Agrega la carne'],
      ['Slice the', 'Corta en rodajas el/la'],
      ['Chop the', 'Pica finamente el/la'],
      ['Finely chop the', 'Pica muy fino el/la'],
      ['Wash the', 'Lava con cuidado el/la'],
      ['Mix well', 'Mezcla homogéneamente'],
      ['Mix together', 'Mezcla todo homogéneamente'],
      ['Serve hot', 'Sirve caliente de inmediato'],
      ['Serve immediately', 'Sirve de inmediato en platos hondos'],
      ['Serve with', 'Acompaña y sirve con'],
      ['just before serving', 'justo antes de servir'],
      ['minutes', 'minutos'],
      ['minute', 'minuto'],
      ['hours', 'horas'],
      ['hour', 'hora'],
    ];

    for (final pair in replacements) {
      s = s.replaceAll(RegExp(pair[0], caseSensitive: false), pair[1]);
    }

    if (s.isNotEmpty) {
      s = s[0].toUpperCase() + s.substring(1);
    }

    return s;
  }
}
