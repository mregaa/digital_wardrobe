import 'package:digital_wardrobe/features/wardrobe/presentation/pages/favorites_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/profile_screen.dart';
import '../../features/wardrobe/presentation/pages/main_shell_page.dart';
import '../../features/wardrobe/presentation/pages/outfit_list_screen.dart';
import '../../features/wardrobe/presentation/pages/outfit_detail_screen.dart';
import '../../features/wardrobe/presentation/pages/add_outfit_screen.dart';
import '../../features/wardrobe/presentation/pages/edit_outfit_screen.dart';
import '../../features/mix_match/presentation/pages/mix_match_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String outfitList = '/outfits';
  static const String outfitDetail = '/outfit-detail';
  static const String addOutfit = '/add-outfit';
  static const String editOutfit = '/edit-outfit';
  static const String profile = '/profile';
  static const String mixMatch = '/mix-match';
  static const String favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const MainShellPage());
      
      case outfitList:
        return MaterialPageRoute(builder: (_) => const OutfitListScreen());
      
      case outfitDetail:
        final outfitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OutfitDetailScreen(outfitId: outfitId),
        );
      
      case addOutfit:
        return MaterialPageRoute(builder: (_) => const AddOutfitScreen());
      
      case editOutfit:
        final outfitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EditOutfitScreen(outfitId: outfitId),
        );
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      case mixMatch:
        return MaterialPageRoute(builder: (_) => const MixMatchScreen());
      
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
