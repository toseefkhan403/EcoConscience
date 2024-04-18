import 'package:eco_conscience/eco_conscience.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TapToStartOverlay extends StatelessWidget {
  final EcoConscience game;

  const TapToStartOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Semantics(
      label: 'Tap to start area',
      child: SizedBox(
        width: width,
        height: height,
        child: InkWell(
          onTap: () async {
            game.overlays.remove("tapToStart");
            game.startTheGame();
          },
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText("[Tap anywhere to start]",
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: height > 500 ? 34 : 26,
                          color: Colors.white,
                      ),
                      duration: const Duration(milliseconds: 2000)),
                ],
                onTap: () async {
                  game.overlays.remove("tapToStart");
                  game.startTheGame();
                },
                pause: const Duration(milliseconds: 10),
                repeatForever: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
