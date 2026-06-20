// All story content is hard-coded here — edit this file to update stories.
// Three languages: EN (English), TW (Twi), EW (Ewe).

enum Lang { en, tw, ew }

class LocalizedText {
  final String en;
  final String tw;
  final String ew;
  const LocalizedText(this.en, this.tw, this.ew);

  String get(Lang lang) {
    switch (lang) {
      case Lang.tw:
        return tw;
      case Lang.ew:
        return ew;
      case Lang.en:
        return en;
    }
  }
}

class StoryChoice {
  final LocalizedText text;
  final bool isSafe;
  final LocalizedText feedback;
  const StoryChoice({
    required this.text,
    required this.isSafe,
    required this.feedback,
  });
}

class DecisionPoint {
  final LocalizedText scenario;
  final String emoji;
  final StoryChoice choiceA;
  final StoryChoice choiceB;
  const DecisionPoint({
    required this.scenario,
    required this.emoji,
    required this.choiceA,
    required this.choiceB,
  });
}

class Story {
  final String id;
  final LocalizedText title;
  final String emoji;
  final LocalizedText intro;
  final String characterName;
  final int characterAge;
  final List<DecisionPoint> decisions;
  final LocalizedText endSummary;
  const Story({
    required this.id,
    required this.title,
    required this.emoji,
    required this.intro,
    required this.characterName,
    required this.characterAge,
    required this.decisions,
    required this.endSummary,
  });
}

// ─────────────────────────────────────────────
// STORY 1: "The Big City Job"
// ─────────────────────────────────────────────
const story1 = Story(
  id: 'story_1',
  emoji: '💼',
  title: LocalizedText(
    'The Big City Job',
    'Adwuma a Ɛwɔ Kuropɔn Kɛse',
    'Dɔ Le Du Gãtɔa Me',
  ),
  characterName: 'Kofi',
  characterAge: 12,
  intro: LocalizedText(
    'Kofi is at the market with his mom\'s shopping list. A friendly woman, Auntie Linda, says she knows a place in Accra that needs young helpers — good pay, free food, free housing. "It\'s our little secret for now, okay?"',
    'Kofi wɔ dwam reyɛ ne maame nneɛma a wɔahyɛ no sɛ ɔnkɔtɔ. Ɔbaa bi a wɔfrɛ no Auntie Linda ka kyerɛ no sɛ ɔnim baabi wɔ Accra a wɔhia mmɔfra a wɔbɛboa — wɔbɛtua sika pa, aduane kwa, ne fie kwa. "Ɛnkɔka obiara, ɛnyɛ yɛn ahintasɛm kakra?"',
    'Kofi le asime wɔnɔ ƒe nuɖaƒomɔ ƒomɔwo dome. Nyɔnu dɔmenyo aɖe, Auntie Linda, gblɔ be enya teƒe le Accra si hiã ɖevi siwo akpe ɖe wo ŋu — fetu nyui, nuɖuɖu femaxee, eye xɔƒe femaxee. "Mègblɔe na ame aɖeke o, anyo eya kple míawo ko dome."',
  ),
  decisions: [
    DecisionPoint(
      emoji: '🤫',
      scenario: LocalizedText(
        'Auntie Linda says, "Don\'t tell your parents yet — let\'s surprise them when you bring home money!" What does Kofi do?',
        'Auntie Linda ka sɛ, "Ɛnkae w\'awofo nnora — yɛbɛma wɔn ahodwo bere a wode sika aba fie!" Dɛn na Kofi bɛyɛ?',
        'Auntie Linda gblɔ be, "Mègblɔe na dziwòlawo o haɖe — mina woakpɔ nuku ne èkplɔ ga va aƒe me!" Nukae Kofi awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I want to ask my parents first.',
          'Mepɛ sɛ mibisa m\'awofo ansa.',
          'Medi be mabia dziwòlawo gbã.',
        ),
        feedback: LocalizedText(
          'Great thinking, Kofi! Real jobs never ask you to keep secrets from your family. Telling a trusted adult first is always the safest move.',
          'Adwen pa, Kofi! Adwuma ankasa nhia wo sɛ wode ahintasɛm kata w\'abusua so. Sɛ wobɔ obi a wugye no di ho amanneɛ kan no yɛ ɛkwan a ɛyɛ dwoodwoo paa.',
          'Tameɖoɖo nyuie, Kofi! Dɔ vavãwo mehiã be ataɣli ɖe ɖoƒe na wo ƒomea o. Be agblɔe na ame tsitsi si dzi ŋutɔ ƒo nu na gbã enye mɔ dzɔdzɔetɔ kekeake.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay! I won\'t tell anyone, it\'ll be a fun surprise!',
          'Eyɛ! Merenka nkyerɛ obiara, ɛbɛyɛ anigye nwonwa adeyɛ!',
          'Enyo! Nyemagblɔe na ame aɖeke o, anye nukunu nyui aɖe!',
        ),
        feedback: LocalizedText(
          'Uh-oh. When someone says "don\'t tell your family," that\'s usually a warning sign — even if it sounds exciting. Let\'s see what happens next...',
          'Hmm. Sɛ obi ka sɛ "ɛnkae w\'abusua" a, ɛtaa yɛ kɔkɔbɔ — ɛwom sɛ ɛte sɛ anigyesɛm de. Yɛn nhwɛ deɛ ɛbɛsi seesei...',
          'Aaɖe. Ne ame aɖe gblɔ be "mègblɔe na ƒomea o," nusia nye nuxlɔ̃ame zi geɖe — togbɔ be edze abe nu vivi aɖe ene hã. Mina míakpɔ nu si adzɔ azɔ...',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '🚗',
      scenario: LocalizedText(
        'Auntie Linda waves down a car. "Just hop in, we\'ll explain everything on the way." What does Kofi do?',
        'Auntie Linda frɛ kar bi. "Pra ho kɔ mu, yɛbɛkyerɛkyerɛ mu nyinaa mu kwan so." Dɛn na Kofi bɛyɛ?',
        'Auntie Linda yɔ ʋu aɖe va. "Just ge ɖe eme, míaɖe nu sia nu me na wò le mɔzɔzɔa me." Nukae Kofi awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I\'d like to know where we\'re going and call my mom first.',
          'Mepɛ sɛ mehu baabi a yɛrekɔ na me frɛ me maame ansa.',
          'Medi be manya afi si míele yiyim ɖo, eye maƒo ka na danye gbã.',
        ),
        feedback: LocalizedText(
          'Smart move! Knowing where you\'re going — and telling someone — is one of the best ways to stay safe, no matter what\'s happening.',
          'Adwen a ɛsɔ ani! Sɛ wonim baabi a worekɔ — na woka kyerɛ obi — yɛ ɛkwan paa a ɛboa wo ma wo ho banbɔ, sɛ deɛn ara a ɛrekɔ so.',
          'Tameɖoɖo nyui aɖe! Be wonya afi si yele yiyim ɖo — eye nàgblɔe na ame aɖe — nye mɔ aɖewo siwo nyo wu be akpɔ wo ɖokui dzi, eɖanye nukae le edzɔdzɔm o.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay, let\'s go!',
          'Eyɛ, ma yɛnkɔ!',
          'Enyo, mina míadze mɔ!',
        ),
        feedback: LocalizedText(
          'This is exactly how it happens — kids get into a car not knowing where they\'re really going. It\'s never too late to ask questions, even after saying yes.',
          'Eyi ne sɛnea ɛtaa kɔ so — mmɔfra kɔ kar mu a wonnim baabi a wɔrekɔ ankasa. Ɛnnyɛ akyiri dodo sɛ wobɛbisa nsɛm, sɛ woaka "aane" mpo a.',
          'Aleae nusiawo dzɔna ɖaa — ɖeviwo gena ɖe ʋuwo me menyaa afi si woyina ɖe o. Megazɔna dzaa be woabia nya o, ne ègblɔ "ee" xoxo gɔ̃ hã.',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '📱',
      scenario: LocalizedText(
        'At the bus station, Auntie Linda says, "Give me your phone — I\'ll keep it safe for you." What does Kofi do?',
        'Wɔ bɔs gyinabea hɔ, Auntie Linda ka sɛ, "Fa wo fon ma me — mɛkora no yie ama wo." Dɛn na Kofi bɛyɛ?',
        'Le ʋudziƒoa, Auntie Linda gblɔ be, "Tsɔ wò kakaɖi vɛ nam — malé eŋu dzi ɖo na wò." Nukae Kofi awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I\'ll keep my phone — I need it to call my family.',
          'Mɛkora me fon — mehia no de mefrɛ m\'abusua.',
          'Malé nye kakaɖi ɖe asi — mehiãe be maƒo ka na nye ƒomea.',
        ),
        feedback: LocalizedText(
          'Yes! Your phone is your lifeline to the people who love you. Never give it up to someone you just met — no matter how kind they seem.',
          'Ampa! Wo fon yɛ wo abusoɔden a ɛka wo ne nnipa a wɔdɔ wo ho. Mfa mma obi a woahyia no foforɔ — ɛmfa ho sɛ ɔyɛ obi pa sɛn ara.',
          'Ee! Wò kakaɖi nye nu si ku ɖe ame siwo lɔ̃ wò ŋu. Mègatsɔe na ame si èkpɔ zi gbãtɔ o — eɖanye ale gbegbe si wòdze abe ame nyui ene hã.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay, here you go.',
          'Eyɛ, wei ni.',
          'Enyo, esia.',
        ),
        feedback: LocalizedText(
          'Giving up your phone means giving up your way to call for help. This is one of the biggest warning signs of all. Always keep your phone — and tell someone where you\'re going.',
          'Sɛ wode wo fon ma a, ɛkyerɛ sɛ wode wo kwan a wobɛfa so frɛ mmoa ama. Eyi yɛ kɔkɔbɔ kɛse a ɛsen biara. Kora wo fon daa — na ka kyerɛ obi baabi a worekɔ.',
          'Ne ètsɔ wò kakaɖi nae, eyae nye be ètsɔ wò mɔnu si dzi nàto akpɔ kpekpeɖeŋu ƒu gbe. Esia nye nuxlɔ̃ame gãtɔ wu be ɖe le wo si. Tsɔ wò kakaɖi ɖe asi ɣesiaɣi — eye nàgblɔ afi si yele yiyim ɖo na ame aɖe.',
        ),
      ),
    ),
  ],
  endSummary: LocalizedText(
    'You made it through "The Big City Job"! Real jobs don\'t need secrets, surprise rides, or your phone. Trusted adults + a little caution = staying safe.',
    'Woawie "Adwuma a Ɛwɔ Kuropɔn Kɛse"! Adwuma ankasa nhia ahintasɛm, nteaseɛ a ɛyɛ nwonwa, anaa wo fon. Nnipa a wɔbɛboa wo + ahwɛyiɛ kakra = banbɔ.',
    'Èwu "Dɔ Le Du Gãtɔa Me" nu! Dɔ vavãwo mehiã ɖoɖowɔwɔ ɣaɣla, ʋukɔkɔɖiwo, alo wò kakaɖi o. Ame tsitsi siwo dzi nàka ɖo + ŋudzɔnu vi aɖe = dedienɔnɔ.',
  ),
);

// ─────────────────────────────────────────────
// STORY 2: "My New Online Friend"
// ─────────────────────────────────────────────
const story2 = Story(
  id: 'story_2',
  emoji: '📱',
  title: LocalizedText(
    'My New Online Friend',
    'M\'adamfo Foforɔ a Wɔ Intanɛt So',
    'Nye Online-xɔlɔ̃ Yeyetɔ',
  ),
  characterName: 'Akosua',
  characterAge: 11,
  intro: LocalizedText(
    'Akosua loves chatting online. A new friend, "Big Brother Kwame," is always kind, always available, and showers her with compliments. One day he says, "You\'re so mature — let\'s keep our chats just between us, okay?"',
    'Akosua pɛ sɛ ɔbɔ nkɔmmɔ wɔ Intanɛt so. Adamfo foforɔ bi, "Big Brother Kwame," yɛ ayamyɛ daa, ɔwɔ hɔ daa, na ɔkamfo no daa. Da bi ɔka sɛ, "Wo deɛ woanyin yiye — ma yɛn nkɔmmɔdie nka yɛn ntam, ɛnte?"',
    'Akosua lɔ̃a dzeɖoɖo le internet dzi. Xɔlɔ̃ yeyetɔ aɖe, "Big Brother Kwame," le dɔmenyo ɣesiaɣi, eli ɣesiaɣi, eye ekafua nyona ɣesiaɣi. Gbeɖeka egblɔ be, "Èle bliboe ŋutɔ — mina míaƒe dzeɖoɖowo nanɔ mía ɖeka dome ko, anyo?"',
  ),
  decisions: [
    DecisionPoint(
      emoji: '🙈',
      scenario: LocalizedText(
        'Big Brother Kwame asks Akosua not to tell her mom about him because "grown-ups don\'t always understand friendships like ours." What does Akosua do?',
        'Big Brother Kwame bisa Akosua sɛ ɔnka ne ho nkyerɛ ne maame ɛfiri sɛ "mpanimfoɔ no nte adamfofa a ɛte yɛn deɛ ase berɛ nyinaa." Dɛn na Akosua bɛyɛ?',
        'Big Brother Kwame bia Akosua be megagblɔ eŋu na danye o elabena "ame tsitsiwo mese xɔlɔ̃yenyenye abe míawo tɔ ene gɔme ɣesiaɣi o." Nukae Akosua awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'Actually, I tell my mom about my online friends.',
          'Nokorɛ, meka m\'adamfo a mehyia wɔn wɔ Intanɛt so kyerɛ me maame.',
          'Le nyateƒe me, megblɔa nye xɔlɔ̃ siwo mekpɔna le internet dzi na danye.',
        ),
        feedback: LocalizedText(
          'Wonderful! A real friend won\'t ask you to hide them from people who care about you. Telling a trusted adult about your online friends keeps everyone honest.',
          'Ɛyɛ anisɔ! Adamfo ankasa renka nkyerɛ wo sɛ fa no hyɛ nnipa a wɔdwene wo ho akyi. Sɛ woka w\'adamfo a wohyia wɔn wɔ Intanɛt so kyerɛ obi a wugye no di no boa ma nokorɛ tena hɔ.',
          'Enya gbɔgblɔ! Xɔlɔ̃ vavã mabia tso asi wò be nàɣla wo ɖe ame siwo léa be ɖe ŋutiwò me o. Be nàgblɔ wò online-xɔlɔ̃wo ŋu na ame tsitsi si dzi nàka ɖo na nyateƒenyenye anɔ anyi.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay, this can be our secret.',
          'Eyɛ, eyi bɛyɛ yɛn ahintasɛm.',
          'Enyo, esia anye míaƒe ɖoɖowɔwɔ ɣaɣla.',
        ),
        feedback: LocalizedText(
          'When someone asks you to keep them secret from people who love you, that\'s a big red flag — even if they seem really nice. Good friends don\'t need secrecy.',
          'Sɛ obi bisa wo sɛ fa wɔn hyɛ nnipa a wɔdɔ wo akyi a, ɛyɛ kɔkɔbɔ kɛseɛ — ɛwom sɛ wɔte sɛ nnipa pa de. Adamfo pa nhia ahintasɛm.',
          'Ne ame aɖe bia tso asiwo be nàɣla woe ɖe ame siwo lɔ̃ wò me, esia nye dzɔgbevɔ̃enuxlɔ̃ame gã aɖe — togbɔ be wodze abe ame nyuiwo ene hã. Xɔlɔ̃ nyuiwo mehiã ɖoɖowɔwɔ ɣaɣla o.',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '📸',
      scenario: LocalizedText(
        'Big Brother Kwame asks Akosua to send him a photo of herself, "just so I know what my best friend looks like." What does Akosua do?',
        'Big Brother Kwame bisa Akosua sɛ ɔnsoma ne ho mfonini ma no, "sɛdeɛ ɛbɛyɛ a mehu sɛnea m\'adamfo pa no teɛ." Dɛn na Akosua bɛyɛ?',
        'Big Brother Kwame bia Akosua be wòaɖo eƒe foto ɖa nɛ, "ne mato dzesi xɔlɔ̃ veviɖitɔ kekeake ƒe dzedzeme." Nukae Akosua awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I don\'t send photos of myself to people I haven\'t met in person.',
          'Mensoma m\'ankasa mfoniniwo mma nnipa a minhyiae wɔ asaase so.',
          'Nyemeɖoa nye fotowo ɖa na ame siwo nyemekpɔ kpɔ le ŋutilã me o.',
        ),
        feedback: LocalizedText(
          'Exactly right! It\'s okay to say no, even to someone who seems friendly. Your photos and personal info are yours to protect.',
          'Ɛnam pɛ! Ɛyɛ adeɛ a yɛpɛ sɛ wose "daabi", sɛ obi te sɛ adamfo mpo a. W\'ankasa mfonini ne wo ho nsɛm yɛ wo deɛ a wɔsɛ wobɔ ho ban.',
          'Edzɔ tututu! Enyo be nàgblɔ "ao", ɖe ame si dze abe xɔlɔ̃ ene gɔ̃ hã. Wò fotowo kple wò ɖokuiwo ŋuti nyatakakawo nye wò ɖokui tɔ siwo wòle be nàdzɔ ŋu.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Sure, here\'s a photo!',
          'Aane, mfonini no ni!',
          'Eɖia, foto la le esi!',
        ),
        feedback: LocalizedText(
          'Sending personal photos to someone you\'ve never met in real life isn\'t safe — even if they\'re kind online. It\'s always okay to say no.',
          'Sɛ wode ankasa mfonini ma obi a wonhyiaa no wɔ asaase so da no nyɛ banbɔ — ɛwom sɛ ɔyɛ ayamyɛ wɔ Intanɛt so de. Ɛyɛ adeɛ pa daa sɛ wobɛka "daabi".',
          'Be nàɖo ɖokuiwo ŋuti fotowo ɖa na ame si mèkpɔ kpɔ le agbe me o mele dedie o — togbɔ be wonye dɔmenyotɔ le internet dzi hã. Enyo ɣesiaɣi be nàgblɔ "ao".',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '🌳',
      scenario: LocalizedText(
        'Big Brother Kwame says, "Let\'s finally meet! Come alone to the park near your school, just us." What does Akosua do?',
        'Big Brother Kwame ka sɛ, "Ma yɛnhyia mprempren! Bra wo nkutoo kɔ park a ɛbɛn wo sukuu, yɛn nkutoo." Dɛn na Akosua bɛyɛ?',
        'Big Brother Kwame gblɔ be, "Mina míado go mlɔeba! Va ɖeka pɛ ɖe park si te ɖe wò sukuu ŋu, mí kple wò ɖeka ko." Nukae Akosua awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I\'ll only meet online friends if a trusted adult comes with me, in a public place.',
          'Mɛhyia adamfo a mehyia no wɔ Intanɛt so sɛ obi a mɛgye no adi bɛka me ho, na ɛwɔ baabi a nnipa wɔ.',
          'Madoa goe kple online-xɔlɔ̃wo ɖeko ne ame tsitsi si dzi maka ɖo va kpe ɖe ŋunye, le teƒe si amewo le.',
        ),
        feedback: LocalizedText(
          'Perfect! Meeting online friends always needs a trusted adult and a public place — that\'s the rule, no matter how long you\'ve been chatting.',
          'Ɛyɛ pɛpɛɛpɛ! Sɛ wobɛhyia adamfo a wohyiaa no wɔ Intanɛt so a, ɛhia daa sɛ obi a wugye no di ka wo ho, na ɛwɔ baabi a nnipa wɔ — ɛno ne mmara a, sɛ bere dodoɔ sɛn ara na moanya kasakasa kɔso.',
          'Enyo bliboe! Be nàdo go kple online-xɔlɔ̃ ahiã ame tsitsi si dzi nàka ɖo kple teƒe si amewo le ɣesiaɣi — esiae nye seawo, eɖanye ale ɣeyiɣi gbegbee si miawɔ dzeɖoɖo hã.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay, I\'ll come alone.',
          'Eyɛ, mɛba me nkutoo.',
          'Enyo, mava ɖeka.',
        ),
        feedback: LocalizedText(
          'Meeting someone you\'ve only talked to online, alone, in a hidden place, is one of the riskiest things you can do. Always bring a trusted adult and choose a public place.',
          'Sɛ wobɛhyia obi a moakasa kasa wɔ Intanɛt so nko ara, wo nkutoo, wɔ baabi a ahintaeɛ, ɛyɛ ɔhaw kɛseɛ pa ara a wobɛtumi ayɛ. Fa obi a wugye no di kɔ daa na yɛ paw baabi a nnipa wɔ.',
          'Be nàdo go kple ame si dzi miaƒo nu kple le internet dzi ko, ɖeka, le teƒe ɣaɣla aɖe, enye nu siwo wɔ dzɔgbevɔ̃e wu le nu siwo àte ŋu wɔ dome. Kplɔ ame tsitsi si dzi nàka ɖo ɖaa eye nàtia teƒe si amewo le.',
        ),
      ),
    ),
  ],
  endSummary: LocalizedText(
    'You finished "My New Online Friend"! Real friends don\'t ask for secrets, private photos, or secret meetings. A trusted adult is always part of the plan.',
    'Woawie "M\'adamfo Foforɔ a Wɔ Intanɛt So"! Adamfo ankasa mmisa ahintasɛm, ankasa mfonini, anaa nhyiamu a ahintaeɛ. Obi a wugye no di yɛ ɔfã wɔ nhyehyɛeɛ no mu daa.',
    'Èwu "Nye Online-xɔlɔ̃ Yeyetɔ" nu! Xɔlɔ̃ vavãwo mebia ɖoɖowɔwɔ ɣaɣla, fotowo siwo ŋu ŋutsu mekpɔ, alo doɣligbɔɖe ɣaɣla o. Ame tsitsi si dzi nàka ɖo nye akpa aɖe le ɖoɖoa me ɣesiaɣi.',
  ),
);

// ─────────────────────────────────────────────
// STORY 3: "Should I Stay in School?"
// ─────────────────────────────────────────────
const story3 = Story(
  id: 'story_3',
  emoji: '🏫',
  title: LocalizedText(
    'Should I Stay in School?',
    'Memmɔ Sukuu Mu Anaa?',
    'Manɔ Sukuu Mea?',
  ),
  characterName: 'Yaw',
  characterAge: 13,
  intro: LocalizedText(
    'Yaw\'s cousin Eric visits from the city, wearing nice clothes and showing off a new phone. "School is a waste of time," Eric says. "Come sell with me in the market — you\'ll make real money, today!"',
    'Yaw nua Eric firi kuropɔn no mu ba, na ɔhyɛ ntoma pa na ɔrekyerɛ fon foforɔ. "Sukuu yɛ bere a wɔsɛe kwa," Eric ka. "Bra na yɛnkɔtɔn nneɛma wɔ dwam — wobɛnya sika ankasa, ɛnnɛ ara!"',
    'Yaw nɔvi Eric tso dua gãtɔa me va, edo awu nyuiwo eye eɖe kakaɖi yeyetɔ aɖe fia. "Sukuu nye ɣeyiɣi dovava," Eric gblɔ. "Va míadzra nu le asime — àkpɔ ga vavã, egbea ke!"',
  ),
  decisions: [
    DecisionPoint(
      emoji: '💸',
      scenario: LocalizedText(
        'Eric says school never helped him, and Yaw could earn money "right now" instead of "wasting years" in class. What does Yaw do?',
        'Eric ka sɛ sukuu mmoaa no da, na Yaw bɛtumi anya sika "seesei ara" sen sɛ "ɔsɛe mfeɛ" wɔ adesua mu. Dɛn na Yaw bɛyɛ?',
        'Eric gblɔ be sukuu mekpe ɖe eŋu kpɔ o, eye Yaw ate ŋu akpɔ ga "fifia ke" wu be "be agblẽ ƒewo dome" le klass me. Nukae Yaw awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I want to talk to my teacher and parents about this first.',
          'Mepɛ sɛ me ne me tikya ne m\'awofo bisa wɔ saa asɛm yi ho ansa.',
          'Medi be maƒo nu kple nye nufiala kple dziwòlawo tso nya sia ŋu gbã.',
        ),
        feedback: LocalizedText(
          'Smart! Big decisions about school and your future are best made together with people who care about you — not on the spot, after one conversation.',
          'Ɛnyansa! Gyinaesie akɛseɛ a ɛfa sukuu ne wo daakye ho yɛ deɛ ɛsɛ sɛ wo ne nnipa a wɔdwene wo ho boom sɛn — ɛnnyɛ amono mu, akyiri kasakasa baako.',
          'Nunya! Nyametsotso gãwo siwo ku ɖe sukuu kple wò etsɔme ŋu, anyo wu ne wò kple ame siwo léa be ɖe ŋuwò la wɔ wo akpa — menye ɖe afi ma ke, le nuƒoƒo ɖeka megbe o.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'You\'re right, school isn\'t helping me. I\'ll stop going.',
          'Woka nokorɛ, sukuu mmoaa me. Mɛgyae kɔ.',
          'Èle eteŋu, sukuu mekpe ɖe ŋunye o. Magbe yiyi.',
        ),
        feedback: LocalizedText(
          'It can sound exciting to make money right now — but quick cash often comes with a price later. Let\'s see what happens next...',
          'Ɛbɛtumi ate sɛ anigyesɛm sɛ wobɛnya sika seesei ara — nanso sika a ɛba ntɛm taa de bo bi ba akyiri. Yɛn nhwɛ deɛ ɛbɛsi seesei...',
          'Adze abe nu vivi aɖe ene be akpɔ ga fifia ke — gake ga si va kabakaba ŋutɔ ɖia fe na ame le emegbe zi geɖe. Mina míakpɔ nu si adzɔ azɔ...',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '🛍️',
      scenario: LocalizedText(
        'The next morning, Eric offers Yaw cash to skip school and help carry goods at the market — "just for today." What does Yaw do?',
        'Adekyeeɛ no, Eric de sika ma Yaw sɛ ɔnnyae sukuu na ɔmmoa no soa nneɛma wɔ dwam so — "ɛnnɛ nko ara." Dɛn na Yaw bɛyɛ?',
        'Le ŋdi si gbɔna, Eric tsɔ ga na Yaw be wòagbe sukuu yiyi eye wòakpe ɖe eŋu na wòakɔ adzraɖoƒea — "egbe sia ko." Nukae Yaw awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I can help after school finishes, not instead of going.',
          'Mɛtumi aboa no sukuu akyi, ɛnyɛ sɛ menkɔ.',
          'Mate ŋu akpe ɖe eŋu ne sukuu wu enu, menye le eteƒe be magbe yiyi o.',
        ),
        feedback: LocalizedText(
          'Great balance! Helping family and going to school don\'t have to be a choice between one or the other — there\'s often a way to do both.',
          'Adwen pa! Sɛ wobɛboa abusua ne sɛ wobɛkɔ sukuu ho nhia sɛ wopaw baako pɛ — wɔtaa wɔ ɛkwan a wobɛtumi ayɛ mmienu nyinaa.',
          'Sidzedze nyui! Be nàkpe ɖe ƒomea ŋu kple be nàyi sukuu mehiã be wòanye tiatia ɖeka koe o — mɔ aɖe li zi geɖe be nàwɔ wo eve nu siaa.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'Okay, I\'ll skip just this once.',
          'Eyɛ, mɛgyae da yi nko ara.',
          'Enyo, magbe yiyi ɖeka sia ko.',
        ),
        feedback: LocalizedText(
          '"Just this once" is how it often starts — and it can be hard to go back once you\'ve missed a day. Every day in school matters.',
          '"Da yi nko ara" ne sɛnea ɛtaa fi aseɛ — na ɛyɛ den sɛ wobɛsane akɔ sɛ woapa da bi. Da biara wɔ sukuu ho hia.',
          '"Ɣe sia ko" enye alesi nusiawo dzea egɔme zi geɖe — eye ate ŋu anye nusi me ne ètrɔ yi le eme ne ègbe ɖeka. Ŋkeke ɖesiaɖe le sukuu me le vevie.',
        ),
      ),
    ),
    DecisionPoint(
      emoji: '👩‍🏫',
      scenario: LocalizedText(
        'Yaw\'s teacher notices he\'s been missing class and gently asks, "Is everything okay at home?" What does Yaw do?',
        'Yaw tikya hu sɛ ɔnkɔ adesua na ɔbisa no brɛoo sɛ, "Biribiara yɛ yie wɔ fie?" Dɛn na Yaw bɛyɛ?',
        'Yaw nufiala kpɔe be metsɔ klassi o eye ebia tso eme nyuie be, "Nuwo le edzedzem nyuie le aƒeme?" Nukae Yaw awɔ?',
      ),
      choiceA: StoryChoice(
        isSafe: true,
        text: LocalizedText(
          'I tell my teacher what\'s been going on so they can help.',
          'Meka asɛm a ɛrekɔ so kyerɛ me tikya na wɔaboa me.',
          'Magblɔ nusi le edzedzem na nye nufiala be wòakpe ɖe ŋunye.',
        ),
        feedback: LocalizedText(
          'That took courage! Teachers and trusted adults can only help when they know what\'s really going on. You did the right thing by being honest.',
          'Ɛno hia akokoɔduru! Tikyafoɔ ne nnipa a wɔbɛboa wo bɛtumi aboa wo sɛ wonim asɛm a ɛrekɔ so ankasa nko ara. Woayɛ adeɛ a ɛtene sɛ wokaa nokorɛ.',
          'Esia hiã dzideŋuƒoƒo! Nufialawo kple ame tsitsi siwo ate ŋu akpe ɖe ŋuwò la ate ŋu awɔe ɖeko ne wonya nu si le edzedzem vavãe. Èwɔ nusi sɔ to be ègblɔ nyateƒea.',
        ),
      ),
      choiceB: StoryChoice(
        isSafe: false,
        text: LocalizedText(
          'I make up an excuse and keep skipping when Eric asks.',
          'Meka anansesɛm na mekɔ so gyae sukuu sɛ Eric bisa me.',
          'Maɖo nutaname aɖe eye magayi gbe sukuu yiyi dzi ne Eric bia.',
        ),
        feedback: LocalizedText(
          'Hiding what\'s really going on means the people who could help — your teacher, your family — never get the chance to. It\'s always braver to tell the truth, even when it feels easier not to.',
          'Sɛ wode nea ɛrekɔ so sie a, ɛkyerɛ sɛ nnipa a wɔbɛtumi aboa wo — wo tikya, w\'abusua — wɔrennya kwan biara da. Ɛyɛ akokoɔduru paa sɛ wobɛka nokorɛ, sɛ ɛte sɛ deɛ ɛyɛ mmerɛ sɛ wode hyɛ mu mpo.',
          'Be nàɣla nu si le edzedzem vavã fia be ame siwo ate ŋu akpe ɖe ŋuwò — wò nufiala, wò ƒomea — mate ŋu akpɔ mɔnukpɔkpɔ akpe ɖe ŋuwò gbeɖe o. Enyo dzidziɖoɖo wu ɣesiaɣi be nàgblɔ nyateƒe, ne edze abe enɔ bɔbɔe wu be magagblɔe o gɔ̃ hã.',
        ),
      ),
    ),
  ],
  endSummary: LocalizedText(
    'You finished "Should I Stay in School?"! Big decisions are better with help from family and teachers, and being honest about what\'s going on always opens doors to support.',
    'Woawie "Memmɔ Sukuu Mu Anaa?"! Gyinaesie akɛseɛ yɛ papa sɛ abusua ne tikyafoɔ boa, na sɛ wobɛka nokorɛ wɔ asɛm a ɛrekɔ so ho daa bue apono ma mmoa.',
    'Èwu "Manɔ Sukuu Mea?" nu! Nyametsotso gãwo nyo wu ne ƒomea kple nufialawo kpe ɖe wo ŋu, eye be nàgblɔ nyateƒe tso nusi le edzedzem ŋu ɖaa ʋuna ʒegbe na kpekpeɖeŋu.',
  ),
);

// All stories in display order
const List<Story> allStories = [story1, story2, story3];
