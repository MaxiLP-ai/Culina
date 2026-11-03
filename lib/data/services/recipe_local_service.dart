import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/ingredient.dart';
import '../models/recipe_model.dart';

class RecipeLocalService {
  static const String _kRecipesKey = 'culina_saved_recipes_v1';
  static const String _kInitializedKey = 'culina_has_seeded_v1';

  final List<RecipeModel> _seedRecipes = [
    RecipeModel(
      id: 'receta-1',
      title: 'Tostada Rústica con Burrata y Tomates Asados',
      subtitle: 'Pan de masa madre tostado, burrata cremosa y albahaca fresca',
      description:
          'Una receta italiana campestre donde la calidad de los ingredientes brilla. Los tomates cherry confitados al horno aportan una dulzura profunda que contrasta con la frescura láctea de la burrata.',
      category: 'Desayunos',
      difficulty: 'Fácil',
      prepTime: 10,
      cookTime: 15,
      servings: 2,
      icon: '🥖',
      colorTheme: 'Trigo',
      author: 'Camila Rossi',
      isFavorite: true,
      isFeatured: true,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Rebanadas gruesas de pan de masa madre', baseAmount: 2, unit: 'unidades'),
        Ingredient(name: 'Burrata fresca de búfala', baseAmount: 1, unit: 'pieza (200g)'),
        Ingredient(name: 'Tomates cherry en rama', baseAmount: 250, unit: 'gramos'),
        Ingredient(name: 'Dientes de ajo laminados', baseAmount: 2, unit: 'dientes'),
        Ingredient(name: 'Aceite de oliva extra virgen', baseAmount: 3, unit: 'cucharadas'),
        Ingredient(name: 'Hojas de albahaca fresca', baseAmount: 8, unit: 'hojas'),
        Ingredient(name: 'Escamas de sal marina y pimienta negra', baseAmount: 1, unit: 'pizca'),
      ],
      steps: [
        'Precalienta el horno a 190°C. Coloca los tomates cherry en una bandeja con el ajo, aceite de oliva, sal y pimienta.',
        'Hornea durante 15 minutos hasta que los tomates comiencen a dorarse y suelten sus jugos dulces.',
        'Tuesta las rebanadas de pan de masa madre en sartén o plancha con un hilo de aceite de oliva hasta que estén bien crujientes.',
        'Frota suavemente medio diente de ajo sobre el pan tostado caliente.',
        'Abre la burrata con las manos y distribúyela sobre las tostadas.',
        'Corona con los tomates asados calientes, rocía con los jugos de la bandeja y decora con hojas frescas de albahaca.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RecipeModel(
      id: 'receta-2',
      title: 'Tagliatelle al Huevo Artesanales con Salvia',
      subtitle: 'Pasta fresca hecha a mano con manteca de hierbas y parmesano',
      description:
          'La auténtica pasta fresca italiana hecha desde cero. La textura al dente combinada con la emulsión de mantequilla dorada y salvia crea un bocado sedoso inolvidable.',
      category: 'Pastas',
      difficulty: 'Media',
      prepTime: 25,
      cookTime: 10,
      servings: 2,
      icon: '🍝',
      colorTheme: 'Trigo',
      author: 'Matías Tapia',
      isFavorite: true,
      isFeatured: false,
      isUserCreated: true,
      ingredients: [
        Ingredient(name: 'Harina de trigo tipo 00', baseAmount: 200, unit: 'gramos'),
        Ingredient(name: 'Huevos de campo frescos', baseAmount: 2, unit: 'unidades'),
        Ingredient(name: 'Mantequilla sin sal de alta calidad', baseAmount: 60, unit: 'gramos'),
        Ingredient(name: 'Hojas de salvia fresca', baseAmount: 12, unit: 'hojas'),
        Ingredient(name: 'Queso Parmigiano Reggiano rallado', baseAmount: 50, unit: 'gramos'),
        Ingredient(name: 'Sal marina gruesa para el agua', baseAmount: 1, unit: 'cucharada'),
      ],
      steps: [
        'Forma un volcán con la harina en la mesada y coloca los huevos al centro.',
        'Bate los huevos con un tenedor incorporando harina de los bordes hasta formar un bollo.',
        'Amasa vigorosamente durante 10 minutos y deja reposar la masa tapada por 30 minutos.',
        'Estira fino con palote o máquina y corta en tiras de tagliatelle de 7 mm.',
        'En una sartén derrite la mantequilla a fuego suave hasta dorar con las hojas de salvia.',
        'Hierve la pasta en abundante agua salada durante 3 minutos, pasa directo a la sartén con un poco de agua de cocción y monta con queso.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RecipeModel(
      id: 'receta-3',
      title: 'Ensalada Verde de Campo con Manzana y Nueces',
      subtitle: 'Hojas verdes crujientes con vinagreta de mostaza y miel',
      description:
          'Frescura balanceada con el toque crujiente de las nueces tostadas y la acidez vibrante de la manzana verde con aderezo casero.',
      category: 'Ensaladas',
      difficulty: 'Fácil',
      prepTime: 15,
      cookTime: 0,
      servings: 2,
      icon: '🥗',
      colorTheme: 'Olivo',
      author: 'Matías Tapia',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: true,
      ingredients: [
        Ingredient(name: 'Mix de hojas verdes (rúcula, espinaca, lechuga)', baseAmount: 180, unit: 'gramos'),
        Ingredient(name: 'Manzana verde cortada en gajos finos', baseAmount: 1, unit: 'unidad'),
        Ingredient(name: 'Nueces tostadas picadas', baseAmount: 50, unit: 'gramos'),
        Ingredient(name: 'Queso de cabra desmenuzado', baseAmount: 70, unit: 'gramos'),
        Ingredient(name: 'Aceite de oliva extra virgen', baseAmount: 3, unit: 'cucharadas'),
        Ingredient(name: 'Vinagre de manzana', baseAmount: 1, unit: 'cucharada'),
        Ingredient(name: 'Miel pura de abejas', baseAmount: 1, unit: 'cucharadita'),
      ],
      steps: [
        'Lava y centrifuga muy bien las hojas verdes para que queden crocantes.',
        'En un cuenco pequeño emulsiona el aceite de oliva, vinagre de manzana, miel, sal y pimienta.',
        'En un bol amplio combina las hojas, la manzana verde y el queso de cabra.',
        'Vierte el aderezo justo antes de servir y finaliza con las nueces tostadas.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RecipeModel(
      id: 'receta-4',
      title: 'Risotto de Portobello y Salvia Fresca',
      subtitle: 'Arroz arborio cremoso con vino blanco seco y caldo casero',
      description:
          'Un risotto reconfortante cocinado a fuego lento, con hongos portobello salteados y mantecatura perfecta con queso pecorino.',
      category: 'Almuerzos',
      difficulty: 'Media',
      prepTime: 15,
      cookTime: 25,
      servings: 3,
      icon: '🍄',
      colorTheme: 'Trufa',
      author: 'Maximiliano Lopez',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Arroz Arborio o Carnaroli', baseAmount: 250, unit: 'gramos'),
        Ingredient(name: 'Hongos Portobello frescos', baseAmount: 200, unit: 'gramos'),
        Ingredient(name: 'Caldo de vegetales caliente', baseAmount: 900, unit: 'ml'),
        Ingredient(name: 'Vino blanco seco', baseAmount: 100, unit: 'ml'),
        Ingredient(name: 'Chalota o cebolla blanca picada fina', baseAmount: 1, unit: 'unidad'),
        Ingredient(name: 'Mantequilla fría cortada en cubos', baseAmount: 40, unit: 'gramos'),
        Ingredient(name: 'Queso Pecorino o Parmesano rallado', baseAmount: 50, unit: 'gramos'),
      ],
      steps: [
        'Saltea los portobellos laminados con aceite de oliva hasta dorar y reserva la mitad.',
        'En una cacerola sofríe la chalota, añade el arroz y nacara durante 2 minutos.',
        'Vierte el vino blanco y deja evaporar por completo el alcohol.',
        'Añade el caldo caliente cucharón a cucharón, removiendo suavemente hasta que el grano esté al dente (18 min).',
        'Retira del fuego e incorpora la mantequilla fría y el queso (mantecatura). Deja reposar tapado 2 minutos y sirve.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    RecipeModel(
      id: 'receta-5',
      title: 'Focaccia Tradicional al Romero y Sal Marina',
      subtitle: 'Miga esponjosa con corteza dorada y abundante aceite de oliva',
      description:
          'Pan plano de fermentación lenta horneado con romero silvestre recogido a mano y cristales de sal marina crujiente.',
      category: 'Desayunos',
      difficulty: 'Media',
      prepTime: 30,
      cookTime: 20,
      servings: 6,
      icon: '🥖',
      colorTheme: 'Trigo',
      author: 'José-Luis Hidalgo',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Harina de fuerza', baseAmount: 400, unit: 'gramos'),
        Ingredient(name: 'Agua tibia', baseAmount: 320, unit: 'ml'),
        Ingredient(name: 'Levadura seca activa', baseAmount: 5, unit: 'gramos'),
        Ingredient(name: 'Aceite de oliva extra virgen', baseAmount: 50, unit: 'ml'),
        Ingredient(name: 'Romero fresco', baseAmount: 3, unit: 'ramitas'),
        Ingredient(name: 'Sal marina gruesa o en escamas', baseAmount: 1, unit: 'cucharadita'),
      ],
      steps: [
        'Mezcla agua tibia con levadura y luego añade la harina e integra sin amasar demasiado.',
        'Realiza pliegues cada 30 minutos durante 2 horas.',
        'Vuelca la masa en una bandeja aceitada y deja fermentar hasta que duplique volumen.',
        'Hunde los dedos con aceite para formar los clásicos hoyuelos de la focaccia.',
        'Espolvorea romero fresco y sal marina. Hornea a 220°C por 20 minutos.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    RecipeModel(
      id: 'receta-6',
      title: 'Gnocchi Caseros de Papa con Mantequilla Avellanada',
      subtitle: 'Almohadillas de papa suaves y livianas con toque de nuez moscada',
      description:
          'La receta secreta de la nonna: papa horneada al vapor para eliminar humedad y lograr unos gnocchi ligeros que se derriten en la boca.',
      category: 'Pastas',
      difficulty: 'Media',
      prepTime: 35,
      cookTime: 10,
      servings: 4,
      icon: '🥔',
      colorTheme: 'Cúrcuma',
      author: 'José-Luis Hidalgo',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Papas harinosas cocidas', baseAmount: 800, unit: 'gramos'),
        Ingredient(name: 'Harina de trigo', baseAmount: 200, unit: 'gramos'),
        Ingredient(name: 'Yema de huevo', baseAmount: 1, unit: 'unidad'),
        Ingredient(name: 'Nuez moscada recién rallada', baseAmount: 1, unit: 'pizca'),
        Ingredient(name: 'Mantequilla para salsa', baseAmount: 70, unit: 'gramos'),
      ],
      steps: [
        'Pisa las papas tibias hasta obtener un puré homogéneo sin grumos.',
        'Añade la yema, nuez moscada y la harina poco a poco uniendo con suavidad.',
        'Forma cordones del grosor de un dedo y corta trozos de 2 cm.',
        'Hierve en agua abundante con sal; cuando floten en la superficie cocina 1 minuto más y retira con espumadera.',
        'Sartenea de inmediato en la mantequilla avellanada y sirve caliente.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    RecipeModel(
      id: 'receta-7',
      title: 'Shakshuka Especiada de Medio Oriente',
      subtitle: 'Huevos escalfados en salsa espesa de tomates, pimientos y comino',
      description:
          'Un festín de sabores servido en sartén de hierro fundido, ideal para mojar con pan tostado o pita caliente.',
      category: 'Almuerzos',
      difficulty: 'Fácil',
      prepTime: 10,
      cookTime: 15,
      servings: 2,
      icon: '🍲',
      colorTheme: 'Terracota',
      author: 'Maximiliano Lopez',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Huevos de campo', baseAmount: 4, unit: 'unidades'),
        Ingredient(name: 'Tomates triturados maduros', baseAmount: 400, unit: 'gramos'),
        Ingredient(name: 'Pimiento rojo en tiras', baseAmount: 1, unit: 'unidad'),
        Ingredient(name: 'Cebolla morada en juliana', baseAmount: 1, unit: 'unidad'),
        Ingredient(name: 'Dientes de ajo picados', baseAmount: 2, unit: 'dientes'),
        Ingredient(name: 'Comino, pimentón dulce y ají molido', baseAmount: 1, unit: 'cucharadita'),
        Ingredient(name: 'Cilantro o perejil fresco picado', baseAmount: 2, unit: 'cucharadas'),
      ],
      steps: [
        'Sofríe en sartén amplia la cebolla y pimiento con aceite de oliva hasta tiernos.',
        'Agrega el ajo y las especias, cocinando por 1 minuto hasta liberar sus aromas.',
        'Incorpora el tomate y cocina a fuego medio hasta reducir y espesar la salsa.',
        'Haz huecos en la salsa y rompe un huevo dentro de cada uno.',
        'Tapa la sartén a fuego bajo por 5-7 minutos hasta que las claras cuajen pero las yemas queden líquidas.',
        'Decora con cilantro fresco y sirve de inmediato.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    RecipeModel(
      id: 'receta-8',
      title: 'Tarta Rústica de Frutos del Bosque (Galette)',
      subtitle: 'Masa crujiente y mantecosa rellena de moras, frambuesas y azúcar rubia',
      description:
          'Una tarta francesa sin molde donde los bordes doblados rústicamente encierran el dulzor jugoso de las bayas frescas.',
      category: 'Postres',
      difficulty: 'Media',
      prepTime: 25,
      cookTime: 25,
      servings: 6,
      icon: '🍰',
      colorTheme: 'Cacao',
      author: 'Camila Rossi',
      isFavorite: false,
      isFeatured: false,
      isUserCreated: false,
      ingredients: [
        Ingredient(name: 'Harina de trigo', baseAmount: 200, unit: 'gramos'),
        Ingredient(name: 'Mantequilla fría en cubos', baseAmount: 100, unit: 'gramos'),
        Ingredient(name: 'Mix de frutos del bosque frescos o congelados', baseAmount: 300, unit: 'gramos'),
        Ingredient(name: 'Azúcar rubia o mascabo', baseAmount: 60, unit: 'gramos'),
        Ingredient(name: 'Fécula de maíz (maicena)', baseAmount: 1, unit: 'cucharada'),
        Ingredient(name: 'Huevo batido para pintar', baseAmount: 1, unit: 'unidad'),
      ],
      steps: [
        'Procesa harina y mantequilla hasta textura arenosa. Agrega agua helada cucharada a cucharada hasta unir y refrigera 30 min.',
        'Mezcla las frutas con azúcar y la fécula de maíz.',
        'Estira la masa en círculo de 30 cm sobre papel manteca.',
        'Coloca la fruta al centro dejando 4 cm de borde libre.',
        'Dobla los bordes sobre la fruta, pincela con huevo batido y hornea a 190°C por 25 minutos.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  Future<List<RecipeModel>> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeeded = prefs.getBool(_kInitializedKey) ?? false;

    if (!hasSeeded) {
      await saveAllRecipes(_seedRecipes);
      await prefs.setBool(_kInitializedKey, true);
      return _seedRecipes;
    }

    final rawJson = prefs.getString(_kRecipesKey);
    if (rawJson == null || rawJson.isEmpty) {
      return _seedRecipes;
    }

    try {
      final List<dynamic> list = jsonDecode(rawJson);
      return list.map((item) => RecipeModel.fromMap(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return _seedRecipes;
    }
  }

  Future<void> saveAllRecipes(List<RecipeModel> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(recipes.map((r) => r.toMap()).toList());
    await prefs.setString(_kRecipesKey, jsonString);
  }
}
