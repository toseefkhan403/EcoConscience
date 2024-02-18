import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

FocusNode gameFocus = FocusNode();

Widget animatedPlayerWidget(double gameHeight, String character) => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: gameHeight / 4,
      height: (gameHeight / 4) * 2,
      margin: EdgeInsets.only(bottom: gameHeight / 5),
      child: SpriteAnimationWidget.asset(
        playing: true,
        anchor: Anchor.center,
        path: 'Characters/${character}_idle_anim_16x16.png',
        data: SpriteAnimationData.range(
            start: 18,
            end: 18 + 5,
            amount: 24,
            stepTimes: List.filled(6, 0.1),
            textureSize: Vector2(16, 32)),
      ),
    ));

Widget brownContainer({Widget? child, double? width, double? height}) =>
    Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xffd0be9c),
        border: Border.all(
          color: const Color(0xffb5754d),
          width: 6.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 3,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: child,
    );

Widget gradientText(String text) => Expanded(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.orange, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          minFontSize: 30,
          style: const TextStyle(
              fontFamily: '4B30',
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );

String getMsgBasedOnEcoMeter(int ecoMeter) {
  switch (ecoMeter) {
    case 80:
      return 'Keep shaping the destiny of EcoVille with your thoughtful choices!';
    case 60:
      return 'There\'s room for improvement. EcoVille\'s fate depends on you!';
    case 40:
      return 'You\'ve got some work to do. Make greener choices to turn things around!';
    case 20:
    case 0:
      return 'It\'s never too late to change!';
    default:
      return 'Make positive choices to keep your environment healthy!';
  }
}

String getGameOverMsgBasedOnEcoMeter(int ecoMeter) {
  switch (ecoMeter) {
    case 100:
      return 'Incredible! You achieved a perfect 100! You were the unwavering champion of EcoVille!';
    case 80:
      return 'Great Job! Your eco-friendly actions significantly benefited the ecosystem of EcoVille.';
    case 60:
      return 'There was room for improvement. EcoVille\'s fate depended on your dedication!';
    case 40:
      return 'You had some work to do. Making greener choices would have turned things around for EcoVille!';
    case 20:
    case 0:
      return 'It was never too late to change! Every positive choice counted towards a healthier environment.';
    default:
      return 'There was room for improvement. EcoVille\'s fate depended on your dedication!';
  }
}

getTuneBasedOnEcoMeter(int ecoMeter) {
  switch (ecoMeter) {
    case 80:
    case 60:
      return 'Penguin-Town';
    case 40:
    case 20:
    case 0:
      return 'Save-the-City';
    default:
      return 'Princess-Quest';
  }
}

playClickSound(EcoConscience game) async {
  if (game.playSounds) await FlameAudio.play('click.wav', volume: game.volume);
}

textButton(String title, Function() onPressed, {Color color = Colors.white}) {
  return Expanded(
    child: InkWell(
      onTap: onPressed,
      child: AutoSizeText(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Arcade-In',
            fontSize: 50,
            color: color.withOpacity(0.8)),
      ),
    ),
  );
}
