import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

animatedPlayerWidget(double gameHeight, String character) => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: gameHeight / 4,
      height: (gameHeight / 4) * 2,
      margin: EdgeInsets.only(bottom: gameHeight / 5),
      child: SpriteAnimationWidget.asset(
        playing: true,
        anchor: Anchor.center,
        path: 'Characters/${character}_idle_anim_16x16.png',
        data: SpriteAnimationData.range(
            start: 18,
            end: 18 + 5,
            amount: 24,
            stepTimes: List.filled(6, 0.1),
            textureSize: Vector2(16, 32)),
      ),
    ));
