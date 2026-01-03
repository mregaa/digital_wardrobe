import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_router.dart';
import '../pages/outfit_list_screen.dart';
import '../pages/favorites_screen.dart';
import '../../../auth/presentation/pages/profile_screen.dart';
import '../providers/outfit_list_provider.dart';
import '../providers/favorites_provider.dart';
import '../../../recommendations/services/recommendation_service.dart';

/// Main shell page with bottom navigation bar using IndexedStack for state preservation
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  // Pages for each tab - instantiated once to preserve state
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    // Initialize pages once
    _pages = [
      const HomeTabContent(), // Home content without scaffold
      const OutfitListScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OutfitListProvider>().loadOutfits();
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.addOutfit);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom_outlined),
            activeIcon: Icon(Icons.checkroom),
            label: 'Wardrobe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Home tab content extracted from HomeScreen
class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Wardrobe'),
        automaticallyImplyLeading: false, // No back button on root tab
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.profile);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search outfits...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.outfitList);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<OutfitListProvider>().setSearchQuery(value);
                    Navigator.pushNamed(context, AppRouter.outfitList);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Mix & Match Card
              _buildMixMatchCard(context),
              const SizedBox(height: 32),

              // Recommended Combinations
              _buildRecommendedSection(context),
              const SizedBox(height: 32),

              // Recent Outfits
              _buildRecentOutfitsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMixMatchCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mixMatch);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avatar Outfit Builder',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dress your avatar with drag & drop',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended Combinations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.mixMatch);
              },
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Create'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<OutfitListProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (provider.outfits.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add outfits to see recommendations',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Generate recommendations using rule-based service
            final recommendationService = RecommendationService();
            final recommendations = recommendationService.generateRecommendations(
              provider.outfits,
              maxResults: 5,
            );

            if (recommendations.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Add more tops and bottoms for recommendations',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final combo = recommendations[index];
                  return _buildComboCard(context, combo);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildComboCard(BuildContext context, OutfitCombo combo) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images stack
          Expanded(
            child: Stack(
              children: [
                // Bottom item (bottom clothing)
                Positioned(
                  left: 0,
                  right: 40,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    child: combo.bottom?.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              combo.bottom!.imageUrl!,
                              fit: BoxFit.cover,
                              isAntiAlias: true,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.checkroom, size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.checkroom, size: 40, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
                // Top item (overlaid)
                Positioned(
                  right: 0,
                  left: 40,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: combo.top?.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.network(
                              combo.top!.imageUrl!,
                              fit: BoxFit.cover,
                              isAntiAlias: true,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.checkroom, size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.checkroom, size: 40, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
                // Score badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getScoreColor(combo.score),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${combo.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  combo.reason,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${combo.top?.name} + ${combo.bottom?.name}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    return Colors.orange;
  }

  Widget _buildRecentOutfitsSection(BuildContext context) {
    return Consumer<OutfitListProvider>(
      builder: (context, provider, child) {
        if (provider.outfits.isEmpty) {
          return const SizedBox.shrink();
        }

        final recentOutfits = provider.outfits.take(6).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Additions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: recentOutfits.length,
              itemBuilder: (context, index) {
                final outfit = recentOutfits[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.outfitDetail,
                      arguments: outfit.id,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              color: Colors.white,
                            ),
                            child: outfit.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      outfit.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      isAntiAlias: true,
                                      filterQuality: FilterQuality.medium,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                outfit.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getColorFromName(outfit.color),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      outfit.category.toUpperCase(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Color _getColorFromName(String colorName) {
    final colors = {
      'black': Colors.black,
      'white': Colors.white,
      'red': Colors.red,
      'blue': Colors.blue,
      'navy': Colors.blue[900]!,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'beige': Colors.brown[200]!,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'pink': Colors.pink,
      'purple': Colors.purple,
      'orange': Colors.orange,
    };

    return colors[colorName.toLowerCase()] ?? Colors.grey;
  }
}
