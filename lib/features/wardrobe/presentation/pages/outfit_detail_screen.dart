import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_router.dart';
import '../providers/outfit_detail_provider.dart';
import '../providers/outfit_list_provider.dart';
import '../providers/favorites_provider.dart';

class OutfitDetailScreen extends StatefulWidget {
  final String outfitId;

  const OutfitDetailScreen({
    super.key,
    required this.outfitId,
  });

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OutfitDetailProvider>().loadOutfit(widget.outfitId);
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Outfit'),
          content: const Text('Are you sure you want to delete this outfit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await context.read<OutfitDetailProvider>().deleteOutfit();
                if (mounted && success) {
                  // Refresh all lists after deletion
                  context.read<OutfitListProvider>().loadOutfits();
                  context.read<FavoritesProvider>().loadFavorites();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Outfit deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Details'),
        actions: [
          IconButton(
            icon: Consumer<OutfitDetailProvider>(
              builder: (context, provider, _) {
                final isFavorite = provider.outfit?.isFavorite ?? false;
                return Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                );
              },
            ),
            onPressed: () async {
              await context.read<OutfitDetailProvider>().toggleFavorite();
              final outfit = context.read<OutfitDetailProvider>().outfit;
              if (outfit != null && mounted) {
                await context.read<FavoritesProvider>().loadFavorites();
                // Reload the outfit to get the updated favorite status from backend
                await context.read<OutfitDetailProvider>().loadOutfit(outfit.id);
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  AppRouter.editOutfit,
                  arguments: widget.outfitId,
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
          ),
        ],
      ),
      body: Consumer<OutfitDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading outfit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.loadOutfit(widget.outfitId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final outfit = provider.outfit;
          if (outfit == null) {
            return const Center(
              child: Text('Outfit not found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: outfit.imageUrl != null
                      ? Image.network(
                          outfit.imageUrl!,
                          fit: BoxFit.cover,
                          isAntiAlias: true,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, size: 100, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image, size: 100, color: Colors.grey),
                          ),
                        ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        outfit.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      
                      // Category Chip
                      Chip(
                        avatar: const Icon(Icons.category, size: 18),
                        label: Text(outfit.category.toUpperCase()),
                      ),
                      const SizedBox(height: 24),
                      
                      // Details Section
                      _DetailRow(
                        icon: Icons.palette,
                        label: 'Color',
                        value: outfit.color,
                      ),
                      const SizedBox(height: 16),
                      
                      _DetailRow(
                        icon: Icons.calendar_today,
                        label: 'Added',
                        value: '${outfit.createdAt.year}-${outfit.createdAt.month.toString().padLeft(2, '0')}-${outfit.createdAt.day.toString().padLeft(2, '0')}',
                      ),
                      const SizedBox(height: 24),
                      
                      // Notes Section
                      if (outfit.notes != null && outfit.notes!.isNotEmpty) ...[
                        Text(
                          'Notes',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            outfit.notes!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                      
                      // Recommendations Section (placeholder)
                      Text(
                        'Wear with',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
