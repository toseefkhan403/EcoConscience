import 'package:flutter/cupertino.dart';

class StartMenuProvider extends ChangeNotifier {
  bool _showMenu = false;

  bool get showMenu => _showMenu;

  set showMenu(bool value) {
    _showMenu = value;
    notifyListeners();
  }
}
