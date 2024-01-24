import 'package:eco_conscience/components/player.dart';

int getFrameBasedOnDirection(PlayerDirection direction) {
  switch(direction) {
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
  switch(direction) {
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
