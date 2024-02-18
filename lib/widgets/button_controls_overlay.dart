import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/sprite_button_with_tap_up_callback.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonControlsOverlay extends StatefulWidget {
  const ButtonControlsOverlay({Key? key, required this.game}) : super(key: key);
  final EcoConscience game;

  @override
  State<ButtonControlsOverlay> createState() => _ButtonControlsOverlayState();
}

class _ButtonControlsOverlayState extends State<ButtonControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            movementButton('u'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                movementButton('l'),
                movementButton('d'),
                movementButton('r'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  movementButton(String direction) {
    return SpriteButtonWithTapUpCallback(
      sprite:
          Sprite(widget.game.images.fromCache('HUD/keyboard_$direction.png')),
      pressedSprite: Sprite(widget.game.images
          .fromCache('HUD/keyboard_${direction}_pressed.png')),
      width: 32 * 1.3,
      height: 32 * 1.3,
      onTapDown: () {
        widget.game.player.onKeyEvent(
          const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey(0),
            logicalKey: LogicalKeyboardKey(0),
            timeStamp: Duration.zero,
          ),
          <LogicalKeyboardKey>{}..add(getKeysFromDirections(direction)),
        );
      },
      onTapUp: () {
        widget.game.player.horizontalMovement = 0;
        widget.game.player.verticalMovement = 0;
      },
      label: const Text(''),
    );
  }

  LogicalKeyboardKey getKeysFromDirections(String direction) {
    switch (direction) {
      case 'u':
        return LogicalKeyboardKey.keyW;
      case 'd':
        return LogicalKeyboardKey.keyS;
      case 'l':
        return LogicalKeyboardKey.keyA;
      case 'r':
        return LogicalKeyboardKey.keyD;
    }
    return LogicalKeyboardKey.keyF;
  }
}
