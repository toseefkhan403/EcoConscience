import 'dart:async';

import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/components.dart';

class NPC extends SpriteAnimationComponent
    with HasGameRef<EcoConscience> {
  NPC(
      {super.position,
        super.size,
        required this.npcName});

  final double stepTime = 0.12;
  final String npcName;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Characters/$npcName.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: stepTime, textureSize: Vector2(16, 32)));
    return super.onLoad();
  }
}
