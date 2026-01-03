import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_router.dart';
import '../providers/auth_provider.dart';
import '../../../wardrobe/presentation/providers/outfit_list_provider.dart';
import '../../../wardrobe/presentation/providers/favorites_provider.dart';
import '../../../mix_match/presentation/providers/mix_match_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Statistics Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer3<OutfitListProvider, FavoritesProvider, MixMatchProvider>(
                builder: (context, outfitProvider, favProvider, mixMatchProvider, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                        icon: Icons.checkroom,
                        label: 'Outfits',
                        value: '${outfitProvider.outfits.length}',
                        color: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.outfitList);
                        },
                      ),
                      _StatCard(
                        icon: Icons.favorite,
                        label: 'Favorites',
                        value: '${favProvider.favoritesCount}',
                        color: Colors.red,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.favorites);
                        },
                      ),
                      _StatCard(
                        icon: Icons.collections,
                        label: 'Combos',
                        value: '${mixMatchProvider.savedCombos.length}',
                        color: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.mixMatch);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            
            const Divider(height: 1),
            
            // Menu Items
            _MenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                // TODO: Navigate to edit profile
              },
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                // TODO: Navigate to notifications settings
              },
            ),
            _MenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                // TODO: Navigate to help
              },
            ),
            _MenuItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                // TODO: Show about dialog
              },
            ),
            const Divider(height: 1),
            _MenuItem(
              icon: Icons.logout,
              title: 'Logout',
              textColor: Colors.red,
              onTap: () => _handleLogout(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? textColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: textColor != null
            ? TextStyle(color: textColor)
            : null,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
