import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:image/image.dart' as img; // for base64Encode
import 'dart:typed_data'; // for Uint8List
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart' as jelly_api; // ALIAS
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' as jelly_enums; // ALIAS
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/screens/shared/authenticate_button_options.dart';
import 'package:kebap/screens/shared/input_fields.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/screens/shared/user_icon.dart';
import 'package:kebap/util/localization_helper.dart';

@RoutePage()
class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  Future<void> _pickAndUploadImage(WidgetRef ref, String userId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;

        if (bytes != null) {
          final api = ref.read(jellyApiProvider);
          // Simple mime type detection based on extension
          String mimeType = 'image/jpeg';

          // Decode image using 'image' package to resize/compress
          final cmd = img.Command()
            ..decodeImage(bytes)
            ..copyResize(width: 512, height: 512, maintainAspect: true)
            ..encodeJpg(quality: 85);
            




          final processedBytes = await cmd.getBytesThread();
          
          if (processedBytes == null) {
            print("[LAG_DEBUG] Failed to process image");
            return;
          }

          final base64Image = base64Encode(processedBytes);
          print("[LAG_DEBUG] Uploading processed image (Base64): Length=${base64Image.length}, Mime=image/jpeg");
          
          // Upload Resized Base64 String
          final response = await api.usersUserIdImagesImageTypePost(
            userId: userId,
            imageType: jelly_enums.ItemsItemIdImagesImageTypePostImageType.primary, 
            body: base64Image,
            mimeType: 'image/jpeg',
          );

          if (response.isSuccessful) {
            print('[LAG_DEBUG] Image upload successful. Triggering updateInformation...');
            await ref.read(userProvider.notifier).updateInformation();
            print('[LAG_DEBUG] updateInformation completed.');
          } else {
             print('[LAG_DEBUG] Image upload failed: ${response.statusCode} - ${response.error}');
          }
        }
      } else {
        print('[LAG_DEBUG] File picker cancelled or empty.');
      }
    } catch (e) {
      print('[LAG_DEBUG] Exception in _pickAndUploadImage: $e');
      debugPrint('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Oops! Failed to pick image. This might be due to a missing system dependency (xdg-desktop-portal) on your Linux setup.\nError: $e",
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return SettingsScaffold(
      label: context.localized.settingsProfileTitle,
      items: [
        if (user != null) ...[
          Center(
            child: Stack(
              children: [
                UserIcon(
                  user: user,
                  size: const Size(120, 120),
                  cornerRadius: 120,
                  onTap: () => _pickAndUploadImage(ref, user.id),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconsaxPlusLinear.edit,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        ...settingsListGroup(
          context,
          SettingsLabelDivider(label: context.localized.settingSecurityApplockTitle),
          [
            SettingsListTile(
              label: Text(context.localized.settingSecurityApplockTitle),
              subLabel: Text(user?.authMethod.name(context) ?? ""),
              onTap: () => showAuthOptionsDialogue(
                context,
                user!,
                (newUser) {
                  ref.read(userProvider.notifier).updateUser(newUser);
                },
              ),
            ),
            SettingsListTile(
              label: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  if (user?.credentials.localUrl?.isNotEmpty == true)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ref.watch(localConnectionAvailableProvider)
                            ? Colors.greenAccent
                            : Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(context.localized.settingsLocalUrlTitle),
                ],
              ),
              subLabel: Text(user?.credentials.localUrl ?? "-"),
              onTap: () {
                openSimpleTextInput(
                  context,
                  user?.credentials.localUrl,
                  (value) => ref.read(userProvider.notifier).setLocalURL(value),
                  context.localized.settingsLocalUrlSetTitle,
                  context.localized.settingsLocalUrlSetDesc,
                );
              },
            ),
          ],
        ),
        // Admin-only settings section
        if (user?.policy?.isAdministrator == true) ...[
          const SizedBox(height: 16),
          ...settingsListGroup(
            context,
            const SettingsLabelDivider(label: 'Admin Settings'),
            [
              Consumer(builder: (context, ref, _) {
                final baklavaConfigAsync = ref.watch(effectiveBaklavaConfigProvider);
                return baklavaConfigAsync.when(
                  data: (cfg) => SettingsListTile(
                    label: const Text('Enable Auto Import'),
                    subLabel: const Text('Non-admin users can import directly without making requests'),
                    onTap: () async {
                      try {
                        await ref.read(baklavaServiceProvider).updateConfig(
                          enableAutoImport: !cfg.enableAutoImport,
                        );
                        // Refresh the config
                        ref.invalidate(baklavaConfigProvider);
                        ref.invalidate(effectiveBaklavaConfigProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update: $e')),
                          );
                        }
                      }
                    },
                    trailing: Switch(
                      value: cfg.enableAutoImport,
                      onChanged: (v) async {
                        try {
                          await ref.read(baklavaServiceProvider).updateConfig(
                            enableAutoImport: v,
                          );
                          // Refresh the config
                          ref.invalidate(baklavaConfigProvider);
                          ref.invalidate(effectiveBaklavaConfigProvider);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  loading: () => const SettingsListTile(
                    label: Text('Enable Auto Import'),
                    subLabel: Text('Loading...'),
                  ),
                  error: (_, __) => const SettingsListTile(
                    label: Text('Enable Auto Import'),
                    subLabel: Text('Requires Baklava plugin'),
                  ),
                );
              }),
            ],
          ),
        ],
      ],
    );
  }
}
