import 'dart:io';

import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  bool showJoystick = false;
  try {
    showJoystick = Platform.isAndroid || Platform.isIOS;
  } catch(e) {
    print('stupid error');
  }
  runApp(GameWidget(game: EcoConscience(showJoystick: showJoystick)));
}
