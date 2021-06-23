import 'package:flutter/material.dart';
import 'package:fire_chat/net/auth_service.dart';
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
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
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
  SizedBox _padding(int size) => SizedBox(
        height: MediaQuery.of(context).size.height / size,
        width: MediaQuery.of(context).size.height / size,
      );

  @override
  void initState() {
    super.initState();
    checkSignIn();
  }

  Future<bool> checkSignIn() async {
    bool user = await authService.isSignedIn();
    if (user) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
        ),
      );
      return true;
    } else {
      return false;
    }
  }

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
              particleColor: Colors.white.withAlpha(18),
              maxParticleSize: 5,
              isRandSize: true,
              isRandomColor: false,
              connectDots: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fireplace_rounded,
                  size: MediaQuery.of(context).size.height / 6,
                  color: Colors.amber.shade900,
                ),
                _padding(35),
                Text(
                  "firechat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height / 18,
                  ),
                ),
                _padding(35),
                _loginFormFieldGenerator(
                  _emailField,
                  "Email",
                  " johndoe@flutterfire.com",
                  false,
                  1.3,
                ),
                _padding(35),
                _loginFormFieldGenerator(
                  _passwordField,
                  "Password",
                  " p@ssw0rd",
                  true,
                  1.3,
                ),
                _padding(35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _generateButton("Login", authService.signIn, 2.7, 45.0),
                    _padding(35),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          bool shouldNavigate = await authService.googleSignIn(
                              _emailField.text, _passwordField.text);
                          if (shouldNavigate) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Image(
                            image: AssetImage('assets/google_anim.gif'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _padding(35),
                _generateButton("Register", authService.register, 1.3, 45.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
