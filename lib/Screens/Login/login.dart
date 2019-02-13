import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widgets/common_dialogs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myPasswordController = TextEditingController();
  final myEmailController = TextEditingController();

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
      ),
    );
  }

  void validateAndSubmit() async {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'abc@efg.com'/*myEmailController.text*/,
        password: '123456'/*myPasswordController.text*/
    ).then((FirebaseUser user) {
      print(user);
      Navigator.pushReplacementNamed(_context, "/home");
    })
        .catchError((e) => showAlertDialog(_context, 'Login Error', e.message));
  }

  loginBody() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[loginHeader(), loginFields()],
    ),
  );

  loginHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlutterLogo(
        colors: Colors.green,
        size: 80.0,
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Welcome to Flutter Demo",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Sign in to continue",
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  loginFields() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
          child: TextField(
            controller: myEmailController,
            maxLines: 1,
            //validator: (value) =>
            //value.isEmpty ? 'Email can\'t be empty' : null,
            decoration: InputDecoration(
              hintText: "Enter your email",
              labelText: "Email",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: TextField(
            controller: myPasswordController,
            maxLines: 1,
            obscureText: true,
            //validator: (value) =>
            //value.isEmpty ? 'Password can\'t be empty' : null,
            decoration: InputDecoration(
              hintText: "Enter your password",
              labelText: "Password",
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "Sign in",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: validateAndSubmit,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        GestureDetector(
          onTap: () {
            //Navigator.push(_context,MaterialPageRoute(builder: (BuildContext context) => SignupPage()));
            Navigator.pushReplacementNamed(context, '/signup');
          },
          child: new Text(
            "Sign up for an account",
            style: new TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ],
    ),
  );
}
