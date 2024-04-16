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

  final Map<int, String> jwts = {
    100:
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4xMDAxMDAiLCJjbGFzc0lkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS5lY29zaGlmdCIsImxvZ28iOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vRWFydGgucG5nP2FsdD1tZWRpYSZ0b2tlbj1jMTAyMjk4MC0zYmM0LTRjYzQtODU4Ni1hNjZkMDFmOTI5YjAifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFYXJ0aCJ9fX0sImNhcmRUaXRsZSI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgQ2hyb25pY2xlcyJ9fSwiaGVhZGVyIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJBIHBlcmZlY3QgMTAwISJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InNjb3JlIiwiaGVhZGVyIjoiU0NPUkUiLCJib2R5IjoiMTAwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6IlJFU1VMVCIsImJvZHkiOiJJbmNyZWRpYmxlISBZb3UgYWNoaWV2ZWQgYSBwZXJmZWN0IDEwMCEgWW91IHdlcmUgdGhlIHVud2F2ZXJpbmcgY2hhbXBpb24gb2YgRWNvVmlsbGUhIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjZjllZGFhIiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb1NoaWZ0VGl0bGVDcm9wcGVkLnBuZz9hbHQ9bWVkaWEmdG9rZW49MmNjNWNlYTItZmM5OS00N2E0LTk5YWMtNGM2ZTM3MDhiODY1In0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgQ2hyb25pY2xlcyJ9fX19XX0sImlhdCI6MTcwODQyMjE3N30.M-yt24VqpXYlUGL5sk6sTpFqTmU6TWsCmM7kzmmozox15aFf9Ku47vY_k69aTSzVODv_9jtrOSoqiDv1gGmtm8A9qWzv8xTYL2SegoE6BrprxMx8p1Ne27rcpDmvzzFMo4zh47Yd0nq8ksqwchiHbMtdczu1I5w7Kbambx0jm4ziYZ1EJQkeA4lize4zKAMxe-MIl7eJPEkKl_esSaRD4KvqJYCoualsRq1f_EQ-7PwYnX7x1WNEzQhmxwgRbcUmlNFEqk6emRCzgXOKmQBRdTKq4Fs8MlIZF_OoCWakAZ7arbNCXl_qIM6adnul23W2gvORJZPJc3lfa8pBMxxo_g",
    80: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS44MDgwIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIzMTA3NTEuZWNvc2hpZnQiLCJsb2dvIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL0VhcnRoLnBuZz9hbHQ9bWVkaWEmdG9rZW49YzEwMjI5ODAtM2JjNC00Y2M0LTg1ODYtYTY2ZDAxZjkyOWIwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWFydGgifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiR3JlYXQgSm9iISJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InNjb3JlIiwiaGVhZGVyIjoiU0NPUkUiLCJib2R5IjoiODAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoiUkVTVUxUIiwiYm9keSI6IkdyZWF0IEpvYiEgWW91ciBlY28tZnJpZW5kbHkgYWN0aW9ucyBzaWduaWZpY2FudGx5IGJlbmVmaXRlZCB0aGUgZWNvc3lzdGVtIG9mIEVjb1ZpbGxlLiJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiIzY5OWMyMCIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9lY29TaGlmdFRpdGxlQ3JvcHBlZC5wbmc_YWx0PW1lZGlhJnRva2VuPTJjYzVjZWEyLWZjOTktNDdhNC05OWFjLTRjNmUzNzA4Yjg2NSJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX19fV19LCJpYXQiOjE3MDg0MjU1NTl9.GarSUKoTbtsiYNT2nY4L-Lh6rbn3OrntqjN8f6klgocmSZFN9JtSpaujYhNXrZ9NwimTo_Ofme-kyctZUPH1npqU8qBqIpDicw4bSjBSvh-3-l3K-pO74OBVw4Yv6I0kPbzoVsE6lxw6VkQBxsCi1-i-n-eagMqIq5D_7rNmtWSkUxoyuHRjThLz2VzhsP5ET8-uDdZY5Y2cDyqshH9CRJ55udKeyZTkyzW7Gbk437fgNfVUwfz25GKVPRRKJXWQ6Kd8hSLiCBsB7Dgak8gWubhZfTY57ZYWJMlqOdwBKYRTS3nSsiH2RBjbxWtGBds1nhrC-i4OSX69O6lenbOY_Q",
    60: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS42MDYwIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIzMTA3NTEuZWNvc2hpZnQiLCJsb2dvIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL0VhcnRoLnBuZz9hbHQ9bWVkaWEmdG9rZW49YzEwMjI5ODAtM2JjNC00Y2M0LTg1ODYtYTY2ZDAxZjkyOWIwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWFydGgifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiQ2FuIGRvIGJldHRlciEifX0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJzY29yZSIsImhlYWRlciI6IlNDT1JFIiwiYm9keSI6IjYwIn0seyJpZCI6InJlc3VsdCIsImhlYWRlciI6IlJFU1VMVCIsImJvZHkiOiJUaGVyZSB3YXMgcm9vbSBmb3IgaW1wcm92ZW1lbnQuIEVjb1ZpbGxlJ3MgZmF0ZSBkZXBlbmRlZCBvbiB5b3VyIGRlZGljYXRpb24hIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjNTRiZTM3IiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb1NoaWZ0VGl0bGVDcm9wcGVkLnBuZz9hbHQ9bWVkaWEmdG9rZW49MmNjNWNlYTItZmM5OS00N2E0LTk5YWMtNGM2ZTM3MDhiODY1In0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgQ2hyb25pY2xlcyJ9fX19XX0sImlhdCI6MTcwODQyNTkyNH0.iqdadP0fBZvgvLPamKkheTFB0jnMkKyDWfv88C1BDjylekGPs32gWZ2zkoSqWnPL3LOAZCSqGbauXGb3kIqtVdL4Ntb5T7HfWIGPIBbycxQvL1oqTKvxWwsPxbrzKZR_lpuPGCeH6fNKA7zShV6yW1jErR51xde7iGB2FrCDlnrMaCteY8xvfjOEc3-HpVrt_4FCnVCBj39qkXMjEaDlBMXHYrbjis1UyppLm0t1f26R9wi5o2EAGt8SXG33HYkA7uCiBl0PiBCnOMFiCP5mLojp9WcaSyuLLts7V9_ecEIoMCSct3fP1Zx7lRBUBvxLAWu-rgbtAoNVWBu_zoNgow",
    40: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS40MDQwIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIzMTA3NTEuZWNvc2hpZnQiLCJsb2dvIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL0VhcnRoLnBuZz9hbHQ9bWVkaWEmdG9rZW49YzEwMjI5ODAtM2JjNC00Y2M0LTg1ODYtYTY2ZDAxZjkyOWIwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWFydGgifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiQ2FuIGRvIG11Y2ggYmV0dGVyISJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InNjb3JlIiwiaGVhZGVyIjoiU0NPUkUiLCJib2R5IjoiNDAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoiUkVTVUxUIiwiYm9keSI6IllvdSBoYWQgc29tZSB3b3JrIHRvIGRvLiBNYWtpbmcgZ3JlZW5lciBjaG9pY2VzIHdvdWxkIGhhdmUgdHVybmVkIHRoaW5ncyBhcm91bmQgZm9yIEVjb1ZpbGxlISJ9XSwiaGV4QmFja2dyb3VuZENvbG9yIjoiI2YxYTQ1NCIsImhlcm9JbWFnZSI6eyJzb3VyY2VVcmkiOnsidXJpIjoiaHR0cHM6Ly9maXJlYmFzZXN0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vdjAvYi9mZnRlc3QtZDM2ZmEuYXBwc3BvdC5jb20vby9lY29TaGlmdFRpdGxlQ3JvcHBlZC5wbmc_YWx0PW1lZGlhJnRva2VuPTJjYzVjZWEyLWZjOTktNDdhNC05OWFjLTRjNmUzNzA4Yjg2NSJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX19fV19LCJpYXQiOjE3MDg0MjYzMzd9.hVjbSJyAHeM-WGTH2wtvmHbjWUum2f5d6t_CDCWd0HhRr9C0BFrqIa2qMmPIpyDrKeIwDe8YN0tnwGIg5YfHXtQzK3htcf9efNkJIDkFLDV_vl8W2G1SrsxNLFdlr9yG_p6wWlri6Locw0MUrLJ5zvcUncsasz1ZFmo9oVBxV_8z1OMLkLdxphfhww6k6dTn255ErJQFzFVZVokzD4361er6zR0c_1nY4Avexi9yEvNUf-dwupdh9lv9W0LoQnZPiTPn9QVKBPk9jebGys_Q-2FQu9hzBlXSpULJQFgFiUGgHu0YzxtGv3asIVCFAMQ7qKNYjF3C4qRL5sCUfU_Jlw",
    20: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4yMDIwIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIzMTA3NTEuZWNvc2hpZnQiLCJsb2dvIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL0VhcnRoLnBuZz9hbHQ9bWVkaWEmdG9rZW49YzEwMjI5ODAtM2JjNC00Y2M0LTg1ODYtYTY2ZDAxZjkyOWIwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWFydGgifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiTmV2ZXIgdG9vIGxhdGUgdG8gY2hhbmdlISJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InNjb3JlIiwiaGVhZGVyIjoiU0NPUkUiLCJib2R5IjoiMjAifSx7ImlkIjoicmVzdWx0IiwiaGVhZGVyIjoiUkVTVUxUIiwiYm9keSI6Ikl0IHdhcyBuZXZlciB0b28gbGF0ZSB0byBjaGFuZ2UhIEV2ZXJ5IHBvc2l0aXZlIGNob2ljZSBjb3VudGVkIHRvd2FyZHMgYSBoZWFsdGhpZXIgZW52aXJvbm1lbnQuIn1dLCJoZXhCYWNrZ3JvdW5kQ29sb3IiOiIjYWIzODJjIiwiaGVyb0ltYWdlIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL2Vjb1NoaWZ0VGl0bGVDcm9wcGVkLnBuZz9hbHQ9bWVkaWEmdG9rZW49MmNjNWNlYTItZmM5OS00N2E0LTk5YWMtNGM2ZTM3MDhiODY1In0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWNvU2hpZnQgQ2hyb25pY2xlcyJ9fX19XX0sImlhdCI6MTcwODQyNjUyNn0.UfncEoBsT6vbkWFUuGd0U8n8Xoz6YfcEN5dPdLT3nYArU6PAU_9inOyS4Lt7w0XTOu9T00h4zGSdpmJ3vOK9Qxe0lg0bL-UszzjF7cfkvUZ4bS_hdRxdsrT46ZoSTN535j5wbwq6AnmUKEkUl4IH0Jv8pzB2EEXHw7kvorui5gk9KpCugRYfFDVh3MGJWzuU1y8NLLZMTf0wx0WFqMHenDY3Ssv4DKbWu6LhweT0p-_jzf_Nbp8Pp-bm2GbeYzmFvQX-NTKEC7O4q0IUAYKHUtgxpzGEpgYY0fOzsWhijoNFpOryQbT57qux23wGy9cTayH6CDgYsL-HKG7z4EGcuQ",
    0: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZW5lcmljLXBhc3NAZWNvc2hpZnQtNDE0ODE1LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiZ29vZ2xlIiwib3JpZ2lucyI6W10sInR5cCI6InNhdmV0b3dhbGxldCIsInBheWxvYWQiOnsiZ2VuZXJpY09iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjMxMDc1MS4wMDAwIiwiY2xhc3NJZCI6IjMzODgwMDAwMDAwMjIzMTA3NTEuZWNvc2hpZnQiLCJsb2dvIjp7InNvdXJjZVVyaSI6eyJ1cmkiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2ZmdGVzdC1kMzZmYS5hcHBzcG90LmNvbS9vL0VhcnRoLnBuZz9hbHQ9bWVkaWEmdG9rZW49YzEwMjI5ODAtM2JjNC00Y2M0LTg1ODYtYTY2ZDAxZjkyOWIwIn0sImNvbnRlbnREZXNjcmlwdGlvbiI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiRWFydGgifX19LCJjYXJkVGl0bGUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IkVjb1NoaWZ0IENocm9uaWNsZXMifX0sImhlYWRlciI6eyJkZWZhdWx0VmFsdWUiOnsibGFuZ3VhZ2UiOiJlbi1VUyIsInZhbHVlIjoiTmV2ZXIgdG9vIGxhdGUgdG8gY2hhbmdlISJ9fSwidGV4dE1vZHVsZXNEYXRhIjpbeyJpZCI6InNjb3JlIiwiaGVhZGVyIjoiU0NPUkUiLCJib2R5IjoiMCJ9LHsiaWQiOiJyZXN1bHQiLCJoZWFkZXIiOiJSRVNVTFQiLCJib2R5IjoiSXQgd2FzIG5ldmVyIHRvbyBsYXRlIHRvIGNoYW5nZSEgRXZlcnkgcG9zaXRpdmUgY2hvaWNlIGNvdW50ZWQgdG93YXJkcyBhIGhlYWx0aGllciBlbnZpcm9ubWVudC4ifV0sImhleEJhY2tncm91bmRDb2xvciI6IiMxMTI1MzUiLCJoZXJvSW1hZ2UiOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHBzOi8vZmlyZWJhc2VzdG9yYWdlLmdvb2dsZWFwaXMuY29tL3YwL2IvZmZ0ZXN0LWQzNmZhLmFwcHNwb3QuY29tL28vZWNvU2hpZnRUaXRsZUNyb3BwZWQucG5nP2FsdD1tZWRpYSZ0b2tlbj0yY2M1Y2VhMi1mYzk5LTQ3YTQtOTlhYy00YzZlMzcwOGI4NjUifSwiY29udGVudERlc2NyaXB0aW9uIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJFY29TaGlmdCBDaHJvbmljbGVzIn19fX1dfSwiaWF0IjoxNzA4NDI2NjcwfQ.qppAu8l1JH41T6zp7ilLJB68IVKCmrorgTUekEU_QIA8VCics9SggTOBg5VCTIKXesQZfoMoKafa6HoLqNW3wKCitmgomxCHybGsMbDLBMVdr55Nmj3ZnaWqugW6V8DCxZxkrt7oEQ2iOxngJg57-ZHijkB1aOZmyWT93HUaLiwnkwOLg3egbU9KnoWtnEfnr_v9-_EX52BGlEkvaBArEmoKjYrvHrb_5X5dY3hhe3aWOjc2dmqVvZcoVSrrT0AuJiPkuoKSEh9KI9bNdC6tIYSd_w0Wz93Tlf7N8YoPZIYiIur3DsJx4p40yxZfcXeKEcVBWMdiAKz1YouEe6HZtw",
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
                        child: verdictWidget(
                            ecoMeter, width, _local, localeProvider.getFontFamily()),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Semantics(
                  label: 'Add to google wallet button',
                  child: GoogleWalletButton(
                    locale: localeProvider.locale.languageCode,
                    onPressed: () => _savePassBrowser(ecoMeter),
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

  _savePassBrowser(int ecoMeter) async {
    String url = "https://pay.google.com/gp/v/save/${jwts[ecoMeter]}";
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
