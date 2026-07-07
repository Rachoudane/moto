import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MotoSanPose { welcome, validate, celebrate, repair, zen }

/// Moto-san, the app's mascot. Renders the SVG matching [pose] and the
/// current theme brightness. Sized by [height] only — each pose has a
/// different intrinsic aspect ratio (props like grids and cells vary in
/// width), so forcing a width would distort the art.
class MotoSan extends StatelessWidget {
  final MotoSanPose pose;
  final double height;

  const MotoSan({super.key, required this.pose, this.height = 120});

  String get _poseName {
    switch (pose) {
      case MotoSanPose.welcome:
        return 'welcome';
      case MotoSanPose.validate:
        return 'validate';
      case MotoSanPose.celebrate:
        return 'celebrate';
      case MotoSanPose.repair:
        return 'repair';
      case MotoSanPose.zen:
        return 'zen';
    }
  }

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).brightness == Brightness.dark
        ? 'dark'
        : 'light';
    return SvgPicture.asset(
      'assets/mascot/moto_san_${_poseName}_$variant.svg',
      height: height,
    );
  }
}
