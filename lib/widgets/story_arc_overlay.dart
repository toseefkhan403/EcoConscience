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

class StoryArcOverlay extends StatefulWidget {
  final eco.EcoConscience game;

  const StoryArcOverlay({Key? key, required this.game}) : super(key: key);

  @override
  State<StoryArcOverlay> createState() => _StoryArcOverlayState();
}

class _StoryArcOverlayState extends State<StoryArcOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.game.playSounds) {
      final dialogs = StoryProgress.gameStories[widget.game.currentStoryArc];
      FlameAudio.bgm.play(
          dialogs?[0].character == eco.Characters.demon
              ? 'typing_devil.mp3'
              : 'typing.mp3',
          volume: widget.game.volume);
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = StoryProgress.gameStories[widget.game.currentStoryArc];
    final gameWidth = MediaQuery.of(context).size.width;
    final gameHeight = MediaQuery.of(context).size.height;
    final provider = context.read<GameProgressProvider>();

    return FadeTransition(
        opacity: _opacityAnimation,
        child: Semantics(
          label: 'Story overlay',
          child: Stack(
            children: [
              RawImage(
                image: widget.game.images
                    .fromCache('Lessons/${widget.game.currentStoryArc}.png'),
                width: gameWidth,
                height: gameHeight,
                fit: BoxFit.cover,
              ),
              widget.game.currentStoryArc != StoryTitles.introArc.name
                  ? animatedPlayerWidget(gameHeight, provider.character)
                  : Container(),
              Semantics(
                label: 'Dialogue box',
                child: AnimatedTextKit(
                  animatedTexts: getAnimatedTextFromDialogs(
                      dialogs, widget.game, provider.playerName),
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
                        FlameAudio.bgm.play(
                            dialogs?[i + 1].character == eco.Characters.demon
                                ? 'typing_devil.mp3'
                                : 'typing.mp3');
                      }
                    }
                  },
                  onFinished: () {
                    if (widget.game.currentStoryArc ==
                        StoryTitles.introArc.name) {
                      startLecture(false);
                      widget.game.overlays
                          .remove(eco.PlayState.storyPlaying.name);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  List<AnimatedText> getAnimatedTextFromDialogs(
      List<MsgFormat>? dialogs, eco.EcoConscience game, String playerName) {
    List<AnimatedText> result = [];
    if (dialogs == null || dialogs.isEmpty) return result;

    final localeProvider = context.read<LocaleProvider>();
    final langCode = localeProvider.locale.languageCode;

    for (var dialog in dialogs) {
      result.add(
        DialogTypewriterAnimatedText(
          (langCode == 'en' ? dialog.msgEn : dialog.msgJa)
              .replaceAll('{username}', playerName),
          dialog,
          game,
          textStyle: TextStyle(
            fontSize: 40.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: localeProvider.getFontFamily(),
          ),
          speed: Duration(milliseconds: langCode == 'en' ? 35 : 60),
          acceptedOrRejectedCallback: dialog.choicesEn != null
              ? (bool isAccepted) {
                  print("isAccepted $isAccepted");
                  startLecture(isAccepted);
                }
              : null,
        ),
      );
    }

    return result;
  }

  void startLecture(bool isAccepted) {
    widget.game.playState = eco.PlayState.lessonPlaying;
    widget.game.currentLesson = '$isAccepted${widget.game.currentStoryArc}';
    widget.game.overlays.add(eco.PlayState.lessonPlaying.name);
  }
}
