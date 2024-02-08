import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/components/utils.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/eco_meter_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final ecoMeter = context.watch<EcoMeterProvider>().ecoMeter;
    // Stack(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(left: rowHeight / 2, top: rowHeight / 3),
    //       child: ShaderMask(
    //         shaderCallback: (Rect bounds) {
    //           return const LinearGradient(
    //             colors: [Colors.orange, Colors.pink],
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //           ).createShader(bounds);
    //         },
    //         child: SpriteButton(
    //             sprite:
    //             Sprite(game.images.fromCache('HUD/green_bar.png')),
    //             pressedSprite:
    //             Sprite(game.images.fromCache('HUD/green_bar.png')),
    //             onPressed: () {},
    //             width: rowHeight * 2,
    //             height: rowHeight / 2,
    //             label: Container()),
    //       ),
    //     ),
    //     SpriteButton(
    //         sprite: Sprite(game.images.fromCache('HUD/Earth.png')),
    //         pressedSprite:
    //         Sprite(game.images.fromCache('HUD/Earth.png')),
    //         onPressed: () {},
    //         width: rowHeight,
    //         height: rowHeight,
    //         label: Container()),
    //   ],
    // ),
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SpriteButton(
          sprite: Sprite(
            game.images.fromCache('HUD/settings_box.png'),
          ),
          pressedSprite: Sprite(
            game.images.fromCache('HUD/settings_box.png'),
          ),
          onPressed: () {
            game.overlays.remove('pauseMenu');
            game.resumeEngine();
          },
          width: width,
          height: width - 100,
          label: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                gradientText('Settings'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SpriteButton(
                        sprite:
                        Sprite(game.images.fromCache('HUD/settings_button.png')),
                        pressedSprite:
                        Sprite(game.images.fromCache('HUD/settings_button_pressed.png')),
                        onPressed: () {},
                        width: width * 0.1,
                        height: width * 0.1,
                        label: Container()),
                    SpriteButton(
                        sprite:
                        Sprite(game.images.fromCache('HUD/settings_button.png')),
                        pressedSprite:
                        Sprite(game.images.fromCache('HUD/settings_button_pressed.png')),
                        onPressed: () {},
                        width: width * 0.1,
                        height: width * 0.1,
                        label: Container()),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              getColorBasedOnEcoMeter(ecoMeter),
                              getColorBasedOnEcoMeter(ecoMeter),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds);
                        },
                        child: SpriteWidget.asset(
                          path: 'HUD/Earth.png')
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: AutoSizeText(
                      getMsgBasedOnEcoMeter(ecoMeter),
                      style: const TextStyle(fontSize: 24),
                    ))
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
