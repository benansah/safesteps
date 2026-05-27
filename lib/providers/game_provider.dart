import 'package:flutter/material.dart';
import '../models/game_log.dart';
import '../models/risk_score.dart';
import '../models/scenario.dart';
import '../services/risk_scorer.dart';
import '../services/robotics_service.dart';
import '../services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  Scenario? currentScenario;
  ScenarioNode? currentNode;
  List<DecisionRecord> decisions = [];
  DateTime? sessionStart;
  DateTime? nodeStart;
  RiskScore? riskScore;
  bool sessionCompleted = false;
  bool sessionSaved = false;

  final RiskScorer _scorer = RiskScorer();

  void startSession(Scenario scenario) {
    currentScenario = scenario;
    currentNode = scenario.nodes.isNotEmpty ? scenario.nodes.first : null;
    decisions = [];
    sessionStart = DateTime.now();
    nodeStart = DateTime.now();
    riskScore = null;
    sessionCompleted = scenario.nodes.isEmpty;
    sessionSaved = false;
    notifyListeners();
  }

  Future<void> makeChoice(Choice choice) async {
    if (currentScenario == null || currentNode == null) return;
    final now = DateTime.now();
    final duration = now.difference(nodeStart ?? now);
    decisions.add(DecisionRecord(
      scenarioId: currentScenario!.id,
      choiceId: choice.id,
      riskValue: choice.riskValue,
      scenarioWeight: currentScenario!.weight,
      decisionTime: duration,
      timestamp: now,
    ));

    riskScore = _scorer.calculate(decisions);
    await RoboticsService.instance.sendSafetyCommand(choice.riskValue);

    if (choice.nextNodeId.isEmpty) {
      sessionCompleted = true;
    } else {
      final next = currentScenario!.nodes.firstWhere(
        (node) => node.id == choice.nextNodeId,
        orElse: () => currentScenario!.nodes.last,
      );
      currentNode = next;
      nodeStart = DateTime.now();
    }
    notifyListeners();
  }

  Future<void> completeSession() async {
    if (currentScenario == null || riskScore == null || sessionSaved) return;

    await StorageService.instance.logSession(
      scenarioId: currentScenario!.id,
      decisions: decisions,
      riskScore: riskScore!.totalScore,
      riskLevel: riskScore!.level.toString().split('.').last,
      helpButtonActivated: false,
    );

    final gameLog = GameLog(
      sessionId: riskScore!.sessionId,
      userId: StorageService.instance.userId,
      userName: StorageService.instance.userName,
      scenarioId: currentScenario!.id,
      scenarioTitle: currentScenario!.title,
      totalScore: riskScore!.totalScore,
      riskLevel: riskScore!.level.toString().split('.').last,
      helpTriggered: false,
      createdAt: DateTime.now(),
      decisions: List.from(decisions),
    );

    await StorageService.instance.saveGameLog(gameLog);
    await StorageService.instance.syncGameLogs();

    sessionCompleted = true;
    sessionSaved = true;
    notifyListeners();
  }

  int get nodeIndex {
    if (currentScenario == null || currentNode == null) return 0;
    return currentScenario!.nodes.indexWhere((node) => node.id == currentNode!.id) + 1;
  }

  int get totalNodes => currentScenario?.nodes.length ?? 1;
}
