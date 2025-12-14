import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:productivity_app/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    // On n'émet pas Loading ici pour éviter de bloquer l'UI au démarrage si c'est rapide
    try {
      final userStream = authRepository.user;
      await emit.forEach(userStream, onData: (user) {
        if (user != null) {
          return AuthAuthenticated(user.uid);
        } else {
          return AuthUnauthenticated();
        }
      });
    } catch (_) {
      emit(AuthFailure("Failed to check auth status"));
    }
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signIn(email: event.email, password: event.password);
      // On n'émet rien ici, car le stream de _onAuthStarted va détecter le changement d'état (User connecté)
      // et émettre AuthAuthenticated automatiquement.
    } catch (e) {
      // En cas d'erreur, on émet l'échec.
      emit(AuthFailure(e.toString()));
      // CRUCIAL : On remet immédiatement l'état à Unauthenticated pour que l'UI sorte du mode "Loading"
      // et réaffiche le formulaire. Le SnackBar aura eu le temps d'être déclenché par le listener sur AuthFailure.
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
  }
}
