import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CustomToastOverlay extends StatelessWidget {
  final EcoConscience game;

  const CustomToastOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: width / 5),
      child: InkWell(
        onTap: () async {
          await playClickSound(game);
          game.overlays.remove(PlayState.showingToast.name);
          game.isStandingWithNpc ? game.startNpcDialog() : game.startStoryArc();
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(game.toastMsg,
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                        fontSize: height > 500 ? 40 : 28,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500),
                    duration: const Duration(milliseconds: 1000)),
              ],
              onTap: () async {
                await playClickSound(game);
                game.overlays.remove(PlayState.showingToast.name);
                game.isStandingWithNpc ? game.startNpcDialog() : game.startStoryArc();
              },
              pause: const Duration(milliseconds: 10),
              repeatForever: true,
            ),
          ),
        ),
      ),
    );
  }
}
