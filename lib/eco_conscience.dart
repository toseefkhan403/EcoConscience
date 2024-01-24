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
// 2. Map - house, bathroom - changing levels
// 3. text bubbles, generated images and interactions
// 4. angel and devil dev
// 5. Map - road dev with changing skyline
// 6. start anim and menu
// 7. grocery littering arc
// 8. office tree plantation arc
// 9. sound fx
// 10. cross platform testing and fixes
class EcoConscience extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {

  EcoConscience({required this.showJoystick});

  final bool showJoystick;
  late CameraComponent cam;
  final Player player = Player(character: 'Adam');
  late final JoystickComponent joystick;
  Vector2 worldDimensions = Vector2.zero();

  @override
  Color backgroundColor() => const Color(0xff62626f);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    if (showJoystick) addJoystick();
    _loadMap();
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

  void loadNextMap(String mapName, {bool isCamFixed = true}) {
    removeWhere((component) => component is Map);
    _loadMap(mapName: mapName, isCamFixed: isCamFixed);
  }

  void _loadMap({String mapName = 'home', bool isCamFixed = true}) {
    final world = Map(name: mapName, player: player);

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
}
