enum RiskLevel { low, medium, high }

class DecisionRecord {
  final String scenarioId;
  final String choiceId;
  final int riskValue;
  final int scenarioWeight;
  final Duration decisionTime;
  final DateTime timestamp;

  DecisionRecord({
    required this.scenarioId,
    required this.choiceId,
    required this.riskValue,
    required this.scenarioWeight,
    required this.decisionTime,
    required this.timestamp,
  });

  factory DecisionRecord.fromJson(Map<String, dynamic> json) {
    return DecisionRecord(
      scenarioId: json['scenarioId'] as String? ?? '',
      choiceId: json['choiceId'] as String? ?? '',
      riskValue: json['riskValue'] as int? ?? 0,
      scenarioWeight: json['scenarioWeight'] as int? ?? 0,
      decisionTime: Duration(seconds: json['decisionTime'] as int? ?? 0),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scenarioId': scenarioId,
      'choiceId': choiceId,
      'riskValue': riskValue,
      'scenarioWeight': scenarioWeight,
      'decisionTime': decisionTime.inSeconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class RiskScore {
  final String sessionId;
  final List<DecisionRecord> decisions;

  RiskScore({required this.sessionId, required this.decisions});

  double get baseScore {
    return decisions.fold(0.0, (total, record) => total + record.scenarioWeight * record.riskValue);
  }

  double get frequencyFactor {
    if (decisions.isEmpty) return 0.0;
    final risky = decisions.where((d) => d.riskValue > 0).length;
    return risky / decisions.length;
  }

  double get timeFactor {
    if (decisions.isEmpty) return 0.0;
    final seconds = decisions.fold<double>(0, (total, record) => total + record.decisionTime.inSeconds);
    final avg = seconds / decisions.length;
    return avg <= 0 ? 0.0 : 1.0 / avg;
  }

  double get adaptationFactor {
    final retries = decisions.length <= 1 ? 0 : decisions.length - 1;
    if (retries <= 0) return 1.0;
    final improved = decisions
        .asMap()
        .entries
        .where((entry) => entry.key > 0 && entry.value.riskValue == 0 && decisions[entry.key - 1].riskValue > 0)
        .length;
    return 1.0 - (improved / retries);
  }

  double get totalScore {
    final score = baseScore + 2.0 * frequencyFactor + 1.5 * timeFactor + 1.5 * adaptationFactor;
    return score.clamp(0.0, 100.0);
  }

  RiskLevel get level {
    if (totalScore >= 13) return RiskLevel.high;
    if (totalScore >= 6) return RiskLevel.medium;
    return RiskLevel.low;
  }

  bool get isHighRisk => totalScore > 12 && frequencyFactor > 0.6;
}
