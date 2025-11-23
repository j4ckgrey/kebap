import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:kebap/util/theme_extensions.dart';

class KebapIcon extends StatelessWidget {
  final double size;
  final bool useGradient;
  const KebapIcon({this.size = 100, this.useGradient = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (useGradient)
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return ui.Gradient.linear(
                const Offset(30, 30),
                const Offset(80, 80),
                [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              );
            },
            child: SvgPicture.asset(
              "icons/kebap_icon.svg",
              width: size,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          )
        else
          SvgPicture.asset(
            "icons/kebap_icon.svg",
            width: size,
          ),
      ],
    );
  }
}

class KebapIconOutlined extends StatelessWidget {
  final double size;
  final Color? color;
  const KebapIconOutlined({this.size = 100, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "icons/kebap_icon_outline.svg",
      width: size,
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn) 
          : null,
    );
  }
}
