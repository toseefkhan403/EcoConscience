import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CustomToastOverlay extends StatelessWidget {
  final EcoConscience game;

  const CustomToastOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 5),
      child: InkWell(
        onTap: () async {
          await playClickSound(game);
          game.overlays.remove(PlayState.showingToast.name);
          game.startStoryArc();
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(game.toastMsg,
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    duration: const Duration(milliseconds: 1000)),
              ],
              onTap: () {
                print('tapped2');
                game.overlays.remove(PlayState.showingToast.name);
                game.startStoryArc();
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
