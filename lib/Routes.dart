import 'package:flutter/material.dart';

import 'Screens/Login/login.dart';
import 'Screens/Login/signup.dart';
import 'Screens/Home/home.dart';
import 'Screens/Record/record.dart';

class Routes {
  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Demo App",
      debugShowCheckedModeBanner: false,
      home: new LoginPage(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginPage(),
              settings: settings,
            );

          case '/signup':
            return new MyCustomRoute(
              builder: (_) => new SignupPage(),
              settings: settings,
            );

          case '/home':
            return new MyCustomRoute(
              builder: (_) => new HomeScreen(),
              settings: settings,
            );

          case '/record':
            return new MyCustomRoute(
              builder: (_) => new RecordAudio(),
              settings: settings,
            );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
