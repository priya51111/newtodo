import 'package:equatable/equatable.dart';
import 'package:newtodo/menu/model.dart';

enum MenuStatus { initial, loading, loaded, error }

final class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.initial,
    this.menu,
    this.message,
    this.menuList=const []
  });
  final MenuStatus status;
  final Map<String, dynamic>? menu;
  final String? message;
  final List<Menu> menuList;

  static MenuState initial =
      const MenuState(status: MenuStatus.initial, message: '', menu: {},menuList:[]);

  MenuState copyWith({
    MenuStatus? status,
    Map<String, dynamic>? user,
    String? message,
     List<Menu> ?menuList,
  }) {
    return MenuState(
      status: status ?? this.status,
      menu: user ?? this.menu,
      message: message ?? this.message,
      menuList: menuList??this.menuList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        menu,
        message,
      menuList
      ];
}
