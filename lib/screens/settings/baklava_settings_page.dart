import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/screens/shared/input_fields.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/size_formatting.dart';

@RoutePage()
class BaklavaSettingsPage extends ConsumerStatefulWidget {
  const BaklavaSettingsPage({super.key});

  @override
  ConsumerState<BaklavaSettingsPage> createState() => _BaklavaSettingsPageState();
}

class _BaklavaSettingsPageState extends ConsumerState<BaklavaSettingsPage> {
  // Cache list state
  List<dynamic>? _cacheItems;
  bool _isLoadingCache = false;
  
  // Service dropdown state
  List<dynamic> _cacheServices = [];
  String? _selectedService;

  @override
  void initState() {
    super.initState();
    _loadCacheList();
    _loadCacheServices();
  }

  Future<void> _loadCacheList() async {
    if (!mounted) return;
    setState(() => _isLoadingCache = true);
    try {
      final res = await ref.read(baklavaServiceProvider).getCacheList();
      if (mounted) {
        setState(() {
          _cacheItems = res.body ?? [];
          _isLoadingCache = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cacheItems = [];
          _isLoadingCache = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load cache: $e')));
      }
    }
  }

  Future<void> _loadCacheServices() async {
    try {
      final res = await ref.read(baklavaServiceProvider).getCacheServices();
      if (mounted) {
        setState(() {
          _cacheServices = res.body ?? [];
        });
      }
    } catch (e) {
      // Silently fail - dropdown just won't have options
    }
  }

  Future<void> _refreshCacheItem(String itemId) async {
    try {
      await ref.read(baklavaServiceProvider).refreshCacheItem(itemId);
      await _loadCacheList();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item refreshed')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to refresh: $e')));
    }
  }

  Future<void> _deleteCacheItem(String itemId) async {
    try {
      await ref.read(baklavaServiceProvider).deleteCacheItem(itemId);
      await _loadCacheList();
      await _loadCacheServices();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item deleted')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  Future<void> _deleteAllCache() async {
    final serviceName = _selectedService ?? 'All Services';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache ($serviceName)?'),
        content: Text(
          'This will delete cached stream metadata${_selectedService != null ? ' for $serviceName' : ''} and remove downloaded files from your Debrid service.\n\nAre you sure?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(baklavaServiceProvider).deleteAllCache(service: _selectedService);
        await _loadCacheList();
        await _loadCacheServices();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cache cleared${_selectedService != null ? ' for $_selectedService' : ''}')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to clear cache: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baklavaConfigAsync = ref.watch(baklavaConfigProvider);

    return SettingsScaffold(
      label: 'Baklava Settings',
      items: [
        baklavaConfigAsync.when(
          data: (config) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- API Keys Section ---
                ...settingsListGroup(
                  context,
                  const SettingsLabelDivider(label: 'API Keys'),
                  [
                    SettingsListTile(
                      label: const Text('TMDB API Key'),
                      subLabel: Text(config.tmdbApiKey?.isNotEmpty == true ? config.tmdbApiKey! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.tmdbApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(tmdbApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'TMDB API Key',
                        '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Debrid API Keys Section ---
                ...settingsListGroup(
                  context,
                  const SettingsLabelDivider(label: 'Debrid API Keys'),
                  [
                    SettingsListTile(
                      label: const Text('RealDebrid API Key'),
                      subLabel: Text((config.realDebridApiKey ?? config.debridApiKey)?.isNotEmpty == true 
                          ? (config.realDebridApiKey ?? config.debridApiKey)! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key_square),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.realDebridApiKey ?? config.debridApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(realDebridApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'RealDebrid API Key',
                        '',
                      ),
                    ),
                    SettingsListTile(
                      label: const Text('TorBox API Key'),
                      subLabel: Text(config.torboxApiKey?.isNotEmpty == true ? config.torboxApiKey! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key_square),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.torboxApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(torboxApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'TorBox API Key',
                        '',
                      ),
                    ),
                    SettingsListTile(
                      label: const Text('AllDebrid API Key'),
                      subLabel: Text(config.alldebridApiKey?.isNotEmpty == true ? config.alldebridApiKey! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key_square),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.alldebridApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(alldebridApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'AllDebrid API Key',
                        '',
                      ),
                    ),
                    SettingsListTile(
                      label: const Text('Premiumize API Key'),
                      subLabel: Text(config.premiumizeApiKey?.isNotEmpty == true ? config.premiumizeApiKey! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key_square),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.premiumizeApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(premiumizeApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'Premiumize API Key',
                        '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Request Settings Section ---
                ...settingsListGroup(
                  context,
                  const SettingsLabelDivider(label: 'Request Settings'),
                  [
                    SettingsListTile(
                      label: const Text('Enable Auto Import'),
                      subLabel: const Text('Allow non-admins to import directly'),
                      trailing: Switch(
                        value: config.enableAutoImport,
                        onChanged: (v) async {
                          await ref.read(baklavaServiceProvider).updateConfig(enableAutoImport: v);
                          ref.invalidate(baklavaConfigProvider);
                        },
                      ),
                      onTap: () async {
                        final newValue = !config.enableAutoImport;
                        await ref.read(baklavaServiceProvider).updateConfig(enableAutoImport: newValue);
                        ref.invalidate(baklavaConfigProvider);
                      },
                    ),
                    if (config.enableAutoImport)
                      SettingsListTile(
                        label: const Text('Disable Modal'),
                        subLabel: const Text('Directly open items on click'),
                        trailing: Switch(
                          value: config.disableModal,
                          onChanged: (v) async {
                            await ref.read(baklavaServiceProvider).updateConfig(disableModal: v);
                            ref.invalidate(baklavaConfigProvider);
                          },
                        ),
                        onTap: () async {
                          final newValue = !config.disableModal;
                          await ref.read(baklavaServiceProvider).updateConfig(disableModal: newValue);
                          ref.invalidate(baklavaConfigProvider);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Debrid Integration Section (DISABLED) ---
                ...settingsListGroup(
                  context,
                  const SettingsLabelDivider(label: 'Debrid Integration (Disabled)'),
                  [
                    Opacity(
                      opacity: 0.5,
                      child: SettingsListTile(
                        label: const Text('Enable Cached Debrid Streams'),
                        subLabel: const Text('Currently disabled in Baklava'),
                        trailing: Switch(
                          value: config.enableDebridMetadata ?? true,
                          onChanged: null,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: SettingsListTile(
                        label: const Text('Enable Non-Cached Streams (Probe)'),
                        subLabel: const Text('Currently disabled in Baklava'),
                        trailing: Switch(
                          value: config.enableFallbackProbe ?? false,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // --- Cache Management Section ---
                const SettingsLabelDivider(label: 'Cache Management'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Service dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                          ),
                          child: DropdownButton<String?>(
                            value: _selectedService,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('All Services'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All Services'),
                              ),
                              ..._cacheServices.map((svc) {
                                final name = svc['name'] as String? ?? '';
                                final fileCount = svc['fileCount'] as int? ?? 0;
                                final hasFiles = svc['hasFiles'] as bool? ?? false;
                                return DropdownMenuItem<String?>(
                                  value: name,
                                  enabled: hasFiles,
                                  child: Text(
                                    '$name ($fileCount files)',
                                    style: TextStyle(
                                      color: hasFiles ? null : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                );
                              }),
                            ],
                            onChanged: (val) => setState(() => _selectedService = val),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: _deleteAllCache,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Cache List
                Container(
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: _isLoadingCache
                      ? const Center(child: CircularProgressIndicator())
                      : _cacheItems == null || _cacheItems!.isEmpty
                          ? Center(
                              child: Text(
                                'Cache is empty',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: _cacheItems!.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = _cacheItems![index];
                                final title = item['title'] ?? 'Unknown Item';
                                final size = (item['size'] as num?)?.toInt() ?? 0;
                                return ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(size.byteFormat ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(IconsaxPlusLinear.refresh, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: Theme.of(context).colorScheme.primary,
                                        onPressed: () => _refreshCacheItem(item['id']),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(IconsaxPlusLinear.trash, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: Theme.of(context).colorScheme.error,
                                        onPressed: () => _deleteCacheItem(item['id']),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error loading Baklava config: $err')),
        ),
      ],
    );
  }
}
