import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/providers/server_config_provider.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';

@RoutePage()
class AdminGeneralScreen extends ConsumerStatefulWidget {
  const AdminGeneralScreen({super.key});

  @override
  ConsumerState<AdminGeneralScreen> createState() => _AdminGeneralScreenState();
}

class _AdminGeneralScreenState extends ConsumerState<AdminGeneralScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serverNameController;
  late TextEditingController _cachePathController;
  late TextEditingController _metadataPathController;
  late TextEditingController _libraryScanFanoutController;
  late TextEditingController _parallelImageEncodingController;
  String _selectedLanguage = 'en';
  bool _quickConnectAvailable = true;
  bool _isLoading = true;
  bool _isSaving = false;

  List<Map<String, String>> _languages = [];

  @override
  void initState() {
    super.initState();
    _serverNameController = TextEditingController();
    _cachePathController = TextEditingController();
    _metadataPathController = TextEditingController();
    _libraryScanFanoutController = TextEditingController(text: '0');
    _parallelImageEncodingController = TextEditingController(text: '0');
    _loadData();
  }

  @override
  void dispose() {
    _serverNameController.dispose();
    _cachePathController.dispose();
    _metadataPathController.dispose();
    _libraryScanFanoutController.dispose();
    _parallelImageEncodingController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(jellyApiProvider);
      
      // Load cultures for language dropdown
      final culturesResponse = await service.api.localizationCulturesGet();
      if (culturesResponse.body != null) {
        _languages = culturesResponse.body!
            .map((c) => {
                  'value': c.twoLetterISOLanguageName ?? '',
                  'name': c.displayName ?? '',
                })
            .toList();
      }

      // Load current config
      final config = await ref.read(serverConfigProvider.future);
      if (mounted) {
        setState(() {
          _serverNameController.text = config.serverName ?? '';
          _cachePathController.text = config.cachePath ?? '';
          _metadataPathController.text = config.metadataPath ?? '';
          _selectedLanguage = config.uICulture ?? 'en';
          _quickConnectAvailable = config.quickConnectAvailable ?? true;
          _libraryScanFanoutController.text = (config.libraryScanFanoutConcurrency ?? 0).toString();
          _parallelImageEncodingController.text = (config.parallelImageEncodingLimit ?? 0).toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final currentConfig = await ref.read(serverConfigProvider.future);
      final service = ref.read(jellyApiProvider);

      final updatedConfig = currentConfig.copyWith(
        serverName: _serverNameController.text,
        cachePath: _cachePathController.text,
        metadataPath: _metadataPathController.text,
        uICulture: _selectedLanguage,
        quickConnectAvailable: _quickConnectAvailable,
        libraryScanFanoutConcurrency: int.tryParse(_libraryScanFanoutController.text) ?? 0,
        parallelImageEncodingLimit: int.tryParse(_parallelImageEncodingController.text) ?? 0,
      );

      await service.systemConfigurationPost(updatedConfig);
      ref.invalidate(serverConfigProvider);

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(IconsaxPlusBold.tick_circle),
              onPressed: _saveSettings,
              tooltip: 'Save',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Server Name
                  TextFormField(
                    controller: _serverNameController,
                    decoration: InputDecoration(
                      labelText: 'Server name',
                      helperText: 'Friendly name of this Jellyfin Server, displayed to users',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.monitor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Server name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Preferred Display Language
                  DropdownButtonFormField<String>(
                    value: _languages.any((lang) => lang['value'] == _selectedLanguage) 
                        ? _selectedLanguage 
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Preferred display language',
                      helperText: 'This is the language that will be used for the user interface',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.language_square),
                    ),
                    items: _languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang['value'],
                        child: Text(lang['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedLanguage = value);
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Paths Section
                  Text(
                    'Paths',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cachePathController,
                    decoration: InputDecoration(
                      labelText: 'Cache path',
                      helperText: 'Specify a custom path to use for cache files. Leave empty to use server default',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.folder_2),
                      suffixIcon: IconButton(
                        icon: const Icon(IconsaxPlusLinear.folder_open),
                        onPressed: () {
                          // TODO: Implement directory picker
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _metadataPathController,
                    decoration: InputDecoration(
                      labelText: 'Metadata path',
                      helperText: 'Specify a custom path to use for metadata files. Leave empty to store within the library folders',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.folder_2),
                      suffixIcon: IconButton(
                        icon: const Icon(IconsaxPlusLinear.folder_open),
                        onPressed: () {
                          // TODO: Implement directory picker
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Connect
                  Card(
                    child: SwitchListTile(
                      value: _quickConnectAvailable,
                      onChanged: (value) {
                        setState(() => _quickConnectAvailable = value);
                      },
                      title: const Text('Enable Quick Connect'),
                      subtitle: const Text('Allow users to sign in with a pin code'),
                      secondary: const Icon(IconsaxPlusLinear.scan),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Performance Section
                  Text(
                    'Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _libraryScanFanoutController,
                    decoration: InputDecoration(
                      labelText: 'Library scan concurrency',
                      helperText: 'Number of library items to scan in parallel. Set to 0 for auto',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.flash),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _parallelImageEncodingController,
                    decoration: InputDecoration(
                      labelText: 'Parallel image encoding limit',
                      helperText: 'Maximum number of image extraction threads. Set to 0 for auto',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconsaxPlusLinear.gallery),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
