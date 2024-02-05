import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

Widget animatedPlayerWidget(double gameHeight, String character) => Align(
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

Widget brownContainer({Widget? child, double? width, double? height}) =>
    Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xffd0be9c),
        border: Border.all(
          color: const Color(0xffb5754d),
          width: 6.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 3,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: child,
    );

Widget gradientText(String text) => Expanded(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.orange, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: '4B30',
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
