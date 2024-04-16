import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/providers/restart_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

class RestartWarningOverlay extends StatelessWidget {
  final EcoConscience game;

  const RestartWarningOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final localeProvider = context.read<LocaleProvider>();
    AppLocalizations local = localeProvider.locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: brownContainer(
          width: width,
          height: width / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              gradientText(local.warning),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: AutoSizeText(
                local.warningMsg,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: localeProvider.getFontFamily(),
                ),
                textAlign: TextAlign.center,
              )),
              Expanded(
                child: Row(
                  children: [
                    textButton(local.cancel, context, () async {
                      await playClickSound(game);
                      game.overlays.remove('restartWarning');
                      game.resumeEngine();
                    }, color: Colors.brown),
                    textButton(local.restart, context, () async {
                      await playClickSound(game);
                      if (game.playSounds) {
                        FlameAudio.bgm.stop();
                      }
                      context.read<RestartProvider>().restartTheGame(context);
                    }, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
