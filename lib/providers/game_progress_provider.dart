import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/story_progress.dart';

class GameProgressProvider extends ChangeNotifier {
  GameProgressProvider() {
    _initSharedPrefs();
  }

  int ecoMeter = 100;
  Map<String, bool> allStoryArcsProgress = {
    StoryTitles.introArc.name: false,
    StoryTitles.bathroomArc.name: false,
    StoryTitles.houseLightsArc.name: false,
    StoryTitles.busToOfficeArc.name: false,
    StoryTitles.officePlantationArc.name: false,
    StoryTitles.tacoArc.name: false,
  };
  bool isHouseLightsOn = true;
  String character = 'Bob';
  String playerName = '';
  late SharedPreferences _prefs;

  Future<void> _initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  deductPoints() {
    ecoMeter -= 20;
    _prefs.setInt('ecoMeter', ecoMeter);
    notifyListeners();
  }

  loadProgress() {
    ecoMeter = _prefs.getInt('ecoMeter') ?? 100;
    isHouseLightsOn = _prefs.getBool('isHouseLightsOn') ?? true;
    character = _prefs.getString('character') ?? 'Bob';
    playerName = _prefs.getString('playerName') ?? '';
    allStoryArcsProgress[StoryTitles.introArc.name] =
        _prefs.getBool(StoryTitles.introArc.name) ?? false;
    allStoryArcsProgress[StoryTitles.bathroomArc.name] =
        _prefs.getBool(StoryTitles.bathroomArc.name) ?? false;
    allStoryArcsProgress[StoryTitles.houseLightsArc.name] =
        _prefs.getBool(StoryTitles.houseLightsArc.name) ?? false;
    allStoryArcsProgress[StoryTitles.busToOfficeArc.name] =
        _prefs.getBool(StoryTitles.busToOfficeArc.name) ?? false;
    allStoryArcsProgress[StoryTitles.officePlantationArc.name] =
        _prefs.getBool(StoryTitles.officePlantationArc.name) ?? false;
    allStoryArcsProgress[StoryTitles.tacoArc.name] =
        _prefs.getBool(StoryTitles.tacoArc.name) ?? false;
  }

  resetProgress() {
    ecoMeter = 100;
    allStoryArcsProgress = {
      StoryTitles.introArc.name: false,
      StoryTitles.bathroomArc.name: false,
      StoryTitles.houseLightsArc.name: false,
      StoryTitles.busToOfficeArc.name: false,
      StoryTitles.officePlantationArc.name: false,
      StoryTitles.tacoArc.name: false,
    };
    isHouseLightsOn = true;
    // reset prefs
    _prefs.remove('ecoMeter');
    _prefs.remove('isHouseLightsOn');
    _prefs.remove('character');
    _prefs.remove('playerName');
    _prefs.remove(StoryTitles.introArc.name);
    _prefs.remove(StoryTitles.bathroomArc.name);
    _prefs.remove(StoryTitles.houseLightsArc.name);
    _prefs.remove(StoryTitles.busToOfficeArc.name);
    _prefs.remove(StoryTitles.officePlantationArc.name);
    _prefs.remove(StoryTitles.tacoArc.name);
  }

  updateStoryProgress(String currentStoryArc) {
    allStoryArcsProgress[currentStoryArc] = true;
    _prefs.setBool(currentStoryArc, true);
  }

  void turnOffHouseLights() {
    isHouseLightsOn = false;
    _prefs.setBool('isHouseLightsOn', false);
  }

  bool doesSaveExist() {
    return _prefs.getString('character') != null;
  }

  savePlayerInfo(String characterSkin, String name) {
    character = characterSkin;
    playerName = name;
    _prefs.setString('character', character);
    _prefs.setString('playerName', playerName);
  }
}
