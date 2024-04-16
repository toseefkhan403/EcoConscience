import 'package:eco_conscience/components/player.dart';
import 'package:flutter/material.dart';

int getFrameBasedOnDirection(PlayerDirection direction) {
  switch (direction) {
    case PlayerDirection.left:
      return 12;
    case PlayerDirection.right:
      return 0;
    case PlayerDirection.up:
      return 6;
    case PlayerDirection.down:
    case PlayerDirection.none:
      return 18;
  }
}

String getStringFromDirection(PlayerDirection direction) {
  switch (direction) {
    case PlayerDirection.left:
      return 'Left';
    case PlayerDirection.right:
      return 'Right';
    case PlayerDirection.up:
      return 'Up';
    case PlayerDirection.down:
    case PlayerDirection.none:
      return 'Down';
  }
}

Color getBgColorBasedOnEcoMeter(int ecoMeter) {
  switch (ecoMeter) {
    case 80:
      return const Color(0x8B86D2EF);
    case 60:
      return const Color(0x936FC098);
    case 40:
      return const Color(0x8EBCD379);
    case 20:
      return const Color(0x9DC49A70);
    case 0:
      return const Color(0x8B7A0909);
    default:
      return const Color(0x5A86D2EF);
  }
}
