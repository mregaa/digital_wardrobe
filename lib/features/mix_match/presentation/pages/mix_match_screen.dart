import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mix_match_provider.dart';
import '../widgets/grid_canvas_painter.dart';
import '../../../wardrobe/domain/entities/outfit_item.dart';

/// Avatar Outfit Builder - Marvelous Designer style canvas
class MixMatchScreen extends StatefulWidget {
  const MixMatchScreen({super.key});

  @override
  State<MixMatchScreen> createState() => _MixMatchScreenState();
}

class _MixMatchScreenState extends State<MixMatchScreen> {
  // Track gesture start values for stable multi-touch transform
  final Map<String, _GestureStartValues> _gestureStarts = {};
  
  // Track library expansion state
  bool _isLibraryExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MixMatchProvider>().loadOutfits();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Outfit Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _showSaveComboDialog(context);
            },
            tooltip: 'Save Combination',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<MixMatchProvider>().clearCanvas();
            },
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Consumer<MixMatchProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allOutfits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checkroom_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No outfits in your wardrobe'),
                  const SizedBox(height: 8),
                  const Text(
                    'Add some outfits to start building!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Full screen canvas
              _buildCanvasArea(context, provider),
              
              // Expandable bottom library
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isLibraryExpanded 
                    ? MediaQuery.of(context).size.height * 0.4
                    : 60,
                  child: _buildOutfitLibrary(context, provider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build the canvas workspace area
  Widget _buildCanvasArea(BuildContext context, MixMatchProvider provider) {
    return Container(
      color: const Color(0xFFF5F5F5), // Light grey background
      child: DragTarget<OutfitItemDragData>(
        onWillAccept: (data) => data != null,
        onAccept: (data) {
          // Calculate drop position relative to canvas center
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            // Default to center if we can't get exact drop position
            final position = Offset(
              box.size.width / 2 - 50, // Center with offset
              box.size.height / 2 - 75,
            );
            provider.addPlacedItem(
              data.outfitId,
              data.imageUrl,
              data.name,
              data.category,
              position,
            );
          }
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;
          
          return Stack(
            children: [
              // Grid background
              Positioned.fill(
                child: CustomPaint(
                  painter: GridCanvasPainter(
                    gridColor: Colors.grey[400]!,
                    smallGridSize: 20,
                    largeGridSize: 100,
                  ),
                ),
              ),
              
              // Avatar silhouette (centered)
              // ⚠️ REPLACE THIS PATH: Add your avatar_silhouette.png to assets/images/
              Center(
                child: Opacity(
                  opacity: 0.15,
                  child: _buildAvatarSilhouette(),
                ),
              ),
              
              // Placed outfit items (draggable)
              ...provider.placedItems.map((item) => _buildPlacedItem(
                    context,
                    provider,
                    item,
                  )),
              
              // Hover overlay
              if (isHovering)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Build avatar silhouette (placeholder until real image is added)
  Widget _buildAvatarSilhouette() {
    // Try to load asset image, fallback to simple shape
    return Image.asset(
      'assets/images/avatar_silhouette.png',
      fit: BoxFit.contain,
      height: 400,
      errorBuilder: (context, error, stackTrace) {
        // Fallback: simple silhouette using shapes
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Head
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 15),
            // Body
            Container(
              width: 140,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(70),
              ),
            ),
            const SizedBox(height: 10),
            // Legs
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Build a placed item on canvas (draggable with multi-touch transform)
  Widget _buildPlacedItem(
    BuildContext context,
    MixMatchProvider provider,
    PlacedOutfitItem item,
  ) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          // Bring to front when user starts interacting
          provider.bringToFront(item.id);
          
          // Store gesture start values for stable transform calculation
          _gestureStarts[item.id] = _GestureStartValues(
            position: item.position,
            scale: item.scale,
            rotation: item.rotation,
            focalPoint: details.focalPoint,
          );
        },
        onScaleUpdate: (details) {
          final startValues = _gestureStarts[item.id];
          if (startValues == null) return;

          // Calculate new position based on focal point delta
          final focalPointDelta = details.focalPoint - startValues.focalPoint;
          final newPosition = startValues.position + focalPointDelta;

          // Calculate new scale (multiply start scale by gesture scale)
          final newScale = startValues.scale * details.scale;

          // Calculate new rotation (add gesture rotation to start rotation)
          final newRotation = startValues.rotation + details.rotation;

          // Update transform via provider
          provider.updatePlacedItemTransform(
            item.id,
            newPosition,
            newScale,
            newRotation,
          );
        },
        onScaleEnd: (details) {
          // Clean up gesture start values
          _gestureStarts.remove(item.id);
        },
        onTap: () {
          // Bring to front and show options on tap
          provider.bringToFront(item.id);
          _showItemOptions(context, provider, item);
        },
        child: Transform.rotate(
          angle: item.rotation,
          child: Transform.scale(
            scale: item.scale,
            child: Container(
              width: 120,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: item.imageUrl != null
                    ? Container(
                        color: Colors.white,
                        child: Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          isAntiAlias: true,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Show options for a placed item
  void _showItemOptions(
    BuildContext context,
    MixMatchProvider provider,
    PlacedOutfitItem item,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove from Canvas'),
              onTap: () {
                provider.removePlacedItem(item.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flip_to_front),
              title: const Text('Bring to Front'),
              onTap: () {
                provider.bringToFront(item.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build outfit library at bottom
  Widget _buildOutfitLibrary(BuildContext context, MixMatchProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Expand/Collapse header
          InkWell(
            onTap: () {
              setState(() {
                _isLibraryExpanded = !_isLibraryExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    _isLibraryExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Outfit Library',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (!_isLibraryExpanded)
                    Text(
                      'Tap to expand',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          if (_isLibraryExpanded) ...[
            // Category filter chips
            _buildCategorySelector(context, provider),
            
            // Outfit grid
            Expanded(
              child: _buildOutfitGrid(context, provider),
            ),
          ],
        ],
      ),
    );
  }

  /// Show save combination dialog
  void _showSaveComboDialog(BuildContext context) {
    final provider = context.read<MixMatchProvider>();
    
    if (!provider.hasPlacedItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add some items to the canvas first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Save Combination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Combination Name',
                hintText: 'e.g., Summer Casual',
                prefixIcon: Icon(Icons.label),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Text(
              '${provider.placedItems.length} items on canvas',
              style: Theme.of(dialogContext).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a name'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              
              provider.saveCombo(name);
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saved "$name" successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Build category selector chips
  Widget _buildCategorySelector(BuildContext context, MixMatchProvider provider) {
    final categories = ['All', 'tops', 'bottoms', 'outerwear', 'shoes', 'accessories'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = (category == 'All' && provider.selectedLibraryCategory == null) ||
                (category != 'All' && provider.selectedLibraryCategory == category);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category == 'All' ? 'All' : category.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  provider.setLibraryCategory(selected && category != 'All' ? category : null);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build outfit grid with draggable items
  Widget _buildOutfitGrid(BuildContext context, MixMatchProvider provider) {
    final items = provider.libraryItems;

    if (items.isEmpty) {
      return const Center(
        child: Text('No items in this category'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildDraggableOutfitTile(context, item);
      },
    );
  }

  /// Build a draggable outfit tile
  Widget _buildDraggableOutfitTile(BuildContext context, OutfitItem item) {
    return LongPressDraggable<OutfitItemDragData>(
      data: OutfitItemDragData(
        outfitId: item.id,
        imageUrl: item.imageUrl,
        name: item.name,
        category: item.category,
      ),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: item.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      isAntiAlias: true,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                )
              : Container(color: Colors.grey[300]),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildOutfitTileContent(context, item),
      ),
      child: _buildOutfitTileContent(context, item),
    );
  }

  /// Build outfit tile content
  Widget _buildOutfitTileContent(BuildContext context, OutfitItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.white,
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        isAntiAlias: true,
                        filterQuality: FilterQuality.medium,
                      ),
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for dragging outfit items
class OutfitItemDragData {
  final String outfitId;
  final String? imageUrl;
  final String name;
  final String category;

  OutfitItemDragData({
    required this.outfitId,
    required this.imageUrl,
    required this.name,
    required this.category,
  });
}

/// Helper class to store gesture start values for stable transform calculation
class _GestureStartValues {
  final Offset position;
  final double scale;
  final double rotation;
  final Offset focalPoint;

  _GestureStartValues({
    required this.position,
    required this.scale,
    required this.rotation,
    required this.focalPoint,
  });
}

