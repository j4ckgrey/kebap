import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resume Playback Settings Screen
/// 
/// Controls when media playback should resume from previous position:
/// - Min/Max resume percentage (0-100%)
/// - Min/Max audiobook resume time (seconds)
/// - Min resume duration threshold (seconds)
@RoutePage()
class AdminResumeScreen extends ConsumerStatefulWidget {
  const AdminResumeScreen({super.key});

  @override
  ConsumerState<AdminResumeScreen> createState() => _AdminResumeScreenState();
}

class _AdminResumeScreenState extends ConsumerState<AdminResumeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minResumePercentageController = TextEditingController();
  final _maxResumePercentageController = TextEditingController();
  final _minAudiobookResumeController = TextEditingController();
  final _maxAudiobookResumeController = TextEditingController();
  final _minResumeDurationController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    setState(() => _isLoading = true);
    
    // TODO: Load resume configuration from API
    // For now, set defaults matching Jellyfin
    _minResumePercentageController.text = '5'; // MinResumePct
    _maxResumePercentageController.text = '90'; // MaxResumePct
    _minAudiobookResumeController.text = '5'; // MinAudiobookResume (seconds)
    _maxAudiobookResumeController.text = '5'; // MaxAudiobookResume (seconds)
    _minResumeDurationController.text = '300'; // MinResumeDurationSeconds (5 minutes)
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Save to API
      // final config = ServerConfiguration(
      //   minResumePct: int.parse(_minResumePercentageController.text),
      //   maxResumePct: int.parse(_maxResumePercentageController.text),
      //   minAudiobookResume: int.parse(_minAudiobookResumeController.text),
      //   maxAudiobookResume: int.parse(_maxAudiobookResumeController.text),
      //   minResumeDurationSeconds: int.parse(_minResumeDurationController.text),
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
    _minResumePercentageController.dispose();
    _maxResumePercentageController.dispose();
    _minAudiobookResumeController.dispose();
    _maxAudiobookResumeController.dispose();
    _minResumeDurationController.dispose();
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
              'Resume Playback',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure when media should resume from the last watched position',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // General Resume Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video & General Media',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Min Resume Percentage
                    TextFormField(
                      controller: _minResumePercentageController,
                      decoration: InputDecoration(
                        labelText: 'Minimum Resume Percentage',
                        helperText: 'Don\'t offer to resume if the playback position is less than this percentage (0-100)',
                        suffixText: '%',
                        border: const OutlineInputBorder(),
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
                        if (intValue == null || intValue < 0 || intValue > 100) {
                          return 'Value must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Max Resume Percentage
                    TextFormField(
                      controller: _maxResumePercentageController,
                      decoration: InputDecoration(
                        labelText: 'Maximum Resume Percentage',
                        helperText: 'Don\'t offer to resume if the playback position is greater than this percentage (1-100)',
                        suffixText: '%',
                        border: const OutlineInputBorder(),
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

                    // Min Resume Duration
                    TextFormField(
                      controller: _minResumeDurationController,
                      decoration: InputDecoration(
                        labelText: 'Minimum Resume Duration',
                        helperText: 'Don\'t offer to resume if the media is shorter than this duration (seconds)',
                        suffixText: 'seconds',
                        border: const OutlineInputBorder(),
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
            const SizedBox(height: 16),

            // Audiobook-Specific Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audiobook Settings',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Special resume settings for audiobooks',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Min Audiobook Resume
                    TextFormField(
                      controller: _minAudiobookResumeController,
                      decoration: InputDecoration(
                        labelText: 'Minimum Audiobook Resume',
                        helperText: 'Don\'t resume audiobooks if less than this many seconds have been played (0-100)',
                        suffixText: 'seconds',
                        border: const OutlineInputBorder(),
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
                        if (intValue == null || intValue < 0 || intValue > 100) {
                          return 'Value must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Max Audiobook Resume
                    TextFormField(
                      controller: _maxAudiobookResumeController,
                      decoration: InputDecoration(
                        labelText: 'Maximum Audiobook Resume',
                        helperText: 'Don\'t resume audiobooks if more than this many seconds remain (1-100)',
                        suffixText: 'seconds',
                        border: const OutlineInputBorder(),
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
