import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';

class AdminLeftPane extends StatefulWidget {
  final String activeRouteName;
  const AdminLeftPane({required this.activeRouteName, super.key});

  @override
  State<AdminLeftPane> createState() => _AdminLeftPaneState();
}

class _AdminLeftPaneState extends State<AdminLeftPane> {
  bool _librariesExpanded = true;
  bool _playbackExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand Libraries if on a library sub-route
    _librariesExpanded = widget.activeRouteName.contains('Library') ||
        widget.activeRouteName.contains('AdminDisplay') ||
        widget.activeRouteName.contains('AdminMetadata') ||
        widget.activeRouteName.contains('AdminNfo');
    
    // Auto-expand Playback if on a playback sub-route
    _playbackExpanded = widget.activeRouteName.contains('Transcoding') ||
        widget.activeRouteName.contains('Resume') ||
        widget.activeRouteName.contains('Streaming') ||
        widget.activeRouteName.contains('Trickplay');
  }

  @override
  Widget build(BuildContext context) {
    void navigateTo(PageRouteInfo route) => context.tabsRouter.navigate(route);

    bool containsRoute(PageRouteInfo route) {
      final isDual = AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual;
      final matches = widget.activeRouteName == route.routeName;
      return isDual && matches;
    }

    // Check if any library sub-route is active
    bool isLibraryActive() {
      return containsRoute(const AdminLibrariesRoute()) ||
          containsRoute(const AdminDisplayRoute()) ||
          containsRoute(const AdminMetadataRoute()) ||
          containsRoute(const AdminNfoRoute());
    }

    // Check if any playback sub-route is active
    bool isPlaybackActive() {
      return containsRoute(const AdminTranscodingRoute()) ||
          containsRoute(const AdminResumeRoute()) ||
          containsRoute(const AdminStreamingRoute()) ||
          containsRoute(const AdminTrickplayRoute());
    }

    return RepaintBoundary(
      child: SettingsScaffold(
        label: 'Admin',
        showBackButtonNested: true,
        items: [
          SettingsListTile(
            key: const ValueKey('admin_activity'),
            label: const Text('Activity Log'),
            subLabel: const Text('Server activity history'),
            selected: containsRoute(const AdminActivityRoute()),
            icon: IconsaxPlusLinear.activity,
            onTap: () => navigateTo(const AdminActivityRoute()),
          ),
          SettingsListTile(
            key: const ValueKey('admin_general'),
            label: const Text('General'),
            subLabel: const Text('Server configuration'),
            selected: containsRoute(const AdminGeneralRoute()),
            icon: IconsaxPlusLinear.setting_2,
            onTap: () => navigateTo(const AdminGeneralRoute()),
          ),
          SettingsListTile(
            key: const ValueKey('admin_branding'),
            label: const Text('Branding'),
            subLabel: const Text('Customize appearance'),
            selected: containsRoute(const AdminBrandingRoute()),
            icon: IconsaxPlusLinear.brush_1,
            onTap: () => navigateTo(const AdminBrandingRoute()),
          ),
          SettingsListTile(
            key: const ValueKey('admin_users'),
            label: const Text('Users'),
            subLabel: const Text('Manage user accounts'),
            selected: containsRoute(const AdminUsersRoute()),
            icon: IconsaxPlusLinear.people,
            onTap: () => navigateTo(const AdminUsersRoute()),
          ),
          SettingsListTile(
            key: const ValueKey('admin_sessions'),
            label: const Text('Sessions'),
            subLabel: const Text('Active user sessions'),
            selected: containsRoute(const AdminSessionsRoute()),
            icon: IconsaxPlusLinear.monitor,
            onTap: () => navigateTo(const AdminSessionsRoute()),
          ),
          SettingsListTile(
            key: const ValueKey('admin_devices'),
            label: const Text('Devices'),
            subLabel: const Text('Connected devices'),
            selected: containsRoute(const AdminDevicesRoute()),
            icon: IconsaxPlusLinear.mobile,
            onTap: () => navigateTo(const AdminDevicesRoute()),
          ),
          // Libraries with expandable submenu
          SettingsListTile(
            key: const ValueKey('admin_libraries'),
            label: const Text('Libraries'),
            subLabel: const Text('Media libraries & settings'),
            selected: isLibraryActive(),
            icon: _librariesExpanded ? IconsaxPlusBold.folder_2 : IconsaxPlusLinear.folder_2,
            trailing: Icon(
              _librariesExpanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
            ),
            onTap: () {
              setState(() {
                _librariesExpanded = !_librariesExpanded;
              });
              // Also navigate to main libraries page
              navigateTo(const AdminLibrariesRoute());
            },
          ),
          // Submenu items (indented)
          if (_librariesExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_libraries_list'),
                label: const Text('Libraries'),
                subLabel: const Text('Manage media libraries'),
                selected: containsRoute(const AdminLibrariesRoute()),
                icon: IconsaxPlusLinear.folder,
                onTap: () => navigateTo(const AdminLibrariesRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_display'),
                label: const Text('Display'),
                subLabel: const Text('Display & grouping settings'),
                selected: containsRoute(const AdminDisplayRoute()),
                icon: IconsaxPlusLinear.monitor_mobbile,
                onTap: () => navigateTo(const AdminDisplayRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_metadata'),
                label: const Text('Metadata'),
                subLabel: const Text('Metadata & chapter settings'),
                selected: containsRoute(const AdminMetadataRoute()),
                icon: IconsaxPlusLinear.tag_2,
                onTap: () => navigateTo(const AdminMetadataRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_nfo'),
                label: const Text('Nfo Settings'),
                subLabel: const Text('Kodi nfo configuration'),
                selected: containsRoute(const AdminNfoRoute()),
                icon: IconsaxPlusLinear.document_code_2,
                onTap: () => navigateTo(const AdminNfoRoute()),
              ),
            ),
          ],
          // Playback with expandable submenu
          SettingsListTile(
            key: const ValueKey('admin_playback'),
            label: const Text('Playback'),
            subLabel: const Text('Transcoding & streaming'),
            selected: isPlaybackActive(),
            icon: _playbackExpanded ? IconsaxPlusBold.play_circle : IconsaxPlusLinear.play_circle,
            trailing: Icon(
              _playbackExpanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
            ),
            onTap: () {
              setState(() {
                _playbackExpanded = !_playbackExpanded;
              });
              // Navigate to transcoding (first submenu)
              navigateTo(const AdminTranscodingRoute());
            },
          ),
          // Submenu items (indented)
          if (_playbackExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_transcoding'),
                label: const Text('Transcoding'),
                subLabel: const Text('Hardware acceleration & encoding'),
                selected: containsRoute(const AdminTranscodingRoute()),
                icon: IconsaxPlusLinear.video_square,
                onTap: () => navigateTo(const AdminTranscodingRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_resume'),
                label: const Text('Resume'),
                subLabel: const Text('Continue watching settings'),
                selected: containsRoute(const AdminResumeRoute()),
                icon: IconsaxPlusLinear.play,
                onTap: () => navigateTo(const AdminResumeRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_streaming'),
                label: const Text('Streaming'),
                subLabel: const Text('Bitrate & quality settings'),
                selected: containsRoute(const AdminStreamingRoute()),
                icon: IconsaxPlusLinear.global,
                onTap: () => navigateTo(const AdminStreamingRoute()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SettingsListTile(
                key: const ValueKey('admin_trickplay'),
                label: const Text('Trickplay'),
                subLabel: const Text('Thumbnail preview generation'),
                selected: containsRoute(const AdminTrickplayRoute()),
                icon: IconsaxPlusLinear.video_time,
                onTap: () => navigateTo(const AdminTrickplayRoute()),
              ),
            ),
          ],
          SettingsListTile(
            key: const ValueKey('admin_tasks'),
            label: const Text('Scheduled Tasks'),
            subLabel: const Text('System maintenance tasks'),
            selected: containsRoute(const AdminTasksRoute()),
            icon: IconsaxPlusLinear.task_square,
            onTap: () => navigateTo(const AdminTasksRoute()),
          ),
        ],
      ),
    );
  }
}
