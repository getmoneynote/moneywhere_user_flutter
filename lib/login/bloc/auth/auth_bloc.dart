import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/commons/index.dart';
import '/login/index.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(const AuthState()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(_, Emitter<AuthState> emit) async {
    final String token = await getToken();
    if (token.isNotEmpty) {
      try {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          initState: await LoginRepository.getInitState(),
        ));
      } catch (_) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
        ));
      }
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
      ));
    }
  }

  void _onLoggedOut(_, Emitter<AuthState> emit) async {
    await deleteToken();
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      initState: null,
    ));
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    await saveToken(event.token);
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      initState: await LoginRepository.getInitState()
    ));
  }

}