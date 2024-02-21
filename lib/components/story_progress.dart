import '../eco_conscience.dart';

enum StoryTitles {
  introArc,
  bathroomArc,
  houseLightsArc,
  busToOfficeArc,
  officePlantationArc,
  tacoArc
}

class StoryProgress {
  static late final Map<String, bool> allStoryArcsProgress;
  static late final Map<String, List<MsgFormat>> gameStories;
  static late final Map<String, List<MsgFormat>> gameLessons;
  static late final Map<int, List<MsgFormat>> npcDialogs;
  static bool isHouseLightsOn = true;

  static init() {
    gameStories = {
      StoryTitles.introArc.name: [
        MsgFormat(
            'In a world where every choice echoes through the fabric of existence, you hold the power to shape the destiny of this realm. Welcome to the EcoShift Chronicles, where your decisions influence the harmony or discord of this world.',
            'ここは選択の影響が存在の織りなす世界。あなたはこの領域の運命を形作る力を持っています。エコシフト・クロニクルへようこそ。あなたの決断がこの世界の調和または不和に影響を与えます。',
            character: Characters.angel),
        MsgFormat(
            "Ah, welcome to the playground of choices! The EcoShift Chronicles await, where every decision holds consequences. But who says you always have to be the hero? Why not embrace the dark side of choices?",
            "ああ、選択の遊び場へようこそ！エコシフト・クロニクルが待っています。ここではすべての決断には結果が伴います。しかし、いつもヒーローである必要があると誰が言いますか？なぜ暗い選択の側面を受け入れないのですか？",
            character: Characters.demon),
        MsgFormat(
            'Embrace the path of balance and watch as the world transforms into a harmonious paradise.',
            'バランスの道を受け入れ、世界が調和の楽園に変わるのを見守ってください。',
            character: Characters.angel),
      ],
      StoryTitles.bathroomArc.name: [
        MsgFormat(
            '[You start to brush your teeth and forgot to turn off the tap]',
            '[歯を磨き始め、蛇口を閉め忘れてしまいました]'),
        MsgFormat(
            'Hey there, buddy! What\'s a little water waste, right? Convenience is key!',
            'やあ、友よ！ちょっとの水の無駄はどうだろう？便利さが重要だよね。',
            character: Characters.demon),
        MsgFormat(
            "Hello, dear! Consider the environment. Turning off the tap while brushing your teeth can save so much water. It's a small gesture, but it makes a big difference.",
            "こんにちは、親愛なる人よ！環境を考えてみて。歯を磨くときに蛇口を閉めることで、たくさんの水を節約できます。小さなジェスチャーですが、大きな違いを生み出します。",
            character: Characters.angel),
        MsgFormat(
            "Ugh, really? You're going to obsess over every drop of water? Come on, it's just a little thing. Who cares?",
            "うーん、本当に？君は本当にすべての水滴にこだわるつもりなのか？さあ、それはちょっとしたことだよ。誰が気にするんだ？",
            character: Characters.demon),
        MsgFormat(
            "Every drop counts, my friend. Conserving water is crucial for the health of our planet. We should not contribute to unnecessary waste.",
            "すべての水滴が重要だよ、友よ。水を節約することは地球の健康にとって不可欠だ。無駄な浪費に寄与すべきではない。",
            character: Characters.angel),
        MsgFormat("Will you turn off the tap?", '蛇口を閉めてもらえますか？',
            choicesEn: ['Yes', 'No'], choicesJa: ['はい', 'いいえ']),
      ],
      StoryTitles.houseLightsArc.name: [
        MsgFormat(
            "Turning off unnecessary lights is a simple act that conserves energy. Let's be mindful of our resources and help create a more sustainable world.",
            "不必要な明かりを消すことは、エネルギーを節約する簡単な行為です。私たちは資源に気を付け、より持続可能な世界を築く手助けをしましょう。",
            character: Characters.angel),
        MsgFormat(
            "Seriously? It's just a couple of light bulbs. Leave them on; it's not like the planet will miss a few watts.",
            "本気で？たった数個の電球だよ。つけたままにしておいても、まるで地球が数ワット足りなくなるわけじゃないよ。",
            character: Characters.demon),
        MsgFormat(
            "Every bit of energy we save counts. By turning off the lights, you're playing a part in reducing our carbon footprint.",
            "私たちが節約するエネルギーはすべて重要です。明かりを消すことで、あなたは私たちの炭素排出量の削減に一役買っています。",
            character: Characters.angel),
        MsgFormat(
            "Fine, be the energy-saving champion. I bet the darkness brings you so much joy.",
            "いいよ、エネルギー節約のチャンピオンになってくれ。暗闇が君にたくさんの喜びをもたらすことだろう。",
            character: Characters.demon),
        MsgFormat(
            "Will you turn off the unnecessary lights?", '不要な照明を消してくれませんか？',
            choicesEn: ["Yes", "No"], choicesJa: ['はい', 'いいえ']),
      ],
      StoryTitles.busToOfficeArc.name: [
        MsgFormat(
            "[You need to commute to your office - will you choose your car or the bus?]",
            "[オフィスへ通勤する必要があります - あなたは自分の車を選びますか、それともバスを選びますか？]"),
        MsgFormat(
            "Come on, why bother with the bus? Your own car is way more convenient and comfortable. Plus, who wants to deal with strangers and their germs?",
            "さあ、なぜバスで悩む必要があるの？あなた自身の車のほうがずっと便利で快適だよ。それに、誰が見知らぬ人たちや彼らの細菌と付き合いたいと思うだろう？",
            character: Characters.demon),
        MsgFormat(
            "Choosing the bus is a great way to reduce your carbon footprint. It's more sustainable, reduces traffic, and can be a chance to meet new people.",
            "バスを選ぶことは炭素排出量を減らす素晴らしい方法です。それはより持続可能で、交通渋滞を減少させ、新しい人に会うチャンスにもなります。",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're going to cram yourself into a bus with strangers? Who cares about a little extra emissions?",
            "本気で？見知らぬ人たちと一緒にバスに詰め込むつもりなの？ちょっとした追加の排出物なんて誰も気にしないよ。",
            character: Characters.demon),
        MsgFormat(
            "Every small choice matters. By driving your car, you contribute to traffic and air pollution. Let's strive for a more eco-friendly commute.",
            "すべての小さな選択が重要です。車で通勤することで、あなたは交通渋滞や大気汚染に寄与します。よりエコフレンドリーな通勤を目指しましょう。",
            character: Characters.angel),
        MsgFormat("What do you choose?", "あなたは何を選びますか？",
            choicesEn: ["Bus", "Car"], choicesJa: ["バス", "車"]),
      ],
      StoryTitles.tacoArc.name: [
        MsgFormat("[You ate a Taco]", "[タコを食べました]"),
        MsgFormat(
            "Hey, toss that taco wrapper wherever! Who cares about a little litter?",
            "ねえ、そのタコの包み紙はどこにでも投げてしまえ！ちょっとしたゴミなんて誰も気にしないよ。",
            character: Characters.demon),
        MsgFormat(
            "Oh no, let's not litter. Proper disposal is essential. Use the dustbin to keep our surroundings clean and protect the environment.",
            "ああ、いいえ、ゴミを捨てないでください。適切な処分が重要です。ゴミ箱を使って周囲をきれいに保ち、環境を守りましょう。",
            character: Characters.angel),
        MsgFormat(
            "Seriously? It's just a taco wrapper. What harm can it do lying around for a bit?",
            "本気で？ただのタコの包み紙だよ。ちょっと寝そべっていても何の害があるんだ？",
            character: Characters.demon),
        MsgFormat(
            "Every piece of litter contributes to pollution. By using the dustbin, you show respect for your environment and set a positive example.",
            "すべてのゴミが汚染に寄与します。ゴミ箱を使うことで、あなたは環境に対する尊重を示し、良い例を提供します。",
            character: Characters.angel),
        MsgFormat("Will you use the dustbin?", "最後の行の翻訳も追加しますか？",
            choicesEn: ["Yes", "No"], choicesJa: ["はい", "いいえ"]),
      ],
      StoryTitles.officePlantationArc.name: [
        MsgFormat(
            "[Your colleagues are going on a tree plantation activity and want you to join]",
            "[同僚たちは樹木植樹活動に参加し、あなたも一緒に行くように誘っています]"),
        MsgFormat(
            "Tree planting? How cliché. Why bother with dirt and sweat when you could be doing something more fun?",
            "樹木植樹？どれほど陳腐なことか。楽しいことができるときに、なぜ汚れと汗をかく必要があるのか？",
            character: Characters.demon),
        MsgFormat(
            "What a wonderful opportunity! Joining your colleagues for a tree plantation activity can make a positive impact on the environment!",
            "素晴らしい機会だね！同僚たちと一緒に樹木植樹活動に参加することは、環境に良い影響を与えることができます！",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're actually going to waste your time planting trees? Do you really think one sapling is going to make a difference?",
            "本気で？本当に時間を無駄にして木を植えるつもりなの？一本の苗木が何か変えると本気で思っているのか？",
            character: Characters.demon),
        MsgFormat(
            "Every tree planted is a step toward a greener future. By participating, you're contributing to a positive change in the local ecosystem.",
            "植えられたすべての木は、より緑豊かな未来に向けた一歩です。参加することで、あなたは地元の生態系にポジティブな変化をもたらしています。",
            character: Characters.angel),
        MsgFormat(
            "Will you join the tree plantation activity?", "植樹活動に参加しませんか？",
            choicesEn: ["Yes", "No"], choicesJa: ["はい", "いいえ"]),
      ]
    };

    gameLessons = {
      'false${StoryTitles.introArc.name}': [
        MsgFormat(
            'Or revel in chaos and witness the town succumb to the consequences of indulgence. The choice is yours.',
            'あるいは混沌に浸り、町が放縦の結果に陥る様子を目の当たりにしてください。選択はあなた次第です。',
            character: Characters.demon),
      ],
      'true${StoryTitles.bathroomArc.name}': [
        MsgFormat(
            "Thank you! Small actions like these contribute to water conservation.",
            "ありがとう！これらの小さな行動は水の保存に貢献します。",
            character: Characters.angel),
        MsgFormat(
            "Seriously? You're not going to win any popularity contests by being a water-saving hero. It's just a drop in the ocean, literally!",
            "本気で？水を節約するヒーローで人気コンテストに勝つつもりはないでしょう。文字通り大海の一滴ですよ！",
            character: Characters.demon),
        MsgFormat(
            "Every drop ripples, my friend. By making conscious choices, you inspire others to do the same!",
            "友よ、すべての滴が波紋を広げます。意識的な選択をすることで、あなたは他の人にも同じことをするようにインスパイアします！",
            character: Characters.angel),
      ],
      'false${StoryTitles.bathroomArc.name}': [
        MsgFormat(
            "A little water down the drain won't hurt anyone. We're not living in a drought, are we?",
            "少しの水が排水されても誰も傷つきません。私たちは干ばつではないですよね？",
            character: Characters.demon),
        MsgFormat(
            "It might be a drop, but every drop adds up. Conserving water is a responsibility we all share. Let's make choices that benefit not just us, but the entire ecosystem",
            "それは一滴かもしれませんが、すべての滴が積み重なります。水を節約することは私たち全員の責任です。私たちは自分だけでなく、全生態系に利益をもたらす選択をしましょう。",
            character: Characters.angel),
      ],
      'true${StoryTitles.houseLightsArc.name}': [
        MsgFormat(
            "Well done! Your choice to switch off the lights is commendable. It not only saves energy but also helps create a more sustainable living environment.",
            "よくやりました！ライトを消す選択は賞賛に値します。それはエネルギーを節約するだけでなく、より持続可能な生活環境を作り出すのにも役立ちます。",
            character: Characters.angel),
      ],
      'false${StoryTitles.houseLightsArc.name}': [
        MsgFormat(
            "Ah, who cares about a few extra kilowatts? It's not like the environment can feel the burn!",
            "ああ、数キロワットの余分なことなんて誰も気にしません。まるで環境がそれを感じるかのようですね！",
            character: Characters.demon),
        MsgFormat(
            "It's disappointing to see the lights left on. Wasting energy has consequences, and unfortunately, our environment pays the price.",
            "ライトをつけたままにするのはがっかりです。エネルギーの浪費には結果が伴います。残念ながら、私たちの環境がその代償を支払います。",
            character: Characters.angel),
      ],
      'true${StoryTitles.busToOfficeArc.name}': [
        MsgFormat(
            "Congratulations on choosing the bus! Public transportation is an excellent choice for a cleaner and more sustainable commute.",
            "バスを選んでおめでとうございます！公共交通機関はより清潔で持続可能な通勤の優れた選択肢です。",
            character: Characters.angel),
        MsgFormat(
            "Fine, be the bus adventurer. I hope you enjoy the extra time it takes, not to mention the inconvenience.",
            "いいよ、バスの冒険者になってくれ。余分な時間を楽しんでくれるといいね、不便さは言うまでもありません。",
            character: Characters.demon),
        MsgFormat(
            "The bus may take a bit longer, but the environmental benefits and reduced stress on the road are worth it!",
            "バスは少し時間がかかるかもしれませんが、環境への利益と道路のストレスの軽減は価値があります！",
            character: Characters.angel),
      ],
      'false${StoryTitles.busToOfficeArc.name}': [
        MsgFormat(
            "Ah, the freedom of your own car! No need to wait for that crowded bus. Who cares about a little extra pollution, right?",
            "ああ、自分の車の自由！混雑したバスを待つ必要はありません。少しの追加の汚染なんて誰も気にしませんよね？",
            character: Characters.demon),
      ],
      'true${StoryTitles.tacoArc.name}': [
        MsgFormat(
            "Well done! Choosing to use the dustbin helps maintain a clean environment. Small actions like these make a big difference.",
            "よくやりました！ゴミ箱を使う選択はきれいな環境を維持するのに役立ちます。これらの小さな行動は大きな違いを生み出します。",
            character: Characters.angel),
      ],
      'false${StoryTitles.tacoArc.name}': [
        MsgFormat(
            "Who wants to be the neat freak? It's just one wrapper; the world won't end.",
            "誰が清潔好きでいたがるんだ？たった一つの包み紙だよ。世界は終わらないさ。",
            character: Characters.demon),
        MsgFormat(
            "Unfortunately, by littering, you've added to the pollution. Let's strive to keep our world clean by using the dustbin.",
            "残念なことに、ゴミを捨てることで汚染が増えてしまいました。ゴミ箱を使って世界を清潔に保つよう努力しましょう。",
            character: Characters.angel),
      ],
      'true${StoryTitles.officePlantationArc.name}': [
        MsgFormat(
            "Well done! Your choice to join the tree plantation activity is commendable. It's these collective efforts that lead to a more sustainable and beautiful world.",
            "よくやりました！樹木植樹活動に参加することを選んだあなたに敬意を表します。これらの集合的な努力が、より持続可能で美しい世界につながります。",
            character: Characters.angel),
      ],
      'false${StoryTitles.officePlantationArc.name}': [
        MsgFormat(
            "It's disheartening to see the missed opportunity. Tree planting has a cascading positive effect on the environment, and your participation could have made a significant difference.",
            "逃した機会を見るのは心が沈みますね。樹木植樹は環境に連鎖的な良い影響を与え、あなたの参加が重要な違いをもたらす可能性がありました。",
            character: Characters.angel),
        MsgFormat("Never mind, you can now do something more enjoyable.",
            "気にしないで、今はもっと楽しいことができますよ。",
            character: Characters.demon),
        MsgFormat(
            "Enjoyment is subjective, but the positive impact of tree planting is undeniable. Let's strive to make choices that benefit both us and the world around us.",
            "楽しみは主観的ですが、樹木植樹のポジティブな影響は否定できません。私たちは自分たちと周りの世界の両方に利益をもたらす選択をしましょう。",
            character: Characters.angel),
      ],
    };

    npcDialogs = {
      100: [
        MsgFormat('What a delightful day in EcoVille!', 'エコビルで素晴らしい日だね！',
            character: Characters.npc),
        MsgFormat(
            'I can feel the positive vibes in the air!', '空気中にポジティブな雰囲気を感じます！',
            character: Characters.npc),
        MsgFormat('Absolutely no pollution today! Clean air is a blessing.',
            '今日はまったく汚染がありません！きれいな空気は恵みです。',
            character: Characters.npc),
      ],
      80: [
        MsgFormat('It\'s a bit hazy today, isn\'t it?', '今日は少し霞んでいますね？',
            character: Characters.npc),
        MsgFormat('Breathing in the fresh air of EcoVille!', 'エコビルの新鮮な空気を吸う！',
            character: Characters.npc),
        MsgFormat('No pollution today! Good job, everyone.',
            '今日はまったく汚染がありません！みんなよくやった。',
            character: Characters.npc),
      ],
      60: [
        MsgFormat(
            'The air quality could use some improvement, don\'t you think?',
            '空気の質は改善の余地がありそうだね、どう思う？',
            character: Characters.npc),
        MsgFormat('More green spaces would really make EcoVille shine.',
            'もっと緑のスペースがあれば、エコビルが本当に輝くでしょう。',
            character: Characters.npc),
        MsgFormat(
            'Let\'s join hands to make our environment healthier and vibrant!',
            '一緒に手を組んで、環境をより健康で活気に満ちたものにしましょう！',
            character: Characters.npc),
      ],
      40: [
        MsgFormat('The pollution levels are rising; we need to act now.',
            '汚染レベルが上昇しています。今すぐ行動する必要があります。',
            character: Characters.npc),
        MsgFormat(
            'Our beautiful EcoVille deserves better. Time to make changes!',
            '美しいエコビルはもっと良いものを値する。変更の時です！',
            character: Characters.npc),
        MsgFormat('Eco-conscious choices can turn things around for us!',
            'エコ意識のある選択が私たちの状況を好転させることができます！',
            character: Characters.npc),
      ],
      20: [
        MsgFormat('It\'s getting hard to breathe in this environment.',
            'この環境で息をするのが難しくなってきた。',
            character: Characters.npc),
        MsgFormat('Garbage everywhere. We can\'t let this continue.',
            'どこにでもゴミが散乱しています。これを続けるわけにはいきません。',
            character: Characters.npc),
        MsgFormat('Maybe it\'s time to consider moving to a cleaner place.',
            'もしかしたら、より清潔な場所に引っ越す時かもしれません。',
            character: Characters.npc),
      ],
      0: [
        MsgFormat('Everything is lost.', 'すべてが失われました。',
            character: Characters.npc),
      ]
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
  final String msgEn;
  final String msgJa;
  final Characters? character;
  final List<String>? choicesEn;
  final List<String>? choicesJa;

  MsgFormat(this.msgEn, this.msgJa,
      {this.character, this.choicesEn, this.choicesJa});
}
