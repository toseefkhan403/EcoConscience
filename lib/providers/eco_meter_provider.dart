import 'package:flutter/cupertino.dart';

class EcoMeterProvider extends ChangeNotifier {
  int ecoMeter = 100;

  deductPoints() {
    ecoMeter -= 20;
    notifyListeners();
  }
}
