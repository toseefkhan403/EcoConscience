import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/eco_meter_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final ecoMeter = context.watch<EcoMeterProvider>().ecoMeter;

    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: brownContainer(
            width: width,
            height: width,
            child: Column(
              children: [
                gradientText('Game Over'),
                const SizedBox(
                  height: 12,
                ),
                // cards widget

                // verdict widget
                verdictWidget(ecoMeter, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  verdictWidget(int ecoMeter, double size) {
    final boxHeight = size * 0.15;
    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.7),
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
              getGameOverMsgBasedOnEcoMeter(ecoMeter),
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
