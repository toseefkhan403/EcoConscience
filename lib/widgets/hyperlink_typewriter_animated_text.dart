import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HyperlinkTypewriterAnimatedText extends AnimatedText {
  final Duration speed;

  final Curve curve;
  final String linkText;
  final String link;

  HyperlinkTypewriterAnimatedText(
    String text, {
    TextAlign textAlign = TextAlign.center,
    TextStyle? textStyle,
    this.speed = const Duration(milliseconds: 80),
    required this.linkText,
    required this.link,
    this.curve = Curves.linear,
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: speed * (text.characters.length),
        );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed * (textCharacters.length - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget completeText(BuildContext context) => Semantics(
        label: 'game credits external link',
        link: true,
        child: AutoSizeText.rich(
          TextSpan(
            children: [
              TextSpan(text: text),
              TextSpan(
                text: linkText,
                style: DefaultTextStyle.of(context)
                    .style
                    .merge(textStyle)
                    .copyWith(
                        color: const Color(0xff0a66c2), fontFamily: '4B30'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    openLink(link);
                  },
              ),
            ],
            style: DefaultTextStyle.of(context).style.merge(textStyle),
          ),
          textAlign: textAlign,
        ),
      );

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final typewriterValue =
        (_typewriterText.value.clamp(0, 1) * (textCharacters.length)).round();

    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(text: visibleString),
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textAlign: textAlign,
    );
  }
}
