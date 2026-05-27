import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game_log.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String _supabaseKey = String.fromEnvironment('SUPABASE_KEY', defaultValue: '');
  bool _initialized = false;

  bool get isConfigured => _supabaseUrl.isNotEmpty && _supabaseKey.isNotEmpty;

  Future<void> initialize() async {
    if (!isConfigured || _initialized) return;
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseKey);
    _initialized = true;
  }

  Future<bool> get isOnline async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  Future<bool> syncGameLogs(List<GameLog> logs) async {
    if (!isConfigured || !_initialized || logs.isEmpty) {
      return false;
    }

    if (!await isOnline) {
      return false;
    }

    try {
      await Supabase.instance.client
          .from('game_logs')
          .insert(logs.map((log) => log.toJson()).toList());
      return true;
    } catch (_) {
      return false;
    }
  }
}
