enum StoryTitles {
  introArc,
  bathroomArc,
  houseLightsArc,
  busToOfficeArc,
  officePlantationArc,
  tacoArc
}

enum Characters { player, angel, demon }

class StoryProgress {
  static late final Map<String, bool> allStoryArcsProgress;
  static late final Map<String, List<MsgFormat>> gameStories;
  static late final Map<String, List<MsgFormat>> gameLessons;
  static bool isHouseLightsOn = true;

  static init() {
    gameStories = {
      StoryTitles.introArc.name: [
        MsgFormat(
            'In a world where every choice echoes through the fabric of existence, you hold the power to shape the destiny of this realm. Welcome to the EcoShift Chronicles, where your decisions influence the harmony or discord of this world.',
            character: Characters.angel),
        MsgFormat(
            "Ah, welcome to the playground of choices! The EcoShift Chronicles await, where every decision holds consequences. But who says you always have to be the hero? Why not embrace the dark side of choices?",
            character: Characters.demon),
        MsgFormat(
            'Embrace the path of balance and watch as the world transforms into a harmonious paradise.',
            character: Characters.angel),
      ],
      StoryTitles.bathroomArc.name: [
        MsgFormat(
            '[You start to brush your teeth and forgot to turn off the tap]'),
        MsgFormat(
            'Hey there, buddy! What\'s a little water waste, right? Convenience is key!',
            character: Characters.demon),
        MsgFormat(
            "Hello, dear! Consider the environment. Turning off the tap while brushing your teeth can save so much water. It's a small gesture, but it makes a big difference.",
            character: Characters.angel),
        MsgFormat(
            "Ugh, really? You're going to obsess over every drop of water? Come on, it's just a little thing. Who cares?",
            character: Characters.demon),
        MsgFormat(
            "Every drop counts, my friend. Conserving water is crucial for the health of our planet. We should not contribute to unnecessary waste.",
            character: Characters.angel),
        MsgFormat("Will you turn off the tap?", choices: ['Yes', 'No']),
      ],
      StoryTitles.houseLightsArc.name: [
        MsgFormat(
            "Turning off unnecessary lights is a simple act that conserves energy. Let's be mindful of our resources and help create a more sustainable world.",
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
        MsgFormat("Will you turn off the unnecessary lights?",
            choices: ["Yes", "No"]),
      ],
      StoryTitles.busToOfficeArc.name: [
        MsgFormat(
            "[You need to commute to your office - will you choose your car or the bus?]"),
        MsgFormat(
            "Come on, why bother with the bus? Your own car is way more convenient and comfortable. Plus, who wants to deal with strangers and their germs?",
            character: Characters.demon),
        MsgFormat(
            "Choosing the bus is a great way to reduce your carbon footprint. It's more sustainable, reduces traffic, and can be a chance to meet new people.",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're going to cram yourself into a bus with strangers? Who cares about a little extra emissions?",
            character: Characters.demon),
        MsgFormat(
            "Every small choice matters. By driving your car, you contribute to traffic and air pollution. Let's strive for a more eco-friendly commute.",
            character: Characters.angel),
        MsgFormat("What do you choose?", choices: ["Bus", "Car"]),
      ],
      StoryTitles.tacoArc.name: [
        MsgFormat("[You ate a Taco]"),
        MsgFormat(
            "Hey, toss that taco wrapper wherever! Who cares about a little litter?",
            character: Characters.demon),
        MsgFormat(
            "Oh no, let's not litter. Proper disposal is essential. Use the dustbin to keep our surroundings clean and protect the environment.",
            character: Characters.angel),
        MsgFormat(
            "Seriously? It's just a taco wrapper. What harm can it do lying around for a bit?",
            character: Characters.demon),
        MsgFormat(
            "Every piece of litter contributes to pollution. By using the dustbin, you show respect for your environment and set a positive example.",
            character: Characters.angel),
        MsgFormat("Will you use the dustbin?", choices: ["Yes", "No"]),
      ],
      StoryTitles.officePlantationArc.name: [
        MsgFormat(
            "[Your colleagues are going on a tree plantation activity and want you to join]"),
        MsgFormat(
            "Tree planting? How cliché. Why bother with dirt and sweat when you could be doing something more fun?",
            character: Characters.demon),
        MsgFormat(
            "What a wonderful opportunity! Joining your colleagues for a tree plantation activity can make a positive impact on the environment!",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're actually going to waste your time planting trees? Do you really think one sapling is going to make a difference?",
            character: Characters.demon),
        MsgFormat(
            "Every tree planted is a step toward a greener future. By participating, you're contributing to a positive change in the local ecosystem.",
            character: Characters.angel),
        MsgFormat("Will you join the tree plantation activity?",
            choices: ["Yes", "No"]),
      ]
    };

    gameLessons = {
      'false${StoryTitles.introArc.name}': [
        MsgFormat(
            'Or revel in chaos and witness the town succumb to the consequences of indulgence. The choice is yours.',
            character: Characters.demon),
      ],
      'true${StoryTitles.bathroomArc.name}': [
        MsgFormat(
            "Thank you! Small actions like these contribute to water conservation.",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're not going to win any popularity contests by being a water-saving hero. It's just a drop in the ocean, literally!",
            character: Characters.demon),
        MsgFormat(
            "Every drop ripples, my friend. By making conscious choices, you inspire others to do the same!",
            character: Characters.angel),
      ],
      'false${StoryTitles.bathroomArc.name}': [
        MsgFormat(
            "A little water down the drain won't hurt anyone. We're not living in a drought, are we?",
            character: Characters.demon),
        MsgFormat(
            "It might be a drop, but every drop adds up. Conserving water is a responsibility we all share. Let's make choices that benefit not just us, but the entire ecosystem",
            character: Characters.angel),
      ],
      'true${StoryTitles.houseLightsArc.name}': [
        MsgFormat(
            "Well done! Your choice to switch off the lights is commendable. It not only saves energy but also helps create a more sustainable living environment.",
            character: Characters.angel),
      ],
      'false${StoryTitles.houseLightsArc.name}': [
        MsgFormat(
            "Ah, who cares about a few extra kilowatts? It's not like the environment can feel the burn!",
            character: Characters.demon),
        MsgFormat(
            "It's disappointing to see the lights left on. Wasting energy has consequences, and unfortunately, our environment pays the price.",
            character: Characters.angel),
      ],
      'true${StoryTitles.busToOfficeArc.name}': [
        MsgFormat(
            "Congratulations on choosing the bus! Public transportation is an excellent choice for a cleaner and more sustainable commute.",
            character: Characters.angel),
        MsgFormat(
            "Fine, be the bus adventurer. I hope you enjoy the extra time it takes, not to mention the inconvenience.",
            character: Characters.demon),
        MsgFormat(
            "The bus may take a bit longer, but the environmental benefits and reduced stress on the road are worth it!",
            character: Characters.angel),
      ],
      'false${StoryTitles.busToOfficeArc.name}': [
        MsgFormat(
            "Ah, the freedom of your own car! No need to wait for that crowded bus. Who cares about a little extra pollution, right?",
            character: Characters.demon),
      ],
      'true${StoryTitles.tacoArc.name}': [
        MsgFormat(
            "Well done! Choosing to use the dustbin helps maintain a clean environment. Small actions like these make a big difference.",
            character: Characters.angel),
      ],
      'false${StoryTitles.tacoArc.name}': [
        MsgFormat(
            "Who wants to be the neat freak? It's just one wrapper; the world won't end.",
            character: Characters.demon),
        MsgFormat(
            "Unfortunately, by littering, you've added to the pollution. Let's strive to keep our world clean by using the dustbin.",
            character: Characters.angel),
      ],
      'true${StoryTitles.officePlantationArc.name}': [
        MsgFormat(
            "Well done! Your choice to join the tree plantation activity is commendable. It's these collective efforts that lead to a more sustainable and beautiful world.",
            character: Characters.angel),
      ],
      'false${StoryTitles.officePlantationArc.name}': [
        MsgFormat(
            "It's disheartening to see the missed opportunity. Tree planting has a cascading positive effect on the environment, and your participation could have made a significant difference.",
            character: Characters.angel),
        MsgFormat("Never mind, you can now do something more enjoyable.",
            character: Characters.demon),
        MsgFormat(
            "Enjoyment is subjective, but the positive impact of tree planting is undeniable. Let's strive to make choices that benefit both us and the world around us.",
            character: Characters.angel),
      ],
    };

    allStoryArcsProgress = {
      StoryTitles.introArc.name: false,
      StoryTitles.bathroomArc.name: false,
      StoryTitles.houseLightsArc.name: false,
      StoryTitles.busToOfficeArc.name: false,
      StoryTitles.officePlantationArc.name: false,
      StoryTitles.tacoArc.name: false,
    };
  }
}

class MsgFormat {
  final String msg;
  final Characters? character;
  final List<String>? choices;

  MsgFormat(this.msg, {this.character, this.choices});
}
