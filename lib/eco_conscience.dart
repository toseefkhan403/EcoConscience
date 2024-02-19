import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'components/map.dart';

// todo - 3 days per task
// 1. Character anims - collisions --done
// 2. Map - house, bathroom - changing levels --done
// 3. text bubbles, generated images and interactions --done
// 4. angel and devil dev --done
// 5. bathroom and house lights arc --done
// 6. Map - road dev with changing skyline --done
// 7. start anim and ecoMeter --done
// 8. busToOffice arc, grocery littering arc --done
// 9. office tree plantation arc --done
// 10. menu and sound fx --done
// 11. add ecoMeter based dynamic characters and npc and add an ending to the game --done
// 12. make it work on web, add support for mobile browser --done

// 13. add Japanese support and google pay cards integration
// 14. gather ppl arc and save progress, integrate custom player name in dialogs, change background/loading Builder
// 15. cross platform testing and fixes - player teleports first -> map loads later,
// player keeps running on next map load, collision blocks correction,
// decor layer missing in home if you travel to right first
// 16. submission video
// flutter earlier v3.13.1

enum PlayState {
  startScreen,
  playing,
  showingToast,
  storyPlaying,
  lessonPlaying,
  gameOver
}

enum Characters { player, angel, demon, npc }

class EcoConscience extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Player player = Player(size: Vector2(32, 64));

  late CameraComponent cam;
  late Map currentMap;
  String toastMsg = '';
  String currentStoryArc = 'introArc';
  bool isStandingWithNpc = false;
  bool playSounds = true;
  double volume = 1.0;

  // true/false+currentStoryArc
  String currentLesson = 'falseintroArc';
  PlayState playState = PlayState.playing;

  @override
  Color backgroundColor() => Colors.black;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    // for testing
    // startGamePlay();

    loadMap(
      mapName: 'startingSequence',
      mapResMultiplier: 1.5,
    );
    startBgmMusic();

    return super.onLoad();
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    if (playSounds) {
      FlameAudio.bgm
          .play('Three-Red-Hearts-Penguin-Town.mp3', volume: volume * 0.5);
    }
  }

  void loadMap(
      {String mapName = 'home',
      double? nextSpawnX,
      double? nextSpawnY,
      double mapResMultiplier = 1.0}) {
    removeWhere((component) =>
        component is Map ||
        component is Player ||
        component is CameraComponent);

    currentMap =
        Map(name: mapName, nextSpawnX: nextSpawnX, nextSpawnY: nextSpawnY);

    // this line makes it responsive! aspect ratio 16:9 - 32x32 in 640x360
    cam = CameraComponent.withFixedResolution(
        world: currentMap,
        width: 640 * mapResMultiplier,
        height: 360 * mapResMultiplier);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, currentMap]);
  }

  void startStoryArc() {
    playState = PlayState.storyPlaying;
    overlays.add(PlayState.storyPlaying.name);
  }

  void startGamePlay() {
    playState = PlayState.playing;
    overlays.add('pauseButton');
    // loads the first map with initial spawn points
    loadMap(mapName: 'home', nextSpawnX: 288, nextSpawnY: 224);
    // loadMap(
    //     mapName: 'outdoors',
    //     nextSpawnX: 96,
    //     nextSpawnY: 384,
    //     mapResMultiplier: 1.5);
    if (playSounds) {
      FlameAudio.bgm
          .play('Three-Red-Hearts-Princess-Quest.mp3', volume: volume * 0.5);
    }
  }

  startNpcDialog() {
    playState = PlayState.storyPlaying;
    overlays.add('npcDialog');
  }

  @override
  void onGameResize(Vector2 size) {
    if (size.x < 600) {
      if (!overlays.activeOverlays.contains('buttonControls') &&
          overlays.activeOverlays.contains('pauseButton')) {
        overlays.add('buttonControls');
      }
    } else {
      if (overlays.activeOverlays.contains('buttonControls')) {
        overlays.remove('buttonControls');
      }
    }
    super.onGameResize(size);
  }

  @override
  void onDispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
    super.onDispose();
  }
}
