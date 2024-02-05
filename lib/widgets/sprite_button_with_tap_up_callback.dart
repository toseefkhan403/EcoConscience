import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class SpriteButtonWithTapUpCallback extends StatefulWidget {
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final Widget label;
  final Sprite sprite;
  final Sprite pressedSprite;
  final double width;
  final double height;

  const SpriteButtonWithTapUpCallback({
    required this.onTapDown,
    required this.onTapUp,
    required this.label,
    required this.sprite,
    required this.pressedSprite,
    this.width = 200,
    this.height = 50,
    super.key,
  });

  @override
  State createState() => _ButtonState();
}

class _ButtonState extends State<SpriteButtonWithTapUpCallback> {
  bool _pressed = false;

  @override
  Widget build(_) {
    final width = widget.width;
    final height = widget.height;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onTapDown.call();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTapUp.call();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        widget.onTapUp.call();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter:
          _ButtonPainter(_pressed ? widget.pressedSprite : widget.sprite),
          child: Center(
            child: Container(
              padding: _pressed ? const EdgeInsets.only(top: 5) : null,
              child: widget.label,
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonPainter extends CustomPainter {
  final Sprite _sprite;

  _ButtonPainter(this._sprite);

  @override
  bool shouldRepaint(_ButtonPainter old) => old._sprite != _sprite;

  @override
  void paint(Canvas canvas, Size size) {
    _sprite.render(canvas, size: size.toVector2());
  }
}
