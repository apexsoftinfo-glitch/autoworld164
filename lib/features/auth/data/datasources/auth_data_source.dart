import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Stream<Map<String, dynamic>?> watchPrincipal();

  Map<String, dynamic>? get currentPrincipal;

  Future<void> signInAnonymously();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> upgradeAnonymousWithEmail({
    required String email,
    required String password,
  });

  Future<void> deleteAccount();

  Future<void> signOut();
}

@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource implements AuthDataSource {
  SupabaseAuthDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Stream<Map<String, dynamic>?> watchPrincipal() {
    final initialPrincipal = _mapUser(_supabaseClient.auth.currentUser);
    debugPrint(
      'ℹ️ [AuthDataSource] watchPrincipal subscribed initial=${_describeRawPrincipal(initialPrincipal)}',
    );

    return _supabaseClient.auth.onAuthStateChange
        .map((authState) {
          final principal = _mapUser(authState.session?.user);
          debugPrint(
            'ℹ️ [AuthDataSource] auth event=${authState.event} principal=${_describeRawPrincipal(principal)}',
          );
          return principal;
        })
        .startWith(initialPrincipal);
  }

  @override
  Map<String, dynamic>? get currentPrincipal =>
      _mapUser(_supabaseClient.auth.currentUser);

  @override
  Future<void> signInAnonymously() async {
    debugPrint('ℹ️ [AuthDataSource] signInAnonymously started');
    await _supabaseClient.auth.signInAnonymously();
    debugPrint('✅ [AuthDataSource] signInAnonymously succeeded');
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('ℹ️ [AuthDataSource] signInWithEmail started email=$email');
    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    debugPrint('✅ [AuthDataSource] signInWithEmail succeeded email=$email');
  }

  @override
  Future<void> upgradeAnonymousWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint(
      'ℹ️ [AuthDataSource] upgradeAnonymousWithEmail started email=$email',
    );
    await _supabaseClient.auth.updateUser(
      UserAttributes(email: email, password: password),
    );
    debugPrint(
      '✅ [AuthDataSource] upgradeAnonymousWithEmail succeeded email=$email',
    );
  }

  @override
  Future<void> deleteAccount() async {
    debugPrint('ℹ️ [AuthDataSource] deleteAccount started');

    try {
      final response = await _supabaseClient.functions.invoke('delete-account');
      debugPrint(
        '✅ [AuthDataSource] deleteAccount succeeded status=${response.status}',
      );
    } on FunctionException catch (error) {
      debugPrint('❌ [AuthDataSource] deleteAccount error: $error');

      if (error.status == 404) {
        throw StateError('delete_account_setup_required');
      }

      if (error.details is Map &&
          (error.details as Map)['error'] == 'delete_account_failed') {
        throw StateError('delete_account_failed');
      }

      throw StateError('delete_account_failed');
    }
  }

  @override
  Future<void> signOut() async {
    debugPrint('ℹ️ [AuthDataSource] signOut started');
    await _supabaseClient.auth.signOut();
    debugPrint('✅ [AuthDataSource] signOut succeeded');
  }

  Map<String, dynamic>? _mapUser(User? user) {
    if (user == null) return null;

    return {
      'user_id': user.id,
      'email': user.email,
      'is_anonymous': user.isAnonymous,
    };
  }

  String _describeRawPrincipal(Map<String, dynamic>? rawPrincipal) {
    if (rawPrincipal == null) return 'none';

    return 'userId=${rawPrincipal['user_id']} email=${rawPrincipal['email'] ?? "-"} anonymous=${rawPrincipal['is_anonymous'] ?? false}';
  }
}
