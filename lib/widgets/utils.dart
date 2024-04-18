import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/locale_provider.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(5.0),
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
      ),
    );

String getGameOverMsgBasedOnEcoMeter(int ecoMeter, AppLocalizations local) {
  switch (ecoMeter) {
    case 100:
      return local.gameOverMsg100;
    case 80:
      return local.gameOverMsg80;
    case 60:
      return local.gameOverMsg60;
    case 40:
      return local.gameOverMsg40;
    case 20:
    case 0:
      return local.gameOverMsg20;
    default:
      return local.gameOverMsg60;
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

textButton(String title, BuildContext context, Function() onPressed,
    {Color color = Colors.white}) {
  final fontFamily =
      context.read<LocaleProvider>().getFontFamily(englishFont: 'Arcade-In');
  return Expanded(
    child: Semantics(
      label: '$title button',
      child: InkWell(
        onTap: onPressed,
        child: AutoSizeText(
          title,
          textAlign: TextAlign.center,
          minFontSize: 20,
          style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 50,
              color: color.withOpacity(0.8)),
        ),
      ),
    ),
  );
}

double calculateBlackAreaHeight(BuildContext context) {
  const imageAspectRatio = 16 / 9;
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  double expectedImageHeight = screenWidth / imageAspectRatio;
  double blackAreaHeight = screenHeight - expectedImageHeight;
  blackAreaHeight = blackAreaHeight < 0 ? 0 : blackAreaHeight;

  return blackAreaHeight;
}

openLink(String url) async {
  if (url == '') return;

  try {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (e) {
    print(e);
  }
}
