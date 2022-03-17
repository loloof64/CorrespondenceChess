import 'package:correspondence_chess/models/user.dart';
import 'package:correspondence_chess/screens/authenticate_screen.dart';
import 'package:correspondence_chess/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const AuthenticateScreen();
    } else {
      return const HomeScreen();
    }
  }
}
