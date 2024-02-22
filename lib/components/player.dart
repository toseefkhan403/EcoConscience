import 'dart:async';
import 'dart:io';

import 'package:eco_conscience/components/utils.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'collision_block.dart';

enum PlayerDirection { left, right, up, down, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<EcoConscience>, KeyboardHandler {
  Player({super.position, super.size});

  final double stepTime = 0.10;
  final double moveSpeed = 150;
  final double headSpaceOffset = 18;

  PlayerDirection playerDirection = PlayerDirection.none;
  bool isRunning = false;
  List<CollisionBlock> collisionBlocks = [];
  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;
  double verticalMovement = 0;
  bool showControls = false;

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    add(RectangleHitbox());
    debugMode = kDebugMode;
    _loadAnims();
    _loadControls();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (game.playState == PlayState.playing ||
        game.playState == PlayState.showingToast) {
      horizontalMovement += isLeftKeyPressed ? -1 : 0;
      horizontalMovement += isRightKeyPressed ? 1 : 0;
      verticalMovement += isUpKeyPressed ? -1 : 0;
      verticalMovement += isDownKeyPressed ? 1 : 0;

      if (horizontalMovement == -1) {
        playerDirection = PlayerDirection.left;
      } else if (horizontalMovement == 1) {
        playerDirection = PlayerDirection.right;
      } else if (verticalMovement == -1) {
        playerDirection = PlayerDirection.up;
      } else if (verticalMovement == 1) {
        playerDirection = PlayerDirection.down;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;

    double newX = position.x + velocity.x * dt;
    double newY = position.y + velocity.y * dt;

    if (
        // _isWithinBoundaries(newX, newY) &&
        !_isInNoGoZone(newX, newY)) {
      position.x = newX;
      position.y = newY;
      game.currentMap.updateParallax(horizontalMovement);
    }

    if (velocity.x != 0 || velocity.y != 0) {
      isRunning = true;
    } else {
      isRunning = false;
    }
    current =
        '${isRunning ? 'running' : 'idle'}${getStringFromDirection(playerDirection)}';
  }

  void _loadAnims() {
    animations = {
      'idleLeft': _getPlayerAnim(PlayerDirection.left, false),
      'idleRight': _getPlayerAnim(PlayerDirection.right, false),
      'idleUp': _getPlayerAnim(PlayerDirection.up, false),
      'idleDown': _getPlayerAnim(PlayerDirection.down, false),
      'runningLeft': _getPlayerAnim(PlayerDirection.left, true),
      'runningRight': _getPlayerAnim(PlayerDirection.right, true),
      'runningUp': _getPlayerAnim(PlayerDirection.up, true),
      'runningDown': _getPlayerAnim(PlayerDirection.down, true),
    };

    // current animation
    current = 'idleDown';
  }

  _getPlayerAnim(PlayerDirection direction, bool isRunning) {
    final character = gameRef.buildContext?.read<GameProgressProvider>().character;
    int startFrame = getFrameBasedOnDirection(direction);
    return SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Characters/${character}_${isRunning ? 'run' : 'idle_anim'}_16x16.png'),
        SpriteAnimationData.range(
            start: startFrame,
            end: startFrame + 5,
            amount: 24,
            stepTimes: List.filled(6, stepTime),
            textureSize: Vector2(16, 32)));
  }

  // bool _isWithinBoundaries(double x, double y) {
  //   double minX = 0.0;
  //   double minY = 0.0;
  //   double maxX = game.worldDimensions.x;
  //   double maxY = game.worldDimensions.y;
  //
  //   return x >= minX && x <= maxX && y >= minY && y <= maxY;
  // }

  bool _isInNoGoZone(double newX, double newY) {
    for (CollisionBlock block in collisionBlocks) {
      double minX = block.x;
      double minY = block.y;
      double maxX = block.x + block.size.x;
      double maxY = block.y + block.size.y;

      if (newX < maxX &&
          newX + size.x > minX &&
          newY < maxY - headSpaceOffset &&
          newY + size.y > minY) {
        return true;
      }
    }
    return false;
  }

  void loadNextMap(String nextMapName, double nextSpawnX,
      {double? nextSpawnY, double? mapResMultiplier}) {
    collisionBlocks = [];
    game.loadMap(
        mapName: nextMapName,
        nextSpawnX: nextSpawnX,
        nextSpawnY: nextSpawnY,
        mapResMultiplier: mapResMultiplier ?? 1.0);
  }

  void _loadControls() async {
    try {
      showControls = Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      print(e.toString());
    }

    if (showControls) {
      game.overlays.add('buttonControls');
    }
  }
}
