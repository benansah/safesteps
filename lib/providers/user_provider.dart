import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/constants.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  String localeCode = 'en';
  String userId = StorageService.instance.userId;
  String role = StorageService.instance.userRole;
  String displayName = StorageService.instance.userName;
  String studentId = StorageService.instance.studentId;
  bool teacherMode = false;
  int teacherPin = 1234;
  int helpActivations = 0;
  int sessionCount = 0;
  int highRiskCount = 0;

  UserProvider() {
    _loadLanguage();
    _loadStats();
  }

  String get label => localeCode == 'tw'
      ? AppStrings.tw['appName']!
      : AppStrings.en['appName']!;

  bool get isStudent => role == 'student';
  bool get isParent => role == 'parent';
  bool get isTeacher => role == 'teacher';
  bool get isLoggedIn => displayName.isNotEmpty;

  Future<void> _loadLanguage() async {
    localeCode = await StorageService.instance.getLanguage();
    notifyListeners();
  }

  Future<void> _loadStats() async {
    final summary = await StorageService.instance.getSessionSummary();
    sessionCount = summary['sessionCount'] ?? 0;
    highRiskCount = summary['highRiskCount'] ?? 0;
    helpActivations = summary['helpActivations'] ?? 0;
    notifyListeners();
  }

  String translate(String key) {
    return localeCode == 'tw'
        ? AppStrings.tw[key] ?? key
        : AppStrings.en[key] ?? key;
  }

  Future<void> setLanguage(String code) async {
    localeCode = code;
    await StorageService.instance.saveLanguage(code);
    notifyListeners();
  }

  Future<void> incrementHelpCount() async {
    helpActivations += 1;
    await StorageService.instance.saveHelpActivationCount(helpActivations);
    notifyListeners();
  }

  Future<void> incrementSessionCount(bool highRisk) async {
    sessionCount += 1;
    if (highRisk) highRiskCount += 1;
    await StorageService.instance
        .saveSessionSummary(sessionCount, highRiskCount, helpActivations);
    notifyListeners();
  }

  Future<void> loginStudent(String name, String studentId) async {
    role = 'student';
    displayName = name;
    this.studentId = studentId;
    userId = studentId;
    await StorageService.instance.saveLogin(
      id: studentId,
      name: name,
      role: role,
      studentId: studentId,
    );
    notifyListeners();
  }

  Future<void> loginParent(String name, String studentId) async {
    role = 'parent';
    displayName = name;
    this.studentId = studentId;
    userId = 'parent-$studentId';
    await StorageService.instance.saveLogin(
      id: userId,
      name: name,
      role: role,
      studentId: studentId,
    );
    notifyListeners();
  }

  Future<void> loginTeacher(String name) async {
    role = 'teacher';
    displayName = name;
    studentId = '';
    userId = 'teacher';
    await StorageService.instance.saveLogin(
      id: userId,
      name: name,
      role: role,
      studentId: '',
    );
    notifyListeners();
  }

  Future<void> logout() async {
    role = 'student';
    displayName = '';
    studentId = '';
    userId = const Uuid().v4();
    await StorageService.instance.clearLogin();
    notifyListeners();
  }

  bool validateTeacherPin(int pin) {
    return pin == teacherPin;
  }
}
