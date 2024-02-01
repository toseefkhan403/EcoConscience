import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/custom_toast_overlay.dart';
import 'package:eco_conscience/widgets/lesson_overlay.dart';
import 'package:eco_conscience/widgets/overlay_screen.dart';
import 'package:eco_conscience/widgets/story_arc_overlay.dart';
import 'package:eco_conscience/components/story_progress.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  StoryProgress.init();
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.vt323TextTheme().apply(),
        ),
        home: Scaffold(
          body: GameWidget(game: EcoConscience(), overlayBuilderMap: {
            PlayState.startScreen.name: (context, game) => const OverlayScreen(
                  title: 'start game title',
                  subtitle: 'subtitle',
                ),
            PlayState.showingToast.name: (context, EcoConscience game) =>
                CustomToastOverlay(game: game),
            PlayState.storyPlaying.name: (context, EcoConscience game) =>
                StoryArcOverlay(game: game),
            PlayState.lessonPlaying.name: (context, EcoConscience game) =>
                LessonOverlay(game: game),
          }),
        ));
  }
}
