import 'dart:async';

import 'package:kebap/models/profanity_filter_models.dart';
import 'package:kebap/wrappers/players/base_player.dart';
import 'package:kebap/wrappers/players/player_states.dart';

/// Controller for managing audio muting during profanity detection
/// 
/// This controller monitors the player position and mutes/unmutes audio
/// based on the profanity metadata mute ranges.
class ProfanityMuteController {
  ProfanityMuteController({
    required this.player,
    required this.metadata,
    this.fadeMs = 50,
    this.onMuteStateChanged,
  });

  final BasePlayer player;
  final ProfanityMetadata metadata;
  final int fadeMs;
  final void Function(bool isMuted)? onMuteStateChanged;

  StreamSubscription<PlayerState>? _subscription;
  bool _isMuted = false;
  double _originalVolume = 100;
  bool _isDisposed = false;

  /// Start monitoring player position for mute ranges
  void start() {
    if (_isDisposed) return;
    
    _subscription = player.stateStream.listen(_onPlayerStateChanged);
  }

  /// Stop monitoring and restore volume
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    
    if (_isMuted) {
      await player.setVolume(_originalVolume);
      _isMuted = false;
      onMuteStateChanged?.call(false);
    }
  }

  /// Dispose of the controller
  Future<void> dispose() async {
    _isDisposed = true;
    await stop();
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (_isDisposed) return;
    
    final positionMs = state.position.inMilliseconds;
    final shouldMute = _isInMuteRange(positionMs);

    if (shouldMute && !_isMuted) {
      _muteAudio(state.volume);
    } else if (!shouldMute && _isMuted) {
      _unmuteAudio();
    }
  }

  bool _isInMuteRange(int positionMs) {
    for (final range in metadata.muteRanges) {
      if (positionMs >= range.startMs && positionMs <= range.endMs) {
        return true;
      }
    }
    return false;
  }

  Future<void> _muteAudio(double currentVolume) async {
    if (_isDisposed) return;
    
    _originalVolume = currentVolume;
    _isMuted = true;
    onMuteStateChanged?.call(true);
    
    // Quick fade to mute
    await _fadeVolume(_originalVolume, 0, fadeMs);
  }

  Future<void> _unmuteAudio() async {
    if (_isDisposed) return;
    
    _isMuted = false;
    onMuteStateChanged?.call(false);
    
    // Quick fade to restore
    await _fadeVolume(0, _originalVolume, fadeMs);
  }

  /// Smooth volume fade to prevent audio pops
  Future<void> _fadeVolume(double from, double to, int durationMs) async {
    if (_isDisposed) return;
    
    const steps = 5;
    final stepDuration = Duration(milliseconds: durationMs ~/ steps);
    final volumeStep = (to - from) / steps;

    for (int i = 1; i <= steps; i++) {
      if (_isDisposed) return;
      
      final newVolume = from + (volumeStep * i);
      await player.setVolume(newVolume);
      await Future.delayed(stepDuration);
    }
  }

  /// Get the next upcoming mute range (for UI display)
  MuteRange? getNextMuteRange(Duration currentPosition) {
    final positionMs = currentPosition.inMilliseconds;
    
    for (final range in metadata.muteRanges) {
      if (range.startMs > positionMs) {
        return range;
      }
    }
    return null;
  }

  /// Check if currently muted
  bool get isMuted => _isMuted;

  /// Get total number of mute ranges
  int get totalMuteRanges => metadata.muteRanges.length;
}
