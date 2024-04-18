import 'dart:math';

import 'package:eco_conscience/eco_conscience.dart' as eco;
import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../providers/game_progress_provider.dart';
import '../providers/locale_provider.dart';
import 'dialog_typewriter_animated_text.dart';

class NpcDialogOverlay extends StatefulWidget {
  final eco.EcoConscience game;

  const NpcDialogOverlay({super.key, required this.game});

  @override
  State<NpcDialogOverlay> createState() => _NpcDialogOverlayState();
}

class _NpcDialogOverlayState extends State<NpcDialogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    if (widget.game.playSounds) {
      FlameAudio.bgm.play('typing.mp3', volume: widget.game.volume);
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameWidth = MediaQuery.of(context).size.width;
    final gameHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SizedBox(
        width: gameWidth,
        height: gameHeight,
        child: Semantics(
          label: 'Dialogue box',
          child: AnimatedTextKit(
            animatedTexts: getAnimatedTextBasedOnEcoMeter(widget.game),
            displayFullTextOnTap: true,
            pause: const Duration(seconds: 4),
            isRepeatingAnimation: false,
            stopPauseOnTap: true,
            onNextBeforePause: (i, isLast) {
              if (widget.game.playSounds) {
                FlameAudio.bgm.stop();
              }
            },
            onNext: (i, isLast) {
              if (widget.game.playSounds) {
                if (isLast) {
                  FlameAudio.bgm.stop();
                } else {
                  FlameAudio.bgm.play('typing.mp3', volume: widget.game.volume);
                }
              }
            },
            onFinished: () {
              widget.game.overlays.remove('npcDialog');
              widget.game.playState = eco.PlayState.playing;
              widget.game.isStandingWithNpc = false;

              if (widget.game.playSounds) {
                final provider = context.read<GameProgressProvider>();
                FlameAudio.bgm.play(
                    'Three-Red-Hearts-${getTuneBasedOnEcoMeter(provider.ecoMeter)}.mp3',
                    volume: widget.game.volume * 0.5);
              }
            },
          ),
        ),
      ),
    );
  }

  List<AnimatedText> getAnimatedTextBasedOnEcoMeter(eco.EcoConscience game) {
    final ecoMeter = context.read<GameProgressProvider>().ecoMeter;
    final localeProvider = context.read<LocaleProvider>();
    final langCode = localeProvider.locale.languageCode;

    List<MsgFormat>? dialogs = StoryProgress.npcDialogs[ecoMeter];
    List<AnimatedText> result = [];

    if (dialogs == null || dialogs.isEmpty) return result;

    int randomIndex = Random().nextInt(dialogs.length);
    MsgFormat msg = dialogs[randomIndex];

    result.add(
      DialogTypewriterAnimatedText(
        langCode == 'en' ? msg.msgEn : msg.msgJa,
        msg,
        game,
        textStyle: TextStyle(
          fontSize: 40.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: localeProvider.getFontFamily(),
        ),
        speed: Duration(milliseconds: langCode == 'en' ? 35 : 60),
      ),
    );

    return result;
  }
}
