class ApiConfig {
  // Conexión activa a TheMealDB API
  static const String theMealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static const String searchEndpoint = '/search.php?s=';
  static const String lookupEndpoint = '/lookup.php?i=';
  static const String categoriesEndpoint = '/categories.php';
  static const String filterCategoryEndpoint = '/filter.php?c=';

  static const Duration requestTimeout = Duration(seconds: 10);

  static Map<String, String> get defaultHeaders => {
        'Accept': 'application/json',
      };

  static bool get isConfigured => true;
}
