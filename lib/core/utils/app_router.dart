import 'package:flutter/material.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/outfit/outfit_list_screen.dart';
import '../../presentation/screens/outfit/outfit_detail_screen.dart';
import '../../presentation/screens/outfit/add_outfit_screen.dart';
import '../../presentation/screens/outfit/edit_outfit_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String outfitList = '/outfits';
  static const String outfitDetail = '/outfit-detail';
  static const String addOutfit = '/add-outfit';
  static const String editOutfit = '/edit-outfit';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case outfitList:
        return MaterialPageRoute(builder: (_) => const OutfitListScreen());
      
      case outfitDetail:
        final outfitId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => OutfitDetailScreen(outfitId: outfitId),
        );
      
      case addOutfit:
        return MaterialPageRoute(builder: (_) => const AddOutfitScreen());
      
      case editOutfit:
        final outfitId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => EditOutfitScreen(outfitId: outfitId),
        );
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
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
