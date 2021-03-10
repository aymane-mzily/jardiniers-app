import 'package:flutter/material.dart';
import './ui/theme.dart';
import './login.dart';
import './register.dart';
import './home.dart';
import './widgets/state_widget.dart';

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}
