import 'package:flutter/material.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/constants/outfit_categories.dart';

class OutfitListScreen extends StatefulWidget {
  const OutfitListScreen({super.key});

  @override
  State<OutfitListScreen> createState() => _OutfitListScreenState();
}

class _OutfitListScreenState extends State<OutfitListScreen> {
  final _searchController = TextEditingController();
  OutfitCategory? _selectedCategory;
  bool _showFavoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter & Sort',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  // Category Filter
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setModalState(() {
                            setState(() {
                              _selectedCategory = null;
                            });
                          });
                        },
                      ),
                      ...OutfitCategory.values.map((category) {
                        return FilterChip(
                          label: Text(category.displayName),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setModalState(() {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Favorites Only
                  SwitchListTile(
                    title: const Text('Favorites Only'),
                    value: _showFavoritesOnly,
                    onChanged: (value) {
                      setModalState(() {
                        setState(() {
                          _showFavoritesOnly = value;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Apply filters
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Outfits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search outfits...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
          ),
          
          // Filter Chips (if any active)
          if (_selectedCategory != null || _showFavoritesOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedCategory != null)
                    Chip(
                      label: Text(_selectedCategory!.displayName),
                      onDeleted: () {
                        setState(() => _selectedCategory = null);
                      },
                    ),
                  if (_showFavoritesOnly)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Chip(
                        label: const Text('Favorites'),
                        onDeleted: () {
                          setState(() => _showFavoritesOnly = false);
                        },
                      ),
                    ),
                ],
              ),
            ),
          
          // Outfit Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 10, // TODO: Replace with actual data
                itemBuilder: (context, index) {
                  return _OutfitGridItem(
                    outfitId: index + 1,
                    isFavorite: index % 3 == 0,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.outfitDetail,
                        arguments: index + 1,
                      );
                    },
                    onFavoriteToggle: () {
                      // TODO: Toggle favorite
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addOutfit);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _OutfitGridItem extends StatelessWidget {
  final int outfitId;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _OutfitGridItem({
    required this.outfitId,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outfit #$outfitId',
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: onFavoriteToggle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
