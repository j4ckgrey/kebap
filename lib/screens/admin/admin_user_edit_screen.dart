import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/providers/admin_provider.dart';
import 'package:kebap/providers/admin_dashboard_provider.dart';

@RoutePage()
class AdminUserEditScreen extends ConsumerStatefulWidget {
  final UserDto user;
  
  const AdminUserEditScreen({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<AdminUserEditScreen> createState() => _AdminUserEditScreenState();
}

class _AdminUserEditScreenState extends ConsumerState<AdminUserEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _remoteBitrateController;
  late TextEditingController _loginAttemptsController;
  late TextEditingController _maxSessionsController;
  
  // Basic settings
  late bool _isAdmin;
  late bool _isDisabled;
  late bool _isHidden;
  
  // Media playback permissions
  late bool _enableMediaPlayback;
  late bool _enableAudioTranscoding;
  late bool _enableVideoTranscoding;
  late bool _enablePlaybackRemuxing;
  late bool _forceRemoteTranscoding;
  
  // Access permissions
  late bool _enableRemoteAccess;
  late bool _enableContentDownloading;
  late bool _enableSyncTranscoding;
  late bool _enableMediaConversion;
  late bool _enableAllDevices;
  
  // Control permissions
  late bool _enableRemoteControl;
  late bool _enableSharedDeviceControl;
  
  // Live TV permissions
  late bool _enableLiveTvAccess;
  late bool _enableLiveTvManagement;
  
  // Management permissions
  late bool _enableCollectionManagement;
  late bool _enableSubtitleManagement;
  late bool _enableContentDeletion;
  
  // Parental control
  late int _maxParentalRating;
  late List<String> _blockedTags;
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final policy = widget.user.policy;
    
    _nameController = TextEditingController(text: widget.user.name);
    _remoteBitrateController = TextEditingController(
      text: ((policy?.remoteClientBitrateLimit ?? 0) ~/ 1000000).toString(),
    );
    _loginAttemptsController = TextEditingController(
      text: (policy?.loginAttemptsBeforeLockout ?? -1).toString(),
    );
    _maxSessionsController = TextEditingController(
      text: (policy?.maxActiveSessions ?? 0).toString(),
    );
    
    // Basic
    _isAdmin = policy?.isAdministrator ?? false;
    _isDisabled = policy?.isDisabled ?? false;
    _isHidden = policy?.isHidden ?? false;
    
    // Media playback
    _enableMediaPlayback = policy?.enableMediaPlayback ?? true;
    _enableAudioTranscoding = policy?.enableAudioPlaybackTranscoding ?? true;
    _enableVideoTranscoding = policy?.enableVideoPlaybackTranscoding ?? true;
    _enablePlaybackRemuxing = policy?.enablePlaybackRemuxing ?? true;
    _forceRemoteTranscoding = policy?.forceRemoteSourceTranscoding ?? false;
    
    // Access
    _enableRemoteAccess = policy?.enableRemoteAccess ?? true;
    _enableContentDownloading = policy?.enableContentDownloading ?? true;
    _enableSyncTranscoding = policy?.enableSyncTranscoding ?? true;
    _enableMediaConversion = policy?.enableMediaConversion ?? true;
    _enableAllDevices = policy?.enableAllDevices ?? true;
    
    // Control
    _enableRemoteControl = policy?.enableRemoteControlOfOtherUsers ?? false;
    _enableSharedDeviceControl = policy?.enableSharedDeviceControl ?? true;
    
    // Live TV
    _enableLiveTvAccess = policy?.enableLiveTvAccess ?? true;
    _enableLiveTvManagement = policy?.enableLiveTvManagement ?? false;
    
    // Management
    _enableCollectionManagement = policy?.enableCollectionManagement ?? false;
    _enableSubtitleManagement = policy?.enableSubtitleManagement ?? true;
    _enableContentDeletion = policy?.enableContentDeletion ?? false;
    
    // Parental control
    _maxParentalRating = policy?.maxParentalRating ?? 0;
    _blockedTags = List<String>.from(policy?.blockedTags ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _remoteBitrateController.dispose();
    _loginAttemptsController.dispose();
    _maxSessionsController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    
    try {
      // Update user name if changed
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
      );
      
      await ref.read(adminServiceProvider.notifier).updateUser(
        userId: widget.user.id!,
        user: updatedUser,
      );

      // Parse numeric values
      final remoteBitrate = (int.tryParse(_remoteBitrateController.text) ?? 0) * 1000000;
      final loginAttempts = int.tryParse(_loginAttemptsController.text) ?? -1;
      final maxSessions = int.tryParse(_maxSessionsController.text) ?? 0;

      // Update user policy (permissions)
      final currentPolicy = widget.user.policy;
      final updatedPolicy = currentPolicy != null
        ? currentPolicy.copyWith(
            // Basic
            isAdministrator: _isAdmin,
            isDisabled: _isDisabled,
            isHidden: _isHidden,
            
            // Media playback
            enableMediaPlayback: _enableMediaPlayback,
            enableAudioPlaybackTranscoding: _enableAudioTranscoding,
            enableVideoPlaybackTranscoding: _enableVideoTranscoding,
            enablePlaybackRemuxing: _enablePlaybackRemuxing,
            forceRemoteSourceTranscoding: _forceRemoteTranscoding,
            
            // Access
            enableRemoteAccess: _enableRemoteAccess,
            enableContentDownloading: _enableContentDownloading,
            enableSyncTranscoding: _enableSyncTranscoding,
            enableMediaConversion: _enableMediaConversion,
            enableAllDevices: _enableAllDevices,
            
            // Control
            enableRemoteControlOfOtherUsers: _enableRemoteControl,
            enableSharedDeviceControl: _enableSharedDeviceControl,
            
            // Live TV
            enableLiveTvAccess: _enableLiveTvAccess,
            enableLiveTvManagement: _enableLiveTvManagement,
            
            // Management
            enableCollectionManagement: _enableCollectionManagement,
            enableSubtitleManagement: _enableSubtitleManagement,
            enableContentDeletion: _enableContentDeletion,
            
            // Access controls
            remoteClientBitrateLimit: remoteBitrate,
            loginAttemptsBeforeLockout: loginAttempts,
            maxActiveSessions: maxSessions,
            
            // Parental control
            maxParentalRating: _maxParentalRating,
            blockedTags: _blockedTags,
          )
        : UserPolicy(
            authenticationProviderId: '',
            passwordResetProviderId: '',
            isAdministrator: _isAdmin,
            isDisabled: _isDisabled,
            isHidden: _isHidden,
            enableMediaPlayback: _enableMediaPlayback,
            enableAudioPlaybackTranscoding: _enableAudioTranscoding,
            enableVideoPlaybackTranscoding: _enableVideoTranscoding,
            enablePlaybackRemuxing: _enablePlaybackRemuxing,
            forceRemoteSourceTranscoding: _forceRemoteTranscoding,
            enableRemoteAccess: _enableRemoteAccess,
            enableContentDownloading: _enableContentDownloading,
            enableSyncTranscoding: _enableSyncTranscoding,
            enableMediaConversion: _enableMediaConversion,
            enableAllDevices: _enableAllDevices,
            enableRemoteControlOfOtherUsers: _enableRemoteControl,
            enableSharedDeviceControl: _enableSharedDeviceControl,
            enableLiveTvAccess: _enableLiveTvAccess,
            enableLiveTvManagement: _enableLiveTvManagement,
            enableCollectionManagement: _enableCollectionManagement,
            enableSubtitleManagement: _enableSubtitleManagement,
            enableContentDeletion: _enableContentDeletion,
            remoteClientBitrateLimit: remoteBitrate,
            loginAttemptsBeforeLockout: loginAttempts,
            maxActiveSessions: maxSessions,
            maxParentalRating: _maxParentalRating,
            blockedTags: _blockedTags,
          );
      
      await ref.read(adminServiceProvider.notifier).updateUserPolicy(
        userId: widget.user.id!,
        policy: updatedPolicy,
      );

      // Refresh users list
      await ref.read(usersListProvider.notifier).refresh();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated user: ${_nameController.text}')),
        );
        context.router.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    final passwordController = TextEditingController();
    final newPassword = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter new password for ${widget.user.name}:'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, passwordController.text),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (newPassword != null && newPassword.isNotEmpty && mounted) {
      try {
        await ref.read(adminServiceProvider.notifier).updateUserPassword(
          userId: widget.user.id!,
          newPassword: newPassword,
          resetPassword: true,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error resetting password: $e')),
          );
        }
      }
    }
    
    passwordController.dispose();
  }

  Future<void> _deleteUser() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${widget.user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(adminServiceProvider.notifier).deleteUser(widget.user.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted user: ${widget.user.name}')),
          );
          context.router.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting user: $e')),
          );
        }
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User: ${widget.user.name}'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
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
              tooltip: 'Save Changes',
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: _isAdmin ? Colors.blue : Colors.green,
              child: Icon(
                _isAdmin ? IconsaxPlusBold.shield_security : IconsaxPlusBold.user,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Basic Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.user),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('User ID'),
                    subtitle: SelectableText(widget.user.id ?? 'Unknown'),
                    leading: const Icon(IconsaxPlusLinear.card),
                    trailing: IconButton(
                      icon: const Icon(IconsaxPlusLinear.copy),
                      tooltip: 'Copy User ID',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.user.id ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User ID copied to clipboard')),
                        );
                      },
                    ),
                  ),
                  if (widget.user.lastActivityDate != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Last Activity'),
                      subtitle: Text(widget.user.lastActivityDate.toString()),
                      leading: const Icon(IconsaxPlusLinear.clock),
                    ),
                ],
              ),
            ),
          ),

          // Basic Permissions
          _buildSectionHeader('Basic Permissions'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Administrator'),
                  subtitle: const Text('Grant full admin privileges'),
                  secondary: const Icon(IconsaxPlusBold.shield_security),
                  value: _isAdmin,
                  onChanged: (value) => setState(() => _isAdmin = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Disabled'),
                  subtitle: const Text('Prevent user from logging in'),
                  secondary: const Icon(IconsaxPlusBold.lock),
                  value: _isDisabled,
                  onChanged: (value) => setState(() => _isDisabled = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Hidden from login screen'),
                  subtitle: const Text('Hide user on the login page'),
                  secondary: const Icon(IconsaxPlusBold.eye_slash),
                  value: _isHidden,
                  onChanged: (value) => setState(() => _isHidden = value),
                ),
              ],
            ),
          ),

          // Media Playback Permissions
          _buildSectionHeader('Media Playback'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Media Playback'),
                  subtitle: const Text('Allow user to play media'),
                  secondary: const Icon(IconsaxPlusLinear.play_circle),
                  value: _enableMediaPlayback,
                  onChanged: (value) => setState(() => _enableMediaPlayback = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Audio Transcoding'),
                  subtitle: const Text('Allow transcoding audio to compatible formats'),
                  secondary: const Icon(IconsaxPlusLinear.music),
                  value: _enableAudioTranscoding,
                  onChanged: (value) => setState(() => _enableAudioTranscoding = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Video Transcoding'),
                  subtitle: const Text('Allow transcoding video to compatible formats'),
                  secondary: const Icon(IconsaxPlusLinear.video),
                  value: _enableVideoTranscoding,
                  onChanged: (value) => setState(() => _enableVideoTranscoding = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Playback Remuxing'),
                  subtitle: const Text('Allow remuxing streams without transcoding'),
                  secondary: const Icon(IconsaxPlusLinear.convert),
                  value: _enablePlaybackRemuxing,
                  onChanged: (value) => setState(() => _enablePlaybackRemuxing = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Force Remote Source Transcoding'),
                  subtitle: const Text('Force transcoding for remote sources'),
                  secondary: const Icon(IconsaxPlusLinear.global),
                  value: _forceRemoteTranscoding,
                  onChanged: (value) => setState(() => _forceRemoteTranscoding = value),
                ),
              ],
            ),
          ),

          // Access & Download Permissions
          _buildSectionHeader('Access & Downloads'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Remote Access'),
                  subtitle: const Text('Allow access from outside the network'),
                  secondary: const Icon(IconsaxPlusLinear.global_search),
                  value: _enableRemoteAccess,
                  onChanged: (value) => setState(() => _enableRemoteAccess = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Downloads'),
                  subtitle: const Text('Allow downloading content for offline use'),
                  secondary: const Icon(IconsaxPlusLinear.document_download),
                  value: _enableContentDownloading,
                  onChanged: (value) => setState(() => _enableContentDownloading = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Sync Transcoding'),
                  subtitle: const Text('Allow transcoding during sync'),
                  secondary: const Icon(IconsaxPlusLinear.refresh),
                  value: _enableSyncTranscoding,
                  onChanged: (value) => setState(() => _enableSyncTranscoding = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Media Conversion'),
                  subtitle: const Text('Allow converting media formats'),
                  secondary: const Icon(IconsaxPlusLinear.convert_3d_cube),
                  value: _enableMediaConversion,
                  onChanged: (value) => setState(() => _enableMediaConversion = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable All Devices'),
                  subtitle: const Text('Allow access from all devices'),
                  secondary: const Icon(IconsaxPlusLinear.devices),
                  value: _enableAllDevices,
                  onChanged: (value) => setState(() => _enableAllDevices = value),
                ),
              ],
            ),
          ),

          // Remote Control Permissions
          _buildSectionHeader('Remote Control'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Remote Control of Other Users'),
                  subtitle: const Text('Allow controlling other users\' sessions'),
                  secondary: const Icon(IconsaxPlusLinear.mobile),
                  value: _enableRemoteControl,
                  onChanged: (value) => setState(() => _enableRemoteControl = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Shared Device Control'),
                  subtitle: const Text('Allow controlling shared devices'),
                  secondary: const Icon(IconsaxPlusLinear.monitor_mobbile),
                  value: _enableSharedDeviceControl,
                  onChanged: (value) => setState(() => _enableSharedDeviceControl = value),
                ),
              ],
            ),
          ),

          // Live TV Permissions
          _buildSectionHeader('Live TV'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Live TV Access'),
                  subtitle: const Text('Allow watching live TV'),
                  secondary: const Icon(IconsaxPlusLinear.video_square),
                  value: _enableLiveTvAccess,
                  onChanged: (value) => setState(() => _enableLiveTvAccess = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Live TV Management'),
                  subtitle: const Text('Allow managing Live TV settings and recordings'),
                  secondary: const Icon(IconsaxPlusLinear.setting_2),
                  value: _enableLiveTvManagement,
                  onChanged: (value) => setState(() => _enableLiveTvManagement = value),
                ),
              ],
            ),
          ),

          // Management Permissions
          _buildSectionHeader('Content Management'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Collection Management'),
                  subtitle: const Text('Allow creating and managing collections'),
                  secondary: const Icon(IconsaxPlusLinear.folder_2),
                  value: _enableCollectionManagement,
                  onChanged: (value) => setState(() => _enableCollectionManagement = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Subtitle Management'),
                  subtitle: const Text('Allow downloading and managing subtitles'),
                  secondary: const Icon(IconsaxPlusLinear.subtitle),
                  value: _enableSubtitleManagement,
                  onChanged: (value) => setState(() => _enableSubtitleManagement = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Content Deletion'),
                  subtitle: const Text('Allow deleting media files'),
                  secondary: const Icon(IconsaxPlusLinear.trash),
                  value: _enableContentDeletion,
                  onChanged: (value) => setState(() => _enableContentDeletion = value),
                ),
              ],
            ),
          ),

          // Access Control Settings
          _buildSectionHeader('Access Control'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _remoteBitrateController,
                    decoration: const InputDecoration(
                      labelText: 'Remote Client Bitrate Limit (Mbps)',
                      helperText: 'Maximum bitrate for remote streaming (0 = unlimited)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.speedometer),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _loginAttemptsController,
                    decoration: const InputDecoration(
                      labelText: 'Login Attempts Before Lockout',
                      helperText: 'Number of failed login attempts before account is locked (-1 = disabled)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.security),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _maxSessionsController,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Active Sessions',
                      helperText: 'Maximum number of simultaneous sessions (0 = unlimited)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.profile_2user),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
          ),

          // Parental Control
          _buildSectionHeader('Parental Control'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Max Parental Rating',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _maxParentalRating,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.shield_tick),
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('No Restriction')),
                      DropdownMenuItem(value: 1, child: Text('G - General Audiences')),
                      DropdownMenuItem(value: 2, child: Text('PG - Parental Guidance')),
                      DropdownMenuItem(value: 3, child: Text('PG-13')),
                      DropdownMenuItem(value: 4, child: Text('R - Restricted')),
                      DropdownMenuItem(value: 5, child: Text('NC-17')),
                      DropdownMenuItem(value: 6, child: Text('Adults Only')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _maxParentalRating = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Blocked Tags',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._blockedTags.map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _blockedTags.remove(tag);
                          });
                        },
                      )),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: const Text('Add Tag'),
                        onPressed: () async {
                          final controller = TextEditingController();
                          final tag = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Add Blocked Tag'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Tag Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, controller.text),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          );
                          
                          if (tag != null && tag.isNotEmpty && !_blockedTags.contains(tag)) {
                            setState(() {
                              _blockedTags.add(tag);
                            });
                          }
                          controller.dispose();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Actions
          _buildSectionHeader('Actions'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(IconsaxPlusBold.key, color: Colors.orange),
                  title: const Text('Reset Password'),
                  subtitle: const Text('Set a new password for this user'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _resetPassword,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusBold.trash, color: Colors.red),
                  title: const Text('Delete User'),
                  subtitle: const Text('Permanently delete this user'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _deleteUser,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
