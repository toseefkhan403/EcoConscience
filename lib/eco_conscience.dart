import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
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

// 10. menu and sound fx
// 11. add ecoMeter based dynamic characters and elements
// 12. add Japanese support and google pay cards integration
// 13. cross platform testing and fixes

enum PlayState {
  startScreen,
  playing,
  showingToast,
  storyPlaying,
  lessonPlaying,
  gameOver
}

class EcoConscience extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  final Player player = Player(size: Vector2(32, 64));

  late CameraComponent cam;
  late Map currentMap;
  String toastMsg = '';
  String currentStoryArc = 'introArc';

  // true/false+currentStoryArc
  String currentLesson = 'falseintroArc';
  PlayState playState = PlayState.playing;

  @override
  Color backgroundColor() => Colors.black;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    // startGame();
    loadMap(
        mapName: 'startingSequence', mapResMultiplier: 1.5,
    );

    return super.onLoad();
  }

  void loadMap(
      {String mapName = 'home',
      double? nextSpawnX,
      double? nextSpawnY,
      double mapResMultiplier = 1.0}) {
    removeWhere((component) => component is Map);
    removeWhere((component) => component is CameraComponent);

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

  void startGame() {
    playState = PlayState.playing;
    overlays.add('pauseButton');
    // loads the first map with initial spawn points
    loadMap(mapName: 'home', nextSpawnX: 288, nextSpawnY: 224);
  }
}
