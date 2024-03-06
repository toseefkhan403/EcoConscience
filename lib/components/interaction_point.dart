import 'dart:async';
import 'dart:math';

import 'package:eco_conscience/components/player.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class InteractionPoint extends SpriteComponent
    with HasGameRef<EcoConscience>, CollisionCallbacks {
  InteractionPoint(
      {super.position,
      super.size,
      required this.hitBoxOffset,
      required this.storyArc});

  final Vector2 hitBoxOffset;
  final double stepTime = 0.12;
  final String storyArc;

  double amplitude = 2.5;
  double frequency = 6.0;
  double time = 0.0;
  double initialY = 0.0;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
        // position is the offset
        position: Vector2(hitBoxOffset.x, hitBoxOffset.y),
        size: size,
        collisionType: CollisionType.passive));
    // debugMode = kDebugMode;
    sprite = Sprite(game.images.fromCache('Interiors/exclamation_32x32.png'));
    initialY = position.y;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    time += dt;
    y = amplitude * sin(time * frequency) + initialY;
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.playState = PlayState.showingToast;
      game.overlays.add(PlayState.showingToast.name);
      game.currentStoryArc = storyArc;
      game.isStandingWithNpc = false;
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
