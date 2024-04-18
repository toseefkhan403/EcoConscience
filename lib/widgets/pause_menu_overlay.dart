import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

class PauseMenuOverlay extends StatefulWidget {
  const PauseMenuOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  State<PauseMenuOverlay> createState() => _PauseMenuOverlayState();
}

class _PauseMenuOverlayState extends State<PauseMenuOverlay> {
  late AppLocalizations _local;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final height = MediaQuery.of(context).size.height;
    final provider = context.watch<GameProgressProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    _local = localeProvider.locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: brownContainer(
          width: width,
          height: width,
          child: Column(
            children: [
              width > 400 && height > 500
                  ? gradientText(_local.pause)
                  : Container(),
              ecoMeterWidget(
                provider.ecoMeter,
                width,
                _local,
                provider,
                localeProvider.getFontFamily(),
              ),
              const SizedBox(
                height: 10,
              ),
              textButton(_local.resume, context, () async {
                await playClickSound(widget.game);
                widget.game.overlays.remove('pauseMenu');
                widget.game.resumeEngine();
              }, color: Colors.brown),
              textButton(_local.restart, context, () async {
                await playClickSound(widget.game);
                widget.game.overlays.remove('pauseMenu');
                widget.game.overlays.add('restartWarning');
              }, color: Colors.brown),
              textButton(
                  '${_local.sounds} ${widget.game.playSounds ? _local.on : _local.off}',
                  context, () async {
                await playClickSound(widget.game);
                widget.game.playSounds = !widget.game.playSounds;
                if (widget.game.playSounds) {
                  FlameAudio.bgm.play(
                      'Three-Red-Hearts-${getTuneBasedOnEcoMeter(provider.ecoMeter)}.mp3',
                      volume: widget.game.volume * 0.5);
                } else {
                  FlameAudio.bgm.stop();
                }
                setState(() {});
              }, color: Colors.brown),
              textButton(
                  '${_local.language} ${_local.localeName == 'en' ? 'Japanese' : 'English'}',
                  context, () async {
                await playClickSound(widget.game);
                context.read<LocaleProvider>().switchLocale();
              }, color: Colors.brown),
              textButton(_local.about, context, () async {
                await playClickSound(widget.game);
                widget.game.overlays.add('about');
              }, color: Colors.brown),
              textButton(_local.exit, context, () async {
                await playClickSound(widget.game);
                openLink("https://devpost.com/software/ecoshift-chronicles");
              }, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  ecoMeterWidget(
    int ecoMeter,
    double size,
    AppLocalizations local,
    GameProgressProvider provider,
    String fontFamily,
  ) {
    final boxHeight = size * 0.15;
    final int fillValue = 100 - ecoMeter;
    double spread = 0.1;
    if (fillValue == 0 || fillValue == 100) {
      spread = 0;
    }

    int tasksDone = 0;
    for (var value in provider.allStoryArcsProgress.values) {
      if (value) tasksDone++;
    }
    final String gameCompletion = ((tasksDone / 6) * 100).toStringAsFixed(2);

    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.brown.withOpacity(0.7)
          ],
          stops: [fillValue / 100 - spread, fillValue / 100 + spread],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: boxHeight * 0.5,
              height: boxHeight * 0.5,
              child: SpriteWidget.asset(path: 'HUD/Earth.png')),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: AutoSizeText(
              '${local.ecoMeter} $ecoMeter%\n${local.gameCompletion} $gameCompletion%',
              maxLines: 2,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: fontFamily,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
