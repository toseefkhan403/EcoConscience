final Map<String, List<MsgFormat>> gameStories = {
  'bathroomArc': [
    MsgFormat('You start to brush your teeth'),
    MsgFormat('Hey! You should turn off the tap, shouldn\'t you?',
        character: Characters.angel),
    MsgFormat("Cmon, few minutes won't hurt anybody",
        character: Characters.demon),
    MsgFormat("You should do what is correct", character: Characters.angel),
    MsgFormat(
        "Or maybe not? Who cares! Billions of people don't. Why should you?",
        character: Characters.demon),
    MsgFormat("Will you turn off the tap?", choices: ['Yes', 'No']),
  ],
  'busToOfficeArc': [
    MsgFormat('msg'),
  ],
};

final Map<String, List<LessonPageFormat>> gameLessons = {
  'truebathroomArc': [
    LessonPageFormat(
        "Your action helped the environment! You had a big impact!",
        'assets/images/lessons/bathroomImpact1.png',
        character: Characters.angel),
    LessonPageFormat("If every day you do so, you can save Earth!",
        'assets/images/lessons/bathroomImpact1.png',
        character: Characters.angel),
  ],
  'falsebathroomArc': [
    LessonPageFormat(
        "You monster!", 'assets/images/lessons/bathroomImpact1.png',
        character: Characters.angel),
    LessonPageFormat(
        "You didn't save Earth!", 'assets/images/lessons/bathroomImpact1.png',
        character: Characters.angel),
  ],
};

enum Characters { player, angel, demon }

class MsgFormat {
  final String msg;
  final Characters? character;
  final List<String>? choices;

  MsgFormat(this.msg, {this.character, this.choices});
}

class LessonPageFormat {
  final String msg;
  final String imgPath;
  final Characters? character;

  LessonPageFormat(this.msg, this.imgPath, {this.character});
}
