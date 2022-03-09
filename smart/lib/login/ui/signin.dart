import 'package:flutter/material.dart';
import '../../firebase.dart';
import '../../main.dart';
import '../../snackbar.dart';
import '../constants/constants.dart';
import '../ui/widgets/custom_shape.dart';
import '../ui/widgets/responsive_ui.dart';
import '../ui/widgets/textformfield.dart';
import 'signup.dart';

class SignInPage extends StatelessWidget {
  GlobalKey _loginPageKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginPageKey,
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, TextEditingController> c = {
    'email': TextEditingController(text: "user@gmail.com"),
    'password': TextEditingController(text: "user123456"),
  };
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    GlobalKey _sKey = new GlobalKey<ScaffoldState>();

    return Material(
      child: Scaffold(
        key: _sKey,
        body: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                welcomeTextRow(),
                signInTextRow(),
                form(),
                SizedBox(height: _height / 12),
                button(_sKey),
                signUpTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: color,
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: color,
                ),
              ),
            ),
          ),
        ),
        // Container(
        //   alignment: Alignment.bottomCenter,
        //   margin: EdgeInsets.only(
        //       top: _large
        //           ? _height / 30
        //           : (_medium ? _height / 25 : _height / 20)),
        //   child: Image.asset(
        //     'assets/images/login.png',
        //     height: _height / 3.5,
        //     width: _width / 3.5,
        //   ),
        // ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: c['email']!,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: c['password']!,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
            ),
          )
        ],
      ),
    );
  }

  validateForm() {
    bool flag = true;
    Map<String, String> data = {};
    c.forEach((key, value) {
      if (value.text.isEmpty) {
        flag = false;
      } else {
        data[key] = value.text;
      }
    });
    return flag ? data : null;
  }

  dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
  }

  Widget button(key) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        var data = validateForm();
        if (data == null) {
          showSnackbar(
              key: key, msg: "Fill the Form Completely", status: false);
        } else {
          // dialog();
          if (await loginWithEmailPassword(data: data, skey: key)) {
            // Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
              builder: (BuildContext context) => HomePage(),
            ));
          }
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: color,
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) => SignUpScreen(),
              ));
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
}
