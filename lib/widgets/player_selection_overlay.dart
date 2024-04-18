import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

import '../providers/locale_provider.dart';

class PlayerSelectionOverlay extends StatefulWidget {
  const PlayerSelectionOverlay({Key? key, required this.game})
      : super(key: key);

  final EcoConscience game;

  @override
  State<PlayerSelectionOverlay> createState() => _PlayerSelectionOverlayState();
}

class _PlayerSelectionOverlayState extends State<PlayerSelectionOverlay>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final List<String> characterSkins = ['Adam', 'Alex', 'Amelia', 'Bob'];
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  int characterSkinsIndex = 0;
  late AppLocalizations _local;

  static final RegExp alphanumericWithJapanese =
      RegExp(r'^[a-zA-Z0-9\u3040-\u309F\u30A0-\u30FF]+$');

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final localeProvider = context.read<LocaleProvider>();
    _local = localeProvider.locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            height > 500 ? gradientText(_local.playerSelection) : Container(),
            brownContainer(
              width: width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        label: 'Change character',
                        child: SpriteButton(
                          sprite: Sprite(
                              widget.game.images.fromCache('HUD/arrow_l.png')),
                          pressedSprite: Sprite(widget.game.images
                              .fromCache('HUD/arrow_l_pressed.png')),
                          width: 40,
                          height: 60,
                          onPressed: () {
                            playClickSound(widget.game);
                            if (characterSkinsIndex == 0) {
                              characterSkinsIndex = characterSkins.length - 1;
                            } else {
                              characterSkinsIndex--;
                            }
                            setState(() {});
                          },
                          label: const Text(''),
                        ),
                      ),
                      Expanded(
                        child: animatedPlayerWidget(
                            height * 0.4, characterSkins[characterSkinsIndex]),
                      ),
                      Semantics(
                        label: 'Change character',
                        child: SpriteButton(
                          sprite: Sprite(
                              widget.game.images.fromCache('HUD/arrow_r.png')),
                          pressedSprite: Sprite(widget.game.images
                              .fromCache('HUD/arrow_r_pressed.png')),
                          width: 40,
                          height: 60,
                          onPressed: () {
                            playClickSound(widget.game);
                            if (characterSkinsIndex ==
                                characterSkins.length - 1) {
                              characterSkinsIndex = 0;
                            } else {
                              characterSkinsIndex++;
                            }
                            setState(() {});
                          },
                          label: const Text(''),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Semantics(
                      label: 'Enter your name',
                      textField: true,
                      child: TextFormField(
                        key: formFieldKey,
                        controller: _textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Arcade-In',
                          fontSize: 30,
                        ),
                        decoration: InputDecoration(
                          hintText: _local.enterName,
                          hintStyle: TextStyle(
                            fontFamily: localeProvider.getFontFamily(
                              englishFont: 'Arcade-In',
                            ),
                            fontSize: 30,
                          ),
                          errorStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: localeProvider.getFontFamily(),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _local.pleaseEnterName;
                          }
                          if (value.length < 3 || value.length > 12) {
                            return _local.validationText1;
                          }
                          if (!alphanumericWithJapanese.hasMatch(value)) {
                            return _local.validationText2;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Play button',
                    child: SpriteButton(
                      sprite: Sprite(
                          widget.game.images.fromCache('HUD/play_button.png')),
                      pressedSprite: Sprite(widget.game.images
                          .fromCache('HUD/play_button_pressed.png')),
                      width: 180,
                      height: 50,
                      onPressed: () async {
                        final provider = context.read<GameProgressProvider>();
                        await playClickSound(widget.game);
                        if (formFieldKey.currentState!.validate()) {
                          provider.savePlayerInfo(
                              characterSkins[characterSkinsIndex],
                              _textController.text.trim());

                          _controller.reverse().then((_) {
                            widget.game.overlays.remove('playerSelection');
                            widget.game.currentStoryArc =
                                StoryTitles.introArc.name;
                            FlameAudio.bgm.stop();
                            widget.game.startStoryArc();
                          });
                        }
                      },
                      label: const Text(''),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
