import 'dart:io';

import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

import '../providers/locale_provider.dart';

class StartScreenOverlay extends StatefulWidget {
  const StartScreenOverlay({super.key, required this.game});

  final EcoConscience game;

  @override
  State<StartScreenOverlay> createState() => _StartScreenOverlayState();
}

class _StartScreenOverlayState extends State<StartScreenOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late AppLocalizations _local;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightDiff = calculateBlackAreaHeight(context);
    final locale = context.watch<LocaleProvider>().locale;
    _local = locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: heightDiff / 2),
        child: Center(
          child: Consumer<StartMenuProvider>(
            builder:
                (BuildContext context, StartMenuProvider value, Widget? child) {
              final provider = context.read<GameProgressProvider>();
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey<bool>(value.showMenu),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      gradientText(_local.appTitle),
                      Expanded(
                        child: value.showMenu
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff595555).withOpacity(0.2),
                                    Colors.black.withOpacity(0.22),
                                    const Color(0xff747372).withOpacity(0.2)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  children: [
                                    if (provider.doesSaveExist())
                                      textButton(_local.resume, context,
                                          () async {
                                        await playClickSound(widget.game);
                                        provider.loadProgress();
                                        widget.game.overlays
                                            .remove(PlayState.startScreen.name);
                                        widget.game.startGamePlay(provider);
                                      }),
                                    textButton(_local.newGame, context,
                                        () async {
                                      await playClickSound(widget.game);
                                      if (widget.game.playSounds &&
                                          !FlameAudio.bgm.isPlaying) {
                                        FlameAudio.bgm.play(
                                            'Three-Red-Hearts-Penguin-Town.mp3',
                                            volume: widget.game.volume * 0.5);
                                      }

                                      /// reset progress - start fresh
                                      provider.resetProgress();

                                      /// player selection
                                      widget.game.overlays
                                          .remove(PlayState.startScreen.name);
                                      widget.game.overlays
                                          .add('playerSelection');
                                    }),
                                    textButton(
                                        '${_local.sounds} ${widget.game.playSounds ? _local.on : _local.off}',
                                        context, () async {
                                      await playClickSound(widget.game);
                                      widget.game.playSounds =
                                          !widget.game.playSounds;
                                      if (widget.game.playSounds) {
                                        FlameAudio.bgm.play(
                                            'Three-Red-Hearts-Penguin-Town.mp3',
                                            volume: widget.game.volume * 0.5);
                                      } else {
                                        FlameAudio.bgm.stop();
                                      }
                                      setState(() {});
                                    }),
                                    textButton(
                                        '${_local.language} ${_local.localeName == 'en' ? 'Japanese' : 'English'}',
                                        context, () async {
                                      await playClickSound(widget.game);
                                      context
                                          .read<LocaleProvider>()
                                          .switchLocale();
                                    }),
                                    textButton(_local.about, context, () async {
                                      await playClickSound(widget.game);
                                      widget.game.overlays.add('about');
                                    }),
                                    textButton(_local.exit, context, () async {
                                      await playClickSound(widget.game);
                                      openLink(
                                          "https://devpost.com/software/ecoshift-chronicles");
                                    }),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
