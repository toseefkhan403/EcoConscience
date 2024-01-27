import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class InteractionPoint extends SpriteAnimationComponent
    with HasGameRef<EcoConscience>, CollisionCallbacks {
  InteractionPoint(
      {super.position,
      super.size,
      required this.hitBoxOffset,
      required this.storyArc});

  final Vector2 hitBoxOffset;
  final double stepTime = 0.12;
  final String storyArc;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
        // position is the offset
        position: Vector2(hitBoxOffset.x, hitBoxOffset.y),
        size: size,
        collisionType: CollisionType.passive));
    debugMode = kDebugMode;
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Interiors/32x32/mail_32x64.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: stepTime, textureSize: Vector2(32, 64)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.toastMsg = "[Tap to continue]";
      game.playState = PlayState.showingToast;
      game.overlays.add(PlayState.showingToast.name);
      game.currentStoryArc = storyArc;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      game.playState = PlayState.playing;
      game.overlays.remove(PlayState.showingToast.name);
    }
    super.onCollisionEnd(other);
  }
}
