import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'game_progress_provider.dart';

class RestartProvider extends ChangeNotifier {

  void restartTheGame(BuildContext context) {
    context.read<GameProgressProvider>().resetProgress();
    context.read<StartMenuProvider>().showMenu = false;

    notifyListeners();
  }
}
