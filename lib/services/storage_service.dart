import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/game_log.dart';
import '../models/risk_score.dart';
import 'supabase_service.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String _gameLogsKey = 'game_logs';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _userRoleKey = 'userRole';
  static const String _studentIdKey = 'studentId';

  late SharedPreferences _prefs;
  FirebaseFirestore? _firestore;
  String userId = const Uuid().v4();
  String userName = '';
  String userRole = 'student';
  String studentId = '';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    userId = _prefs.getString(_userIdKey) ?? const Uuid().v4();
    userName = _prefs.getString(_userNameKey) ?? '';
    userRole = _prefs.getString(_userRoleKey) ?? 'student';
    studentId = _prefs.getString(_studentIdKey) ?? '';
    await _prefs.setString(_userIdKey, userId);
    if (!kIsWeb) {
      _firestore = FirebaseFirestore.instance;
    }
    await SupabaseService.instance.initialize();
  }

  Future<void> saveLogin({
    required String id,
    required String name,
    required String role,
    String studentId = '',
  }) async {
    userId = id;
    userName = name;
    userRole = role;
    this.studentId = studentId;
    await _prefs.setString(_userIdKey, id);
    await _prefs.setString(_userNameKey, name);
    await _prefs.setString(_userRoleKey, role);
    await _prefs.setString(_studentIdKey, studentId);
  }

  Future<void> clearLogin() async {
    userId = const Uuid().v4();
    userName = '';
    userRole = 'student';
    studentId = '';
    await _prefs.setString(_userIdKey, userId);
    await _prefs.remove(_userNameKey);
    await _prefs.setString(_userRoleKey, userRole);
    await _prefs.remove(_studentIdKey);
  }

  Future<void> saveLanguage(String code) async {
    await _prefs.setString('language', code);
  }

  Future<String> getLanguage() async {
    return _prefs.getString('language') ?? 'en';
  }

  Future<void> saveSessionSummary(
      int sessions, int highRisk, int helpActivations) async {
    await _prefs.setInt('sessionCount', sessions);
    await _prefs.setInt('highRiskCount', highRisk);
    await _prefs.setInt('helpActivations', helpActivations);
  }

  Future<Map<String, int>> getSessionSummary() async {
    return {
      'sessionCount': _prefs.getInt('sessionCount') ?? 0,
      'highRiskCount': _prefs.getInt('highRiskCount') ?? 0,
      'helpActivations': _prefs.getInt('helpActivations') ?? 0,
    };
  }

  Future<void> saveHelpActivationCount(int count) async {
    await _prefs.setInt('helpActivations', count);
  }

  Future<int> getHelpActivationCount() async {
    return _prefs.getInt('helpActivations') ?? 0;
  }

  Future<void> logSession({
    required String scenarioId,
    required List<DecisionRecord> decisions,
    required double riskScore,
    required String riskLevel,
    required bool helpButtonActivated,
    String districtCode = 'unknown',
  }) async {
    if (_firestore == null) return;
    try {
      final sessionId = const Uuid().v4();
      final sessionDoc = _firestore!.collection('sessions').doc(sessionId);
      await sessionDoc.set({
        'userId': userId,
        'userName': userName,
        'scenarioId': scenarioId,
        'decisions': decisions
            .map((decision) => {
                  'choiceId': decision.choiceId,
                  'riskValue': decision.riskValue,
                  'scenarioWeight': decision.scenarioWeight,
                  'decisionTime': decision.decisionTime.inSeconds,
                  'timestamp': decision.timestamp.toIso8601String(),
                })
            .toList(),
        'riskScore': riskScore,
        'riskLevel': riskLevel,
        'helpButtonActivated': helpButtonActivated,
        'timestamp': DateTime.now().toIso8601String(),
        'districtCode': districtCode,
      });
    } catch (_) {
      // Ignore errors and remain offline-first.
    }
  }

  Future<void> logHelpActivation({
    required String sessionId,
    String districtCode = 'unknown',
  }) async {
    if (_firestore == null) return;
    try {
      final activationId = const Uuid().v4();
      await _firestore!.collection('helpActivations').doc(activationId).set({
        'sessionId': sessionId,
        'timestamp': DateTime.now().toIso8601String(),
        'districtCode': districtCode,
      });
    } catch (_) {
      // Fail silently.
    }
  }

  Future<List<GameLog>> getCachedGameLogs() async {
    final rawLogs = _prefs.getStringList(_gameLogsKey) ?? [];
    return rawLogs
        .map((jsonString) =>
            GameLog.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveGameLog(GameLog log) async {
    final existing = await getCachedGameLogs();
    existing.add(log);
    final encoded =
        existing.map((entry) => jsonEncode(entry.toJson())).toList();
    await _prefs.setStringList(_gameLogsKey, encoded);
  }

  Future<List<GameLog>> fetchLogsForUser(String userId) async {
    if (_firestore != null) {
      try {
        final snapshot = await _firestore!
            .collection('sessions')
            .where('userId', isEqualTo: userId)
            .get();
        return snapshot.docs
            .map((doc) => GameLog.fromJson(doc.data()))
            .toList();
      } catch (_) {
        // Fall back to cached logs.
      }
    }
    final cached = await getCachedGameLogs();
    return cached.where((log) => log.userId == userId).toList();
  }

  Future<List<GameLog>> fetchAllLogs() async {
    if (_firestore != null) {
      try {
        final snapshot = await _firestore!.collection('sessions').get();
        final remote =
            snapshot.docs.map((doc) => GameLog.fromJson(doc.data())).toList();
        return remote;
      } catch (_) {
        // Fall back to cached logs.
      }
    }
    return await getCachedGameLogs();
  }

  Future<void> clearCachedGameLogs() async {
    await _prefs.remove(_gameLogsKey);
  }

  Future<void> syncGameLogs() async {
    final logs = await getCachedGameLogs();
    if (logs.isEmpty) return;
    final success = await SupabaseService.instance.syncGameLogs(logs);
    if (success) {
      await clearCachedGameLogs();
    }
  }
}
