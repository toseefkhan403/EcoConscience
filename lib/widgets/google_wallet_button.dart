import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleWalletButton extends StatelessWidget {
  static const double _minHeight = 48;

  final double height;
  final VoidCallback? onPressed;
  final String locale;

  const GoogleWalletButton({
    Key? key,
    this.height = _minHeight,
    this.locale = 'en_US',
    this.onPressed,
  }) : super(key: key);

  String _assetPath(context) {
    return 'assets/google_buttons/${locale}_wallet_button_condensed.svg';
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(8),
      onPressed: onPressed,
      child: SvgPicture.asset(
        _assetPath(context),
        height: max(height, _minHeight),
        fit: BoxFit.contain,
      ),
    );
  }
}
