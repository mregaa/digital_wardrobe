import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/outfit_categories.dart';
import '../providers/outfit_form_provider.dart';
import '../providers/outfit_detail_provider.dart';
import '../providers/outfit_list_provider.dart';

class EditOutfitScreen extends StatefulWidget {
  final String outfitId;

  const EditOutfitScreen({
    super.key,
    required this.outfitId,
  });

  @override
  State<EditOutfitScreen> createState() => _EditOutfitScreenState();
}

class _EditOutfitScreenState extends State<EditOutfitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _notesController = TextEditingController();
  
  OutfitCategory _selectedCategory = OutfitCategory.tops;
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOutfitData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadOutfitData() async {
    final detailProvider = context.read<OutfitDetailProvider>();
    await detailProvider.loadOutfit(widget.outfitId);
    
    final outfit = detailProvider.outfit;
    if (outfit != null && mounted) {
      setState(() {
        _nameController.text = outfit.name;
        _colorController.text = outfit.color;
        _notesController.text = outfit.notes ?? '';
        
        // Use safe parsing to handle any category format
        _selectedCategory = OutfitCategoryExtension.fromAny(
          outfit.category,
          fallback: OutfitCategory.tops,
        );
      });
      
      // Initialize form provider
      final formProvider = context.read<OutfitFormProvider>();
      formProvider.initializeWithOutfit(outfit);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      if (mounted) {
        context.read<OutfitFormProvider>().setImagePath(pickedFile.path);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final formProvider = context.read<OutfitFormProvider>();
      formProvider.setName(_nameController.text);
      formProvider.setCategory(_selectedCategory.name.toLowerCase());
      formProvider.setColor(_colorController.text);
      formProvider.setNotes(_notesController.text);
      
      final outfit = await formProvider.updateOutfit(widget.outfitId);
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (outfit != null) {
          // Refresh providers
          context.read<OutfitListProvider>().loadOutfits();
          context.read<OutfitDetailProvider>().loadOutfit(widget.outfitId);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Outfit updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(formProvider.errorMessage ?? 'Failed to update outfit'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Outfit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              Consumer<OutfitDetailProvider>(
                builder: (context, detailProvider, _) {
                  final outfit = detailProvider.outfit;
                  final bool hasNewImage = _selectedImagePath != null;
                  final bool hasExistingImage = outfit?.imageUrl != null;
                  
                  return GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: hasNewImage
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        setState(() => _selectedImagePath = null);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : hasExistingImage
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        outfit!.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        isAntiAlias: true,
                                        filterQuality: FilterQuality.medium,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 64,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Tap to change',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Tap to add photo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Outfit Name',
                  hintText: 'e.g., Blue Summer Dress',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter outfit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<OutfitCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: OutfitCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Color Field
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'e.g., Navy Blue',
                  prefixIcon: Icon(Icons.palette_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter color';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add any additional details...',
                  prefixIcon: Icon(Icons.notes_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Update Outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
