import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/widgets/hyperlink_typewriter_animated_text.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

class AboutOverlay extends StatefulWidget {
  final EcoConscience game;

  const AboutOverlay({super.key, required this.game});

  @override
  State<AboutOverlay> createState() => _AboutOverlayState();
}

class _AboutOverlayState extends State<AboutOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
    super.initState();
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
    final locale = context.watch<LocaleProvider>().locale;
    AppLocalizations local = locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/Exteriors/skyline/longEvening.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gradientText(local.appTitle),
            const SizedBox(
              height: 10,
            ),
            typerWidget(
                text: local.developedBy,
                linkText: 'Toseef Ali Khan',
                link: 'https://www.linkedin.com/in/toseef-khan/',
                pause: 0),
            typerWidget(
                text: local.musicCredits,
                linkText: 'Abstraction',
                link: 'https://abstractionmusic.com/',
                pause: 1800),
            typerWidget(
                text: local.gameAssetsCredits,
                linkText: 'LimeZu',
                link: '',
                pause: 3500),
            textButton(
              local.exit,
              () async {
                await playClickSound(widget.game);
                widget.game.overlays.remove('about');
              },
            ),
          ],
        ),
      ),
    );
  }

  typerWidget(
      {required String text,
      required String link,
      required String linkText,
      required int pause}) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(''),
        HyperlinkTypewriterAnimatedText(
          text,
          link: link,
          linkText: linkText,
          textStyle: TextStyle(fontSize: widget.game.size.y < 600 ? 24 : 32),
        ),
      ],
      pause: Duration(milliseconds: pause),
      isRepeatingAnimation: false,
    );
  }
}
