import 'package:uuid/uuid.dart';
import '../models/risk_score.dart';

class RiskScorer {
  final _uuid = const Uuid();

  RiskScore calculate(List<DecisionRecord> decisions) {
    return RiskScore(sessionId: _uuid.v4(), decisions: decisions);
  }
}
