import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/eco_meter_provider.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/providers/restart_provider.dart';
import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:eco_conscience/widgets/button_controls_overlay.dart';
import 'package:eco_conscience/widgets/custom_toast_overlay.dart';
import 'package:eco_conscience/widgets/game_over_overlay.dart';
import 'package:eco_conscience/widgets/npc_dialog_overlay.dart';
import 'package:eco_conscience/widgets/pause_button_overlay.dart';
import 'package:eco_conscience/widgets/lesson_overlay.dart';
import 'package:eco_conscience/widgets/pause_menu_overlay.dart';
import 'package:eco_conscience/widgets/player_selection_overlay.dart';
import 'package:eco_conscience/widgets/start_screen_overlay.dart';
import 'package:eco_conscience/widgets/story_arc_overlay.dart';
import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StartMenuProvider()),
          ChangeNotifierProvider(create: (_) => EcoMeterProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => RestartProvider()),
        ],
        child: Consumer<RestartProvider>(builder: (context, localeRef, child) {
          /// restart game
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                textTheme: GoogleFonts.vt323TextTheme().apply(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: GameWidget(
                    game: EcoConscience(),
                    focusNode: gameFocus,
                    // backgroundBuilder: (_) => Center(child: gradientText("Loading...")),
                    overlayBuilderMap: {
                      PlayState.startScreen.name:
                          (context, EcoConscience game) =>
                              StartScreenOverlay(game: game),
                      PlayState.showingToast.name:
                          (context, EcoConscience game) =>
                              CustomToastOverlay(game: game),
                      PlayState.storyPlaying.name:
                          (context, EcoConscience game) =>
                              StoryArcOverlay(game: game),
                      PlayState.lessonPlaying.name:
                          (context, EcoConscience game) =>
                              LessonOverlay(game: game),
                      PlayState.gameOver.name: (context, EcoConscience game) =>
                          GameOverOverlay(game: game),
                      'buttonControls': (context, EcoConscience game) =>
                          ButtonControlsOverlay(game: game),
                      'pauseButton': (context, EcoConscience game) =>
                          PauseButtonOverlay(game: game),
                      'pauseMenu': (context, EcoConscience game) =>
                          PauseMenuOverlay(game: game),
                      'playerSelection': (context, EcoConscience game) =>
                          PlayerSelectionOverlay(game: game),
                      'npcDialog': (context, EcoConscience game) =>
                          NpcDialogOverlay(game: game),
                    }),
              ));
        }));
  }
}
