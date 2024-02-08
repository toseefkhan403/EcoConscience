import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/components/story_progress.dart' as eco;
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flutter/material.dart';

class DialogTypewriterAnimatedText extends AnimatedText {
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  final eco.MsgFormat msg;

  final Function(bool isAccepted)? acceptedOrRejectedCallback;

  DialogTypewriterAnimatedText(
    String text,
    this.msg, {
    TextAlign textAlign = TextAlign.center,
    TextStyle? textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.acceptedOrRejectedCallback,
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: speed * text.characters.length,
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
  Widget completeText(BuildContext context) {
    final dialogBoxWidth = MediaQuery.of(context).size.width;
    final dialogBoxHeight = MediaQuery.of(context).size.height / 5;

    return Column(
      children: [
        const Spacer(),
        _characterRow(dialogBoxHeight),
        brownContainer(
          width: dialogBoxWidth,
          height: dialogBoxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AutoSizeText(
                    text,
                    maxLines: 2,
                    textAlign: textAlign,
                    style: DefaultTextStyle.of(context)
                        .style
                        .merge(textStyle)
                        .copyWith(fontSize: dialogBoxHeight * 0.25),
                  ),
                ),
              ),
              msg.choices == null
                  ? Container()
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (acceptedOrRejectedCallback != null) {
                                acceptedOrRejectedCallback!(true);
                              }
                            },
                            child: AutoSizeText(
                              msg.choices![0],
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .merge(textStyle)
                                  .copyWith(color: Colors.green),
                              textAlign: textAlign,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (acceptedOrRejectedCallback != null) {
                                acceptedOrRejectedCallback!(false);
                              }
                            },
                            child: AutoSizeText(
                              msg.choices![1],
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .merge(textStyle)
                                  .copyWith(color: Colors.red),
                              textAlign: textAlign,
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final typewriterValue =
        (_typewriterText.value.clamp(0, 1) * (textCharacters.length)).round();

    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    final dialogBoxWidth = MediaQuery.of(context).size.width;
    final dialogBoxHeight = MediaQuery.of(context).size.height / 5;

    return Column(
      children: [
        const Spacer(),
        _characterRow(dialogBoxHeight),
        brownContainer(
          width: dialogBoxWidth,
          height: dialogBoxHeight,
          child: AutoSizeText(
            visibleString,
            maxLines: 2,
            textAlign: textAlign,
            style: DefaultTextStyle.of(context)
                .style
                .merge(textStyle)
                .copyWith(fontSize: dialogBoxHeight * 0.25),
          ),
        ),
      ],
    );
  }

  _characterRow(double dialogBoxHeight) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            msg.character == eco.Characters.angel || msg.choices != null
                ? Image.asset(
                    'assets/images/Characters/angel_dialog.png',
                    width: dialogBoxHeight,
                    fit: BoxFit.cover,
                  )
                : Container(),
            msg.character == eco.Characters.demon || msg.choices != null
                ? Image.asset(
                    'assets/images/Characters/demon_dialog.png',
                    width: dialogBoxHeight,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ],
        ),
      );
}
