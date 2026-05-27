class Scenario {
  final String id;
  final String title;
  final String titleTwi;
  final String description;
  final String descriptionTwi;
  final String audioFileEn;
  final String audioFileTw;
  final int weight;
  final List<ScenarioNode> nodes;
  final String coverImage;

  Scenario({
    required this.id,
    required this.title,
    required this.titleTwi,
    required this.description,
    required this.descriptionTwi,
    required this.audioFileEn,
    required this.audioFileTw,
    required this.weight,
    required this.nodes,
    required this.coverImage,
  });
}

class ScenarioNode {
  final String id;
  final String text;
  final String textTwi;
  final List<Choice> choices;
  final bool isEnding;
  final String? nextNodeId;

  ScenarioNode({
    required this.id,
    required this.text,
    required this.textTwi,
    required this.choices,
    required this.isEnding,
    this.nextNodeId,
  });
}

class Choice {
  final String id;
  final String text;
  final String textTwi;
  final int riskValue;
  final String nextNodeId;
  final String feedbackText;
  final String feedbackTextTwi;

  Choice({
    required this.id,
    required this.text,
    required this.textTwi,
    required this.riskValue,
    required this.nextNodeId,
    required this.feedbackText,
    required this.feedbackTextTwi,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      textTwi: json['textTwi'] as String? ?? '',
      riskValue: json['riskValue'] as int? ?? 0,
      nextNodeId: json['nextNodeId'] as String? ?? '',
      feedbackText: json['feedbackText'] as String? ?? '',
      feedbackTextTwi: json['feedbackTextTwi'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'textTwi': textTwi,
      'riskValue': riskValue,
      'nextNodeId': nextNodeId,
      'feedbackText': feedbackText,
      'feedbackTextTwi': feedbackTextTwi,
    };
  }
}
