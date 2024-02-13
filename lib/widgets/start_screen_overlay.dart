import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StartScreenOverlay extends StatefulWidget {
  const StartScreenOverlay({super.key, required this.game});

  final EcoConscience game;

  @override
  State<StartScreenOverlay> createState() => _StartScreenOverlayState();
}

class _StartScreenOverlayState extends State<StartScreenOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Center(
        child: Consumer<StartMenuProvider>(
          builder:
              (BuildContext context, StartMenuProvider value, Widget? child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<bool>(value.showMenu),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                width: double.infinity,
                height: double.infinity,
                color: value.showMenu
                    ? Colors.blueGrey.withOpacity(0.25)
                    : Colors.transparent,
                child: Column(
                  children: [
                    gradientText('Ecoshift\nChronicles'),
                    Expanded(
                      child: value.showMenu
                          ? Column(
                              children: [
                                textButton('Start', () async {
                                  await playClickSound(widget.game);
                                  /// player selection
                                  widget.game.overlays.remove(PlayState.startScreen.name);
                                  widget.game.overlays.add('playerSelection');
                                }),
                                textButton('Sounds ${widget.game.playSounds ? 'ON' : 'OFF'}',
                                        () async {
                                      await playClickSound(widget.game);
                                      widget.game.playSounds = !widget.game.playSounds;
                                      if (widget.game.playSounds) {
                                        FlameAudio.bgm.play(
                                            'Three-Red-Hearts-Penguin-Town.mp3',
                                            volume: widget.game.volume * 0.5);
                                      } else {
                                        FlameAudio.bgm.stop();
                                      }
                                      setState(() {});
                                    }),
                                textButton('About', () async {
                                  await playClickSound(widget.game);
                                  // credits
                                }),
                                textButton('Exit', () async {
                                  await playClickSound(widget.game);
                                  SystemNavigator.pop();
                                  exit(0);
                                }),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
