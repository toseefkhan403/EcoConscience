import 'dart:async';

import 'package:eco_conscience/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class InteractionPoint extends PositionComponent with CollisionCallbacks {
  InteractionPoint({super.position, super.size}) {
    // debugMode = true;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(collisionType: CollisionType.passive));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      other.interact();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
