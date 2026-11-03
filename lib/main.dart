import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/repositories/recipe_repository_impl.dart';
import 'data/services/auth_service.dart';
import 'data/services/recipe_local_service.dart';
import 'domain/repositories/recipe_repository.dart';
import 'presentation/providers/recipe_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style matching the Figma Android look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CulinaApp());
}

class CulinaApp extends StatelessWidget {
  final RecipeRepository? recipeRepository;
  final AuthService? authService;

  const CulinaApp({
    super.key,
    this.recipeRepository,
    this.authService,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRepo = recipeRepository ??
        RecipeRepositoryImpl(localService: RecipeLocalService());
    final effectiveAuth = authService ?? AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeProvider>(
          create: (_) => RecipeProvider(repository: effectiveRepo),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(authService: effectiveAuth),
        ),
      ],
      child: MaterialApp(
        title: 'Culina',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
