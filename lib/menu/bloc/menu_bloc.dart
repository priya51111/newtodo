import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import 'package:bloc/bloc.dart';
import 'package:newtodo/menu/home_page.dart';
import 'package:newtodo/menu/bloc/menu_event.dart';
import 'package:newtodo/menu/bloc/menu_state.dart';
import 'package:newtodo/menu/repo/repositiry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required MenuRepository menuRepository,
  })  : _menuRepository = menuRepository,
        super(MenuState.initial) {
    on<CreateMenu>(_onCreateMenu);
    on<FetchMenu>(_onFetchMenu);
  }
  final MenuRepository _menuRepository;
  final Logger logger = Logger();
   final box = GetStorage();
  Future<void> _onCreateMenu(
    CreateMenu event,
    Emitter<MenuState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));
      final menuCreate =
          await _menuRepository.createMenu(event.menuname, event.date);
      logger.d("MenuBloc ::: _onCreateMenu:: $menuCreate");

      
      emit(state.copyWith(
        status: MenuStatus.loaded,
        user: menuCreate,
      ));
        final userId = box.read('userId');
      final date = box.read('menuDate');

     if (userId != null && date != null) {
 
} else {
  emit(state.copyWith(
    status: MenuStatus.error,
    message: "Date or userId is missing",
  ));
}

       
      
    } catch (error) {
      logger.e("Error fetching JSON data: $error");

      emit(
        state.copyWith(
          status: MenuStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchMenu(FetchMenu event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));
      final fetchedMenu = await _menuRepository.fetchMenus(
          userId: event.userId, date: event.date);
      logger.d("MenuBloc ::: _onCreateMenu:: $fetchedMenu");
      emit(state.copyWith(
        status: MenuStatus.loaded,
        menuList: fetchedMenu,
      ));
    } catch (error) {
      logger.e("Error fetching JSON data: $error");

      emit(
        state.copyWith(
          status: MenuStatus.error,
          message: error.toString(),
        ),
      );
     
    }
  }
}
