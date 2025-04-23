import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'working.dart';
import 'main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String envUrl = dotenv.env['ENVIRONMENT_URL'] ?? 'demourl_notfound_error';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Response'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    try {
      final url = Uri.parse('$envUrl/credentials/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'mobile_number': int.parse(username),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final FlutterSecureStorage secureStorage = FlutterSecureStorage();
        _showDialog("you are logged in , happy sessions ahead!");
        final Map resp = json.decode(response.body);
        final String token = resp['token'];

        // Store the token securely
        // _showDialog('received token is $token');
        await secureStorage.write(key: 'auth_token', value: token);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyAppp()), // Navigate to LoginPage
        );
        // Login successful
      } else if (response.statusCode == 404) {
        // Login failed

        _showDialog("invalid credentials / server error");
      } else if (response.statusCode == 500) {
        _showDialog("enter details in proper format");
      } else {
        _showDialog('try again , some error occured ${response.body}');
      }
    } catch (err) {
      _showDialog("error in username, enter properly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[400],
      /* appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 248, 168),
        title: Center(
            child: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        )),
        automaticallyImplyLeading: false,
      ),*/
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[400]!
            ], // Gradient from white to grey
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 170.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 3),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Image.asset(
                  'images/applogico.png',
                  width: 120.0,
                  height: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 50.0),
                child: SizedBox(
                  width: 250.0,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                    ),
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: 250.0,
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                    ),
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Text('LOGIN'),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.black, // Makes the background transparent
                      //backgroundBuilder: Colors.transparent, // Makes the surface (when disabled) transparent as well
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors
                          .transparent // Optional: Makes the shadow transparent
                      ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage()), // Navigate to LoginPage
                    );
                  },
                  child: Text('NO ACCOUNT? SIGN UP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
