import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/eco_meter_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PauseMenuOverlay extends StatefulWidget {
  const PauseMenuOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  State<PauseMenuOverlay> createState() => _PauseMenuOverlayState();
}

class _PauseMenuOverlayState extends State<PauseMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final ecoMeter = context.watch<EcoMeterProvider>().ecoMeter;

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: brownContainer(
          width: width,
          height: width,
          child: Column(
            children: [
              gradientText('Pause'),
              ecoMeterWidget(ecoMeter, width),
              const SizedBox(
                height: 10,
              ),
              textButton('Resume', () async {
                await playClickSound(widget.game);
                widget.game.overlays.remove('pauseMenu');
                widget.game.resumeEngine();
              }, color: Colors.brown),
              textButton('Sounds ${widget.game.playSounds ? 'ON' : 'OFF'}',
                  () async {
                await playClickSound(widget.game);
                widget.game.playSounds = !widget.game.playSounds;
                if (widget.game.playSounds) {
                  FlameAudio.bgm.play(
                      'Three-Red-Hearts-${getTuneBasedOnEcoMeter(ecoMeter)}.mp3',
                      volume: widget.game.volume * 0.5);
                } else {
                  FlameAudio.bgm.stop();
                }
                setState(() {});
              }, color: Colors.brown),
              textButton('About', () async {
                await playClickSound(widget.game);
                // credits
              }, color: Colors.brown),
              textButton('Exit', () async {
                await playClickSound(widget.game);
                SystemNavigator.pop();
                exit(0);
              }, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  ecoMeterWidget(int ecoMeter, double size) {
    final boxHeight = size * 0.15;
    final int fillValue = 100 - ecoMeter;
    double spread = 0.1;
    if (fillValue == 0 || fillValue == 100) {
      spread = 0;
    }
    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.brown.withOpacity(0.7)
          ],
          stops: [fillValue / 100 - spread, fillValue / 100 + spread],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: boxHeight * 0.5,
              height: boxHeight * 0.5,
              child: SpriteWidget.asset(path: 'HUD/Earth.png')),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: AutoSizeText(
              getMsgBasedOnEcoMeter(ecoMeter),
              maxLines: 2,
              style: const TextStyle(fontSize: 32, color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
