import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widgets/common_dialogs.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final mySignupPasswordController = TextEditingController();
  final mySignupEmailController = TextEditingController();
  final mySignupConfirmController = TextEditingController();

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

  void checkPasswordMatch() {
    var email = mySignupEmailController.text;
    bool emailValid  = EmailValidator.validate(email);

    if (mySignupEmailController.text == "") {
      showAlertDialog(_context, 'Signup Error', "An email address must be provided.");
    }
    else if (!emailValid) {
      showAlertDialog(_context, 'Signup Error', "Please enter a valid email.");
    }
    else if (mySignupPasswordController.text == "" || mySignupConfirmController.text == "") {
      showAlertDialog(_context, 'Password Error', "Passwords can't be empty");
    }
    else if (mySignupPasswordController.text.length < 6 || mySignupConfirmController.text.length < 6) {
      showAlertDialog(_context, 'Password Error', "Passwords should be atleast 6 characters");
    }
    else if (mySignupPasswordController.text != mySignupConfirmController.text) {
      print("passwords mismatch");
      showAlertDialog(_context, 'Password Error', "Passwords doesn't match");
    }
    else {
    print("passwords match");
    createAccount();
    }
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
        "Set up your Flutter Demo account",
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
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
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
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: TextField(
            controller: mySignupPasswordController,
            maxLines: 1,
            obscureText: true,
            //validator: (value) => value.isEmpty ? 'Password can\'t be empty':null,
            decoration: InputDecoration(
              hintText: "Minimum of 6 characters",
              labelText: "Password",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: TextField(
            controller: mySignupConfirmController,
            maxLines: 1,
            obscureText: true,
            //validator: (value) => value.isEmpty ? 'Password can\'t be empty':null,
            decoration: InputDecoration(
              hintText: "Enter same password",
              labelText: "Confirm Password",
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
            onPressed: checkPasswordMatch,
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