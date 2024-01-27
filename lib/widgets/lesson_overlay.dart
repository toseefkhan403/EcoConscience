import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/stories.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'dialog_typewriter_animated_text.dart';

class LessonOverlay extends StatelessWidget {
  final EcoConscience game;

  const LessonOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lessons = gameLessons[game.currentLesson];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffd0be9c),
        border: Border.all(
          color: const Color(0xffb5754d), // Dark brown color for the border
          width: 6.0,
        ),
      ),
      child: AnimatedTextKit(
        animatedTexts: getAnimatedTextFromLessons(lessons),
        displayFullTextOnTap: true,
        pause: const Duration(seconds: 4),
        isRepeatingAnimation: false,
        stopPauseOnTap: true,
        onFinished: () {
          // story ended
          game.overlays.remove(PlayState.lessonPlaying.name);
          game.playState = PlayState.playing;
        },
      ),
    );
  }

  List<AnimatedText> getAnimatedTextFromLessons(List<LessonPageFormat>? lessons) {
    List<AnimatedText> result = [];
    if (lessons == null || lessons.isEmpty) return result;

    for (var lesson in lessons) {
      result.add(
        DialogTypewriterAnimatedText(
          lesson.msg,
          MsgFormat(''),
          textStyle: const TextStyle(
              fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      );
    }

    return result;
  }
}
