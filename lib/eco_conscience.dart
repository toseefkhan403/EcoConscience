import 'dart:async';
import 'dart:io';

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
// 5. bathroom and lights arc
// 6. Map - road dev with changing skyline
// 7. start anim and menu
// 8. grocery littering arc
// 9. office tree plantation arc
// 10. sound fx
// 11. cross platform testing and fixes

enum PlayState {
  startScreen,
  playing,
  showingToast,
  arcPlaying,
  lessonPlaying,
  gameOver
}

class EcoConscience extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  final Player player = Player(character: 'Adam', size: Vector2(32, 64));
  late final JoystickComponent joystick;

  late CameraComponent cam;
  String toastMsg = '';
  String currentStoryArc = '';
  String currentLesson = '';
  PlayState playState = PlayState.playing;
  bool showJoystick = false;

  @override
  Color backgroundColor() => const Color(0xff62626f);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    _loadMap();
    try {
      showJoystick = Platform.isAndroid || Platform.isIOS;
      if (showJoystick) addJoystick();
    } catch (e) {
      print(e.toString());
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
        player.horizontalMovement = -1;
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.horizontalMovement = 1;
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.up:
        player.verticalMovement = -1;
        player.playerDirection = PlayerDirection.up;
        break;
      case JoystickDirection.down:
        player.verticalMovement = 1;
        player.playerDirection = PlayerDirection.down;
        break;
      case JoystickDirection.idle:
        player.horizontalMovement = 0;
        player.verticalMovement = 0;
        break;
      case JoystickDirection.upLeft:
        player.verticalMovement = -1;
        player.horizontalMovement = -1;
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.downLeft:
        player.verticalMovement = 1;
        player.horizontalMovement = -1;
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.upRight:
        player.verticalMovement = -1;
        player.horizontalMovement = 1;
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.downRight:
        player.verticalMovement = 1;
        player.horizontalMovement = 1;
        player.playerDirection = PlayerDirection.right;
        break;
    }
  }

  void loadNextMap(String mapName, Vector2 nextSpawn,
      {bool isCamFixed = true}) {
    removeWhere((component) => component is Map);
    _loadMap(mapName: mapName, isCamFixed: isCamFixed, nextSpawn: nextSpawn);
  }

  void _loadMap(
      {String mapName = 'home', bool isCamFixed = true, Vector2? nextSpawn}) {
    final world = Map(name: mapName, nextSpawn: nextSpawn);

    // this line makes it responsive! aspect ratio 16:9 - 32x32 in 640x360
    // take fixed for every room of the house
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    if (isCamFixed) {
      cam.viewfinder.anchor = Anchor.topLeft;
    } else {
      // have both - following player in some situations and fixed room in some
      cam.follow(player);
    }

    addAll([cam, world]);
  }

  void startStoryArc() {
    playState = PlayState.arcPlaying;
    overlays.add(PlayState.arcPlaying.name);
  }
}
