import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widgets/common_dialogs.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final mySignupPasswordController = TextEditingController();
  final mySignupEmailController = TextEditingController();

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

  void createAccount() async {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mySignupEmailController.text,
        password: mySignupPasswordController.text
    ).then((FirebaseUser user) {
      print(user);
      Navigator.pushReplacementNamed(_context, "/home");
    })
        .catchError((e) => showAlertDialog(_context, 'Signup Error', e.message));
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
        colors: Colors.red,
        size: 80.0,
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Welcome to Flutter Demo",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Please enter an email and password to create account",
        style: TextStyle(color: Colors.black),
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
            controller: mySignupEmailController,
            maxLines: 1,
            //validator: (value) => value.isEmpty ? 'Email can\'t be empty':null,
            decoration: InputDecoration(
              hintText: "Enter your email",
              labelText: "Email",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: TextField(
            controller: mySignupPasswordController,
            maxLines: 1,
            obscureText: true,
            //validator: (value) => value.isEmpty ? 'Password can\'t be empty':null,
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
              "Create Account",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: createAccount,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        GestureDetector(
          onTap: () {
            //Navigator.pop(_context);
            //Navigator.push(_context,MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
            Navigator.pushReplacementNamed(_context, '/login');
          },
          child: new Text(
            "Already have an Account? LOGIN",
            style: new TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ],
    ),
  );
}