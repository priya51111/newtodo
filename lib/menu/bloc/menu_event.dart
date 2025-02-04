abstract class MenuEvent {}


class CreateMenu extends MenuEvent {
  final String menuname;
  final String date;

  CreateMenu({required this.menuname, required this.date});
}
class FetchMenu extends MenuEvent {
  final String userId;
  final String date;

  FetchMenu(this.userId,  this.date);
}