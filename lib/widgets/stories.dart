final Map<String, bool> allStoryArcs = {
  'bathroomArc': false,
  'houseLightsArc': false,
  'busToOfficeArc': false,
  'officePlantationArc': false,
  'groceryArc': false,
};

final Map<String, List<MsgFormat>> gameStories = {
  'bathroomArc': [
    MsgFormat('[You start to brush your teeth]'),
    MsgFormat(
        'Hey there, buddy! Forget about turning off the tap while brushing your teeth. What\'s a little water waste, right? Convenience is key!',
        character: Characters.demon),
    MsgFormat(
        "Hello, dear! Consider the environment. Turning off the tap while brushing your teeth can save so much water. It's a small gesture, but it makes a big difference.",
        character: Characters.angel),
    MsgFormat(
        "Ugh, really? You're going to be that person who obsesses over every drop of water? Come on, it's just a little thing. Who cares?",
        character: Characters.demon),
    MsgFormat(
        "Every drop counts, my friend. Conserving water is crucial for the health of our planet. It's disheartening to see us contribute to unnecessary waste.",
        character: Characters.angel),
    MsgFormat("Will you turn off the tap?", choices: ['Yes', 'No']),
  ],
  'houseLightsArc': [
    MsgFormat(
        "Hey! Aren't you forgetting something? Turning off the lights before leaving is a simple act that conserves energy. Let's be mindful of our resources and help create a more sustainable world.",
        character: Characters.angel),
    MsgFormat(
        "Seriously? It's just a couple of light bulbs. Leave them on; it's not like the planet will miss a few watts.",
        character: Characters.demon),
    MsgFormat(
        "Every bit of energy we save counts. By turning off the lights, you're playing a part in reducing our carbon footprint.",
        character: Characters.angel),
    MsgFormat(
        "Fine, be the energy-saving champion. I bet the darkness brings you so much joy.",
        character: Characters.demon),
    MsgFormat("Will you turn off the lights before leaving?",
        choices: ["Yes", "No"]),
  ],
};

final Map<String, List<MsgFormat>> gameLessons = {
  'truebathroomArc': [
    MsgFormat(
        "Congratulations on choosing to turn off the tap while brushing your teeth! Small actions like these contribute to water conservation.",
        character: Characters.angel),
    MsgFormat(
        "Seriously? You're not going to win any popularity contests by being a water-saving hero. It's just a drop in the ocean, literally!",
        character: Characters.demon),
    MsgFormat(
        "Every drop ripples, my friend. By making conscious choices, you inspire others to do the same. Let's continue to make a positive impact on the environment!",
        character: Characters.angel),
  ],
  'falsebathroomArc': [
    MsgFormat(
        "A little water down the drain won't hurt anyone. We're not living in a drought, are we?",
        character: Characters.demon),
    MsgFormat(
        "It might be a drop, but every drop adds up. Conserving water is a responsibility we all share. Let's make choices that benefit not just us, but the entire ecosystem",
        character: Characters.angel),
  ],
  'truehouseLightsArc': [
    MsgFormat(
        "Well done! Your choice to switch off the lights is commendable. It not only saves energy but also helps create a more sustainable living environment.",
        character: Characters.angel),
    MsgFormat(
        "Keep playing the energy-saving game if it makes you happy. But let's be real, it's just a drop in the power grid.",
        character: Characters.demon),
    MsgFormat(
        "Every drop, or in this case, every watt, matters. Conserving energy is a collective effort, and your choice contributes to a more sustainable world.",
        character: Characters.angel),
  ],
  'falsehouseLightsArc': [
    MsgFormat(
        "It's disappointing to see the lights left on. Wasting energy has consequences, and unfortunately, our environment pays the price.",
        character: Characters.angel),
    MsgFormat(
        "Who cares about a few extra kilowatts? It's not like the environment can feel the burn.",
        character: Characters.demon),
    MsgFormat(
        "Our environment does feel the impact of our choices. By not turning off the lights, we contribute to unnecessary energy consumption and its negative effects.",
        character: Characters.angel),
  ]
};

enum Characters { player, angel, demon }

class MsgFormat {
  final String msg;
  final Characters? character;
  final List<String>? choices;

  MsgFormat(this.msg, {this.character, this.choices});
}
