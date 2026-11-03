import 'package:flutter/material.dart';
import '../widgets/culina_bottom_nav_bar.dart';
import 'create_recipe_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
      // Tap center "Crear" button -> Open CreateRecipeScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CreateRecipeScreen(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateTab: _onTabTapped,
      ),
      const ExploreScreen(),
      const SizedBox.shrink(), // Placeholder for index 2 (center action)
      FavoritesScreen(
        onGoToExplore: () => _onTabTapped(1),
      ),
      ProfileScreen(
        onGoToCreate: () => _onTabTapped(2),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CulinaBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

