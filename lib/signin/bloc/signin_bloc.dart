import 'package:logger/logger.dart';

import 'package:bloc/bloc.dart';
import 'package:newtodo/signin/bloc/signin_event.dart';
import 'package:newtodo/signin/bloc/signin_state.dart';
import 'package:newtodo/signin/repository/signin_repository.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc({
    required SigninRepository SigninRepository,
  })  : _signinRepository = SigninRepository,
        super(SigninState.initial) {
    on<CreateUser>(_onCreateUser);
    on<LoginUser>(_onLoginUser);
     on<LogoutUser>(_onLogoutUser);
  }
  final SigninRepository _signinRepository;
  final Logger logger = Logger();
  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SigninStatus.loading));
      final userCreate =
          await _signinRepository.signIn(event.email, event.password);
      logger.d("Login ::: _onCreateUser:: $userCreate");
      emit(state.copyWith(
        status: SigninStatus.loaded,
        user: userCreate,
      ));
        final login = await _signinRepository.logIn(event.email, event.password);
      logger.d("Login ::: _onLoginUser:: $login.token");

    
      emit(state.copyWith(
        status: SigninStatus.loaded,
        user: login,
      ));
    } catch (error) {
      logger.e("Error fetching JSON data: $error");

      emit(
        state.copyWith(
          status: SigninStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLoginUser(
    LoginUser event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SigninStatus.loading));
      final login = await _signinRepository.logIn(event.email, event.password);
      logger.d("Login ::: _onCreateUser:: $login");
      emit(state.copyWith(
        status: SigninStatus.loaded,
        user: login,
      ));
    } catch (error) {
      logger.e("Error fetching JSON data: $error");

      emit(
        state.copyWith(
          status: SigninStatus.error,
          message: error.toString(),
        ),
      );
    }
  }
    Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SigninStatus.loading));
      await _signinRepository.logOut(); // Perform logout logic
      logger.i("User logged out successfully");
      emit(state.copyWith(
        status: SigninStatus.initial,
        user: null,
      ));
    } catch (error) {
      logger.e("Error during logout: $error");
      emit(state.copyWith(
        status: SigninStatus.error,
        message: error.toString(),
      ));
    }
  }
}
