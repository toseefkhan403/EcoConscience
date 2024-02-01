import 'dart:async';

import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/components.dart';

class OtherInteractionPoint extends SpriteAnimationComponent
    with HasGameRef<EcoConscience> {
  OtherInteractionPoint(
      {super.position,
        super.size,
        required this.imageName});

  final double stepTime = 0.12;
  final String imageName;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Interiors/32x32/$imageName.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: stepTime, textureSize: Vector2(32, 32)));
    return super.onLoad();
  }
}
