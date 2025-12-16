import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

@RoutePage()
class AdminTranscodingScreen extends ConsumerStatefulWidget {
  const AdminTranscodingScreen({super.key});

  @override
  ConsumerState<AdminTranscodingScreen> createState() => _AdminTranscodingScreenState();
}

class _AdminTranscodingScreenState extends ConsumerState<AdminTranscodingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Hardware Acceleration Type
  String _hardwareAccelerationType = 'none';
  final List<String> _hardwareDecodingCodecs = [];
  bool _enableHardwareEncoding = false;
  bool _enableEnhancedNvdecDecoder = false;
  bool _preferSystemNativeHwDecoder = false;
  bool _enableIntelLowPowerH264 = false;
  bool _enableIntelLowPowerHevc = false;
  
  // Hardware decoding - 10bit/12bit support
  bool _enableDecodingColorDepth10Hevc = false;
  bool _enableDecodingColorDepth10Vp9 = false;
  bool _enableDecodingColorDepth10HevcRext = false;
  bool _enableDecodingColorDepth12HevcRext = false;
  
  // Encoding format options
  bool _allowHevcEncoding = false;
  bool _allowAv1Encoding = false;
  
  // Tonemapping - Basic
  bool _enableTonemapping = false;
  String _tonemappingAlgorithm = 'hable';
  bool _enableVppTonemapping = false;
  bool _enableVideoToolboxTonemapping = false;
  String _tonemappingMode = 'auto';
  String _tonemappingRange = 'auto';
  
  // Processing options
  String _deinterlaceMethod = 'yadif';
  bool _deinterlaceDoubleRate = false;
  bool _enableSubtitleExtraction = false;
  bool _enableThrottling = false;
  bool _enableSegmentDeletion = false;
  String _encoderPreset = 'auto';
  String _downMixAudioBoost = 'None';
  
  // Text field controllers
  late TextEditingController _vaapiDeviceController;
  late TextEditingController _qsvDeviceController;
  late TextEditingController _transcodingTempPathController;
  late TextEditingController _fallbackFontPathController;
  late TextEditingController _encoderAppPathController;
  late TextEditingController _encodingThreadsController;
  late TextEditingController _segmentKeepSecondsController;
  late TextEditingController _throttleDelaySecondsController;
  late TextEditingController _maxMuxingQueueSizeController;
  late TextEditingController _tonemappingDesatController;
  late TextEditingController _tonemappingPeakController;
  late TextEditingController _tonemappingParamController;
  late TextEditingController _vppTonemappingBrightnessController;
  late TextEditingController _vppTonemappingContrastController;
  late TextEditingController _h264CrfController;
  late TextEditingController _h265CrfController;
  
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _vaapiDeviceController = TextEditingController();
    _qsvDeviceController = TextEditingController();
    _transcodingTempPathController = TextEditingController();
    _fallbackFontPathController = TextEditingController();
    _encoderAppPathController = TextEditingController(text: '/usr/bin/ffmpeg');
    _encodingThreadsController = TextEditingController(text: '0');
    _segmentKeepSecondsController = TextEditingController(text: '200');
    _throttleDelaySecondsController = TextEditingController(text: '120');
    _maxMuxingQueueSizeController = TextEditingController(text: '2048');
    _tonemappingDesatController = TextEditingController(text: '0');
    _tonemappingPeakController = TextEditingController(text: '0');
    _tonemappingParamController = TextEditingController(text: '0');
    _vppTonemappingBrightnessController = TextEditingController(text: '0');
    _vppTonemappingContrastController = TextEditingController(text: '1.2');
    _h264CrfController = TextEditingController(text: '23');
    _h265CrfController = TextEditingController(text: '28');
    // TODO: Load actual encoding configuration from API
  }

  @override
  void dispose() {
    // Dispose all text controllers
    _vaapiDeviceController.dispose();
    _qsvDeviceController.dispose();
    _transcodingTempPathController.dispose();
    _fallbackFontPathController.dispose();
    _encoderAppPathController.dispose();
    _encodingThreadsController.dispose();
    _segmentKeepSecondsController.dispose();
    _throttleDelaySecondsController.dispose();
    _maxMuxingQueueSizeController.dispose();
    _tonemappingDesatController.dispose();
    _tonemappingPeakController.dispose();
    _tonemappingParamController.dispose();
    _vppTonemappingBrightnessController.dispose();
    _vppTonemappingContrastController.dispose();
    _h264CrfController.dispose();
    _h265CrfController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Save encoding configuration to API
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transcoding settings saved')),
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
        title: const Text('Transcoding'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hardware Acceleration Type
            DropdownButtonFormField<String>(
              value: _hardwareAccelerationType,
              decoration: const InputDecoration(
                labelText: 'Hardware acceleration',
                helperText: 'Select hardware acceleration type for transcoding',
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconsaxPlusLinear.cpu),
              ),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'amf', child: Text('AMD AMF')),
                DropdownMenuItem(value: 'nvenc', child: Text('Nvidia NVENC')),
                DropdownMenuItem(value: 'qsv', child: Text('Intel QuickSync (QSV)')),
                DropdownMenuItem(value: 'vaapi', child: Text('Video Acceleration API (VAAPI)')),
                DropdownMenuItem(value: 'videotoolbox', child: Text('VideoToolbox')),
                DropdownMenuItem(value: 'rkmpp', child: Text('Rockchip MPP')),
                DropdownMenuItem(value: 'v4l2m2m', child: Text('V4L2 M2M')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _hardwareAccelerationType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Device path fields for VAAPI and QSV
            if (_hardwareAccelerationType == 'vaapi')
              TextFormField(
                controller: _vaapiDeviceController,
                decoration: const InputDecoration(
                  labelText: 'VAAPI device',
                  helperText: 'e.g., /dev/dri/renderD128',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconsaxPlusLinear.driver),
                ),
              ),
            if (_hardwareAccelerationType == 'qsv')
              TextFormField(
                controller: _qsvDeviceController,
                decoration: const InputDecoration(
                  labelText: 'QSV device',
                  helperText: 'e.g., /dev/dri/renderD128',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconsaxPlusLinear.driver),
                ),
              ),
            if (_hardwareAccelerationType == 'vaapi' || _hardwareAccelerationType == 'qsv')
              const SizedBox(height: 16),
            const SizedBox(height: 24),

            // Hardware Decoding
            if (_hardwareAccelerationType != 'none') ...[
              Text(
                'Hardware Decoding',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text('Enable hardware decoding for:'),
              const SizedBox(height: 8),
              
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('h264'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('h264');
                    } else {
                      _hardwareDecodingCodecs.remove('h264');
                    }
                  });
                },
                title: const Text('H264'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('hevc'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('hevc');
                    } else {
                      _hardwareDecodingCodecs.remove('hevc');
                    }
                  });
                },
                title: const Text('HEVC'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('mpeg2video'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('mpeg2video');
                    } else {
                      _hardwareDecodingCodecs.remove('mpeg2video');
                    }
                  });
                },
                title: const Text('MPEG2'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('vc1'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('vc1');
                    } else {
                      _hardwareDecodingCodecs.remove('vc1');
                    }
                  });
                },
                title: const Text('VC1'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('vp8'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('vp8');
                    } else {
                      _hardwareDecodingCodecs.remove('vp8');
                    }
                  });
                },
                title: const Text('VP8'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('vp9'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('vp9');
                    } else {
                      _hardwareDecodingCodecs.remove('vp9');
                    }
                  });
                },
                title: const Text('VP9'),
              ),
              CheckboxListTile(
                value: _hardwareDecodingCodecs.contains('av1'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _hardwareDecodingCodecs.add('av1');
                    } else {
                      _hardwareDecodingCodecs.remove('av1');
                    }
                  });
                },
                title: const Text('AV1'),
              ),
              const SizedBox(height: 16),
              
              // 10bit/12bit support
              if (['qsv', 'vaapi', 'nvenc', 'amf', 'videotoolbox', 'rkmpp'].contains(_hardwareAccelerationType)) ...[
                const Divider(),
                const SizedBox(height: 8),
                const Text('High bit-depth support:'),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: _enableDecodingColorDepth10Hevc,
                  onChanged: (value) => setState(() => _enableDecodingColorDepth10Hevc = value),
                  title: const Text('HEVC 10bit'),
                  dense: true,
                ),
                SwitchListTile(
                  value: _enableDecodingColorDepth10Vp9,
                  onChanged: (value) => setState(() => _enableDecodingColorDepth10Vp9 = value),
                  title: const Text('VP9 10bit'),
                  dense: true,
                ),
                if (['qsv', 'vaapi'].contains(_hardwareAccelerationType)) ...[
                  SwitchListTile(
                    value: _enableDecodingColorDepth10HevcRext,
                    onChanged: (value) => setState(() => _enableDecodingColorDepth10HevcRext = value),
                    title: const Text('HEVC RExt 8/10bit'),
                    dense: true,
                  ),
                  SwitchListTile(
                    value: _enableDecodingColorDepth12HevcRext,
                    onChanged: (value) => setState(() => _enableDecodingColorDepth12HevcRext = value),
                    title: const Text('HEVC RExt 12bit'),
                    dense: true,
                  ),
                ],
              ],
              const SizedBox(height: 24),

              // Hardware Encoding Options
              Text(
                'Hardware Encoding',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              
              SwitchListTile(
                value: _enableHardwareEncoding,
                onChanged: (value) => setState(() => _enableHardwareEncoding = value),
                title: const Text('Enable hardware encoding'),
                subtitle: const Text('Use hardware encoder when available'),
              ),
              
              // Intel specific options
              if (_hardwareAccelerationType == 'qsv' || _hardwareAccelerationType == 'vaapi') ...[
                SwitchListTile(
                  value: _enableIntelLowPowerH264,
                  onChanged: (value) => setState(() => _enableIntelLowPowerH264 = value),
                  title: const Text('Enable Intel low-power H.264 hardware encoder'),
                ),
                SwitchListTile(
                  value: _enableIntelLowPowerHevc,
                  onChanged: (value) => setState(() => _enableIntelLowPowerHevc = value),
                  title: const Text('Enable Intel low-power HEVC hardware encoder'),
                ),
              ],
              
              // Nvidia specific options
              if (_hardwareAccelerationType == 'nvenc')
                SwitchListTile(
                  value: _enableEnhancedNvdecDecoder,
                  onChanged: (value) => setState(() => _enableEnhancedNvdecDecoder = value),
                  title: const Text('Enable enhanced NVDEC decoder'),
                  subtitle: const Text('Use Nvidia enhanced decoder for better performance'),
                ),
              
              // QSV specific options
              if (_hardwareAccelerationType == 'qsv')
                SwitchListTile(
                  value: _preferSystemNativeHwDecoder,
                  onChanged: (value) => setState(() => _preferSystemNativeHwDecoder = value),
                  title: const Text('Prefer system native HW decoder'),
                  subtitle: const Text('Use system decoder instead of FFmpeg QSV'),
                ),
              
              const SizedBox(height: 24),
            ],

            // Encoding Format Options
            Text(
              'Encoding Format Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            
            SwitchListTile(
              value: _allowHevcEncoding,
              onChanged: (value) => setState(() => _allowHevcEncoding = value),
              title: const Text('Allow HEVC encoding'),
              subtitle: const Text('Allow encoding to H.265/HEVC format'),
            ),
            SwitchListTile(
              value: _allowAv1Encoding,
              onChanged: (value) => setState(() => _allowAv1Encoding = value),
              title: const Text('Allow AV1 encoding'),
              subtitle: const Text('Allow encoding to AV1 format'),
            ),
            const SizedBox(height: 24),

            // Tonemapping
            if (_hardwareAccelerationType != 'none' || true) ...[
              Text(
                'Tonemapping',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              
              // VPP Tonemapping (QSV/VAAPI specific)
              if (_hardwareAccelerationType == 'qsv' || _hardwareAccelerationType == 'vaapi') ...[
                SwitchListTile(
                  value: _enableVppTonemapping,
                  onChanged: (value) => setState(() => _enableVppTonemapping = value),
                  title: const Text('Enable VPP tonemapping'),
                  subtitle: const Text('Use Intel VPP for HDR to SDR conversion'),
                ),
                if (_enableVppTonemapping) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vppTonemappingBrightnessController,
                    decoration: const InputDecoration(
                      labelText: 'VPP tonemapping brightness',
                      helperText: 'Range: 0-100',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final num = double.tryParse(value!);
                      if (num == null || num < 0 || num > 100) return 'Must be between 0 and 100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vppTonemappingContrastController,
                    decoration: const InputDecoration(
                      labelText: 'VPP tonemapping contrast',
                      helperText: 'Range: 1-2',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final num = double.tryParse(value!);
                      if (num == null || num < 1 || num > 2) return 'Must be between 1 and 2';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ],
              
              // VideoToolbox Tonemapping
              if (_hardwareAccelerationType == 'videotoolbox')
                SwitchListTile(
                  value: _enableVideoToolboxTonemapping,
                  onChanged: (value) => setState(() => _enableVideoToolboxTonemapping = value),
                  title: const Text('Enable VideoToolbox tonemapping'),
                  subtitle: const Text('Use Apple VideoToolbox for HDR to SDR conversion'),
                ),
              
              // General tonemapping toggle
              if (_hardwareAccelerationType != 'none' && _hardwareAccelerationType != 'videotoolbox')
                SwitchListTile(
                  value: _enableTonemapping,
                  onChanged: (value) => setState(() => _enableTonemapping = value),
                  title: const Text('Enable tonemapping'),
                  subtitle: const Text('Convert HDR content to SDR'),
                ),
              
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tonemappingAlgorithm,
                decoration: const InputDecoration(
                  labelText: 'Tonemapping algorithm',
                  helperText: 'Algorithm used for HDR to SDR conversion',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('None')),
                  DropdownMenuItem(value: 'clip', child: Text('Clip')),
                  DropdownMenuItem(value: 'linear', child: Text('Linear')),
                  DropdownMenuItem(value: 'gamma', child: Text('Gamma')),
                  DropdownMenuItem(value: 'reinhard', child: Text('Reinhard')),
                  DropdownMenuItem(value: 'hable', child: Text('Hable')),
                  DropdownMenuItem(value: 'mobius', child: Text('Mobius')),
                  DropdownMenuItem(value: 'bt2390', child: Text('BT.2390')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _tonemappingAlgorithm = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Advanced tonemapping options
              if (['amf', 'nvenc', 'qsv', 'vaapi', 'rkmpp', 'videotoolbox'].contains(_hardwareAccelerationType)) ...[
                DropdownButtonFormField<String>(
                  value: _tonemappingMode,
                  decoration: const InputDecoration(
                    labelText: 'Tonemapping mode',
                    helperText: 'Color space conversion mode',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('Auto')),
                    DropdownMenuItem(value: 'max', child: Text('MAX')),
                    DropdownMenuItem(value: 'rgb', child: Text('RGB')),
                    DropdownMenuItem(value: 'lum', child: Text('LUM')),
                    DropdownMenuItem(value: 'itp', child: Text('ITP')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _tonemappingMode = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tonemappingRange,
                  decoration: const InputDecoration(
                    labelText: 'Tonemapping range',
                    helperText: 'Output color range',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('Auto')),
                    DropdownMenuItem(value: 'tv', child: Text('TV (Limited)')),
                    DropdownMenuItem(value: 'pc', child: Text('PC (Full)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _tonemappingRange = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tonemappingDesatController,
                  decoration: const InputDecoration(
                    labelText: 'Tonemapping desaturation',
                    helperText: 'Desaturation strength (0 = none)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    final num = double.tryParse(value!);
                    if (num == null || num < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tonemappingPeakController,
                  decoration: const InputDecoration(
                    labelText: 'Tonemapping peak luminance',
                    helperText: 'Peak brightness in nits (0 = auto)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    final num = double.tryParse(value!);
                    if (num == null || num < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tonemappingParamController,
                  decoration: const InputDecoration(
                    labelText: 'Tonemapping parameter',
                    helperText: 'Algorithm-specific parameter (0 = default)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    final num = double.tryParse(value!);
                    if (num == null || num < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],

            // Encoding Quality
            Text(
              'Encoding Quality',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _encoderPreset,
              decoration: const InputDecoration(
                labelText: 'Encoder preset',
                helperText: 'Speed vs quality tradeoff',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'auto', child: Text('Auto')),
                DropdownMenuItem(value: 'veryslow', child: Text('Very Slow')),
                DropdownMenuItem(value: 'slower', child: Text('Slower')),
                DropdownMenuItem(value: 'slow', child: Text('Slow')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'fast', child: Text('Fast')),
                DropdownMenuItem(value: 'faster', child: Text('Faster')),
                DropdownMenuItem(value: 'veryfast', child: Text('Very Fast')),
                DropdownMenuItem(value: 'superfast', child: Text('Super Fast')),
                DropdownMenuItem(value: 'ultrafast', child: Text('Ultra Fast')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _encoderPreset = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _h265CrfController,
              decoration: const InputDecoration(
                labelText: 'H.265 CRF',
                helperText: 'Constant Rate Factor for H.265 (0-51, lower = better)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                final num = int.tryParse(value!);
                if (num == null || num < 0 || num > 51) return 'Must be between 0 and 51';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _h264CrfController,
              decoration: const InputDecoration(
                labelText: 'H.264 CRF',
                helperText: 'Constant Rate Factor for H.264 (0-51, lower = better)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                final num = int.tryParse(value!);
                if (num == null || num < 0 || num > 51) return 'Must be between 0 and 51';
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Audio & Processing
            Text(
              'Audio & Processing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _downMixAudioBoost,
              decoration: const InputDecoration(
                labelText: 'Downmix audio boost',
                helperText: 'Audio normalization algorithm',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'None', child: Text('None')),
                DropdownMenuItem(value: 'Dave750', child: Text('Dave750')),
                DropdownMenuItem(value: 'NightmodeDialogue', child: Text('Nightmode Dialogue')),
                DropdownMenuItem(value: 'Rfc7845', child: Text('RFC7845')),
                DropdownMenuItem(value: 'Ac4', child: Text('AC-4')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _downMixAudioBoost = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _maxMuxingQueueSizeController,
              decoration: const InputDecoration(
                labelText: 'Max muxing queue size',
                helperText: 'Maximum packets to buffer (higher = more memory)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _deinterlaceMethod,
              decoration: const InputDecoration(
                labelText: 'Deinterlace method',
                helperText: 'Algorithm for deinterlacing video',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'yadif', child: Text('YADIF')),
                DropdownMenuItem(value: 'bwdif', child: Text('BWDIF')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _deinterlaceMethod = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              value: _deinterlaceDoubleRate,
              onChanged: (value) => setState(() => _deinterlaceDoubleRate = value),
              title: const Text('Use double rate deinterlacing'),
              subtitle: const Text('Double framerate when deinterlacing'),
            ),
            
            SwitchListTile(
              value: _enableSubtitleExtraction,
              onChanged: (value) => setState(() => _enableSubtitleExtraction = value),
              title: const Text('Allow on-the-fly subtitle extraction'),
              subtitle: const Text('Extract subtitles during transcoding'),
            ),
            
            SwitchListTile(
              value: _enableThrottling,
              onChanged: (value) => setState(() => _enableThrottling = value),
              title: const Text('Allow FFmpeg throttling'),
              subtitle: const Text('Throttle transcoding to reduce CPU usage'),
            ),
            
            if (_enableThrottling) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _throttleDelaySecondsController,
                decoration: const InputDecoration(
                  labelText: 'Throttle delay (seconds)',
                  helperText: 'Delay before throttling starts (10-3600)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final num = int.tryParse(value!);
                  if (num == null || num < 10 || num > 3600) return 'Must be between 10 and 3600';
                  return null;
                },
              ),
            ],
            
            const SizedBox(height: 8),
            SwitchListTile(
              value: _enableSegmentDeletion,
              onChanged: (value) => setState(() => _enableSegmentDeletion = value),
              title: const Text('Allow segment deletion'),
              subtitle: const Text('Delete old segments automatically'),
            ),
            const SizedBox(height: 24),
            
            // Paths & System
            Text(
              'Paths & System',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _encodingThreadsController,
              decoration: const InputDecoration(
                labelText: 'Encoding thread count',
                helperText: 'Number of threads to use for encoding. 0 = auto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconsaxPlusLinear.cpu_charge),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _encoderAppPathController,
              decoration: const InputDecoration(
                labelText: 'FFmpeg path',
                helperText: 'Path to FFmpeg binary (read-only)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconsaxPlusLinear.document_code),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _transcodingTempPathController,
              decoration: InputDecoration(
                labelText: 'Transcoding temporary path',
                helperText: 'Custom path for transcoding temp files',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(IconsaxPlusLinear.folder_2),
                suffixIcon: IconButton(
                  icon: const Icon(IconsaxPlusLinear.folder_open),
                  onPressed: () {
                    // TODO: Directory picker
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _fallbackFontPathController,
              decoration: InputDecoration(
                labelText: 'Fallback font path',
                helperText: 'Path to fallback font for subtitles',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(IconsaxPlusLinear.text),
                suffixIcon: IconButton(
                  icon: const Icon(IconsaxPlusLinear.folder_open),
                  onPressed: () {
                    // TODO: Directory picker
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _segmentKeepSecondsController,
              decoration: const InputDecoration(
                labelText: 'Segment keep seconds',
                helperText: 'How long to keep segments in transcoding temp',
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconsaxPlusLinear.timer_1),
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
