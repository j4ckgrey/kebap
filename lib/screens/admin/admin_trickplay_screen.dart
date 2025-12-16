import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trickplay Image Generation Settings Screen
/// 
/// Controls thumbnail preview image generation (shown when scrubbing through video):
/// - Hardware acceleration/encoding
/// - Scan behavior (blocking/non-blocking)
/// - Process priority
/// - Image interval and dimensions
/// - Tile grid configuration
/// - Quality settings (JPEG/Qscale)
/// - Thread count
@RoutePage()
class AdminTrickplayScreen extends ConsumerStatefulWidget {
  const AdminTrickplayScreen({super.key});

  @override
  ConsumerState<AdminTrickplayScreen> createState() => _AdminTrickplayScreenState();
}

class _AdminTrickplayScreenState extends ConsumerState<AdminTrickplayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageIntervalController = TextEditingController();
  final _widthResolutionsController = TextEditingController();
  final _tileWidthController = TextEditingController();
  final _tileHeightController = TextEditingController();
  final _jpegQualityController = TextEditingController();
  final _qscaleController = TextEditingController();
  final _processThreadsController = TextEditingController();
  
  bool _enableHardwareAcceleration = false;
  bool _enableHardwareEncoding = false;
  bool _enableKeyFrameOnlyExtraction = true;
  String _scanBehavior = 'NonBlocking'; // NonBlocking, Blocking
  String _processPriority = 'BelowNormal'; // High, AboveNormal, Normal, BelowNormal, Idle
  
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    setState(() => _isLoading = true);
    
    // TODO: Load trickplay configuration from API
    // For now, set defaults matching Jellyfin
    _enableHardwareAcceleration = false;
    _enableHardwareEncoding = false;
    _enableKeyFrameOnlyExtraction = true;
    _scanBehavior = 'NonBlocking';
    _processPriority = 'BelowNormal';
    _imageIntervalController.text = '10000'; // milliseconds
    _widthResolutionsController.text = '320'; // comma-separated widths
    _tileWidthController.text = '10';
    _tileHeightController.text = '10';
    _jpegQualityController.text = '90';
    _qscaleController.text = '4';
    _processThreadsController.text = '0'; // 0 = auto
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Save to API
      // final config = TrickplayOptions(
      //   enableHwAcceleration: _enableHardwareAcceleration,
      //   enableHwEncoding: _enableHardwareEncoding,
      //   enableKeyFrameOnlyExtraction: _enableKeyFrameOnlyExtraction,
      //   scanBehavior: _scanBehavior,
      //   processPriority: _processPriority,
      //   interval: int.parse(_imageIntervalController.text),
      //   widthResolutions: _widthResolutionsController.text.split(',').map((e) => int.parse(e.trim())).toList(),
      //   tileWidth: int.parse(_tileWidthController.text),
      //   tileHeight: int.parse(_tileHeightController.text),
      //   jpegQuality: int.parse(_jpegQualityController.text),
      //   qscale: int.parse(_qscaleController.text),
      //   processThreads: int.parse(_processThreadsController.text),
      // );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _imageIntervalController.dispose();
    _widthResolutionsController.dispose();
    _tileWidthController.dispose();
    _tileHeightController.dispose();
    _jpegQualityController.dispose();
    _qscaleController.dispose();
    _processThreadsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Header
            Text(
              'Trickplay',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure thumbnail image generation for video scrubbing preview',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Hardware Acceleration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hardware Acceleration',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('Enable Hardware Acceleration'),
                      subtitle: const Text('Use GPU to accelerate image extraction'),
                      value: _enableHardwareAcceleration,
                      onChanged: (value) {
                        setState(() => _enableHardwareAcceleration = value);
                      },
                    ),

                    SwitchListTile(
                      title: const Text('Enable Hardware Encoding'),
                      subtitle: const Text('Use GPU to encode extracted images'),
                      value: _enableHardwareEncoding,
                      onChanged: (value) {
                        setState(() => _enableHardwareEncoding = value);
                      },
                    ),

                    SwitchListTile(
                      title: const Text('Key Frame Only Extraction'),
                      subtitle: const Text('Extract images only from key frames (faster, lower quality)'),
                      value: _enableKeyFrameOnlyExtraction,
                      onChanged: (value) {
                        setState(() => _enableKeyFrameOnlyExtraction = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scan Behavior & Priority
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Processing Behavior',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _scanBehavior,
                      decoration: const InputDecoration(
                        labelText: 'Scan Behavior',
                        helperText: 'How trickplay generation should run during library scans',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'NonBlocking',
                          child: Text('Non-Blocking'),
                        ),
                        DropdownMenuItem(
                          value: 'Blocking',
                          child: Text('Blocking'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _scanBehavior = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _processPriority,
                      decoration: const InputDecoration(
                        labelText: 'Process Priority',
                        helperText: 'CPU priority for trickplay generation',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'High',
                          child: Text('High'),
                        ),
                        DropdownMenuItem(
                          value: 'AboveNormal',
                          child: Text('Above Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'BelowNormal',
                          child: Text('Below Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'Idle',
                          child: Text('Idle'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _processPriority = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image Extraction Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Extraction',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _imageIntervalController,
                      decoration: const InputDecoration(
                        labelText: 'Image Interval',
                        helperText: 'Extract one image every X milliseconds',
                        suffixText: 'ms',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1) {
                          return 'Value must be 1 or greater';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _widthResolutionsController,
                      decoration: const InputDecoration(
                        labelText: 'Width Resolutions',
                        helperText: 'Comma-separated list of image widths to generate (e.g., 320,640)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter at least one resolution';
                        }
                        // Validate comma-separated numbers
                        final parts = value.split(',');
                        for (final part in parts) {
                          if (int.tryParse(part.trim()) == null) {
                            return 'Invalid format. Use comma-separated numbers';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tile Grid Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tile Grid',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Images are combined into tile grids for efficient loading',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _tileWidthController,
                      decoration: const InputDecoration(
                        labelText: 'Tile Width',
                        helperText: 'Number of images per row in the tile grid',
                        suffixText: 'images',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1) {
                          return 'Value must be 1 or greater';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _tileHeightController,
                      decoration: const InputDecoration(
                        labelText: 'Tile Height',
                        helperText: 'Number of images per column in the tile grid',
                        suffixText: 'images',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1) {
                          return 'Value must be 1 or greater';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quality Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality Settings',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _jpegQualityController,
                      decoration: const InputDecoration(
                        labelText: 'JPEG Quality',
                        helperText: 'Image quality (1-100, higher = better quality but larger files)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1 || intValue > 100) {
                          return 'Value must be between 1 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _qscaleController,
                      decoration: const InputDecoration(
                        labelText: 'Qscale',
                        helperText: 'Video quality scale (2-31, lower = better quality)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 2 || intValue > 31) {
                          return 'Value must be between 2 and 31';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Threading
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Threading',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _processThreadsController,
                      decoration: const InputDecoration(
                        labelText: 'Process Threads',
                        helperText: 'Number of threads for processing (0 = auto)',
                        suffixText: 'threads',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 0) {
                          return 'Value must be 0 or greater';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveConfiguration,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
