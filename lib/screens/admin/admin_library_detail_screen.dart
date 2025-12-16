import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/providers/admin_provider.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

@RoutePage()
class AdminLibraryDetailScreen extends ConsumerStatefulWidget {
  final String libraryId;
  final String? libraryName;

  const AdminLibraryDetailScreen({
    super.key,
    @PathParam('libraryId') required this.libraryId,
    @QueryParam('name') this.libraryName,
  });

  @override
  ConsumerState<AdminLibraryDetailScreen> createState() => _AdminLibraryDetailScreenState();
}

class _AdminLibraryDetailScreenState extends ConsumerState<AdminLibraryDetailScreen> {
  VirtualFolderInfo? _library;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ref.read(adminServiceProvider.notifier).getVirtualFolders();
      if (mounted) {
        final library = response.body?.firstWhere(
          (lib) => lib.itemId == widget.libraryId || lib.name == widget.libraryName,
          orElse: () => VirtualFolderInfo(),
        );
        
        setState(() {
          _library = library;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteLibrary() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Library'),
        content: Text(
          'Remove library "${_library?.name}"?\n\nThis will not delete the actual media files.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(adminServiceProvider.notifier).removeVirtualFolder(
          name: _library!.name!,
          refreshLibrary: true,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted library: ${_library!.name}')),
          );
          context.router.back();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _scanLibrary() async {
    try {
      await ref.read(adminServiceProvider.notifier).scanLibrary();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Library scan started')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  IconData _getLibraryIcon(String? collectionType) {
    final type = collectionType?.toLowerCase() ?? '';
    switch (type) {
      case 'movies':
        return IconsaxPlusBold.video;
      case 'tvshows':
        return IconsaxPlusBold.monitor;
      case 'music':
        return IconsaxPlusBold.music;
      case 'books':
        return IconsaxPlusBold.book;
      case 'photos':
        return IconsaxPlusBold.gallery;
      default:
        return IconsaxPlusBold.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.libraryName ?? 'Library Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.libraryName ?? 'Library Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadLibrary,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_library == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.libraryName ?? 'Library Details'),
        ),
        body: const Center(child: Text('Library not found')),
      );
    }

    final locations = _library!.locations ?? [];
    final collectionType = _library!.collectionType?.toString().split('.').last ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(_library!.name ?? 'Library Details'),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.trash),
            onPressed: _deleteLibrary,
            tooltip: 'Delete Library',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLibrary,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Library Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            _getLibraryIcon(collectionType),
                            color: colorScheme.onPrimaryContainer,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _library!.name ?? 'Unnamed Library',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Type: $collectionType',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(IconsaxPlusLinear.scan, color: colorScheme.primary),
                    title: const Text('Scan Library'),
                    subtitle: const Text('Scan for new and updated media'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _scanLibrary,
                  ),
                  Divider(height: 1, indent: 72, color: colorScheme.outlineVariant),
                  ListTile(
                    leading: Icon(IconsaxPlusLinear.folder_open, color: colorScheme.primary),
                    title: const Text('Browse Library'),
                    subtitle: const Text('View library content'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (_library!.itemId != null) {
                        context.router.back();
                        context.router.pushNamed('/library?id=${_library!.itemId}&recursive=true');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Folder Locations Section
            Text(
              'Folder Locations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (locations.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No folders configured',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: locations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final location = entry.value;
                    final isLast = index == locations.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              IconsaxPlusLinear.folder_2,
                              color: colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            location,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        if (!isLast)
                          Divider(height: 1, indent: 72, color: colorScheme.outlineVariant),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),

            // Library Settings
            Text(
              'Library Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Enable library'),
                    subtitle: const Text('Enable this library'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Preferred metadata language'),
                    trailing: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: 'en',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'de', child: Text('German')),
                          DropdownMenuItem(value: 'es', child: Text('Spanish')),
                          DropdownMenuItem(value: 'fr', child: Text('French')),
                          DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Country'),
                    trailing: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: 'US',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'US', child: Text('United States')),
                          DropdownMenuItem(value: 'GB', child: Text('United Kingdom')),
                          DropdownMenuItem(value: 'DE', child: Text('Germany')),
                          DropdownMenuItem(value: 'FR', child: Text('France')),
                          DropdownMenuItem(value: 'JP', child: Text('Japan')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Enable photos'),
                    subtitle: const Text('Enable this library for photo organization features'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Season zero display name'),
                    subtitle: const Text('Specials'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Automatically refresh metadata'),
                    trailing: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: 'never',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'never', child: Text('Never')),
                          DropdownMenuItem(value: 'daily', child: Text('Every day')),
                          DropdownMenuItem(value: '30days', child: Text('Every 30 days')),
                          DropdownMenuItem(value: '60days', child: Text('Every 60 days')),
                          DropdownMenuItem(value: '90days', child: Text('Every 90 days')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Enable realtime monitor'),
                    subtitle: const Text('Detect file changes immediately'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Enable LUFS scan'),
                    subtitle: const Text('Scan for loudness normalization data'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Automatically add to collection'),
                    subtitle: const Text('Automatically add new movies to collections'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Automatically group series'),
                    subtitle: const Text('Merge duplicate series by group name or identifier'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Trickplay
            Text(
              'Trickplay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Extract trickplay images'),
                    subtitle: const Text('Generate trickplay images for seeking preview'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Extract during library scan'),
                    subtitle: const Text('Generate trickplay images during library scans'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Save trickplay locally'),
                    subtitle: const Text('Save trickplay images in media folders'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Chapter Images
            Text(
              'Chapter Images',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Extract chapter images'),
                    subtitle: const Text('Generate images for chapter markers'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Extract during library scan'),
                    subtitle: const Text('Extract chapter images while scanning'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subtitle Downloads
            Text(
              'Subtitle Downloads',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Download Languages',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select languages to automatically download subtitles for',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('English'),
                          selected: true,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('Spanish'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('French'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('German'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('Japanese'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('Portuguese'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('Russian'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        FilterChip(
                          label: const Text('Chinese'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: true,
                      onChanged: (value) {},
                      title: const Text('Require perfect subtitle match'),
                      subtitle: const Text('Only download subtitles that match file name perfectly'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      value: false,
                      onChanged: (value) {},
                      title: const Text('Skip if audio track present'),
                      subtitle: const Text("Skip if an audio track matches the metadata language"),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      value: false,
                      onChanged: (value) {},
                      title: const Text('Skip if graphical subtitles present'),
                      subtitle: const Text('Skip if embedded image-based subtitles are present'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      value: true,
                      onChanged: (value) {},
                      title: const Text('Save subtitles into media folders'),
                      subtitle: const Text('Save downloaded subtitles alongside media files'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lyrics
            Text(
              'Lyrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Save lyrics into media folders'),
                    subtitle: const Text('Save downloaded lyrics alongside media files'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Audio Tag Settings
            Text(
              'Audio Tag Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Enable embedded titles'),
                    subtitle: const Text('Use titles from file tags'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Enable embedded episode info'),
                    subtitle: const Text('Extract episode information from file tags'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Allow embedded subtitles'),
                    trailing: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: 'AllowAll',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'AllowAll', child: Text('All')),
                          DropdownMenuItem(value: 'AllowText', child: Text('Text only')),
                          DropdownMenuItem(value: 'AllowImage', child: Text('Image only')),
                          DropdownMenuItem(value: 'AllowNone', child: Text('None')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Prefer non-standard artists tag'),
                    subtitle: const Text('Use non-standard artists tag when available'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: false,
                    onChanged: (value) {},
                    title: const Text('Use custom tag delimiters'),
                    subtitle: const Text('Enable custom delimiters for multi-value tags'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Custom tag delimiters'),
                    subtitle: const Text('/|;\\'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Delimiter whitelist'),
                    subtitle: const Text('Allowed delimiters (one per line)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Metadata Savers & Readers
            Text(
              'Metadata',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (value) {},
                    title: const Text('Save local metadata'),
                    subtitle: const Text('Save metadata into media folders'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ExpansionTile(
                    title: const Text('Metadata savers'),
                    subtitle: const Text('2 enabled'),
                    children: [
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text('Nfo'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (value) {},
                        title: const Text('Jellyfin'),
                        dense: true,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  ExpansionTile(
                    title: const Text('Metadata readers'),
                    subtitle: const Text('Order: Nfo'),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.drag_handle),
                        title: const Text('Nfo'),
                        dense: true,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  ExpansionTile(
                    title: const Text('Metadata fetchers'),
                    subtitle: const Text('TheMovieDb, TheTVDB, etc.'),
                    children: [
                      ListTile(
                        title: const Text('Movie metadata downloaders'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text('TheMovieDb'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (value) {},
                        title: const Text('The Open Movie Database'),
                        dense: true,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  ExpansionTile(
                    title: const Text('Image fetchers'),
                    subtitle: const Text('Download artwork from providers'),
                    children: [
                      ListTile(
                        title: const Text('Movie image fetchers'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text('TheMovieDb'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text('Embedded Image Extractor'),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text('Screen Grabber'),
                        dense: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
