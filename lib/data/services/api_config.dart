class ApiConfig {
  // Cuando tengas la URL de la API del profesor o backend, solo reemplaza este valor:
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api-placeholder.culina.app/api/v1',
  );

  // Endpoints REST
  static const String recipesEndpoint = '/recipes';
  static const String authLoginEndpoint = '/auth/login';
  static const String authRegisterEndpoint = '/auth/register';

  static const Duration requestTimeout = Duration(seconds: 10);

  // Cabeceras estándar
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

  // Indica si la URL configurada corresponde a una API real activa
  static bool get isConfigured {
    return baseUrl.isNotEmpty &&
        !baseUrl.contains('placeholder') &&
        (baseUrl.startsWith('http://') || baseUrl.startsWith('https://'));
  }
}
