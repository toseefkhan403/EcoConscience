import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'eco_meter_provider.dart';

class RestartProvider extends ChangeNotifier {

  void restartTheGame(BuildContext context) {
    context.read<EcoMeterProvider>().ecoMeter = 100;
    context.read<StartMenuProvider>().showMenu = false;

    notifyListeners();
  }
}
