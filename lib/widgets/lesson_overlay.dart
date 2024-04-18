import 'package:eco_conscience/eco_conscience.dart' as eco;
import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../providers/game_progress_provider.dart';
import 'dialog_typewriter_animated_text.dart';

class LessonOverlay extends StatefulWidget {
  final eco.EcoConscience game;

  const LessonOverlay({super.key, required this.game});

  @override
  State<LessonOverlay> createState() => _LessonOverlayState();
}

class _LessonOverlayState extends State<LessonOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    if (widget.game.playSounds) {
      final lessons = StoryProgress.gameLessons[widget.game.currentLesson];
      FlameAudio.bgm.play(lessons?[0].character == eco.Characters.demon
          ? 'typing_devil.mp3'
          : 'typing.mp3');
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
    final lessons = StoryProgress.gameLessons[widget.game.currentLesson];
    final gameWidth = MediaQuery.of(context).size.width;
    final gameHeight = MediaQuery.of(context).size.height;
    final provider = context.read<GameProgressProvider>();

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Semantics(
        label: 'Lesson overlay',
        child: Stack(
          children: [
            RawImage(
              image: widget.game.images
                  .fromCache('Lessons/${widget.game.currentStoryArc}.png'),
              width: gameWidth,
              height: gameHeight,
              fit: BoxFit.cover,
              color: widget.game.currentLesson.startsWith('false')
                  ? const Color(0x8B7A0909)
                  : Colors.green.withOpacity(0.75),
              colorBlendMode: BlendMode.softLight,
            ),
            widget.game.currentStoryArc != StoryTitles.introArc.name
                ? animatedPlayerWidget(gameHeight, provider.character)
                : Container(),
            Semantics(
              label: 'Dialogue box',
              child: AnimatedTextKit(
                animatedTexts: getAnimatedTextFromLessons(
                    lessons, widget.game, provider.playerName),
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
                          lessons?[i + 1].character == eco.Characters.demon
                              ? 'typing_devil.mp3'
                              : 'typing.mp3');
                    }
                  }
                },
                onFinished: () {
                  final provider = context.read<GameProgressProvider>();

                  /// story ended - remove overlays, ecoPoints and interaction point
                  widget.game.overlays.remove(eco.PlayState.lessonPlaying.name);
                  widget.game.overlays.remove(eco.PlayState.storyPlaying.name);
                  provider.updateStoryProgress(widget.game.currentStoryArc);

                  if (widget.game.currentStoryArc ==
                      StoryTitles.introArc.name) {
                    widget.game.startGamePlay(provider);
                    return;
                  }

                  widget.game.overlays.add('feedBackToast');

                  final isAccepted =
                      widget.game.currentLesson.startsWith('true');
                  if (!isAccepted) {
                    provider.deductPoints();
                    print('EcoMeter ${provider.ecoMeter}');
                  }

                  if (widget.game.playSounds) {
                    FlameAudio.bgm.play(
                        'Three-Red-Hearts-${getTuneBasedOnEcoMeter(provider.ecoMeter)}.mp3',
                        volume: widget.game.volume * 0.5);
                  }

                  widget.game.currentMap
                      .removeInteractionPoint(isAccepted, provider);
                  widget.game.playState = eco.PlayState.playing;

                  // go to office after busToOfficeArc
                  if (widget.game.currentStoryArc ==
                      StoryTitles.busToOfficeArc.name) {
                    widget.game.loadMap(
                        mapName: 'office', nextSpawnX: 304, nextSpawnY: 256);
                  }

                  if (isGameOver(provider)) {
                    widget.game.playState = eco.PlayState.gameOver;
                    widget.game.pauseEngine();
                    widget.game.overlays.add(eco.PlayState.gameOver.name);
                    if (widget.game.overlays.activeOverlays
                        .contains('pauseButton')) {
                      widget.game.overlays.remove('pauseButton');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AnimatedText> getAnimatedTextFromLessons(
      List<MsgFormat>? lessons, eco.EcoConscience game, String playerName) {
    List<AnimatedText> result = [];
    if (lessons == null || lessons.isEmpty) return result;

    final localeProvider = context.read<LocaleProvider>();
    final langCode = localeProvider.locale.languageCode;

    for (var lesson in lessons) {
      result.add(
        DialogTypewriterAnimatedText(
          (langCode == 'en' ? lesson.msgEn : lesson.msgJa)
              .replaceAll('{username}', playerName),
          lesson,
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
    }

    return result;
  }

  bool isGameOver(GameProgressProvider provider) {
    return !provider.allStoryArcsProgress.values.contains(false);
  }
}
