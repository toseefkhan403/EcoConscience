import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class OtherInteractionPoint extends SpriteAnimationComponent
    with HasGameRef<EcoConscience>, CollisionCallbacks {
  OtherInteractionPoint({super.position, super.size, required this.imageName});

  final double stepTime = 0.12;
  final String imageName;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Interiors/$imageName.png'),
        SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: stepTime,
            textureSize: Vector2(size.x, size.y)));
    add(RectangleHitbox(collisionType: CollisionType.passive));
    debugMode = kDebugMode;
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.playState = PlayState.showingToast;
      game.overlays.add(PlayState.showingToast.name);
      game.isStandingWithNpc = true;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      game.playState = PlayState.playing;
      game.overlays.remove(PlayState.showingToast.name);
      game.isStandingWithNpc = false;
    }
    super.onCollisionEnd(other);
  }
}
