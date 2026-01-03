import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/outfit_categories.dart';
import '../providers/outfit_form_provider.dart';
import '../providers/outfit_list_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AddOutfitScreen extends StatefulWidget {
  const AddOutfitScreen({super.key});

  @override
  State<AddOutfitScreen> createState() => _AddOutfitScreenState();
}

class _AddOutfitScreenState extends State<AddOutfitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _notesController = TextEditingController();
  
  OutfitCategory _selectedCategory = OutfitCategory.tops;
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      if (mounted) {
        context.read<OutfitFormProvider>().setImagePath(pickedFile.path);
      }
    }
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      if (mounted) {
        context.read<OutfitFormProvider>().setImagePath(pickedFile.path);
      }
    }
  }

  void _showBackgroundRemovalTip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Tip'),
          ],
        ),
        content: const Text(
          'Images without background are recommended for best results in Mix & Match.\n\nYou can remove backgrounds online before uploading.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final url = Uri.parse('https://www.remove.bg/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open background remover'),
                    ),
                  );
                }
              }
            },
            child: const Text('Open Background Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final formProvider = context.read<OutfitFormProvider>();
      formProvider.setName(_nameController.text);
      formProvider.setCategory(_selectedCategory.name.toLowerCase());
      formProvider.setColor(_colorController.text);
      formProvider.setNotes(_notesController.text);
      
      final outfit = await formProvider.createOutfit();
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (outfit != null) {
          // Refresh the outfit list
          context.read<OutfitListProvider>().loadOutfits();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Outfit added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(formProvider.errorMessage ?? 'Failed to add outfit'),
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
        title: const Text('Add Outfit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker Section with Help Button
              Row(
                children: [
                  const Text(
                    'Outfit Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 20),
                    onPressed: _showBackgroundRemovalTip,
                    tooltip: 'Background removal tip',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Image Preview
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImagePath == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No photo selected',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: kIsWeb
                              ? Image.network(
                                  _selectedImagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  isAntiAlias: true,
                                  filterQuality: FilterQuality.medium,
                                )
                              : Image.file(
                                  File(_selectedImagePath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  isAntiAlias: true,
                                  filterQuality: FilterQuality.medium,
                                ),
                        ),
                      )
              ),
              const SizedBox(height: 16),
              
              // Image Source Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                ],
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
                    : const Text('Add Outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
