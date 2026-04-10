import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/models/user_model.dart';
import '../../../home/presentation/cubit/mood_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;
  final MoodCubit _moodCubit;

  StreamSubscription<AuthState>? _authSub;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository authRepository,
    required MoodCubit moodCubit,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _authRepository = authRepository,
        _moodCubit = moodCubit,
        super(AuthInitial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSub = Supabase.instance.client.auth.onAuthStateChange
        .where((data) =>
            data.event != AuthChangeEvent.tokenRefreshed &&
            data.event != AuthChangeEvent.userUpdated)
        .map((data) {
          final session = data.session;
          if (session != null) {
            return AuthAuthenticated(UserModel.fromSupabaseUser(session.user))
                as AuthState;
          }
          return AuthUnauthenticated();
        })
        .listen((authState) {
          if (isClosed) return;
          emit(authState);
          if (authState is AuthAuthenticated) {
            _moodCubit.clearEntries();
            _moodCubit.getHistory();
          } else if (authState is AuthUnauthenticated) {
            _moodCubit.clearEntries();
          }
        });
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _loginUseCase(email: email, password: password);
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        // OAuth flow opened in browser — auth state listener handles the rest
      },
    );
  }

  Future<void> logout() async {
    _moodCubit.clearEntries();
    final result = await _logoutUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
