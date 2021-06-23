import 'package:flutter/material.dart';
import 'package:fire_chat/net/flutterfire.dart';

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
          color: Colors.amber.shade900,
          fontSize: 20.0,
        ),
        controller: controller,
        obscureText: hideText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber.shade900,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
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
        color: Colors.amber.shade900,
      ),
      child: MaterialButton(
        onPressed: () async {
          // bool shouldNavigate =
          //     await press(_emailField.text, _passwordField.text);
          // if (shouldNavigate) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => HomeView(),
          //     ),
          //   );
          // } else
          //   _invalidDialog("Invalid Details");
        },
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
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
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
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
                  color: Colors.amber.shade900,
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
                1.4,
                45.0,
              ), //  Create Login button
              _padding(), //  Padding
              _generateButton(
                "Register",
                register,
                1.4,
                45.0,
              ), //  Create Register button
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    size: MediaQuery.of(context).size.height / 4,
                    color: Colors.white,
                  ),
                  Text(
                    "Crypto\nWallet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height / 20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loginFormFieldGenerator(
                    _emailField,
                    "Email",
                    "johndoe@flutterfire.com",
                    false,
                    3,
                  ), //  Create Email TextFormField
                  _padding(), //  Padding
                  _loginFormFieldGenerator(
                    _passwordField,
                    "Password",
                    "p@ssw0rd",
                    true,
                    3,
                  ), //  Create Email TextFormField //  Padding
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _generateButton(
                    "Login",
                    signIn,
                    6,
                    45.0,
                  ), //  Create Login button
                  _padding(), //  Padding
                  _generateButton(
                    "Register",
                    register,
                    6,
                    45.0,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
