import 'package:flutter/cupertino.dart';

class StartMenuProvider extends ChangeNotifier {
  bool showMenu = false;

  void shouldShowMenu(bool showMenu) {
    this.showMenu = showMenu;
    notifyListeners();
  }
}