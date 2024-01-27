import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/stories.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'dialog_typewriter_animated_text.dart';

class ArcOverlay extends StatelessWidget {
  final EcoConscience game;

  const ArcOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dialogs = gameStories[game.currentStoryArc];
    return AnimatedTextKit(
      animatedTexts: getAnimatedTextFromDialogs(dialogs),
      displayFullTextOnTap: true,
      pause: const Duration(seconds: 4),
      isRepeatingAnimation: false,
      stopPauseOnTap: true,
    );
  }

  List<AnimatedText> getAnimatedTextFromDialogs(List<MsgFormat>? dialogs) {
    List<AnimatedText> result = [];
    if (dialogs == null || dialogs.isEmpty) return result;

    for (var dialog in dialogs) {
      result.add(
        DialogTypewriterAnimatedText(
          dialog.msg,
          dialog,
          textStyle: const TextStyle(
              fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.w500),
          acceptedOrRejectedCallback: dialog.choices != null
              ? (bool isAccepted) {
                  print("isAccepted $isAccepted");
                  // remove the overlay and start lecture
                  startLecture(isAccepted);
                }
              : null,
        ),
      );
    }

    return result;
  }

  void startLecture(bool isAccepted) {
    game.overlays.remove(PlayState.arcPlaying.name);
    game.playState = PlayState.lessonPlaying;
    game.currentLesson = '$isAccepted${game.currentStoryArc}';
    game.overlays.add(PlayState.lessonPlaying.name);
  }
}
