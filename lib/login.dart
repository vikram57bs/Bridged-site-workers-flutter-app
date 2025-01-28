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
        // Login successful
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyAppp()), // Navigate to LoginPage
        );
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
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Center(
            child: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        )),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Submit'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage()), // Navigate to LoginPage
                  );
                },
                child: Text('no account ? sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
