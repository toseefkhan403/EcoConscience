import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class PauseButtonOverlay extends StatelessWidget {
  const PauseButtonOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  Widget build(BuildContext context) {
    double rowHeight = MediaQuery.of(context).size.height * 0.08;
    if (rowHeight < 32) {
      rowHeight = 32;
    }
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SpriteButton(
            sprite: Sprite(game.images.fromCache('HUD/settings_button.png')),
            pressedSprite: Sprite(
                game.images.fromCache('HUD/settings_button_pressed.png')),
            onPressed: () async {
              await playClickSound(game);
              if (!game.overlays.activeOverlays.contains('pauseMenu')) {
                game.overlays.add('pauseMenu');
                game.pauseEngine();
              } else {
                game.overlays.remove('pauseMenu');
                game.resumeEngine();
              }

              game.overlays.remove('restartWarning');
              game.overlays.remove(PlayState.showingToast.name);
            },
            width: rowHeight,
            // height is 9.09% bigger than width
            height: rowHeight + (rowHeight * 0.0909),
            label: Container()),
      ),
    );
  }
}
