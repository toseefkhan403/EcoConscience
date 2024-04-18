import 'package:auto_size_text/auto_size_text.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/providers/game_progress_provider.dart';
import 'package:eco_conscience/providers/locale_provider.dart';
import 'package:eco_conscience/widgets/utils.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';

import '../providers/restart_provider.dart';
import 'google_wallet_button.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({Key? key, required this.game}) : super(key: key);

  final EcoConscience game;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late AppLocalizations _local;

  final Map<int, String> jwtsEn = {
    100: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDEwMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkEgcGVyZmVjdCAxMDAhIn19LCJ0ZXh0TW9kdWxlc0RhdGEiOlt7ImlkIjoic2NvcmUiLCJoZWFkZXIiOiJTQ09SRSIsImJvZHkiOiIxMDAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoiUkVTVUxUIiwiYm9keSI6IkluY3JlZGlibGUhIFlvdSBhY2hpZXZlZCBhIHBlcmZlY3QgMTAwISBZb3Ugd2VyZSB0aGUgdW53YXZlcmluZyBjaGFtcGlvbiBvZiBFY29WaWxsZSEifV0sImhleEJhY2tncm91bmRDb2xvciI6IiNmZmQ0ZTEiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vZWNvc2hpZnQtMDEwMC5wbmc_YWx0PW1lZGlhJnRva2VuPTQ4MDM0NWUzLTdkNTQtNDViOS04YmE2LTYzZjVlM2VlNDc4NyJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IEdlbmVyaWMgUGFzcyJ9fX19XX0sImlhdCI6MTcxMzM3ODk2MX0.Ey2JmkAsFtbePZVohz8XMOLjWReIUlTQbcR09AUG5VDDCfPXk26UyN0zZt3K5R5MtJ8iOvr5xWvYiMCh--jWpdxah091lRYo-ERHXmkI2aHg-YAph3yrv_bLnXTioniqGWIp0evuqeSL6fyZvKGD4FveHUvD9vzFrL3SY0K2ZFmSeI8crDGsGFVNjSqqdOw2bj05ZV8LL4kykvh1g3d0g-b-Xo0SA7GNsuknq5fNgb2YPWzk2sUVMKNWTetCdKXi07WQZR0QRkCTDiLSHncbFZtQCTNkAgcIiDfycHaHv3-gL0QcQ0lkLIJDRoq9egrIgEZW924duBRTEHbENtlaBA",
    80: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDA4MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkdyZWF0IEpvYiEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IlNDT1JFIiwiYm9keSI6IjgwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6IlJFU1VMVCIsImJvZHkiOiJHcmVhdCBKb2IhIFlvdXIgZWNvLWZyaWVuZGx5IGFjdGlvbnMgc2lnbmlmaWNhbnRseSBiZW5lZml0ZWQgdGhlIGVjb3N5c3RlbSBvZiBFY29WaWxsZS4ifV0sImhleEJhY2tncm91bmRDb2xvciI6IiMyMDVEMjgiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vZWNvc2hpZnQtMDA4MC5wbmc_YWx0PW1lZGlhJnRva2VuPWQ2YWUwMThmLTQ1NTMtNDk4Zi04ZDFhLTg3NDZlMDQ5ZjAyYiJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IEdlbmVyaWMgUGFzcyJ9fX19XX0sImlhdCI6MTcxMzM3OTUxOH0.qjfJO1EQoHw3rGxwBofTf7rNyGVZtxU6Ga0nq7T_kpVKpJZX8r-1cCmxNFzhh62oQ92O6m1ywwA94zBinIxkjvoqxi1vwSO45P8N9B6zUbaC2BTSFywVM05ESHut76bRNiesjrTfGTg2VSRAkkOB_UwhGYRLh3t8UCHVDsRFRk_spvanR8rrxRR2d3lenQCmta4GW5LT-TT2ojNmjIaOOe2Hk3_UG55mGJexYOXgEgfzYYDVheD6H7yqbFNXyc3UHD8apRSd5WYazUjvms369JvLrafWCoYH9qgUpEoEirw4TQfvTAN1sO4Mz6c3U2XKh8ylQIaxFi5HJFTsvQopWQ",
    60: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDA2MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkNhbiBkbyBiZXR0ZXIhIn19LCJ0ZXh0TW9kdWxlc0RhdGEiOlt7ImlkIjoic2NvcmUiLCJoZWFkZXIiOiJTQ09SRSIsImJvZHkiOiI2MCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiJSRVNVTFQiLCJib2R5IjoiVGhlcmUgd2FzIHJvb20gZm9yIGltcHJvdmVtZW50LiBFY29WaWxsZSdzIGZhdGUgZGVwZW5kZWQgb24geW91ciBkZWRpY2F0aW9uISJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiI2VkOTM1MCIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9lY29zaGlmdC0wMDYwLnBuZz9hbHQ9bWVkaWEmdG9rZW49MTEyOTRiM2ItMzIxMy00OTZlLWEzYWEtZjVjZTkxMWFhMWI4In0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgR2VuZXJpYyBQYXNzIn19fX1dfSwiaWF0IjoxNzEzMzc5ODczfQ.SfyRhOtVsN6e3oIff45e2yMpFSBjLDbfoG_RrwpoLvmkOIcmQ-Fko05ldt8fdUWXjx36NEwBU2o6bFysCJVQKwX8RlpYpmI91jFGq7jPQvfKJKotHHBq5uR-BN6qNG0wGIh-9k2DAu5BksebjwuCcRBFPX75nhQ8LZG2ESuxYRVdRivoQyWOWEDXYOHbTvgpK3ZnRRqVrIrxsHPlNQe4--hQqxz-st_cApjcoBec8RLjNqgPlT5EScVAQBX5mH2t7RaeGIvf0BdC0Fryy0kOOievUp9uYvAWOAIXBcGICBP1MeD0HhwedeM3YsuB7uJDcyotHiUYmKR-UG_wa94MXQ",
    40: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDA0MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkNhbiBkbyBtdWNoIGJldHRlciEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IlNDT1JFIiwiYm9keSI6IjQwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6IlJFU1VMVCIsImJvZHkiOiJZb3UgaGFkIHNvbWUgd29yayB0byBkby4gTWFraW5nIGdyZWVuZXIgY2hvaWNlcyB3b3VsZCBoYXZlIHR1cm5lZCB0aGluZ3MgYXJvdW5kIGZvciBFY29WaWxsZSEifV0sImhleEJhY2tncm91bmRDb2xvciI6IiM5ODNBMjgiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vZWNvc2hpZnQtMDA0MC5wbmc_YWx0PW1lZGlhJnRva2VuPWQ1NmNjOTY2LTNmNzYtNDE2Yy1iZjBjLWZjZmMxY2IwOWU1NSJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IEdlbmVyaWMgUGFzcyJ9fX19XX0sImlhdCI6MTcxMzM4MDEwNn0.mUEd1v_eKtSUQS1ozIZRZGvylD7_eb_KvyK0gldRoKngXwC5ps5DJKKvt-8gvVTmYAD4LYsd1KVnunYmBi9EtGOJVUdAIecrKbWToI0mrqeAo9pyxmPrCnLC70FR1q-pRnW-GIcFZ98tHKkbTk2pKqGQOwZ7lbZ055PHkMa5qch9mh964l-q4jFP-iLMXAarr4x1wqtpTlWoGuuIdzAoIQ03APaMekVm-ziJoHLqRVvUwEF7EjAx3sYW-F-0hM-SSZCVJiT2t2dnAOkgjIKBdiSbY4SKZaTmVmKU59h2FOL43NDDeYNMh6WUrrqUXRWOZBnu_VESK6fGqO70P3iujQ",
    20: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDAyMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6Ik5ldmVyIHRvbyBsYXRlIHRvIGNoYW5nZSEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IlNDT1JFIiwiYm9keSI6IjIwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6IlJFU1VMVCIsImJvZHkiOiJJdCB3YXMgbmV2ZXIgdG9vIGxhdGUgdG8gY2hhbmdlISBFdmVyeSBwb3NpdGl2ZSBjaG9pY2UgY291bnRlZCB0b3dhcmRzIGEgaGVhbHRoaWVyIGVudmlyb25tZW50LiJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiI0MyMzUxNSIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9lY29zaGlmdC0wMDIwLnBuZz9hbHQ9bWVkaWEmdG9rZW49M2I2NzIxMzItMDRhOC00MzZhLWFhNzQtMTg5ZmRkNGQ5NDJlIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgR2VuZXJpYyBQYXNzIn19fX1dfSwiaWF0IjoxNzEzMzgwODUxfQ.pJle4Iix8s0Wtdqn32Pk76z_s7APFWRc2FCEm4UqRrT_Ckj7fOu9c1oG9AJbAGSsOu3lVaURYBGVHpheYQEzbUbb9IaZOK3MAf7jiVLYQtISTiFnb_Jr06GPcXA_YEsQfculg_CGo_JMdxt5Wuhb9c9qNubREU3inCKjm2up4UOc-tk3dKg2MCpyPqNkrUM4QAA3BRdOzujPRaEiZ7uIsegRrdDG6-rQKOTdwlqv_jfSETNMCxk2L8sBqnuZEPqaWf3C3jQkD3qbrl1WmggekeoL84X85jc7831NbbuH6vd3eqhGrO7mLqbRVbCJXGQ9AF6pgf-uIwoEqIfh179t0Q",
    0: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDAwMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVhcnRoIn19fSwiY2FyZFRpdGxlIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19LCJoZWFkZXIiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6Ik5ldmVyIHRvbyBsYXRlIHRvIGNoYW5nZSEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IlNDT1JFIiwiYm9keSI6IjAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoiUkVTVUxUIiwiYm9keSI6Ikl0IHdhcyBuZXZlciB0b28gbGF0ZSB0byBjaGFuZ2UhIEV2ZXJ5IHBvc2l0aXZlIGNob2ljZSBjb3VudGVkIHRvd2FyZHMgYSBoZWFsdGhpZXIgZW52aXJvbm1lbnQuIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjQzIzNTE1IiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb3NoaWZ0LTAwMjAucG5nP2FsdD1tZWRpYSZ0b2tlbj0zYjY3MjEzMi0wNGE4LTQzNmEtYWE3NC0xODlmZGQ0ZDk0MmUifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBHZW5lcmljIFBhc3MifX19fV19LCJpYXQiOjE3MTMzODA5ODJ9.m8M3G8KVS60shOr51vKyr5DGt3pwBE9pc916uM_FgUQanYIAUUH30LdRzldEjZODlE2OAVBWUWLihxAoMDx-HFbzbdYDsX-k-Hj8mT1wfno2Eye0RRc-j-LXSlDmWE7tkiO6aLE5QG4UDYJRpFeWxGWiFFfOm4T2P7I2szivV-WMNxsZ6KBojjRiRP2aabxx0BGDqukl_8HOSdoRBhjBS3YAIanrl_-omIRsvPx0mmdrLGQ3AecUf_mKMu5l6nJlBxaozA4a6KMgUTpU6Q-Fqp-3WQ3jaW-kPfvgc9lCtZh0qmu1-wSeQdVx1CTVZN_cUxyUuMkNFrnFIdNAIKGRcQ",
  };

  final Map<int, String> jwtsJa = {
    100:
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMTEwMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLlroznkqfjgaoxMDDngrnvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiIxMDAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoi57WQ5p6cIiwiYm9keSI6IuS_oeOBmOOCieOCjOOBquOBhO-8geWujOeSp-OBqjEwMOeCueOCkumBlOaIkOOBl-OBvuOBl-OBn--8geOBguOBquOBn-OBr-OCqOOCs-ODk-ODq-OBruaPuuOCi-OBjuOBquOBhOODgeODo-ODs-ODlOOCquODs-OBp-OBl-OBn--8gSJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiI2ZmZDRlMSIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9lY29zaGlmdC0wMTEwMC5wbmc_YWx0PW1lZGlhJnRva2VuPWNkNTNhNjhiLTlhM2MtNDA2Ni05OTg4LWM2MWYxYTk0YTI0ZSJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuOCqOOCs-OCt-ODleODiCDjgrjjgqfjg43jg6rjg4Pjgq8g44OR44K5In19fX1dfSwiaWF0IjoxNzEzMzgyOTU0fQ.nZqwrHrr-LlJQwjWRe1yRpMWMYM7prtNDfcFMrtGNTcIONxOJA1FzSgBITIBwecslR6mDQFXxyA4W66CJtv6nJfNJQCsKzMfiCzyrWMfzEl33q6YK_YQE_cSaYYAd6ScMglG9v57u7lcv6ESUAOvnCzAnY64uOXdx0JESC41jZ0nLZ1T0ZEJpwAO8pOk6MlnzFXnGyHjlx7GbI8krKsphiluu5bgbw6LX504_TmlrrsJ-E0-guA5a5JAXi2s1C4Jg45s54E28J13-Y70mqDsnypROQkvPe9pfmA-xnKRVSEpqWjd1CcQUsVhKe-0ktd2u39UTxUwhSZgUajkvnp2YQ",
    80: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMTA4MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLntKDmmbTjgonjgZfjgYTku5XkuovjgafjgZnvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiI4MCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiLntZDmnpwiLCJib2R5Ijoi57Sg5pm044KJ44GX44GE5LuV5LqL44Gn44GZ77yB44GC44Gq44Gf44Gu44Ko44Kz44OV44Os44Oz44OJ44Oq44O844Gq6KGM5YuV44GM44CB44Ko44Kz44OT44Or44Gu55Sf5oWL57O744Gr5aSn44GN44Gq5Yip55uK44KS44KC44Gf44KJ44GX44G-44GX44Gf44CCIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjMjA1ZDI4IiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb3NoaWZ0LTAxMDgwLnBuZz9hbHQ9bWVkaWEmdG9rZW49Yjk1N2I3ZDktZTFiMy00YjNiLWEzZjQtMjU2MjRiNWU1OTA2In0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCuOOCp-ODjeODquODg-OCryDjg5HjgrkifX19fV19LCJpYXQiOjE3MTMzODI2NzF9.cyigS73abyQv8Xd-4ZJX-ctWdvgDiVW2HWnqlcZ2i7gO1nYvqsqEQr1W8S5vwuejFN9YCZ79zuzKGgg6karv-XUVgnISuFiMkCxpBu60cFEijRBt0RqpdY3wk7wJtu_hgxxw1xyihFW6eUxWJ6BeRbeqED-PJ5KfBYvOMPKFWg7QpObvSn1fuIBNGBr83jBK4nGIwhU45UhJ42gMOjHaRQRqCVM5mMXdIivEq7rz3On4c-dn-WB2Vt7fKPs4R3sIKyysGF3CxqnDE1ea0a1Q3zXAC6sS-B2vXLQ98ixrcCkZ7aNRYTFLqg_OwcyIUtIG3OPlQ6q8TtIALdr0iIGHgQ",
    60: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMTA2MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLjgoLjgaPjgajoia_jgYTntZDmnpzjgYzmnJ_lvoXjgafjgY3jgb7jgZnvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiI2MCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiLntZDmnpwiLCJib2R5Ijoi5pS55ZaE44Gu5L2Z5Zyw44GM44GC44KK44G-44GX44Gf44CC44Ko44Kz44OT44Or44Gu6YGL5ZG944Gv44GC44Gq44Gf44Gu54yu6Lqr44Gr44GL44GL44Gj44Gm44GE44G-44GX44Gf77yBIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjZWQ5MzUwIiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb3NoaWZ0LTAxMDYwLnBuZz9hbHQ9bWVkaWEmdG9rZW49Yjc1YzFmMmItNDY3YS00NGI2LTk4MDMtZmE2MDEyMmM3MGYwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCuOOCp-ODjeODquODg-OCryDjg5HjgrkifX19fV19LCJpYXQiOjE3MTMzODIzNzR9.cGAoT-BatcRfwpA9Sxjtz7ysG3pqln9UkSB7OTZSmMG1Vy-MUFWRbRtMj6VKY6b76QbxrAYoeXIwo7EY-bNpZ3XOQ2dmytd20n6H5rlODDKB4iG1_B1XZJ28zNMrcyMNN7NrAqW8NHVj-Ot55z_OoleryVwVo6T0W8KMCocNn1oNK0CVftVVWZpsiSv9OBqrQvFXrnlw_KI_ek4ifwEmuvWQHUr7w-y-vnziYxVyg8fb5CLdO6gwu94O0fTLmDOuCiuoH8xBm55l8PxBAKxCW6l5fLNfBTIo4Owe_v_-BiyyONdhb4W_SLQkigedE3gzM_BPtswOnK_BSbnJ4z2MlQ",
    40: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMTA0MCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLjgoLjgaPjgajoia_jgYTntZDmnpzjgpLlh7rjgZvjgovjga_jgZrjgafjgZnvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiI0MCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiLntZDmnpwiLCJib2R5Ijoi44GC44Gq44Gf44Gr44Gv44KE44KL44G544GN5LuV5LqL44GM44GC44KK44G-44GX44Gf44CC44KI44KK55Kw5aKD44Gr5YSq44GX44GE6YG45oqe44KS44GZ44KL44GT44Go44Gn44CB44Ko44Kz44OT44Or44Gu54q25rOB44KS5aW96Lui44GV44Gb44KL44GT44Go44GM44Gn44GN44G-44GX44Gf44CCIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjOTgzYTI4IiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb3NoaWZ0LTAxMDQwLnBuZz9hbHQ9bWVkaWEmdG9rZW49MDhiMTk5ZWEtOTliZS00NTZkLWFkNmMtNDI2YWY0OWU5ZGYyIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCuOOCp-ODjeODquODg-OCryDjg5HjgrkifX19fV19LCJpYXQiOjE3MTMzODIxNDR9.cyvOUobc9e2eAU_RlZilk3BIsTNNkCFD5PojsZSZhqCl13jt6q2O2ad618W8tJcp7f34XJoF2aW0xsdtqaJTY7CMGQJfV8-cw8BmnZEdXIdWzz2CgDzYfxO5oKbCTD4jKsFR53d-MJPRb6bxXrFVJZslyCG3bRKhJxsTvQcVU6ehsMdjx2QLBHolRIgc_QoD4rNfMfewKME-TYRFgcylUvJFvsmHw_7e91dulP7d-wj9IC9I4AoofeH145NR2f28MweOO_j-bckW4clxCf-z-3giUGT49Nj2T8uUpx4KA4K6CY4aMjcQrCV6zmv9DiponwSvE3IotMi8KPaI261v6A",
    20: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMTAyMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLlpInjgo_jgovjga7jgavpgYXjgZnjgY7jgovjgZPjgajjga_jgYLjgorjgb7jgZvjgpPvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiIyMCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiLntZDmnpwiLCJib2R5Ijoi5aSJ44KP44KL44Gu44Gr6YGF44GZ44GO44KL44GT44Go44Gv44GC44KK44G-44Gb44KT44Gn44GX44Gf77yB5YGl5bq355qE44Gq55Kw5aKD44Gr5ZCR44GR44Gf44GZ44G544Gm44Gu44Od44K444OG44Kj44OW44Gq6YG45oqe44GM6YeN6KaB44Gn44GX44Gf44CCIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjQzIzNTE1IiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb3NoaWZ0LTAxMDAwLnBuZz9hbHQ9bWVkaWEmdG9rZW49MmFiYTgyM2MtMjg1YS00OWVjLTlkZDYtNTIxMjcyOTQ3YzAwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCuOOCp-ODjeODquODg-OCryDjg5HjgrkifX19fV19LCJpYXQiOjE3MTMzODE4MzJ9.JioOLGoTkV2avj7PSLTC6T-b9u5IQjd2erfcGuMTOWu3YwQu7bHgAAPMP9JH2xNcmDQhDnwt3pjlYb_DKy0OY4m8n3Belt3IOdxZtYdMQzZSPcSBs_4qTu-wbKB2BxZpmU14mHrAckNDI80OLuIM4mZunRNhNod9LE5fpZqaZvkod2Jkh5hTcpxFOaGmnz8MQB0sX_GYsI0AuEMR5FPuQTE3yz0e5y7KnI-gnQeo5agtumi7h24cNkZA4ORaqotQCKe1gPzdWrTs1IEzMcutnn2E2kqQK3x0nv3gjmMVDMt0eRZscWT1i6XRutyRebgyRXv0hzK0qZE5nVt3yd1pGg",
    0: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4xMTAwMCIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyMzEwNzUxLmVjb3NoaWZ0IiwibG9nbyI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9FYXJ0aC5wbmc_YWx0PW1lZGlhJnRva2VuPWMxMDIyOTgwLTNiYzQtNGNjNC04NTg2LWE2NmQwMWY5MjliMCJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiamEtSlAiLCJ2YWx1ZSI6IuWcsOeQgyJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJqYS1KUCIsInZhbHVlIjoi44Ko44Kz44K344OV44OIIOOCr-ODreODi-OCr-ODqyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLlpInjgo_jgovjga7jgavpgYXjgZnjgY7jgovjgZPjgajjga_jgYLjgorjgb7jgZvjgpPvvIEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IuOCueOCs-OCoiIsImJvZHkiOiIwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6Iue1kOaenCIsImJvZHkiOiLlpInjgo_jgovjga7jgavpgYXjgZnjgY7jgovjgZPjgajjga_jgYLjgorjgb7jgZvjgpPjgafjgZfjgZ_vvIHlgaXlurfnmoTjgarnkrDlooPjgavlkJHjgZHjgZ_jgZnjgbnjgabjga7jg53jgrjjg4bjgqPjg5bjgarpgbjmip7jgYzph43opoHjgafjgZfjgZ_jgIIifV0sImhleEJhY2tncm91bmRDb2xvciI6IiNDMjM1MTUiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vZWNvc2hpZnQtMDEwMDAucG5nP2FsdD1tZWRpYSZ0b2tlbj0yYWJhODIzYy0yODVhLTQ5ZWMtOWRkNi01MjEyNzI5NDdjMDAifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImphLUpQIiwidmFsdWUiOiLjgqjjgrPjgrfjg5Xjg4gg44K444Kn44ON44Oq44OD44KvIOODkeOCuSJ9fX19XX0sImlhdCI6MTcxMzM4MTY0MX0.UelszOp2_fBZExG-vqAoaQMrnXLPrFooR98ditDUDV92i0AsnSiVCD2mrZzXOsgLkXc3SHaCIUMk-JMr0VJ97hiMZ8U5TXzhx-7svD1AITCXCDsOFXobiIiU1iTZBJn224e_cCXNRzcMQYejejFiKYmcms3DLQwO6ykeTsOumkd9VXUiJbWEpvxVDm6-eyEX47XOk5bNMt0mr4LLX2qAzunGSMqL99AdZr-TglK9YWSTa-IKnubOgT5OsFoDC-wf0ItqXBH60vm_LDI6Yn60nD1iT4J7P6mbMfksBZbdndDffzapVqJRFOMqFLjo_99Xj92YZ4PvIb2dWCvwhjV4Rg",
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final height = MediaQuery.of(context).size.height;
    final ecoMeter = context.watch<GameProgressProvider>().ecoMeter;
    final localeProvider = context.read<LocaleProvider>();
    _local = localeProvider.locale.languageCode == 'ja'
        ? AppLocalizationsJa()
        : AppLocalizationsEn();

    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: brownContainer(
            width: width,
            height: width,
            child: Column(
              children: [
                gradientText(_local.gameOver),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: AutoSizeText(
                    "${_local.gameOverMsg}\n${_local.finalScoreIs} $ecoMeter ${_local.outOf100}",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: localeProvider.getFontFamily(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                height > 500
                    ? Expanded(
                        child: verdictWidget(ecoMeter, width, _local,
                            localeProvider.getFontFamily()),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Semantics(
                  label: 'Add to google wallet button',
                  child: GoogleWalletButton(
                    locale: localeProvider.locale.languageCode,
                    onPressed: () => _savePassBrowser(
                      ecoMeter,
                      localeProvider.locale.languageCode == 'ja'
                          ? jwtsJa
                          : jwtsEn,
                    ),
                  ),
                ),
                textButton(_local.restartTheGame, context, () async {
                  await playClickSound(widget.game);
                  if (widget.game.playSounds) {
                    FlameAudio.bgm.stop();
                  }
                  context.read<RestartProvider>().restartTheGame(context);
                }, color: Colors.brown),
                height > 500 ? const Spacer() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  verdictWidget(
      int ecoMeter, double size, AppLocalizations local, String fontFamily) {
    final boxHeight = size * 0.15;
    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 3,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: boxHeight * 0.5,
              height: boxHeight * 0.5,
              child: SpriteWidget.asset(path: 'HUD/Earth.png')),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: AutoSizeText(
              getGameOverMsgBasedOnEcoMeter(ecoMeter, local),
              maxLines: 2,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: fontFamily,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  _savePassBrowser(int ecoMeter, Map<int, String> map) async {
    String url = "https://pay.google.com/gp/v/save/${map[ecoMeter]}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open Google Wallet via web';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
