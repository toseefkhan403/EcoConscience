import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'dialog_typewriter_animated_text.dart';

class LessonOverlay extends StatefulWidget {
  final EcoConscience game;

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
    super.initState();
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
    final lessons = StoryProgress.gameLessons[widget.game.currentLesson];
    final gameWidth = MediaQuery.of(context).size.width;
    final gameHeight = MediaQuery.of(context).size.height;
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: gameWidth,
        height: gameHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/Lessons/${widget.game.currentStoryArc}.png',
              ),
              colorFilter: ColorFilter.mode(
                  widget.game.currentLesson.startsWith('false')
                      ? const Color(0x8B7A0909)
                      : Colors.green.withOpacity(0.5),
                  BlendMode.softLight),
              fit: BoxFit.cover),
          border: Border.all(
            color: const Color(0xffb5754d),
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            animatedPlayerWidget(gameHeight, widget.game.player.character),
            AnimatedTextKit(
              animatedTexts: getAnimatedTextFromLessons(lessons),
              displayFullTextOnTap: true,
              pause: const Duration(seconds: 4),
              isRepeatingAnimation: false,
              stopPauseOnTap: true,
              onFinished: () {
                /// story ended - remove overlays, ecoPoints and interaction point
                widget.game.overlays.remove(PlayState.lessonPlaying.name);
                widget.game.overlays.remove(PlayState.storyPlaying.name);
                StoryProgress
                    .allStoryArcsProgress[widget.game.currentStoryArc] = true;

                if(widget.game.currentStoryArc == StoryTitles.introArc.name) {
                  widget.game.startGame();
                  return;
                }

                final isAccepted = widget.game.currentLesson.startsWith('true');
                if (!isAccepted) {
                  StoryProgress.ecoMeter -= 20;
                }
                print('StoryProgress.ecoMeter ${StoryProgress.ecoMeter}');

                widget.game.currentMap.removeInteractionPoint(isAccepted);
                widget.game.playState = PlayState.playing;
              },
            ),
          ],
        ),
      ),
    );
  }

  List<AnimatedText> getAnimatedTextFromLessons(List<MsgFormat>? lessons) {
    List<AnimatedText> result = [];
    if (lessons == null || lessons.isEmpty) return result;

    for (var lesson in lessons) {
      result.add(
        DialogTypewriterAnimatedText(
          lesson.msg,
          lesson,
          textStyle: const TextStyle(
              fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      );
    }

    return result;
  }
}
