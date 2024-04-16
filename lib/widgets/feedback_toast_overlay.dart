import 'dart:math';

import 'package:eco_conscience/eco_conscience.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';

class FeedBackToastOverlay extends StatelessWidget {
  final EcoConscience game;

  const FeedBackToastOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final localeProvider = context.watch<LocaleProvider>();
    final isAccepted = game.currentLesson.startsWith('true');
    late AppLocalizations local;
    local = localeProvider.locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    final positiveFeedback = [
      local.positiveFeedback1,
      local.positiveFeedback2,
      local.positiveFeedback3,
    ];
    final negativeFeedback = [
      local.negativeFeedback1,
      local.negativeFeedback2,
      local.negativeFeedback3,
    ];

    final randomIndex = Random().nextInt(positiveFeedback.length);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
                isAccepted
                    ? positiveFeedback[randomIndex]
                    : negativeFeedback[randomIndex],
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: height > 500 ? 36 : 26,
                  color: isAccepted
                      ? Colors.green.shade400
                      : Colors.red.withOpacity(0.8),
                  fontFamily: localeProvider.getFontFamily(),
                ),
                fadeInEnd: 0.1,
                fadeOutBegin: 0.9,
                duration: const Duration(milliseconds: 4500)),
          ],
          onFinished: () {
            game.overlays.remove('feedBackToast');
          },
          isRepeatingAnimation: false,
        ),
      ),
    );
  }
}
