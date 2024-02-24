import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
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
// 13. google wallet passes integration --done
// 14. add Japanese localization --done
// 15. restart and save progress, restart warning dialog, change loading builder and add restart button on game over screen --done

// 16. cross platform testing and fixes
// player teleports first -> map loads later --done
// player keeps running on next map load, collision blocks correction --done
// decor layer missing in home if you travel to right first --done
// can click tap to continue while pause overlay is on --done
// optimize maps and images --done
// add credits -done

// accessibility stuff - add semantics to images and buttons
// add higher priority cityProps for player
// gather ppl arc maybe
// google wallet api publishing access
// 17. submission video

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
    await preLoadMaps();
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

  void startGamePlay(GameProgressProvider provider) {
    playState = PlayState.playing;
    overlays.add('pauseButton');
    // loads the first map with initial spawn points
    // loadMap(mapName: 'home', nextSpawnX: 288, nextSpawnY: 224);
    loadMap(
        mapName: 'outdoors',
        nextSpawnX: 96,
        nextSpawnY: 384,
        mapResMultiplier: 1.5);
    if (playSounds) {
      FlameAudio.bgm.play(
          'Three-Red-Hearts-${getTuneBasedOnEcoMeter(provider.ecoMeter)}.mp3',
          volume: volume * 0.5);
    }
  }

  startNpcDialog() {
    playState = PlayState.storyPlaying;
    overlays.add('npcDialog');
  }

  @override
  void onDispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
    super.onDispose();
  }

  preLoadMaps() async {
    FlameAudio.bgm.play('typing.mp3', volume: 0);
    FlameAudio.bgm.play('typing_devil.mp3', volume: 0);
    await loadTiledComponent('outdoors');
    await loadTiledComponent('home');
    await loadTiledComponent('startingSequence');
    await loadTiledComponent('outdoorsOffice');
    await loadTiledComponent('outdoorsBus');
    await loadTiledComponent('outdoorsTaco');
    await loadTiledComponent('office');
    await loadTiledComponent('bathroom');
  }

  loadTiledComponent(String name) async =>
      await TiledComponent.load('$name.tmx', Vector2.all(32),
          atlasMaxX: 20000,
          atlasMaxY: 20000);
}
