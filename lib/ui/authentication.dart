import 'package:flutter/material.dart';
import 'package:fire_chat/net/flutterfire.dart';
import 'package:fire_chat/particles/particles_flutter.dart';

import 'home_view.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  // Creates a login Text Form Field
  Container _loginFormFieldGenerator(
    TextEditingController controller,
    String label,
    String hint,
    bool hideText,
    double widthFactor,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width / widthFactor,
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        controller: controller,
        obscureText: hideText,
        cursorColor: Colors.amber.shade900,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber.shade900,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withAlpha(100),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber.shade900,
            ),
          ),
        ),
      ),
    );
  }

  // Created a Button (login or register)
  Container _generateButton(
    String name,
    Future<bool> Function(String, String) press,
    double widthFactor,
    double height,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width / widthFactor,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: MaterialButton(
        onPressed: () async {
          bool shouldNavigate =
              await press(_emailField.text, _passwordField.text);
          if (shouldNavigate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ),
            );
          }
        },
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  // Created padding element
  SizedBox _padding() => SizedBox(
        height: MediaQuery.of(context).size.height / 35,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircularParticle(
              key: UniqueKey(),
              awayRadius: 100,
              numberOfParticles: 200,
              speedOfParticles: 0.2,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              onTapAnimation: true,
              particleColor: Colors.white.withAlpha(18),
              awayAnimationDuration: Duration(milliseconds: 1000),
              maxParticleSize: 5,
              isRandSize: true,
              isRandomColor: false,
              // randColorList: [
              //   Colors.amber.withAlpha(150),
              // ],
              awayAnimationCurve: Curves.easeInOutBack,
              enableHover: false,
              // hoverColor: Colors.white,
              // hoverRadius: 90,
              connectDots: true, //not recommended
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fireplace_rounded,
                  size: MediaQuery.of(context).size.height / 6,
                  color: Colors.amber.shade900,
                ),
                Text(
                  "firechat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height / 18,
                  ),
                ),
                _padding(),
                _loginFormFieldGenerator(
                  _emailField,
                  "Email",
                  " johndoe@flutterfire.com",
                  false,
                  1.3,
                ), //  Create Email TextFormField
                _padding(), //  Padding
                _loginFormFieldGenerator(
                  _passwordField,
                  "Password",
                  " p@ssw0rd",
                  true,
                  1.3,
                ), //  Create Email TextFormField
                _padding(), //  Padding
                _generateButton(
                  "Login",
                  signIn,
                  1.3,
                  45.0,
                ), //  Create Login button
                _padding(), //  Padding
                _generateButton(
                  "Register",
                  register,
                  1.3,
                  45.0,
                ), //  Create Register button
              ],
            ),
          ],
        ),
      ),
    );
  }
}
