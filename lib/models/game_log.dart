import 'package:uuid/uuid.dart';
import 'risk_score.dart';

class GameLog {
  final String sessionId;
  final String userId;
  final String userName;
  final String scenarioId;
  final String scenarioTitle;
  final double totalScore;
  final String riskLevel;
  final bool helpTriggered;
  final DateTime createdAt;
  final List<DecisionRecord> decisions;

  GameLog({
    required this.sessionId,
    required this.userId,
    required this.userName,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.totalScore,
    required this.riskLevel,
    required this.helpTriggered,
    required this.createdAt,
    required this.decisions,
  });

  factory GameLog.fromJson(Map<String, dynamic> json) {
    return GameLog(
      sessionId: json['sessionId'] as String? ?? const Uuid().v4(),
      userId: json['userId'] as String? ?? 'unknown',
      userName: json['userName'] as String? ?? 'Unknown',
      scenarioId: json['scenarioId'] as String? ?? 'unknown',
      scenarioTitle: json['scenarioTitle'] as String? ?? 'Unknown',
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 0.0,
      riskLevel: json['riskLevel'] as String? ?? 'low',
      helpTriggered: json['helpTriggered'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      decisions: (json['decisions'] as List<dynamic>?)
              ?.map((item) => DecisionRecord.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'userName': userName,
      'scenarioId': scenarioId,
      'scenarioTitle': scenarioTitle,
      'totalScore': totalScore,
      'riskLevel': riskLevel,
      'helpTriggered': helpTriggered,
      'createdAt': createdAt.toIso8601String(),
      'decisions': decisions.map((decision) => decision.toJson()).toList(),
    };
  }
}
