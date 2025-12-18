import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Load cache list on init
    _loadCacheList();
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
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item deleted')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  Future<void> _deleteAllCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cache?'),
        content: const Text(
          'This will delete all cached stream metadata and remove downloaded files from your Debrid service.\n\nAre you sure?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(baklavaServiceProvider).deleteAllCache();
        await _loadCacheList();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All cache cleared')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to clear cache: $e')));
      }
    }
  }

  Future<void> _probeAllCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Probe All Cache?'),
        content: const Text(
          'This will scan all cached items, verify Debrid links, and perform FFprobe analysis on audio/subtitle streams.\n\nThis may take a long time.\nAre you sure?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Probe All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(baklavaServiceProvider).probeAllCache();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Probe All started in background. Check logs.')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baklavaConfigAsync = ref.watch(baklavaConfigProvider); // Use direct provider to get fresh server config
    // We can also use effectiveBaklavaConfigProvider but for settings editing we usually want source of truth

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

                // --- Debrid Integration Section ---
                ...settingsListGroup(
                  context,
                  const SettingsLabelDivider(label: 'Debrid Integration (Stream MediaInfo)'),
                  [
                    SettingsListTile(
                      label: const Text('Debrid Service'),
                      subLabel: Text(config.debridService ?? 'Real-Debrid'),
                      leading: const Icon(IconsaxPlusLinear.cloud_connection),
                      onTap: () {
                         // Show selection
                         showModalBottomSheet(
                           context: context,
                           builder: (context) => SafeArea(
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: ['realdebrid', 'alldebrid', 'premiumize', 'debridlink', 'torbox'].map((e) => ListTile(
                                 title: Text(e),
                                 trailing: config.debridService == e ? const Icon(Icons.check) : null,
                                 onTap: () async {
                                   Navigator.pop(context);
                                   await ref.read(baklavaServiceProvider).updateConfig(debridService: e);
                                   ref.invalidate(baklavaConfigProvider);
                                 },
                               )).toList(),
                             ),
                           ),
                         );
                      },
                    ),
                    SettingsListTile(
                      label: const Text('Debrid API Key'),
                      subLabel: Text(config.debridApiKey?.isNotEmpty == true ? config.debridApiKey! : 'Not Set'),
                      leading: const Icon(IconsaxPlusLinear.key_square),
                      onTap: () => openSimpleTextInput(
                        context,
                        config.debridApiKey,
                        (val) async {
                           await ref.read(baklavaServiceProvider).updateConfig(debridApiKey: val);
                           ref.invalidate(baklavaConfigProvider);
                        },
                        'Debrid API Key',
                        '',
                      ),
                    ),
                    SettingsListTile(
                      label: const Text('Enable Cached Debrid Streams'),
                      subLabel: const Text('Fetch metadata from debrid cache without downloading'),
                      trailing: Switch(
                        value: config.enableDebridMetadata ?? true,
                        onChanged: (v) async {
                          await ref.read(baklavaServiceProvider).updateConfig(enableDebridMetadata: v);
                          ref.invalidate(baklavaConfigProvider);
                        },
                      ),
                    ),
                    if (config.enableDebridMetadata == true)
                      SettingsListTile(
                        label: const Text('Fetch Cached Per Version'),
                        subLabel: const Text('Only fetch metadata for selected version (Faster)'),
                        trailing: Switch(
                          value: config.fetchCachedMetadataPerVersion ?? false,
                          onChanged: (v) async {
                            await ref.read(baklavaServiceProvider).updateConfig(fetchCachedMetadataPerVersion: v);
                            ref.invalidate(baklavaConfigProvider);
                          },
                        ),
                      ),
                    SettingsListTile(
                      label: const Text('Enable Non-Cached Streams (Probe)'),
                      subLabel: const Text('WARNING: Will download file to debrid account if not cached'),
                      trailing: Switch(
                        value: config.enableFallbackProbe ?? false,
                        onChanged: (v) async {
                          await ref.read(baklavaServiceProvider).updateConfig(enableFallbackProbe: v);
                          ref.invalidate(baklavaConfigProvider);
                        },
                      ),
                    ),
                    // Advanced Toggles

                    if (config.enableFallbackProbe == true)
                      SettingsListTile(
                        label: const Text('Fetch All Non-Cached'),
                        subLabel: const Text('WARNING: Costly! Downloads all versions to probe.'),
                        trailing: Switch(
                          value: config.fetchAllNonCachedMetadata ?? false,
                          onChanged: (v) async {
                            await ref.read(baklavaServiceProvider).updateConfig(fetchAllNonCachedMetadata: v);
                            ref.invalidate(baklavaConfigProvider);
                          },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Manage cached', style: Theme.of(context).textTheme.bodySmall), // Shortened label
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /* TextButton(
                            onPressed: _probeAllCache,
                            child: const Text('Probe All'),
                          ),
                          const SizedBox(width: 8), */
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.error,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _deleteAllCache,
                            child: const Text('Clear All'),
                          ),
                        ],
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
                                // Simple list item
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
