// Copyright 2025 vikram balaji subrahmanyam
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import 'working.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:async';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

final String envUrl = dotenv.env['ENVIRONMENT_URL'] ?? 'demourl_notfound_error';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String ss = "";

  @override
  void initState() {
    super.initState();
    checktok();
  }

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<void> checktok() async {
    String? token = await secureStorage.read(key: 'auth_token');
    final url = Uri.parse('$envUrl/sessions/checktoken');
    final headers = {"Content-Type": "application/json"};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final data = jsonEncode({"tok": "check"});
    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //_showDialog('Requested. Kindly wait for confirmation.');
        Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          ss = "exists";
          Map<String, dynamic> rolee = responseBody["user"];
        });
        //return responseBody['user'];
      } else {
        if (response.statusCode == 401) {
          setState(() async {
            ss = "login";
            await DefaultCacheManager().removeFile('settings_profile_image');
          });
        }
        if (response.statusCode == 403) {
          setState(() {
            ss = "register";
          });
        }
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        //_showDialog("check the fields once.try again ${response.body}");
        //print(response.statusCode);
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      //print(e);
      //_showDialog("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Worker App',
      theme: ThemeData(
        primarySwatch: Colors.brown, // Use a color representing bricks
        scaffoldBackgroundColor: Colors.amber[100], // Sand color background
        textTheme: const TextTheme(
          headlineMedium:
              TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: ss == "register"
          ? MyHomePage()
          : ss == "login"
              ? LoginPage()
              : MyAppp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fullText = "Connects to Commute.";
  String visibleText = "";
  int _charIndex = 0;
  double _buttonOpacity = 0.0;
  @override
  void initState() {
    super.initState();

    // Wait 3 seconds before starting the typing effect
    Future.delayed(Duration(seconds: 2), () {
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_charIndex < fullText.length) {
          setState(() {
            visibleText += fullText[_charIndex];
            _charIndex++;
          });
        } else {
          timer.cancel();
        }
      });
      setState(() {
        _buttonOpacity = 1.0;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Container(
                  width: 100.0,
                  height: 200.0,
                  child: Image.asset('images/applogico.png')),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Text(
                  visibleText,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontFamily: 'Cursive',
                  ),
                ),
              ),
            ),

            AnimatedOpacity(
              duration: Duration(seconds: 3),
              opacity: _buttonOpacity,
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContractorPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600], // Bricks color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  foregroundColor: Colors.amber[50],
                ),
                child: const Text(
                  'CONTRACTOR',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 30), // Space between the buttons
            AnimatedOpacity(
              opacity: _buttonOpacity,
              duration: Duration(seconds: 4),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BuilderPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey[600], // Button color representing bricks
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  foregroundColor: Colors.amber[50],
                ),
                child: const Text(
                  'BUILDER',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),

            const SizedBox(height: 30), // Space between the buttons
            AnimatedOpacity(
              opacity: _buttonOpacity,
              duration: Duration(seconds: 5),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey[500], // Button color representing bricks
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  foregroundColor: Colors.amber[50],
                ),
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContractorPage extends StatefulWidget {
  const ContractorPage({super.key});

  @override
  _ContractorPageState createState() => _ContractorPageState();
}

class _ContractorPageState extends State<ContractorPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _compnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _idnController = TextEditingController();

  FilePickerResult? _pdf;
  FilePickerResult? _pdff;
  String _fileName = '';
  String _fileNamee = '';

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _compnameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _idnController.dispose();
    super.dispose();
  }

  Future<int?> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return null;
  }

  // Method to pick a PDF file
  Future<void> pickPDF() async {
    int? sdkVersion = await getAndroidSdkVersion();

    PermissionStatus status;

    if (sdkVersion != null && sdkVersion >= 33) {
      // Android 13 and above
      status = await Permission.photos.request();
    } else if (sdkVersion != null && sdkVersion >= 30) {
      // Android 11 and 12
      status = await Permission.storage.request();
    } else {
      // Below Android 11
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pdf = result;
          _fileName = result.files.single.name;
        });
        _showDialog('File selected: ${_pdf!.files.single.name}');
      } else {
        _showDialog('No file selected.');
      }
    } else if (status.isDenied) {
      _showDialog("Storage permission denied. Cannot access files.");
    } else {
      _showDialog("Permission permanently denied. Enable it from settings.");
    }
  }

  Future<void> pickPDFF() async {
    int? sdkVersion = await getAndroidSdkVersion();

    PermissionStatus status;

    if (sdkVersion != null && sdkVersion >= 33) {
      // Android 13 and above
      status = await Permission.photos.request();
    } else if (sdkVersion != null && sdkVersion >= 30) {
      // Android 11 and 12
      status = await Permission.storage.request();
    } else {
      // Below Android 11
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
        withData: true,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pdff = result;
          _fileNamee = result.files.single.name;
        });
        _showDialog('File selected: ${_pdff!.files.single.name}');
      } else {
        _showDialog('No file selected.');
      }
    } else if (status.isDenied) {
      _showDialog("Storage permission denied. Cannot access files.");
    } else {
      _showDialog("Permission permanently denied. Enable it from settings.");
    }
  }

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Submit button functionality
  void submitDetails() {
    String name1 = _nameController.text;
    String mobile1 = _mobileController.text;
    String comp1 = _compnameController.text;
    String address1 = _addressController.text;
    String city1 = _cityController.text;
    String state1 = _stateController.text;
    String country1 = _countryController.text;
    String identity1 = _idnController.text;

    Future<void> makePostRequest() async {
      final url = Uri.parse('$envUrl/contractors/postcontractordata');
      final request = http.MultipartRequest('POST', url);

      // Add JSON fields
      request.fields['name'] = name1;
      request.fields['mobile_number'] = mobile1;
      request.fields['company_name'] = comp1;
      request.fields['address'] = address1;
      request.fields['city'] = city1;
      request.fields['state'] = state1;
      request.fields['country'] = country1;
      request.fields['identity_number'] = identity1;

      // Add PDF file if selected
      if (_pdf != null && _pdf!.files.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'identity_proof',
            _pdf!.files.single.bytes!,
            filename: _pdf!.files.single.name,
            contentType: MediaType('application', 'jpg'),
          ),
        );
      }

      if (_pdff != null && _pdff!.files.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'institution_proof',
            _pdff!.files.single.bytes!,
            filename: _pdff!.files.single.name,
            contentType: MediaType('application', 'jpg'),
          ),
        );
      }
      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          var responsee = await http.Response.fromStream(response);
          final Map<String, dynamic> responseBody = json.decode(responsee.body);
          final String token = responseBody['token'];

          // Store the token securely
          // _showDialog('received token is $token');
          await secureStorage.write(key: 'auth_token', value: token);
          //print('Token stored securely');
          String? storedToken = await secureStorage.read(key: 'auth_token');
          if (storedToken != null) {
            // _showDialog('Token stored successfully: $storedToken');
          } else {
            _showDialog('Failed to store token.');
          }
          _showDialog('wow ! your account has been created successfully!');
        } else {
          final responseBody = await response.stream.bytesToString();
          _showDialog("Check the fields once. Try again: $responseBody");
        }
      } catch (e) {
        _showDialog("Error: ${e.toString()}");
      }
    }

    makePostRequest();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text(
          'Contractor Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true, // Match the button color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _compnameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address 1 ( door no . , street)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // City field
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City (chennai,delhi,koltakata...)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // State field
                TextField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State (tamil nadu,rajasthan,jharkhand...)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Country field
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idnController,
                  decoration: const InputDecoration(
                    labelText: 'Identity Card Number (aadhar,pan,voter id)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickPDF,
                  child: const Text('Proof of Identity (jpg)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 10, 3, 0), // Button color representing bricks
                  ),
                ),
                Text('Selected file: $_fileName'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickPDFF,
                  child: const Text('Upload Proof of Institution (jpg)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 10, 3, 0), // Button color representing bricks
                  ),
                ),
                Text('Selected file: $_fileNamee'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitDetails();
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 10, 3, 0), // Button color representing bricks
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuilderPage extends StatefulWidget {
  const BuilderPage({super.key});

  @override
  _BuilderPageState createState() => _BuilderPageState();
}

class _BuilderPageState extends State<BuilderPage> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Builder Language Selection',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true, // Match the button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Language',
              ),
              items: <String>['English', 'Hindi', 'Tamil', 'Telugu']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
            ),
            const SizedBox(height: 20), // Space between dropdown and button
            ElevatedButton(
              onPressed: _selectedLanguage == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuilderDetailsPage(),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 0, 0, 0), // Button color matching builder
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ),
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}

class BuilderDetailsPage extends StatefulWidget {
  const BuilderDetailsPage({super.key});

  @override
  _BuilderDetailsPageState createState() => _BuilderDetailsPageState();
}

class _BuilderDetailsPageState extends State<BuilderDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _idnController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _idnController.dispose();
    super.dispose();
  }

  String? _fileName;
  FilePickerResult? _pdf;

  // Method to pick a PDF file
  Future<int?> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return null;
  }

  Future<void> pickPDF() async {
    int? sdkVersion = await getAndroidSdkVersion();

    PermissionStatus status;

    if (sdkVersion != null && sdkVersion >= 33) {
      // Android 13 and above
      status = await Permission.photos.request();
    } else if (sdkVersion != null && sdkVersion >= 30) {
      // Android 11 and 12
      status = await Permission.storage.request();
    } else {
      // Below Android 11
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
        withData: true,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pdf = result;
          _fileName = result.files.single.name;
        });
        _showDialog('File selected: ${_pdf!.files.single.name}');
      } else {
        _showDialog('No file selected.');
      }
    } else if (status.isDenied) {
      _showDialog("Storage permission denied. Cannot access files.");
    } else {
      _showDialog("Permission permanently denied. Enable it from settings.");
    }
  }

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

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Submit button functionality
  void submitDetails() {
    String name1 = _nameController.text;
    String dob1 = _dobController.text;
    String mobile1 = _mobileController.text;
    String address1 = _addressController.text;
    String city1 = _cityController.text;
    String state1 = _stateController.text;
    String country1 = _countryController.text;
    String identity1 = _idnController.text;

    Future<void> makePostRequest() async {
      final url = Uri.parse('$envUrl/workers/postuserdata');
      final request = http.MultipartRequest('POST', url);

      // Add JSON fields
      request.fields['name'] = name1;
      request.fields['date_of_birth'] = dob1;
      request.fields['mobile_number'] = mobile1;
      request.fields['address'] = address1;
      request.fields['city'] = city1;
      request.fields['state'] = state1;
      request.fields['country'] = country1;
      request.fields['identity_number'] = identity1;

      // Add PDF file if selected
      if (_pdf != null && _pdf!.files.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'identity_proof',
            _pdf!
                .files.single.bytes!, // Use single instead of first for clarity
            filename: _pdf!.files.single.name,
            contentType: MediaType('application', 'jpg'),
          ),
        );
      }

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          var responsee = await http.Response.fromStream(response);
          final Map<String, dynamic> responseBody = json.decode(responsee.body);
          final String token = responseBody['token'];

          // Store the token securely
          await secureStorage.write(key: 'auth_token', value: token);
          //print('Token stored securely');
          _showDialog('wow!your account has been created successfully!');
        } else {
          final responseBody = await response.stream.bytesToString();
          _showDialog("Check the fields once. Try again: $responseBody");
        }
      } catch (e) {
        _showDialog("Error: ${e.toString()}");
      }
    }

    makePostRequest();
  }

// Method to show alert dialog

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text(
          'Builder Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Name field
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Age field
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth (yyyy-mm-dd)',
                  border:
                      OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
                ),
              ),
              const SizedBox(height: 20),
              // Mobile Number field
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address 1 ( door no . , street)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // City field
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City (chennai,delhi,kolkata...)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // State field
              TextField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State (tamil nadu,rajasthan,jharkhand..)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Country field
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Mobile Number field
              TextField(
                controller: _idnController,
                decoration: const InputDecoration(
                  labelText: 'Identity Card Number(aadhar,pan,voter id)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              // Identity proof file picker
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickPDF,
                child: const Text('Upload Identity Proof (jpg)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 0, 0, 0), // Button color representing bricks
                ),
              ),
              if (_fileName != null) Text('Selected file: $_fileName'),
              const SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  submitDetails();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 0, 0, 0), // Button color representing bricks
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:settings_ui/settings_ui.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Openings',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List mydata = [];
  String? filename = null;
  Uint8List? imageBytes;
  final List<Widget> _pages = [
    const JobOpeningsPage(), // Default page (posts)
    CurrentJobPage(title: 0),
    const SettingsPage(),
    const Groupsfave(),
    const HiringsPage(),
    const UpdateProfilePage(),
    const PremiumPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchmyself();
  }

  Future<void> fetchmyself() async {
    try {
      final response = await http.get(Uri.parse(
          '$envUrl/contractors/myowndata')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          //dumm = json.decode(response.body);
          //dumm = dumm[0]["posts"]; // Parse JSON data into the list
          mydata = jsonDecode(response.body);
          ////print("mydata $mydata");
          Map? profilePhoto = mydata[0]!['profile_photo']!;
          ////print("mapp pp $profilePhoto");
          if (profilePhoto?.length == 3) {
            ////print("hol");
            filename = profilePhoto?['filename'];
            final List<int> imageData =
                List<int>.from(profilePhoto?['file']?["data"]);
            imageBytes = Uint8List.fromList(imageData);
            // Converting to Uint8List
            ////print("md imb $imageBytes");

            // Displaying the image
          } else {
            //print('No profile photo found for an item');
          }
        });

        ////print(secdum);

        ////print("check");
        ////print(contractorwithposts);
        ////print(allposts);
        ////print("hh");
        ////print(contractorwithposts);

        //items = dumm;
        ////print(items);
        ////print(response.body);
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return mydata.length == 1
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'PRIPOVA',
                style: TextStyle(
                    color: Colors.white), // Set the text color to white
              ),
              backgroundColor: const Color.fromARGB(255, 10, 3, 0),
              foregroundColor: Colors.brown,
              centerTitle: true,
            ),
            drawer: Drawer(
              backgroundColor: Colors.brown,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 10, 3, 0),
                    ),
                    accountName: mydata.length == 0
                        ? Text("loading..")
                        : Text(
                            '${mydata[0]["name"]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                    accountEmail: mydata.length == 0
                        ? Text("loading..")
                        : Text(
                            '${mydata[0]["city"]}',
                            style: TextStyle(color: Colors.white),
                          ),
                    currentAccountPicture: CircleAvatar(
                        backgroundImage: mydata[0]["profile_photo"].length == 3
                            ? MemoryImage(imageBytes!)
                            : NetworkImage(url) as ImageProvider),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.white),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    leading:
                        const Icon(Icons.work_history, color: Colors.white),
                    title: const Text(
                      'Manage Jobs',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.people_alt_sharp, color: Colors.white),
                    title: const Text(
                      'saved groups',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    leading:
                        const Icon(Icons.edit_document, color: Colors.white),
                    title: const Text(
                      'Proof of Work',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.info_outline, color: Colors.white),
                    title: const Text(
                      'About',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 5;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    leading: const Icon(Icons.money, color: Colors.white),
                    title: const Text(
                      'Premium',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 6;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Divider()
                ],
              ),
            ),
            body: _pages[_selectedIndex],
          )
        : Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("please check your network connection")
              ],
            ),
          ));
  }
}

class JobOpeningsPage extends StatefulWidget {
  const JobOpeningsPage({super.key});

  @override
  State<JobOpeningsPage> createState() => _JobOpeningsPageState();
}

class _JobOpeningsPageState extends State<JobOpeningsPage> {
  List allcontractors = [];
  List allcontractorss = [];
  List aumm = [];
  List contractorwithposts = [];
  List contractorwithpostss = [];
  List secdum = [];
  List secdumm = [];
  List allposts = [];
  List allpostss = [];
  Map condetails = {};
  String filta = "any";
  String salary = 'any';
  String type = 'Both';
  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchadmins();
    // Fetch data on init
  }

  Future<void> fetchadmins() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/getadmin')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        aumm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        //print("admin: ${aumm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(
          '$envUrl/contractors/allprojects')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          secdum = [];
          //dumm = json.decode(response.body);
          //dumm = dumm[0]["posts"]; // Parse JSON data into the list
          allcontractors = jsonDecode(response.body);
          contractorwithposts = allcontractors
              .where((membe) => membe["posts"].length != 0)
              .toList();
          for (var obj in contractorwithposts) {
            for (var mems in obj["posts"]) {
              Map das = mems;
              if (obj["profile_photo"].length == 3) {
                List hhk = obj["profile_photo"]["file"]["data"];
                List<int> inti = hhk
                    .map((element) => int.parse(element.toString()))
                    .toList();
                das["profile_photo"] = inti;
              } else {
                das["profile_photo"] = "nil";
              }
              secdum.add(das);
            }
          }
        });
        ////print(secdum);
        allposts = secdum;
        ////print("check");
        ////print(contractorwithposts);
        ////print(allposts);
        ////print("hh");
        ////print(contractorwithposts);

        //items = dumm;
        ////print(items);
        ////print(response.body);
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<int> fetchItemss(String posttid) async {
    try {
      final response = await http.get(Uri.parse(
          '$envUrl/contractors/allprojects')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          secdumm = [];
          allcontractorss = jsonDecode(response.body);
          contractorwithpostss = allcontractorss
              .where((membe) => membe["posts"].isNotEmpty)
              .toList();
          for (var obj in contractorwithpostss) {
            for (var mems in obj["posts"]) {
              secdumm.add(mems);
            }
          }
        });
        ////print(allcontractorss);
        ////print(contractorwithpostss);
        //print(secdumm);
        //print("haha");

        int a = 0;
        allpostss = secdumm;
        allpostss =
            allpostss.where((membee) => membee["_id"] == posttid).toList();
        //print(allpostss);
        //print(allpostss.length);
        // Adding null safety
        if (allpostss.isNotEmpty) {
          Map post = allpostss[0];
          List appliedIndividual =
              post["workers"]?["applied"]?["individual"] ?? [];

          if (appliedIndividual == []) {
            a = 0;
          } else {
            for (Map ijk in appliedIndividual) {
              if (ijk["mobile_number"] == 7907666366) {
                a = 1;
              }
            }
          }
          return a;
        } else {
          return 0;
        }
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    } catch (err) {
      throw Exception('network/connection error');
    }
  }

  void showInfoDialog(BuildContext context, String name, String mobileNumber,
      String companyName, String city, String state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDialogRow('Name', name),
                _buildDialogRow('Mobile Number', mobileNumber),
                _buildDialogRow('Company Name', companyName),
                _buildDialogRow('City', city),
                _buildDialogRow('State', state),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String header, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$header: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showConfirmationModal(BuildContext contextt, String msg) {
    //print("im called");
    showModalBottomSheet(
      context: contextt,
      builder: (contextt) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(contextt).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Application',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(msg),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(contextt).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<int> fetchItemssg(String posttid, int reff_no) async {
    try {
      final response = await http.get(Uri.parse(
          '$envUrl/contractors/allprojects')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          secdumm = [];
          allcontractorss = jsonDecode(response.body);
          contractorwithpostss = allcontractorss
              .where((membe) => membe["posts"].isNotEmpty)
              .toList();
          for (var obj in contractorwithpostss) {
            for (Map mems in obj["posts"]) {
              secdumm.add(mems);
            }
          }
        });

        int a = 0;
        allpostss = secdumm;
        allpostss =
            allpostss.where((membee) => membee["_id"] == posttid).toList();

        // Adding null safety
        if (allpostss.isNotEmpty) {
          Map post = allpostss[0];
          List appliedGroup = post["workers"]?["applied"]?["group"] ?? [];

          if (appliedGroup.isEmpty) {
            a = 0;
          } else {
            for (Map ijk in appliedGroup) {
              if (ijk["reference_number"] == reff_no) {
                a = 1;
                break; // Exit the loop early if we find a match
              }
            }
          }
          return a;
        } else {
          return 0;
        }
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    } catch (err) {
      throw Exception('network/connection error');
    }
  }

  Future<void> makeapplicationRequest(String pid) async {
    final url =
        Uri.parse('$envUrl/contractors/createapplicationindi');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({"mobile_number": 7907666366, "post_id": pid});

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        // _showDialog('job applied . kindly wait');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        // _showDialog("check once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      // _showDialog("error");
    }
  }

  Future<void> makeapplicationRequestt(String pid, int ref_no) async {
    final url =
        Uri.parse('$envUrl/contractors/createapplicationgroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({"reference_number": ref_no, "post_id": pid});

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //_showDialog('job applied . kindly wait');
        //_showConfirmationModal();
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        // _showDialog("check once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      //_showDialog("error");
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail'),
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

  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: salary,
                  items: <String>['any', '300', '400', '500', '600', '700']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      salary = newValue!;
                      if (type == "Both" && salary == "any") {
                        allposts = secdum;
                      } else if (type == "Both" && salary != "any") {
                        allposts = secdum
                            .where((memb) =>
                                memb["workers_type"] == type &&
                                memb["salary"] == int.parse(salary))
                            .toList();
                      } else if (type != "Both" && salary == "any") {
                        allposts = secdum
                            .where((memb) => memb["workers_type"] == type)
                            .toList();
                      } else {
                        allposts = secdum
                            .where((memb) =>
                                memb["workers_type"] == type &&
                                memb["salary"] == int.parse(salary))
                            .toList();
                      }
                    });
                  },
                ),
                DropdownButton<String>(
                  value: type,
                  items: <String>['Both', 'Individual', 'Group']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Handle type filter change
                    setState(() {
                      type = newValue!;

                      if (type == "Both" && salary == "any") {
                        allposts = secdum;
                      } else if (type == "Both" && salary != "any") {
                        allposts = secdum
                            .where((memb) =>
                                memb["workers_type"] == type &&
                                memb["salary"] == int.parse(salary))
                            .toList();
                      } else if (type != "Both" && salary == "any") {
                        allposts = secdum
                            .where((memb) => memb["workers_type"] == type)
                            .toList();
                      } else {
                        allposts = secdum
                            .where((memb) =>
                                memb["workers_type"] == type &&
                                memb["salary"] == int.parse(salary))
                            .toList();
                      }
                    });
                  },
                ),
                DropdownButton<String>(
                  value: filta,
                  items: <String>['any', 'salary inc', 'salary dec']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      filta = newValue!;
                      if (filta == "salary inc") {
                        List fakesec = allposts;
                        fakesec
                            .sort((a, b) => a["salary"].compareTo(b["salary"]));
                        allposts = fakesec;
                      } else if (filta == "salary dec") {
                        List fakesec = allposts;
                        fakesec
                            .sort((a, b) => b["salary"].compareTo(a["salary"]));
                        allposts = fakesec;
                      } else {
                        if (type == "Both" && salary == "any") {
                          allposts = secdum;
                        } else if (type == "Both" && salary != "any") {
                          allposts = secdum
                              .where((memb) =>
                                  memb["workers_type"] == type &&
                                  memb["salary"] == int.parse(salary))
                              .toList();
                        } else if (type != "Both" && salary == "any") {
                          allposts = secdum
                              .where((memb) => memb["workers_type"] == type)
                              .toList();
                        } else {
                          allposts = secdum
                              .where((memb) =>
                                  memb["workers_type"] == type &&
                                  memb["salary"] == int.parse(salary))
                              .toList();
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          allposts.length != 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount:
                        int.parse('${allposts.length}'), // Example item count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GFCard(
                          boxFit: BoxFit.cover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePosition: GFPosition.start,
                          title: GFListTile(
                            avatar: GFAvatar(
                              backgroundImage:
                                  allposts[index]["profile_photo"] == "nil"
                                      ? NetworkImage(url, scale: 10.0)
                                          as ImageProvider
                                      : MemoryImage(Uint8List.fromList(
                                          allposts[index]["profile_photo"])),
                            ),
                            title: Text(
                              '${allposts[index]["project_name"]}\n${allposts[index]["project_location"]}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${allposts[index]["job_description"]}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        '${allposts[index]["salary"]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        GFButton(
                                          onPressed: () {
                                            _showApplyDialog(context,
                                                '${allposts[index]["_id"]}');
                                          },
                                          text: "Apply",
                                          color: const Color.fromARGB(
                                              255, 10, 3, 0),
                                        ),
                                        const SizedBox(width: 8),
                                        GFIconButton(
                                          onPressed: () {
                                            for (var ojk
                                                in contractorwithposts) {
                                              for (var dfg in ojk["posts"]) {
                                                if (dfg == allposts[index]) {
                                                  setState(() {
                                                    condetails = ojk;
                                                  });
                                                }
                                              }
                                            }
                                            showInfoDialog(
                                                context,
                                                condetails["name"],
                                                condetails["mobile_number"]
                                                    .toString(),
                                                condetails["company_name"],
                                                condetails["city"],
                                                condetails["state"]);
                                          },
                                          icon: const Icon(Icons.info_rounded),
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, String postid) {
    //final List<String> applicationTypes = ['Individual', 'Group'];

    showDialog(
      context: context,
      builder: (context) {
        return aumm.length > 0 && type != "Individual"
            ? AlertDialog(
                title: Center(child: const Text('Apply For Job')),
                content: SizedBox(
                  height: 150, // Adjust height as needed
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: int.parse('${aumm.length}'),
                    itemBuilder: (context, index) {
                      //final applicationType = applicationTypes[index];
                      return ListTile(
                        title: Text('${aumm[index]["name"]}'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();

                            int a = await fetchItemssg(
                                postid,
                                int.parse(
                                    '${aumm[index]["reference_number"]}'));
                            if (a == 0) {
                              await makeapplicationRequestt(
                                  postid,
                                  int.parse(
                                      '${aumm[index]["reference_number"]}'));
                              _showConfirmationModal(
                                  context, "application done");
                            } else {
                              _showConfirmationModal(
                                  context, "your group has already applied");
                            }
                          },
                          child: const Text('Apply'),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      int a = await fetchItemss(postid);
                      if (a == 0) {
                        await makeapplicationRequest(postid);
                        _showConfirmationModal(context, "application done");
                      } else {
                        _showConfirmationModal(
                            context, "you have already applied");
                      }
                    },
                    child: const Text('individually apply'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Apply for this job?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Handle 'No' button press
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Handle 'Yes' button press
                      Navigator.of(context).pop();

                      int a = await fetchItemss(postid);
                      if (a == 0) {
                        await makeapplicationRequest(postid);
                        _showConfirmationModal(context, "application done");
                      } else {
                        _showConfirmationModal(
                            context, "you have already applied");
                      }

                      // Close the dialog
                      // Additional actions can be added here if needed
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
      },
    );
  }
}

class CurrentJobPage extends StatefulWidget {
  //const CurrentJobPage({super.key});
  final int title;

  CurrentJobPage({required this.title});

  @override
  _CurrentJobPageState createState() => _CurrentJobPageState();
}

class _CurrentJobPageState extends State<CurrentJobPage> {
  String jobType = 'Current Jobs';
  String salary = '\$400';
  String rating = '3.0';
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.title; // Assign the passed index to _selectedIndex
  }

  static const url =
      "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

  static const List<Widget> _widgetOptions = <Widget>[
    JobsPage(),
    GroupsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Jobs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 10, 3, 0),
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<dynamic> groupss = [
    {"name": "loading", "description": "loading"}
  ];
  List<dynamic> dumm = [];
  List<dynamic> dummems = [];
  List<dynamic> aumm = [];
  List<dynamic> dumma = [];
  List mumm = [];
  List fumm = [];
  Uint8List? bytes;
  String? imageUrl = "";
  FilePickerResult? result;
  bool loading = false;
  final TextEditingController _groupnameController = TextEditingController();
  final TextEditingController _groupsizeController = TextEditingController();
  final TextEditingController _groupdescController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _gncontroller = TextEditingController();
  final TextEditingController _gdcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
    // Fetch data on init
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/membergroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        dumm = json.decode(response.body);

        //dumm = dumm[0]["members"]; // Parse JSON data into the list
        groupss = dumm;
        //print("gg $groupss");
        loading = true;
      });

      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchfavs() async {
    final response = await http.get(Uri.parse(
        '$envUrl/workers/favgroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        fumm = json.decode(response.body);
        //print("fumm: $fumm");
        //dumm = dumm[0]["members"]; // Parse JSON data into the list
      });
      //groupss = fumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  void dispose() {
    _groupnameController.dispose();
    _groupsizeController.dispose();
    _groupdescController.dispose();
    _refController.dispose();
    _addController.dispose();
    _gncontroller.dispose();
    _gdcontroller.dispose();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail'),
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

  Future<void> submitDetails() async {
    String name1 = _groupnameController.text;
    String desc1 = _groupdescController.text;
    String size1 = max_size;

    Future<void> makePostRequest() async {
      final url = Uri.parse('$envUrl/groups/creategroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'name': name1,
        'size': size1,
        'description': desc1,
        'admin': 7907666366,
        'members': [
          {"mobile_number": 7907666366}
        ],
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          _showDialog('Requested. Kindly wait for confirmation.');
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("check the fields once.try again ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makePostRequest();
  }

  Future<void> fetchadmins() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/getadmin')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        aumm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        //print("admin: ${aumm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> submitrefnumber() async {
    final url = Uri.parse('$envUrl/groups/joingroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'reference_number': _refController.text});

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        _showDialog('Requested. Kindly wait for confirmation.');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> submitmobnumber(String mmb, String gd) async {
    final url = Uri.parse('$envUrl/groups/addmgroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'mobile_number': int.parse(mmb), 'group_id': gd});

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        _showDialog('Requested. Kindly wait for confirmation.');
        setState(() {
          for (var obn in groupss) {
            if (obn["_id"] == gd) {
              obn["members"].add({"mobile_number": int.parse(mmb)});
            }
          }
          //print("after adding: $groupss");
        });
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  void _showManageModal(String groupName, int index) async {
    Future<void> makeadminRequest() async {
      List memlist = dumm[index]["members"];
      List<int> mobileNumbers =
          memlist.map((member) => member['mobile_number'] as int).toList();
      final url = Uri.parse('$envUrl/workers/getallmembers');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'members': mobileNumbers,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print(dummems);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makeadminRequest();
    Future<void> makePostRequest() async {
      List memlist = dumm[index]["members"];
      List<int> mobileNumbers =
          memlist.map((member) => member['mobile_number'] as int).toList();
      final url = Uri.parse('$envUrl/workers/getallmembers');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'members': mobileNumbers,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print("dummems:${dummems}");
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makePostRequest();

    await fetchadmins();
    Future<void> makedeleteRequest(String mbno) async {
      //print(mbno);
      //print(dumm[index]);
      final url = Uri.parse('$envUrl/groups/deletemember');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'mobile_number': int.parse(mbno),
        'group': {"_id": dumm[index]["_id"]},
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          //dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          setState(() {
            //List ogg=[];
            for (var ll in dumm) {
              //List emm=[];
              List ds = ll["members"];
              List ls = ds
                  .where((member) => member["mobile_number"] != int.parse(mbno))
                  .toList();
              ll["members"] = ls;
            }
            //dumm["members"]=emm;
            //print('${dumm}');
          });
          //print('deleted');
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    bool checkifadmin(String id) {
      bool chk = false;
      for (var obj in aumm) {
        if (obj["_id"] == id) {
          chk = true;
        }
      }
      return chk;
    }

    int getadminnumber(String gid) {
      return int.parse('${groupss[index]["admin"]}');
    }

    Future<void> makegroupchange(
        int ref_no, String groupname, String groupdesc) async {
      final url = Uri.parse('$envUrl/groups/changegroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'reference_number': ref_no,
        'group_name': groupname,
        'group_desc': groupdesc
      });

      try {
        final response = await http.put(url, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);
          _showDialog('Requested. Kindly wait for confirmation.');
          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    void _uploadImageWeb(Uint8List bytes, String filename) async {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$envUrl/groups/setgroupprofile'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'profile_photo', // Replace with your form field name
        bytes,
        filename: filename,
      ));

      // Add mobile number to the request
      request.fields['mobile'] = '7907666366';

      var response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    }

    void _uploadImage(String path) async {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$envUrl/groups/setgroupprofile'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo', // Replace with your form field name
        path,
      ));

      // Add mobile number to the request
      request.fields['mobile'] = '7907666366';

      var response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    }

    void _pickImage() async {
      String imageUrl =
          "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List? bytes = result.files.single.bytes;
          if (bytes != null) {
            // Upload image for web
            _uploadImageWeb(bytes, result.files.single.name);
          }
        } else if (result.files.single.path != null) {
          setState(() {
            imageUrl = result.files.single.path!;
          });

          // Upload image for mobile
          _uploadImage(result.files.single.path!);
        }
      }
    }

    List<int> coving(List a) {
      List<int> inti =
          a.map((element) => int.parse(element.toString())).toList();
      return inti;
    }

    void _showEditModal(int idx) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EDIT GROUP DETAILS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Upload Group Image:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // File picker button for image upload
                ElevatedButton(
                  onPressed: () async {
                    // Use file_picker to allow image selection
                    _pickImage();
                  },
                  child: Text('Upload Image'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Group Name'),
                  controller: _gncontroller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Group Description'),
                  controller: _gdcontroller,
                ),

                ElevatedButton(
                  onPressed: () async {
                    // Handle Create Post action
                    await makegroupchange(
                        int.parse('${dumm[idx]["reference_number"]}'),
                        _gncontroller.text,
                        _gdcontroller.text);
                    setState(() {
                      dumm[idx]["name"] = _gncontroller.text;
                      dumm[idx]["description"] = _gdcontroller.text;
                    });
                  },
                  child: const Text('save changes'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 10, 3, 0),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              dummems.length != 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: int.parse(
                            '${dummems.length}'), // Example item count
                        itemBuilder: (context, indexx) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      dummems[indexx]["profile_photo"].length !=
                                              3
                                          ? NetworkImage(
                                              'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                            ) as ImageProvider
                                          : MemoryImage(Uint8List.fromList(
                                              coving(dummems[indexx]
                                                      ["profile_photo"]["file"]
                                                  ["data"]))),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    '${dummems[indexx]["name"]}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String dobString =
                                        '${dummems[indexx]["date_of_birth"]}';
                                    DateTime dob = DateTime.parse(dobString);
                                    DateTime now = DateTime.now();
                                    int age = now.year - dob.year;
                                    if (now.month < dob.month ||
                                        (now.month == dob.month &&
                                            now.day < dob.day)) {
                                      age--;
                                    }
                                    //print(age);
                                    _showMemberDetails(
                                        context,
                                        '${dummems[indexx]["name"]}',
                                        '${dummems[indexx]["city"]}',
                                        ('${dummems[indexx]["mobile_number"]}')
                                            .toString(),
                                        age.toString(),
                                        groupss[index]["reference_number"],
                                        index);
                                  },
                                  child: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 10, 3, 0), // Button color
                                  ),
                                ),
                                (aumm.length > 0 &&
                                        checkifadmin(
                                            '${groupss[index]["_id"]}') &&
                                        getadminnumber(
                                                '${groupss[index]["_id"]}') !=
                                            int.parse(
                                                '${dummems[indexx]["mobile_number"]}'))
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          // Handle Delete Member action
                                          //print("pressed");
                                          await makedeleteRequest(
                                              '${dummems[indexx]["mobile_number"]}');
                                          //Navigator.pop(context);
                                        },
                                        color: Colors.red,
                                      )
                                    : SizedBox(width: 1.0),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              aumm.length > 0 && checkifadmin('${groupss[index]["_id"]}')
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle Add Member action
                            _addmemberGroupModal(
                                context, '${groupss[index]["_id"]}');
                          },
                          child: const Text('Add Member'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle Add Member action
                            _showEditModal(index);
                          },
                          child: const Text('Edit Group'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showDialog('${groupss[index]["reference_number"]}'
                                .toString());
                          },
                          child: const Text('Invite ID'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                      ],
                    )
                  : SizedBox(width: 1.0),
            ],
          ),
        );
      },
    );
  }

  void _showMemberDetails(BuildContext context, String name, String location,
      String mobile, String age, int ref_no, int indexc) {
    int getadminnumber(int ind) {
      return int.parse('${groupss[ind]["admin"]}');
    }

    List<int> getpropifc(String mobile) {
      List<int> inti = [1, 2];
      int ogm = int.parse(mobile);
      for (Map mm in dummems) {
        if (mm["mobile_number"] == ogm) {
          if (mm["profile_photo"]?.length == 3) {
            List hhk = mm["profile_photo"]?["file"]["data"];
            inti = hhk.map((element) => int.parse(element.toString())).toList();
          } else {
            continue;
          }
        }
      }
      return inti;
    }

    Future<void> makeadminchange() async {
      final url = Uri.parse('$envUrl/groups/changeadmin');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'reference_number': ref_no,
        'mobile_number': int.parse(mobile),
      });

      try {
        final response = await http.put(url, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          dumma = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: getpropifc(mobile).length == 2
                    ? NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ) as ImageProvider
                    : MemoryImage(Uint8List.fromList(getpropifc(mobile))),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age),
                ],
              ),
            ],
          ),
          actions: [
            getadminnumber(indexc) != int.parse(mobile)
                ? TextButton(
                    onPressed: () async {
                      await makeadminchange();
                      Navigator.of(context).pop();
                    },
                    child: const Text('make admin'),
                  )
                : const SizedBox(width: 1.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String max_size = '20';
  void _showAddGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal occupy 60-70% of the screen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the modal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _groupnameController,
                decoration: InputDecoration(labelText: 'Group Name'),
              ),
              // Label for the image upload

              DropdownButtonFormField<String>(
                value: max_size,
                items: <String>['20', '30', '40', '50'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    max_size = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Group Size'),
              ),
              TextField(
                controller: _groupdescController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await submitDetails();
                },
                child: Text('Create Group'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showJoinGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal occupy 60-70% of the screen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the modal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _refController,
                decoration: InputDecoration(
                  labelText:
                      'Enter Reference Number', // Prompt for reference number
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitrefnumber();
                  ////print("Group joined!");
                  //Navigator.pop(context); // Close the modal after submit
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 10, 3, 0), // Button color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addmemberGroupModal(BuildContext context, String grid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal occupy 60-70% of the screen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the modal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _addController,
                decoration: InputDecoration(
                  labelText:
                      'Enter Mobile Number', // Prompt for reference number
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitmobnumber(_addController.text, grid);
                  ////print("Group joined!");
                  //Navigator.pop(context); // Close the modal after submit
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 10, 3, 0), // Button color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> makedeleteRequest(String mbno, int inkex) async {
    //rint(mbno);
    //int(dumm[index]);
    final url = Uri.parse('$envUrl/groups/deletemember');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'mobile_number': int.parse(mbno),
      'group': {"_id": groupss[inkex]["_id"]},
    });

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //dummems = jsonDecode(response.body);
        //_showDialog('Requested. Kindly wait for confirmation.');
        _showDialog("left the group");
        ////print('deleted');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> makeadminchangee(int ref_no, String mobile) async {
    final url = Uri.parse('$envUrl/groups/changeadmin');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'reference_number': ref_no,
      'mobile_number': int.parse(mobile),
    });

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> makedeletegroup(int ref_no) async {
    final url = Uri.parse('$envUrl/groups/deletegroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'reference_number': ref_no,
    });

    try {
      final response = await http.delete(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('deleted the group');
        ////print(dumma);
      } else {
        // Failure response
        //////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  void _showLeaveOutConfirmationDialog(BuildContext context, int ing) {
    const n = 7907666366;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to Leave this Group?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Handle sign out logic here
                List leaveg = groupss[ing]["members"];
                if (leaveg.length > 1) {
                  if (groupss[ing]['admin'] == n) {
                    //print("yes you admin");
                    //print(groupss[ing]["members"][1]["mobile_number"]);
                    await makeadminchangee(
                        int.parse('${groupss[ing]["reference_number"]}'),
                        '${groupss[ing]["members"][1]["mobile_number"]}');
                    setState(() {
                      groupss[ing]["admin"] = int.parse(
                          '${groupss[ing]["members"][1]["mobile_number"]}');
                    });

                    await fetchadmins();
                  }
                  leaveg = leaveg
                      .where((membs) => membs["mobile_number"] != n)
                      .toList();
                  setState(() {
                    groupss[ing]["members"] = leaveg;
                  });
                  await makedeleteRequest(n.toString(), ing);
                } else {
                  await makedeletegroup(
                      int.parse('${dumm[ing]["reference_number"]}'));
                }
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 5),
                  Text('YES'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 5),
                  Text('NO'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> makefavouriteRequest(int ref_noo, String param) async {
    final url = Uri.parse('$envUrl/workers/createfavourite');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      "type": param,
      "reference_number": ref_noo,
    });

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        _showDialog('Requested. Kindly wait for confirmation.');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("check the fields once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  String filt_size = 'any';
  var arr = List.filled(10, 0);
  bool calcfav(int ind) {
    bool a = false;
    if (fumm[0]["favourites"].length == 0) {
      return a;
    } else {
      for (Map i in fumm[0]["favourites"]) {
        if (i["reference_number"] == groupss[ind]["reference_number"]) {
          a = true;
        }
      }
      return a;
    }
  }

  List<int> coving(List a) {
    List<int> inti = a.map((element) => int.parse(element.toString())).toList();
    return inti;
  }

  @override
  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return loading
        ? Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showAddGroupModal(context),
                        child: const Text('Add Group'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 10, 3, 0), // Button color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showJoinGroupModal(context),
                        child: const Text('Join Group'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 10, 3, 0), // Button color
                        ),
                      ),
                      DropdownButton<String>(
                        value: filt_size,
                        items: <String>['any', '20', '30', '40', '50']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            filt_size = newValue!;
                            if (filt_size == 'any') {
                              groupss = dumm;
                            } else {
                              groupss = dumm
                                  .where((group) =>
                                      group["size"] ==
                                      int.parse('${filt_size}'))
                                  .toList();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                groupss.length != 0
                    ? Expanded(
                        child: groupss.length == 0
                            ? Center(
                                child:
                                    Text("no groups found. create a new one ?"))
                            : ListView.builder(
                                itemCount: int.parse(
                                    '${groupss.length}'), // Example item count
                                itemBuilder: (context, index) {
                                  return groupss.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: GFCard(
                                            boxFit: BoxFit.cover,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            titlePosition: GFPosition.start,
                                            title: GFListTile(
                                              avatar: GFAvatar(
                                                backgroundImage: groupss[index]?[
                                                                "profile_photo"]
                                                            ?.length !=
                                                        3
                                                    ? NetworkImage(url,
                                                            scale: 10.0)
                                                        as ImageProvider
                                                    : MemoryImage(Uint8List.fromList(
                                                        coving(groupss[index][
                                                                "profile_photo"]
                                                            ["file"]["data"]))),
                                              ),
                                              title: Text(
                                                '${groupss[index]["name"]}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            content: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                '${groupss[index]["description"]}',
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            buttonBar: GFButtonBar(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      GFButton(
                                                        onPressed: () {
                                                          _showManageModal(
                                                              "${groupss[index]["name"]}",
                                                              index);
                                                        },
                                                        text: "Manage",
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 10, 3, 0),
                                                      ),
                                                      GFIconButton(
                                                        onPressed: () async {
                                                          await fetchfavs();
                                                          bool calcfav(
                                                              int ind) {
                                                            bool a = false;
                                                            if (fumm[0]["favourites"]
                                                                    .length ==
                                                                0) {
                                                              return a;
                                                            } else {
                                                              for (Map i in fumm[
                                                                      0][
                                                                  "favourites"]) {
                                                                if (i["reference_number"] ==
                                                                    groupss[ind]
                                                                        [
                                                                        "reference_number"]) {
                                                                  a = true;
                                                                }
                                                              }
                                                              return a;
                                                            }
                                                          }
                                                          // Handle Favorite action

                                                          if (calcfav(index) ==
                                                              false) {
                                                            await makefavouriteRequest(
                                                                int.parse(
                                                                    "${groupss[index]["reference_number"]}"),
                                                                "create");
                                                            _showDialog(
                                                                "added to your favourites");
                                                          } else {
                                                            await makefavouriteRequest(
                                                                int.parse(
                                                                    "${groupss[index]["reference_number"]}"),
                                                                "remove");
                                                            _showDialog(
                                                                "removed from your favourites");
                                                          }
                                                        },
                                                        icon: Icon(
                                                            Icons.star_border),
                                                        color: Colors.blue,
                                                      ),
                                                      GFButton(
                                                        onPressed: () {
                                                          //_showManageModal("TRIPURA WORKERS");
                                                          _showLeaveOutConfirmationDialog(
                                                              context, index);
                                                        },
                                                        text: "Leave",
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const CircularProgressIndicator();
                                },
                              ),
                      )
                    : const Text("no groups found.create a new one"),
              ],
            ),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String filt_jobs = "Completed Jobs";
  String work_type = "Individual";
  List<dynamic> completedind = [];
  List dump = [];
  bool loading = true;
  List gsmm = [];
  @override
  void initState() {
    super.initState();
    decideitemcount();
    fetchgroups();
  }

  Future<void> fetchgroups() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/allgroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        gsmm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        ////print("gsers: ${gsmm}");
        ////print(gsmm);
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchcompletedind() async {
    final response = await http.get(Uri.parse(
        '$envUrl/contractors/fetchcompleted')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        completedind = jsonDecode(response.body);
      });

      ////print('dumm: $dumm');
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Widget _buildDialogRow(String header, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$header: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void showInfoDialog(BuildContext context, String name, String mobileNumber,
      String companyName, String city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDialogRow('Name', name),
                _buildDialogRow('Mobile Number', mobileNumber),
                _buildDialogRow('Company Name', companyName),
                _buildDialogRow('salary', city),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> decideitemcount() async {
    dump = [];
    await fetchcompletedind();
    int n = 7907666366;
    if (work_type == "Individual" && filt_jobs == "Current Jobs") {
      for (Map k in completedind) {
        if (k["posts"].length > 0) {
          for (Map l in k["posts"]) {
            for (Map dd in l["workers"]["current"]["individual"]) {
              if (dd["mobile_number"] == n) {
                Map fff = l;
                fff["owner"] = k["name"];
                fff["cname"] = k["company_name"];
                fff["mbno"] = k["mobile_number"];
                fff["salary"] = l["salary"];
                if (k["profile_photo"]?.length == 3) {
                  List da = k["profile_photo"]?["file"]["data"];
                  List<int> inti = da
                      .map((element) => int.parse(element.toString()))
                      .toList();
                  fff["profile_photo"] = inti;
                } else {
                  fff["profile_photo"] = "nil";
                }
                dump.add(fff);
              }
            }
          }
        }
      }
      completedind = dump;
      loading = true;
    } else if (work_type == "Individual" && filt_jobs == "Completed Jobs") {
      dump = [];
      for (Map k in completedind) {
        if (k["posts"].length > 0) {
          for (Map l in k["posts"]) {
            for (Map dd in l["workers"]["completed"]["individual"]) {
              if (dd["mobile_number"] == n) {
                Map fff = l;
                fff["owner"] = k["name"];
                fff["cname"] = k["company_name"];
                fff["mbno"] = k["mobile_number"];
                fff["salary"] = l["salary"];
                if (k["profile_photo"]?.length == 3) {
                  List da = k["profile_photo"]?["file"]["data"];
                  List<int> inti = da
                      .map((element) => int.parse(element.toString()))
                      .toList();
                  fff["profile_photo"] = inti;
                } else {
                  fff["profile_photo"] = "nil";
                }
                dump.add(fff);
              }
            }
          }
        }
      }
      completedind = dump;
      loading = true;
    } else if (work_type == "Individual" && filt_jobs == "Upcoming") {
      dump = [];
      for (Map k in completedind) {
        if (k["posts"].length > 0) {
          for (Map l in k["posts"]) {
            for (Map dd in l["workers"]["applied"]["individual"]) {
              if (dd["mobile_number"] == n) {
                Map fff = l;
                fff["owner"] = k["name"];
                fff["cname"] = k["company_name"];
                fff["mbno"] = k["mobile_number"];
                fff["salary"] = l["salary"];
                if (k["profile_photo"]?.length == 3) {
                  List da = k["profile_photo"]?["file"]["data"];
                  List<int> inti = da
                      .map((element) => int.parse(element.toString()))
                      .toList();
                  fff["profile_photo"] = inti;
                } else {
                  fff["profile_photo"] = "nil";
                }
                dump.add(fff);
              }
            }
          }
        }
      }
      completedind = dump;
      loading = true;
    } else if (work_type == "Group" && filt_jobs == "Current Jobs") {
      dump = [];
      for (Map i in gsmm) {
        for (Map k in completedind) {
          if (k["posts"].length > 0) {
            for (Map l in k["posts"]) {
              for (Map dd in l["workers"]["current"]["group"]) {
                if (dd["reference_number"] == i["reference_number"]) {
                  Map fff = l;
                  fff["gname"] = i["name"];
                  fff["owner"] = k["name"];
                  fff["cname"] = k["company_name"];
                  fff["mbno"] = k["mobile_number"];
                  fff["salary"] = l["salary"];
                  if (k["profile_photo"]?.length == 3) {
                    List da = k["profile_photo"]?["file"]["data"];
                    List<int> inti = da
                        .map((element) => int.parse(element.toString()))
                        .toList();
                    fff["profile_photo"] = inti;
                  } else {
                    fff["profile_photo"] = "nil";
                  }
                  dump.add(fff);
                }
              }
            }
          }
        }
      }
      completedind = dump;
      loading = true;
    } else if (work_type == "Group" && filt_jobs == "Completed Jobs") {
      dump = [];
      for (Map i in gsmm) {
        for (Map k in completedind) {
          if (k["posts"].length > 0) {
            for (Map l in k["posts"]) {
              for (Map dd in l["workers"]["completed"]["group"]) {
                if (dd["reference_number"] == i["reference_number"]) {
                  Map fff = l;
                  fff["gname"] = i["name"];
                  fff["owner"] = k["name"];
                  fff["cname"] = k["company_name"];
                  fff["mbno"] = k["mobile_number"];
                  fff["salary"] = l["salary"];
                  if (k["profile_photo"]?.length == 3) {
                    List da = k["profile_photo"]?["file"]["data"];
                    List<int> inti = da
                        .map((element) => int.parse(element.toString()))
                        .toList();
                    fff["profile_photo"] = inti;
                  } else {
                    fff["profile_photo"] = "nil";
                  }
                  dump.add(fff);
                }
              }
            }
          }
        }
      }
      completedind = dump;
      loading = true;
    } else {
      dump = [];
      for (Map i in gsmm) {
        for (Map k in completedind) {
          if (k["posts"].length > 0) {
            for (Map l in k["posts"]) {
              for (Map dd in l["workers"]["applied"]["group"]) {
                if (dd["reference_number"] == i["reference_number"]) {
                  Map fff = l;
                  fff["gname"] = i["name"];
                  fff["owner"] = k["name"];
                  fff["cname"] = k["company_name"];
                  fff["mbno"] = k["mobile_number"];
                  fff["salary"] = l["salary"];
                  if (k["profile_photo"]?.length == 3) {
                    List da = k["profile_photo"]?["file"]["data"];
                    List<int> inti = da
                        .map((element) => int.parse(element.toString()))
                        .toList();
                    fff["profile_photo"] = inti;
                  } else {
                    fff["profile_photo"] = "nil";
                  }
                  dump.add(fff);
                }
              }
            }
          }
        }
        completedind = dump;
        loading = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: filt_jobs,
                items: <String>[
                  'Completed Jobs',
                  'Upcoming',
                  'Current Jobs',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) async {
                  setState(() {
                    filt_jobs = newValue!;
                  });
                  await decideitemcount();
                },
              ),
              DropdownButton<String>(
                value: work_type,
                items: <String>['Individual', 'Group'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) async {
                  setState(() {
                    work_type = newValue!;
                  });
                  await decideitemcount();
                },
              ),
            ],
          ),
        ),
        completedind.length > 0
            ? Expanded(
                child: ListView.builder(
                  itemCount: completedind.length, // Example item count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GFCard(
                        boxFit: BoxFit.cover,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        titlePosition: GFPosition.start,
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage:
                                completedind[index]["profile_photo"] == "nil"
                                    ? NetworkImage(url, scale: 10.0)
                                        as ImageProvider
                                    : MemoryImage(Uint8List.fromList(
                                        completedind[index]["profile_photo"])),
                          ),
                          title: Text(
                            '${completedind[index]["project_name"]}\n${completedind[index]["project_location"]}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${completedind[index]["job_description"]}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        buttonBar: GFButtonBar(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: filt_jobs == "Upcoming"
                                        ? Text(
                                            'APPLIED FOR JOB',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : filt_jobs == "Completed Jobs"
                                            ? Text(
                                                'JOB COMPLETED',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                'CURRENTLY WORKING',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                  ),
                                  work_type == "Group"
                                      ? Text('${completedind[index]["gname"]}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ))
                                      : Text('Individual',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          )),
                                  GFIconButton(
                                    onPressed: () {
                                      // Handle Favorite action
                                      showInfoDialog(
                                          context,
                                          '${completedind[index]["owner"]}',
                                          '${completedind[index]["mbno"]}',
                                          '${completedind[index]["cname"]}',
                                          '${completedind[index]["salary"]}');
                                    },
                                    icon: const Icon(Icons.info_outline),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const CircularProgressIndicator()
      ],
    );
  }
}

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({super.key});

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  String location = "Chennai";
  String salary = '\$400';
  String type = 'Individual';
  String view = "Individual";
  void _showManageModal(String groupName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Example item count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              'Member Name ${index + 1}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showMemberDetails(
                                  context,
                                  'Member Name ${index + 1}',
                                  'bengal',
                                  '9080677795',
                                  '23');
                            },
                            child: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 10, 3, 0), // Button color
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _applicationType = "Individual";
  void _showMemberDetails(BuildContext context, String name, String location,
      String mobile, String age) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Apply as'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Individual'),
                leading: Radio<String>(
                  value: 'Individual',
                  groupValue: _applicationType,
                  onChanged: (value) {
                    setState(() {
                      _applicationType = value!;
                    });
                    Navigator.of(context).pop();
                    _showApplyDialog(
                        context); // Rebuild dialog to reflect new selection
                  },
                ),
              ),
              ListTile(
                title: const Text('Group'),
                leading: Radio<String>(
                  value: 'Group',
                  groupValue: _applicationType,
                  onChanged: (value) {
                    setState(() {
                      _applicationType = value!;
                    });
                    Navigator.of(context).pop();
                    _showApplyDialog(
                        context); // Rebuild dialog to reflect new selection
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmationModal(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Application',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Application done'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";
    return view == "Individual"
        ? Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: location,
                        items: <String>[
                          'Chennai',
                          'Mumbai',
                          'Delhi',
                          'Bangalore'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            location = newValue!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: salary,
                        items: <String>['\$400', '\$500', '\$600', '\$700']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            salary = newValue!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: type,
                        items:
                            <String>['Individual', 'Group'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // Handle type filter change
                          setState(() {
                            type = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Example item count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GFCard(
                          boxFit: BoxFit.cover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePosition: GFPosition.start,
                          title: GFListTile(
                            avatar: GFAvatar(
                              backgroundImage: NetworkImage(url, scale: 10.0),
                            ),
                            title: const Text(
                              'Company Name\nchennai , india',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'I need 25 workers (individual) who can work from 9 to 5 and also no accommodation is provided. No negotiation.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: const Text(
                                        '\$400',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        GFButton(
                                          onPressed: () {
                                            // Handle Apply action
                                            _showApplyDialog(context);
                                          },
                                          text: "Apply",
                                          color: const Color.fromARGB(
                                              255, 10, 3, 0),
                                        ),
                                        const SizedBox(width: 8),
                                        GFIconButton(
                                          onPressed: () {
                                            // Handle Favorite action
                                          },
                                          icon: const Icon(Icons.favorite),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Example item count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GFCard(
                          boxFit: BoxFit.cover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePosition: GFPosition.start,
                          title: GFListTile(
                            avatar: GFAvatar(
                              backgroundImage: NetworkImage(url, scale: 10.0),
                            ),
                            title: const Text(
                              'Group Name',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'This group consists of 50 members.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GFButton(
                                      onPressed: () {
                                        _showManageModal("TRIPURA WORKERS");
                                      },
                                      text: "View",
                                      color:
                                          const Color.fromARGB(255, 10, 3, 0),
                                    ),
                                    GFIconButton(
                                      onPressed: () {
                                        // Handle Favorite action
                                      },
                                      icon: const Icon(Icons.favorite_border),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String imageUrl =
      "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";
  String defim =
      "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";
  bool isDarkMode = false;
  List mydata = [];
  Uint8List? imageBytes;

  String? filename = null;
  @override
  void initState() {
    super.initState();
    fetchmyself();
  }

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      if (kIsWeb) {
        Uint8List? bytes = result.files.single.bytes;
        if (bytes != null) {
          // Upload image for web
          _uploadImageWeb(bytes, result.files.single.name);
        }
      } else if (result.files.single.path != null) {
        setState(() {
          imageUrl = result.files.single.path!;
        });

        // Upload image for mobile
        _uploadImage(result.files.single.path!);
      }
    }
  }

  void _uploadImageWeb(Uint8List bytes, String filename) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$envUrl/contractors/edituserprofile'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'profile_photo', // Replace with your form field name
      bytes,
      filename: filename,
    ));

    // Add mobile number to the request
    request.fields['mobile'] = '7305621554';

    var response = await request.send();

    // Handle the response
    if (response.statusCode == 201) {
      //print('Image uploaded successfully');
    } else {
      //print('Image upload failed');
    }
  }

  void _uploadImage(String path) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$envUrl/contractors/edituserprofile'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'profile_photo', // Replace with your form field name
      path,
    ));

    // Add mobile number to the request
    request.fields['mobile'] = '9842163059';

    var response = await request.send();

    // Handle the response
    if (response.statusCode == 201) {
      //print('Image uploaded successfully');
    } else {
      //print('Image upload failed');
    }
  }

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

  Future<void> fetchmyself() async {
    try {
      final response = await http.get(Uri.parse(
          '$envUrl/contractors/myowndata')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          //dumm = json.decode(response.body);
          //dumm = dumm[0]["posts"]; // Parse JSON data into the list
          mydata = jsonDecode(response.body);
          ////print("mydata $mydata");
          Map? profilePhoto = mydata[0]!['profile_photo']!;
          // //print("mapp pp $profilePhoto");
          if (profilePhoto?.length == 3) {
            // //print("hol");
            filename = profilePhoto?['filename'];
            final List<int> imageData =
                List<int>.from(profilePhoto?['file']?["data"]);
            imageBytes = Uint8List.fromList(imageData);
            // Converting to Uint8List

            // Displaying the image
          } else {
            //print('No profile photo found for an item');
          }
        });

        ////print(secdum);

        ////print("check");
        ////print(contractorwithposts);
        ////print(allposts);
        ////print("hh");
        ////print(contractorwithposts);

        //items = dumm;
        ////print(items);
        ////print(response.body);
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> changelanguage(String language) async {
    final url = Uri.parse('$envUrl/workers/changelanguage');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'language': language});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> changeaddress(String address) async {
    final url = Uri.parse('$envUrl/workers/changeaddress');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'address': address});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> changepassword(String password) async {
    final url = Uri.parse('$envUrl/workers/changepassword');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'password': password});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> changecity(String city) async {
    final url = Uri.parse('$envUrl/workers/changecity');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'city': city});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> changenumber(int number) async {
    final url = Uri.parse('$envUrl/workers/changenumber');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'mobile_number': number});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  String location = "Chennai";
  void _showLocationDialog(
      String title, String currentValue, Function(String) onSaved) {
    String selectedValue = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedValue,
                items: [currentValue, 'Chennai', 'Mumbai', 'Bangalore', 'Delhi']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await changecity(selectedValue.toString());
                onSaved(selectedValue);

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(
      String title, String currentValue, Function(String) onSaved) {
    String selectedValue = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedValue,
                items: [selectedValue, 'English', 'Hindi', 'Telugu', 'Tamil']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await changelanguage(selectedValue.toString());
                onSaved(selectedValue);

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPhoneDialog(
      String title, String initialValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $title"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await changenumber(int.parse(controller.text));
              onSave(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String address = "13,balaji nagar,nanganallur,chennai";
  void _showEditAddressDialog(
      String title, String initialValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $title"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await changeaddress(controller.text);
              onSave(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String language = "English";
  void _showPasswordChangeDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(hintText: "Current Password"),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(hintText: "New Password"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save new password logic here
              if (currentPasswordController.text == mydata[0]["password"]) {
                await changepassword(newPasswordController.text);
                _showDialog("successfully changed password");
              } else {
                _showDialog("wrong current password");
              }

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String phone = "91-9080677795";

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle sign out logic here
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 5),
                  Text('Yes'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 5),
                  Text('No'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle delete account logic here
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 5),
                  Text('Yes'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 5),
                  Text('No'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return mydata.length != 0
        ? Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Column(
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : NetworkImage(defim) as ImageProvider,
                    child: imageBytes == null ? Icon(Icons.add_a_photo) : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${mydata[0]["name"]}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SettingsList(
                    sections: [
                      SettingsSection(
                        title: const Text('Common'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: const Icon(Icons.language),
                            title: const Text('Language'),
                            value: Text('${mydata[0]["language"]}'),
                            onPressed: (context) {
                              _showLanguageDialog(
                                  'Language', '${mydata[0]["language"]}',
                                  (value) {
                                setState(() {
                                  language = value;
                                });
                              });
                            },
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                            initialValue: isDarkMode,
                            leading: const Icon(Icons.brightness_6),
                            title: const Text('Dark Mode'),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('Profile'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: const Icon(Icons.phone),
                            title: const Text('Phone number'),
                            value: Text('${mydata[0]["mobile_number"]}'),
                            onPressed: (context) {
                              _showEditPhoneDialog('Phone number',
                                  '${mydata[0]["mobile_number"]}', (value) {
                                // Save new phone number logic here
                                setState(() {
                                  phone = value;
                                });
                              });
                            },
                          ),
                          SettingsTile.navigation(
                            leading: const Icon(Icons.location_city_sharp),
                            title: const Text('Address'),
                            value: Text('${mydata[0]["address"]}'),
                            onPressed: (context) {
                              _showEditAddressDialog(
                                  'Address', '${mydata[0]["address"]}',
                                  (value) {
                                // Save new phone number logic here
                                setState(() {
                                  address = value;
                                });
                              });
                            },
                          ),
                          SettingsTile.navigation(
                              leading: const Icon(Icons.location_on),
                              title: const Text('Location'),
                              value: Text('${mydata[0]["city"]}'),
                              onPressed: (context) {
                                _showLocationDialog(
                                  'Location',
                                  '${mydata[0]["city"]}',
                                  (value) {
                                    setState(() {
                                      location = value;
                                    });
                                  },
                                );
                              }),
                          SettingsTile.navigation(
                            leading: const Icon(Icons.lock),
                            title: const Text('Change Password'),
                            onPressed: (context) {
                              _showPasswordChangeDialog();
                            },
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('App'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: const Icon(Icons.logout),
                            title: const Text('Sign out'),
                            onPressed: (context) {
                              // Handle sign out
                              _showSignOutConfirmationDialog(context);
                            },
                          ),
                          SettingsTile.navigation(
                            leading: const Icon(Icons.delete),
                            title: const Text('Delete account'),
                            onPressed: (context) {
                              // Handle delete account
                              _showDeleteAccountConfirmationDialog(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(child: const CircularProgressIndicator());
  }
}

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('FAQ Page'),
    );
  }
}

class HiringsPage extends StatelessWidget {
  const HiringsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Proof of Work Page'),
    );
  }
}

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Update Profile Page'),
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Premium Page'),
    );
  }
}

class _ManageWorkersContent extends StatefulWidget {
  const _ManageWorkersContent({super.key});

  @override
  State<_ManageWorkersContent> createState() => _ManageWorkersContentState();
}

class _ManageWorkersContentState extends State<_ManageWorkersContent> {
  List items = [];
  List dumm = [];
  List dumma = [];
  List gsmm = [];
  List usmm = [];
  List allworkingmems = [];
  List pplingrp = [];
  List dummanyy = [];
  List<int> aqw = [1];

  String location = "Chennai";
  String salary = "\$400";
  String type = "20";
  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchgroups();
    fetchusers();
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        '$envUrl/contractors/contractorprojects')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        items = [];
        dumm = [];
        dumma = json.decode(response.body);
        dumm = dumma[0]["posts"];
        // //print("dumm dumm: $dumm");
        for (Map aksa in dumm) {
          if (dumma[0]["profile_photo"].length == 3) {
            List hhk = dumma[0]["profile_photo"]["file"]["data"];
            List<int> inti =
                hhk.map((element) => int.parse(element.toString())).toList();
            aksa["profile_photo"] = inti;
          } else {
            aksa["profile_photo"] = "nil";
          }
        }
// Parse JSON data into the list
      });
      items = dumm;
      ////print('dumm: $dumm');
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchgroups() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/allgroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        gsmm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        ////print("gsers: ${gsmm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchmyfavs() async {
    final response = await http.get(Uri.parse(
        '$envUrl/contractors/contractorfavs')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response

      dummanyy = json.decode(response.body);
      //print(dummanyy);
// Parse JSON data into the list

      ////print('dumm: $dumm');
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchusers() async {
    final response = await http.get(Uri.parse(
        '$envUrl/workers/allusers')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        usmm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        ////print("users: ${usmm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> makeareport(int mbbno, String pid) async {
    final url = Uri.parse('$envUrl/contractors/createareport');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({"mobile_number": mbbno, "post_id": pid});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        _showDialog('reported . kindly wait');
        //print("reported");
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("check once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> completejob(String pid) async {
    final url = Uri.parse('$envUrl/contractors/completejob');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({"post_id": pid});

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        _showDialog('job completed');
        ////print("reported");
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("check once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  bool checkreport(int mb, String refno) {
    bool chc = false;
    for (Map hgi in usmm) {
      if (hgi["mobile_number"] == mb) {
        int l = hgi["reports"].length;
        if (l == 0) {
          continue;
        } else {
          for (Map rr in hgi["reports"]) {
            if (rr["postid"] == refno) {
              chc = true;
            }
          }
        }
      }
    }
    return chc;
  }

  int grpnop(int refno) {
    int ppl = 0;
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        ppl = dfg["members"].length;
      }
    }
    return ppl;
  }

  int noofpeopleworking(String pid) {
    int groupsum = 0;
    List tte = items.where((post) => post["_id"] == pid).toList();
    if (tte[0]["workers"]["completed"]["individual"].length +
            tte[0]["workers"]["completed"]["group"].length ==
        0) {
      int inlength = (tte[0]["workers"]["current"]["individual"]).length;
      for (Map grp in tte[0]["workers"]["current"]["group"]) {
        groupsum += grpnop(grp["reference_number"]);
      }
      return inlength + groupsum;
    } else {
      int inlength = (tte[0]["workers"]["completed"]["individual"]).length;
      for (Map grp in tte[0]["workers"]["completed"]["group"]) {
        groupsum += grpnop(grp["reference_number"]);
      }
      return inlength + groupsum;
    }
  }

  String getusername(int mbbnno) {
    String name = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        name = uu["name"];
      }
    }
    return name;
  }

  String getgrpname(int refno) {
    String gname = '';
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        gname = dfg["name"];
      }
    }
    return gname;
  }

  List<int> getgrpprofile(int refno) {
    List<int> indi = [];
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        if (dfg["profile_photo"]?.length == 3) {
          List ii = dfg["profile_photo"]?["file"]["data"];
          indi = ii.map((element) => int.parse(element.toString())).toList();
        } else {
          continue;
        }
      }
    }
    return indi;
  }

  List grpmems(int ref) {
    List membs = [];
    for (Map dets in gsmm) {
      if (dets["reference_number"] == ref) {
        membs = dets["members"];
      }
    }
    return membs;
  }

  String getusercity(int mbbnno) {
    String city = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        city = uu["city"];
      }
    }
    return city;
  }

  String getuserdob(int mbbnno) {
    String city = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        city = uu["date_of_birth"];
      }
    }
    return city;
  }

  List<int> getprofilepic(int mbno) {
    List ii = [];
    List<int> inti = [];
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbno) {
        if (uu["profile_photo"]?.length == 3) {
          ii = uu["profile_photo"]?["file"]?["data"];
          inti = ii.map((element) => int.parse(element.toString())).toList();
        } else {
          inti = [];
        }
      }
    }
    return inti;
  }

  int calcage(String dobString) {
    int age;
    DateTime dob = DateTime.parse(dobString);
    DateTime now = DateTime.now();
    age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  void getallworking(String pid) {
    allworkingmems = [];
    Map userdat = {};
    Map guserdat = {};
    List indarr = [];
    List grparr = [];
    List tte = items.where((post) => post["_id"] == pid).toList();
    if (tte[0]["workers"]["completed"]["individual"].length +
            tte[0]["workers"]["completed"]["group"].length !=
        0) {
      indarr = tte[0]["workers"]["completed"]["individual"];
      grparr = tte[0]["workers"]["completed"]["group"];
    } else {
      indarr = tte[0]["workers"]["current"]["individual"];
      grparr = tte[0]["workers"]["current"]["group"];
    }

    for (Map tvk in indarr) {
      userdat = {};
      userdat["name"] = getusername(tvk["mobile_number"]);
      userdat["city"] = getusercity(tvk["mobile_number"]);
      userdat["mobile_number"] = tvk["mobile_number"];
      userdat["age"] = calcage(getuserdob(tvk["mobile_number"]));
      userdat["profile_photo"] = getprofilepic(tvk["mobile_number"]);
      allworkingmems.add(userdat);
    }
    for (Map tvk in grparr) {
      for (Map dmk in grpmems(tvk["reference_number"])) {
        guserdat = {};
        guserdat["name"] = getusername(dmk["mobile_number"]);
        guserdat["city"] = getusercity(dmk["mobile_number"]);
        guserdat["mobile_number"] = dmk["mobile_number"];
        guserdat["age"] = calcage(getuserdob(dmk["mobile_number"]));
        guserdat["profile_photo"] = getprofilepic(dmk["mobile_number"]);
        allworkingmems.add(guserdat);
        ////print(allworkingmems);
      }
    }
    ////print("all $allworkingmems");
  }

  void grpspecific(String pid) {
    List tte = items.where((post) => post["_id"] == pid).toList();
    //print(tte);
    List grparr = tte[0]["workers"]["current"]["group"];
    if (grparr.length == 0) {
      grparr = tte[0]["workers"]["completed"]["group"];
    }
    setState(() {
      pplingrp = grparr;
    });
    //print("pplin : $pplingrp");
  }

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

  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: int.parse('${items.length}'), // Example item count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GFCard(
                  boxFit: BoxFit.cover,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  titlePosition: GFPosition.start,
                  title: GFListTile(
                    avatar: GFAvatar(
                        backgroundImage: items[index]["profile_photo"] == "nil"
                            ? NetworkImage(url, scale: 10.0) as ImageProvider
                            : MemoryImage(Uint8List.fromList(
                                items[index]["profile_photo"]))),
                    title: Text(
                      '${items[index]["project_name"]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: items[index]["workers"]["completed"]["individual"]
                                    .length +
                                items[index]["workers"]["completed"]["group"]
                                    .length ==
                            0
                        ? Text(
                            'This project consists of ${noofpeopleworking('${items[index]["_id"]}')} workers currently',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            'This project consisted of ${noofpeopleworking('${items[index]["_id"]}')} workers and completed',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  buttonBar: GFButtonBar(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GFButton(
                              onPressed: () {
                                getallworking('${items[index]["_id"]}');
                                _showManageModal(
                                    context,
                                    '${items[index]["project_name"]}',
                                    '${items[index]["_id"]}');
                              },
                              text: "Manage",
                              color: const Color.fromARGB(255, 10, 3, 0),
                            ),
                            GFIconButton(
                              onPressed: () {
                                // Handle Favorite action
                              },
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showManageMModal(BuildContext context, String groupName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Flexible(
                child: int.parse('${pplingrp.length}') > 0
                    ? ListView.builder(
                        itemCount: int.parse(
                            '${pplingrp.length}'), // Example item count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundImage: getgrpprofile(int.parse(
                                              '${pplingrp[index]["reference_number"]}'))
                                          .isEmpty
                                      ? NetworkImage(
                                          'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                        ) as ImageProvider
                                      : MemoryImage(Uint8List.fromList(
                                          getgrpprofile(int.parse(
                                              '${pplingrp[index]["reference_number"]}')))),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  getgrpname(int.parse(
                                      '${pplingrp[index]["reference_number"]}')),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showMMemberDetails(
                                        context,
                                        int.parse(
                                            '${pplingrp[index]["reference_number"]}'));
                                  },
                                  child: const Text('View'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 10, 3, 0), // Button color
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(child: Text("no groups recruited")),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  void projectDetails(BuildContext context, String postid) {
    List admk = items.where((posts) => posts["_id"] == postid).toList();
    String proj_loc = admk[0]["project_location"];
    int salary = admk[0]["salary"];
    int totalexpense = salary * (noofpeopleworking(postid));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Project Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8.0),
                  Text("Location: $proj_loc"),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.monetization_on),
                  SizedBox(width: 8.0),
                  Text("Salary: $salary"),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.attach_money),
                  SizedBox(width: 8.0),
                  Text("Total Expense: $totalexpense"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showManageModal(BuildContext context, String groupName, String piiid) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Flexible(
                child: int.parse('${allworkingmems.length}') > 0
                    ? ListView.builder(
                        itemCount: int.parse(
                            '${allworkingmems.length}'), // Example item count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  backgroundImage: allworkingmems[index]
                                                  ?["profile_photo"]
                                              ?.length ==
                                          0
                                      ? NetworkImage(
                                          'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                        ) as ImageProvider
                                      : MemoryImage(Uint8List.fromList(
                                          allworkingmems[index]
                                              ["profile_photo"])),
                                ),
                                const SizedBox(width: 20.0),
                                Text(
                                  '${allworkingmems[index]["name"]}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _showMemberDetails(
                                        context,
                                        '${allworkingmems[index]["name"]}',
                                        '${allworkingmems[index]["city"]}',
                                        allworkingmems[index]["mobile_number"],
                                        allworkingmems[index]["age"]);
                                  },
                                  child: const Text('View'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 10, 3, 0), // Button color
                                  ),
                                ),
                                !checkreport(
                                            allworkingmems[index]
                                                ["mobile_number"],
                                            piiid) &&
                                        items
                                                    .where((poss) =>
                                                        poss["_id"] == piiid)
                                                    .toList()[0]["workers"]
                                                        ["completed"]
                                                        ["individual"]
                                                    .length +
                                                items
                                                    .where((poss) =>
                                                        poss["_id"] == piiid)
                                                    .toList()[0]["workers"]
                                                        ["completed"]["group"]
                                                    .length ==
                                            0
                                    ? GFIconButton(
                                        onPressed: () async {
                                          // Handle Favorite action
                                          await makeareport(
                                              allworkingmems[index]
                                                  ["mobile_number"],
                                              piiid);
                                        },
                                        icon: const Icon(Icons.report),
                                        color: Colors.yellow,
                                      )
                                    : const SizedBox(width: 1.0),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(child: Text("no workers recruited")),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Add Member action
                      projectDetails(context, piiid);
                    },
                    child: const Text('Project Details'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          const Color.fromARGB(255, 10, 3, 0), // Button color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Change Admin action
                      grpspecific(piiid);
                      _showManageMModal(context, "All Groups");
                    },
                    child: const Text('View Groups'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          const Color.fromARGB(255, 10, 3, 0), // Button color
                    ),
                  ),
                  items
                                  .where((poss) => poss["_id"] == piiid)
                                  .toList()[0]["workers"]["completed"]
                                      ["individual"]
                                  .length +
                              items
                                  .where((poss) => poss["_id"] == piiid)
                                  .toList()[0]["workers"]["completed"]["group"]
                                  .length ==
                          0
                      ? ElevatedButton(
                          onPressed: () async {
                            await completejob(piiid);
                            await fetchItems();
                          },
                          child: const Text('Finish'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        )
                      : const SizedBox(width: 1.0),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMMemberDetails(BuildContext context, int referno) {
    Future<void> makefavouriteRequest(int ref_noo, String param) async {
      final url =
          Uri.parse('$envUrl/contractors/contractorfavourite');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        "type": param,
        "reference_number": ref_noo,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    List gnos = grpmems(referno);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Group Members"),
          content: SizedBox(
            // Set a specific height for the ListView to avoid render issues
            height: 200.0,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: gnos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.man),
                      const SizedBox(width: 8.0),
                      Text(getusername(
                          int.parse('${gnos[index]["mobile_number"]}'))),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            GFIconButton(
              onPressed: () async {
                // Handle Favorite action
                await fetchmyfavs();
                bool check() {
                  bool aa = false;
                  if (dummanyy[0]["favourites"].length == 0) {
                    aa = false;
                  } else {
                    for (Map sk in dummanyy[0]["favourites"]) {
                      if (sk["reference_number"] == referno) {
                        aa = true;
                      }
                    }
                  }
                  return aa;
                }

                if (check() == true) {
                  await makefavouriteRequest(referno, "remove");
                  _showDialog("removed from favourites");
                } else {
                  await makefavouriteRequest(referno, "create");
                  _showDialog("added to favourites");
                }
              },
              icon: const Icon(Icons.star_border),
              color: Colors.red,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showMemberDetails(
      BuildContext context, String name, String location, int mobile, int age) {
    List<int> cc = [1, 2];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: getprofilepic(mobile).isEmpty
                    ? NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ) as ImageProvider
                    : MemoryImage(Uint8List.fromList(getprofilepic(mobile))),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile.toString()),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age.toString()),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ContractorPage extends StatefulWidget {
  const ContractorPage({super.key});

  @override
  State<ContractorPage> createState() => _ContractorPageState();
}

class _ContractorPageState extends State<ContractorPage> {
  List<dynamic> dumm = [];
  List dumma = [];
  List items = [];
  String location = 'Chennai';
  String salary = '\$400';
  String type = 'Both';
  int _selectedIndex = 0;
  String typeie = "Individual";
  List usmm = [];
  List gsmm = [];
  final TextEditingController _projnameController = TextEditingController();
  final TextEditingController _locController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _salController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchusers();
    fetchgroups(); // Fetch data on init
  }

  Future<void> fetchusers() async {
    final response = await http.get(Uri.parse(
        '$envUrl/workers/allusers')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        usmm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        //print("users: ${usmm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchgroups() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/allgroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        gsmm = json.decode(response.body);
        //dumm = dumm[0]["posts"]; // Parse JSON data into the list
        ////print("gsers: ${gsmm}");
      });
      //items = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        '$envUrl/contractors/contractorprojects')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        items = [];
        dumm = [];
        dumma = json.decode(response.body);
        ////print("dumma $dumma");
        dumm = dumma[0]["posts"];
        ////print("dumm : $dumm");
// Parse JSON data into the list
        for (Map aksa in dumm) {
          if (dumma[0]["profile_photo"].length == 3) {
            List hhk = dumma[0]["profile_photo"]["file"]["data"];
            List<int> inti =
                hhk.map((element) => int.parse(element.toString())).toList();
            aksa["profile_photo"] = inti;
          } else {
            aksa["profile_photo"] = "nil";
          }
        }
      });
      items = dumm;
      ////print('dumm: $dumm');
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  void dispose() {
    _projnameController.dispose();
    _locController.dispose();
    _typeController.dispose();
    _descController.dispose();
    _salController.dispose();
    super.dispose();
  }

  void submitDetails(String hhype) async {
    String name1 = _projnameController.text;
    String loc1 = _locController.text;
    String sal1 = _salController.text;
    String desc1 = _descController.text;
    String type1 = hhype;
    String conno = "7305621554";
    Future<void> makePostRequest() async {
      final url = Uri.parse('$envUrl/contractors/contractorpost');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'contractorId': conno,
        'newPost': {
          "project_name": name1,
          "project_location": loc1,
          "salary": sal1,
          "job_description": desc1,
          "workers_type": type1
        }
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          _showDialog('Requested. Kindly wait for confirmation.');
          setState(() {
            Map temp = jsonDecode(data);
            Map tempa = temp["newPost"];
            tempa["workers"] = {
              "applied": {"individual": [], "group": []}
            };
            items.add(tempa);
          });
        } else {
          _showDialog("check the fields once.try again ${response.body}");
        }
      } catch (e) {
        _showDialog("error");
      }
    }

    await makePostRequest();
  }

// Method to show alert dialog
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

  void _showEditModal(String piid) {
    List ep = items.where((memnb) => memnb["_id"] == piid).toList();
    setState(() {
      type = '${ep[0]["workers_type"]}';
    });
    final TextEditingController _projnameeController =
        TextEditingController(text: '${ep[0]["project_name"]}');
    final TextEditingController _loccController =
        TextEditingController(text: '${ep[0]["project_location"]}');
    final TextEditingController _desccController =
        TextEditingController(text: '${ep[0]["job_description"]}');
    final TextEditingController _sallController =
        TextEditingController(text: '${ep[0]["salary"]}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit This Post',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _projnameeController,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: _loccController,
                decoration: InputDecoration(labelText: 'Project Location'),
              ),
              TextField(
                controller: _sallController,
                decoration: InputDecoration(labelText: 'Salary per Day'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _desccController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const Text(
                'Workers type',
                style: TextStyle(fontSize: 18),
              ),
              DropdownButton<String>(
                value: type,
                items:
                    <String>['Both', 'Individual', 'Group'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // Handle type filter change
                  setState(() {
                    type = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle Create Post action
                  await updateDetails(
                      piid,
                      _projnameeController.text,
                      _loccController.text,
                      _sallController.text,
                      type,
                      _desccController.text);
                },
                child: const Text('Edit Post'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 10, 3, 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  updateDetails(String postid, String name1, String loc1, String sal1,
      String type1, String desc1) async {
    List ep = items.where((memnb) => memnb["_id"] == postid).toList();
    String name11 = name1;
    String loc11 = loc1;
    String sal11 = sal1;
    String desc11 = desc1;
    String type11 = type1;
    Future<void> makePostRequest() async {
      final url =
          Uri.parse('$envUrl/contractors/contractorpostedit');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'postId': postid,
        'newPost': {
          "project_name": name11,
          "project_location": loc11,
          "salary": int.parse(sal11),
          "job_description": desc11,
          "workers_type": type11,
          "workers": ep[0]["workers"],
        }
      });

      try {
        final response = await http.put(url, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          _showDialog('Requested. Kindly wait for confirmation.');
          setState(() {
            for (var okj in items) {
              if (okj["_id"] == postid) {
                okj["project_name"] = name11;
                okj["project_location"] = loc11;
                okj["salary"] = int.parse(sal11);
                okj["job_description"] = desc11;
                okj["workers_type"] = type11;
              }
            }
          });
        } else {
          _showDialog("check the fields once.try again ${response.body}");
        }
      } catch (e) {
        _showDialog("error");
      }
    }

    await makePostRequest();
  }

  void _showCreatePostModal() {
    String hype = "Individual";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Post',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _projnameController,
                    decoration: InputDecoration(labelText: 'Project Name'),
                  ),
                  TextField(
                    controller: _locController,
                    decoration: InputDecoration(labelText: 'Project Location'),
                  ),
                  TextField(
                    controller: _salController,
                    decoration: InputDecoration(labelText: 'Salary per Day'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Workers type',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButton<String>(
                    value: hype,
                    items: <String>['Individual', 'Group', 'Both']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        hype = newValue!;
                      });
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      ////print(hype);
                      submitDetails(hype);
                    },
                    child: const Text('Create Post'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 10, 3, 0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int grpnop(int refno) {
    int ppl = 0;
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        ppl = dfg["members"].length;
      }
    }
    return ppl;
  }

  String getusername(int mbbnno) {
    String name = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        name = uu["name"];
      }
    }
    return name;
  }

  List<int> getuserppic(int mbbnno) {
    List<int> inti = [];
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        if (uu["profile_photo"]?.length == 3) {
          List hhk = uu["profile_photo"]?["file"]["data"];
          inti = hhk.map((element) => int.parse(element.toString())).toList();
        } else {
          inti = [];
        }
      }
    }
    return inti;
  }

  String getgrpname(int refno) {
    String gname = '';
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        gname = dfg["name"];
      }
    }
    return gname;
  }

  List<int> getgrppic(int refno) {
    List<int> inti = [];
    for (Map dfg in gsmm) {
      if (dfg["reference_number"] == refno) {
        if (dfg["profile_photo"]?.length == 3) {
          List hhk = dfg["profile_photo"]?["file"]["data"];
          inti = hhk.map((element) => int.parse(element.toString())).toList();
        } else {
          inti = [];
        }
      }
    }
    return inti;
  }

  List grpmems(int ref) {
    List membs = [];
    for (Map dets in gsmm) {
      if (dets["reference_number"] == ref) {
        membs = dets["members"];
      }
    }
    return membs;
  }

  String getusercity(int mbbnno) {
    String city = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        city = uu["city"];
      }
    }
    return city;
  }

  String getuserdob(int mbbnno) {
    String city = '';
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        city = uu["date_of_birth"];
      }
    }
    return city;
  }

  int calcage(String dobString) {
    int age;
    DateTime dob = DateTime.parse(dobString);
    DateTime now = DateTime.now();
    age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _showManageModal(int refano) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  '${getgrpname(refano)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: grpnop(refano), // Example item count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              getusername(int.parse(
                                  '${grpmems(refano)[index]["mobile_number"]}')),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showMemberDetails(
                                  context,
                                  getusername(int.parse(
                                      '${grpmems(refano)[index]["mobile_number"]}')),
                                  getusercity(int.parse(
                                      '${grpmems(refano)[index]["mobile_number"]}')),
                                  '${grpmems(refano)[index]["mobile_number"]}',
                                  calcage(getuserdob(int.parse(
                                      '${grpmems(refano)[index]["mobile_number"]}'))));
                            },
                            child: const Text('View'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 10, 3, 0), // Button color
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        );
      },
    );
  }

  List<int> getpropic(int mbbnno) {
    print("fn clled");
    List<int> inti = [1, 2];
    for (Map uu in usmm) {
      if (uu["mobile_number"] == mbbnno) {
        print("entering $mbbnno");
        if (uu["profile_photo"]?.length == 3) {
          List hhk = uu["profile_photo"]?["file"]["data"];
          inti = hhk.map((element) => int.parse(element.toString())).toList();
        } else {
          continue;
        }
      }
    }
    return inti;
  }

  void _showMemberDetails(BuildContext context, String name, String location,
      String mobile, int age) {
    List<int> cc = [1, 2];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: getpropic(int.parse(mobile)) == cc
                    ? NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ) as ImageProvider
                    : MemoryImage(
                        Uint8List.fromList(getpropic(int.parse(mobile)))),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age.toString()),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildManageRequests() {
    List? indreq = [];
    List? grpreq = [];
    List? indreqq = [];
    List? grpreqq = [];
    void ff() async {
      await fetchItems();
    }

    ff();
    for (Map pos in dumm) {
      for (Map? meme in pos["workers"]["applied"]["individual"]) {
        Map det = {"proj_id": pos["_id"], "memb": meme};
        indreq.add(det);
      }
    }
    for (Map pos in dumm) {
      for (Map? meme in pos["workers"]["applied"]["group"]) {
        Map det = {"proj_id": pos["_id"], "grp": meme};
        grpreq.add(det);
      }
    }
    String getgrpname(int refno) {
      String gname = '';
      for (Map dfg in gsmm) {
        if (dfg["reference_number"] == refno) {
          gname = dfg["name"];
        }
      }
      return gname;
    }

    String getgrpdesc(int refno) {
      String gname = '';
      for (Map dfg in gsmm) {
        if (dfg["reference_number"] == refno) {
          gname = dfg["description"];
        }
      }
      return gname;
    }

    int grpadn(int refno) {
      int ppl = 0;
      for (Map dfg in gsmm) {
        if (dfg["reference_number"] == refno) {
          ppl = dfg["admin"];
        }
      }
      return ppl;
    }

    indreqq = indreq;
    grpreqq = grpreq;
    String getproname(String id) {
      String dee = 'error';
      for (Map okk in dumm) {
        if (okk["_id"] == id) {
          dee = okk["project_name"];
        }
      }
      return dee;
    }

    Future<void> hiregroup(int ref_no, String postid, int indi) async {
      final url = Uri.parse('$envUrl/contractors/hiregroup');
      final url2 = Uri.parse('$envUrl/contractors/firegroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'postid': postid,
        'reference_number': ref_no,
      });

      try {
        final response = await http.put(url, headers: headers, body: data);
        //print(response.body);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);
          final response2 = await http.put(url2, headers: headers, body: data);
          //print(response2.body);
          if (response2.statusCode == 200) {
            setState(() {
              grpreq.removeAt(indi);
              //print(grpreq);
            });
          } else {
            _showDialog("some error occured in fetching ${response.body}");
          }

          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error :$e");
      }
    }

    Future<void> hireind(int mob_no, String postid, int indi) async {
      final url = Uri.parse('$envUrl/contractors/hireind');
      final url2 = Uri.parse('$envUrl/contractors/fireind');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'postid': postid,
        'mobile_number': mob_no,
      });

      try {
        final response = await http.put(url, headers: headers, body: data);
        //print(response.body);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);
          final response2 = await http.put(url2, headers: headers, body: data);
          //print(response2.body);
          if (response2.statusCode == 200) {
            setState(() {
              indreq.removeAt(indi);
              //print(indreq);
            });
          } else {
            _showDialog("some error occured in fetching ${response.body}");
          }

          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error :$e");
      }
    }

    Future<void> firegroup(int ref_no, String postid, int indi) async {
      final url2 = Uri.parse('$envUrl/contractors/firegroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'postid': postid,
        'reference_number': ref_no,
      });

      try {
        final response = await http.put(url2, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);

          setState(() {
            grpreq.removeAt(indi);
            //print(grpreq);
          });

          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error :$e");
      }
    }

    Future<void> fireind(int mob_no, String postid, int indi) async {
      final url2 = Uri.parse('$envUrl/contractors/fireind');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'postid': postid,
        'mobile_number': mob_no,
      });

      try {
        final response = await http.put(url2, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);

          setState(() {
            indreq.removeAt(indi);
            //print(indreq);
          });

          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error :$e");
      }
    }

    List<int> decider(String type, int nos) {
      List<int> inti = [];
      if (type == "Individual" && getuserppic(nos).isEmpty) {
        inti = [];
      } else if (type == "Individual" && getuserppic(nos).isNotEmpty) {
        inti = getuserppic(nos);
      } else if (type == "Group" && getgrppic(nos).isEmpty) {
        inti = [];
      } else {
        inti = getgrppic(nos);
      }
      return inti;
    }

    //print("indreq : $indreq");
    //print("grpreq : $grpreq");

    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Column(
      children: [
        DropdownButton<String>(
          value: typeie,
          items: <String>['Individual', 'Group'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              typeie = newValue!;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: typeie == "Individual"
                ? int.parse('${indreq.length}')
                : int.parse('${grpreq.length}'), // Example item count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GFCard(
                  boxFit: BoxFit.cover,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  titlePosition: GFPosition.start,
                  title: GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: typeie == "individual" &&
                              decider(typeie, int.parse('${indreq[index]["memb"]["mobile_number"]}'))
                                  .isEmpty
                          ? NetworkImage(url, scale: 10.0) as ImageProvider
                          : typeie == "individual" &&
                                  decider(
                                          typeie,
                                          int.parse(
                                              '${indreq[index]["memb"]["mobile_number"]}'))
                                      .isNotEmpty
                              ? MemoryImage(Uint8List.fromList(decider(
                                  typeie,
                                  int.parse(
                                      '${indreq[index]["memb"]["mobile_number"]}'))))
                              : typeie == "Group" &&
                                      decider(
                                              typeie,
                                              int.parse(
                                                  '${grpreq[index]["grp"]["reference_number"]}'))
                                          .isEmpty
                                  ? NetworkImage(url, scale: 10.0)
                                      as ImageProvider
                                  : MemoryImage(Uint8List.fromList(decider(
                                      typeie,
                                      int.parse('${grpreq[index]["grp"]["reference_number"]}')))),
                    ),
                    title: Text(
                      typeie == "Individual"
                          ? getproname('${indreq[index]["proj_id"]}')
                          : getproname('${grpreq[index]["proj_id"]}'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: typeie == "Group"
                        ? [
                            ListTile(
                              leading: Icon(Icons.people_outline),
                              title: Text(
                                  '${getgrpname(int.parse('${grpreq[index]["grp"]["reference_number"]}'))}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.numbers),
                              title: Text(
                                  '${grpnop(int.parse('${grpreq[index]["grp"]["reference_number"]}'))}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.note),
                              title: Text(
                                  '${getgrpdesc(int.parse('${grpreq[index]["grp"]["reference_number"]}'))}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.man),
                              title: Text(
                                  '${grpadn(int.parse('${grpreq[index]["grp"]["reference_number"]}'))}'),
                            ),
                          ]
                        : [
                            ListTile(
                              leading: Icon(Icons.man_2_outlined),
                              title: Text(
                                  '${getusername(int.parse('${indreq[index]["memb"]["mobile_number"]}'))}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: Text(
                                  '${indreq[index]["memb"]["mobile_number"]}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.star_border_outlined),
                              title: Text('Rating'),
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text(
                                  '${getusercity(int.parse('${indreq[index]["memb"]["mobile_number"]}'))}'),
                            ),
                          ],
                  ),
                  buttonBar: GFButtonBar(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () async {
                              // Handle Delete action
                              typeie == "Group"
                                  ? await firegroup(
                                      int.parse(
                                          '${grpreq[index]["grp"]["reference_number"]}'),
                                      '${grpreq[index]["proj_id"]}',
                                      index)
                                  : await fireind(
                                      int.parse(
                                          '${indreq[index]["memb"]["mobile_number"]}'),
                                      '${indreq[index]["proj_id"]}',
                                      index);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          typeie == "Group"
                              ? ElevatedButton(
                                  onPressed: () {
                                    //_showMemberDetails(context, 'Member Name ${index + 1}', 'Bengal', '9080677795', '23');
                                    typeie == "Group"
                                        ? _showManageModal(int.parse(
                                            '${grpreq[index]["grp"]["reference_number"]}'))
                                        : _showMemberDetails(
                                            context,
                                            "ali",
                                            "chennai",
                                            "908065439",
                                            int.parse("44"));
                                  },
                                  child: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 10, 3, 0), // Button color
                                  ),
                                )
                              : const SizedBox(
                                  width: 1.0,
                                ),
                          IconButton(
                            onPressed: () async {
                              // Handle Accept action
                              typeie == "Group"
                                  ? await hiregroup(
                                      int.parse(
                                          '${grpreq[index]["grp"]["reference_number"]}'),
                                      '${grpreq[index]["proj_id"]}',
                                      index)
                                  : await hireind(
                                      int.parse(
                                          '${indreq[index]["memb"]["mobile_number"]}'),
                                      '${indreq[index]["proj_id"]}',
                                      index);
                            },
                            icon: const Icon(
                                Icons.check_circle), // Replaced with tick icon
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contractor Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? Column(
              children: [
                items.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: int.parse(
                              '${items.length}'), // Example item count
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GFCard(
                                boxFit: BoxFit.cover,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                titlePosition: GFPosition.start,
                                title: GFListTile(
                                  avatar: GFAvatar(
                                    backgroundImage:
                                        items[index]["profile_photo"] == "nil"
                                            ? NetworkImage(url, scale: 10.0)
                                                as ImageProvider
                                            : MemoryImage(Uint8List.fromList(
                                                items[index]["profile_photo"])),
                                  ),
                                  title: Text(
                                    '${items[index]["project_name"]}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '${items[index]["job_description"]}',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                buttonBar: GFButtonBar(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            await fetchItems();
                                            _showEditModal(
                                                '${items[index]["_id"]}');
                                          },
                                          child: const Text('EDIT'),
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color.fromARGB(
                                                255, 10, 3, 0), // Button color
                                          ),
                                        ),
                                        (items[index]["workers"]["current"]
                                                                ["individual"]
                                                            .length +
                                                        items[index]["workers"]
                                                                    ["current"]
                                                                ["individual"]
                                                            .length ==
                                                    0 &&
                                                items[index]["workers"]
                                                                    ["completed"]
                                                                ["individual"]
                                                            .length +
                                                        items[index]["workers"]
                                                                    ["completed"]
                                                                ["individual"]
                                                            .length ==
                                                    0)
                                            ? IconButton(
                                                onPressed: () {
                                                  // Handle Delete action
                                                },
                                                icon: const Icon(Icons.delete),
                                                color: Colors.red,
                                              )
                                            : const SizedBox(width: 1.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            )
          : _selectedIndex == 2
              ? _buildManageRequests()
              : _ManageWorkersContent(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showCreatePostModal,
              child: const Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 10, 3, 0),
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Manage Workers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Manage Requests',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}

class Groupsfave extends StatefulWidget {
  const Groupsfave({super.key});

  @override
  State<Groupsfave> createState() => _GroupsfaveState();
}

class _GroupsfaveState extends State<Groupsfave> {
  List<dynamic> groupss = [];
  List<dynamic> dumm = [];
  List<dynamic> dummems = [];
  List<dynamic> aumm = [];
  List<dynamic> dumma = [];
  List fumm = [];
  final TextEditingController _groupnameController = TextEditingController();
  final TextEditingController _groupsizeController = TextEditingController();
  final TextEditingController _groupdescController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _gncontroller = TextEditingController();
  final TextEditingController _gdcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchog(); // Fetch data on init
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/membergroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        dumm = json.decode(response.body);
        //print("dumm: $dumm");
        //dumm = dumm[0]["members"]; // Parse JSON data into the list
      });
      //groupss = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchfavs() async {
    final response = await http.get(Uri.parse(
        '$envUrl/workers/favgroups')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        fumm = json.decode(response.body);
        //print("fumm: $fumm");
        //dumm = dumm[0]["members"]; // Parse JSON data into the list
      });
      //groupss = fumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchog() async {
    await fetchItems();
    await fetchfavs();
    for (Map i in fumm[0]["favourites"]) {
      for (Map k in dumm) {
        if (k["reference_number"] == i["reference_number"]) {
          groupss.add(k);
        }
      }
    }
  }

  void dispose() {
    _groupnameController.dispose();
    _groupsizeController.dispose();
    _groupdescController.dispose();
    _refController.dispose();
    _addController.dispose();
    _gncontroller.dispose();
    _gdcontroller.dispose();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail'),
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

  void submitDetails() async {
    String name1 = _groupnameController.text;
    String desc1 = _groupdescController.text;
    String size1 = max_size;
    Future<void> makePostRequest() async {
      final url = Uri.parse('$envUrl/groups/creategroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'name': name1,
        'size': size1,
        'description': desc1,
        'admin': 7907666366,
        'members': [
          {"mobile_number": 7907666366}
        ],
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          _showDialog('Requested. Kindly wait for confirmation.');
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("check the fields once.try again ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makePostRequest();
  }

  Future<void> submitmobnumber(String mmb, String gd) async {
    final url = Uri.parse('$envUrl/groups/addmgroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({'mobile_number': int.parse(mmb), 'group_id': gd});

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        _showDialog('Requested. Kindly wait for confirmation.');
        setState(() {
          for (var obn in dumm) {
            if (obn["_id"] == gd) {
              obn["members"].add({"mobile_number": int.parse(mmb)});
            }
          }
        });
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("check the fields once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  void _showManageModal(String groupName, int index) async {
    Future<void> makeadminRequest() async {
      List memlist = groupss[index]["members"];
      List<int> mobileNumbers =
          memlist.map((member) => member['mobile_number'] as int).toList();
      final url = Uri.parse('$envUrl/workers/getallmembers');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'members': mobileNumbers,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print(dummems);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makeadminRequest();
    Future<void> makePostRequest() async {
      List memlist = groupss[index]["members"];
      List<int> mobileNumbers =
          memlist.map((member) => member['mobile_number'] as int).toList();
      final url = Uri.parse('$envUrl/workers/getallmembers');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'members': mobileNumbers,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print("dummems:${dummems}");
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makePostRequest();
    Future<void> fetchadmins() async {
      final response = await http.get(Uri.parse(
          '$envUrl/groups/getadmin')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          aumm = json.decode(response.body);
          //dumm = dumm[0]["posts"]; // Parse JSON data into the list
          //print("admin: ${aumm}");
        });
        //items = dumm;
        ////print(items);
      } else {
        // If the server doesn't return a 200 response
        throw Exception('Failed to load items ${response.body}');
      }
    }

    await fetchadmins();
    Future<void> makedeleteRequest(String mbno) async {
      //print(mbno);
      //print(dumm[index]);
      final url = Uri.parse('$envUrl/groups/deletemember');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'mobile_number': int.parse(mbno),
        'group': {"_id": groupss[index]["_id"]},
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          //dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          setState(() {
            //List ogg=[];
            for (var ll in dumm) {
              //List emm=[];
              List ds = ll["members"];
              List ls = ds
                  .where((member) => member["mobile_number"] != int.parse(mbno))
                  .toList();
              ll["members"] = ls;
            }
            //dumm["members"]=emm;
            //print('${dumm}');
          });
          //print('deleted');
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    bool checkifadmin(String id) {
      bool chk = false;
      for (var obj in aumm) {
        if (obj["_id"] == id) {
          chk = true;
        }
      }
      return chk;
    }

    int getadminnumber(String gid) {
      return int.parse('${groupss[index]["admin"]}');
    }

    Future<void> makegroupchange(
        int ref_no, String groupname, String groupdesc) async {
      final url = Uri.parse('$envUrl/groups/changegroup');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'reference_number': ref_no,
        'group_name': groupname,
        'group_desc': groupdesc
      });

      try {
        final response = await http.put(url, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          //dumma = jsonDecode(response.body);
          _showDialog('Requested. Kindly wait for confirmation.');
          ////print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    void _showEditModal(int idx) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EDIT GROUP DETAILS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Upload Group Image:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // File picker button for image upload
                ElevatedButton(
                  onPressed: () async {
                    // Use file_picker to allow image selection
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image, // Only allow image files
                    );

                    if (result != null) {
                      // Use the file path or bytes as needed
                      String filePath = result.files.single.path ?? "";
                      // You can also use Image.memory to display the image using file bytes
                      //print("Selected file path: $filePath");
                    } else {
                      // User canceled the picker
                      //print("No image selected");
                    }
                  },
                  child: Text('Upload Image'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Group Name'),
                  controller: _gncontroller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Group Description'),
                  controller: _gdcontroller,
                ),

                ElevatedButton(
                  onPressed: () async {
                    // Handle Create Post action
                    await makegroupchange(
                        int.parse('${groupss[idx]["reference_number"]}'),
                        _gncontroller.text,
                        _gdcontroller.text);
                    setState(() {
                      dumm[idx]["name"] = _gncontroller.text;
                      dumm[idx]["description"] = _gdcontroller.text;
                    });
                  },
                  child: const Text('save changes'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 10, 3, 0),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      int.parse('${dummems.length}'), // Example item count
                  itemBuilder: (context, indexx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: dummems[indexx]["profile_photo"]
                                        .length !=
                                    3
                                ? NetworkImage(
                                    'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                    scale: 10.0) as ImageProvider
                                : MemoryImage(Uint8List.fromList(coving(
                                    dummems[indexx]["profile_photo"]["file"]
                                        ["data"]))),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              '${dummems[indexx]["name"]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              String dobString =
                                  '${dummems[indexx]["date_of_birth"]}';
                              DateTime dob = DateTime.parse(dobString);
                              DateTime now = DateTime.now();
                              int age = now.year - dob.year;
                              if (now.month < dob.month ||
                                  (now.month == dob.month &&
                                      now.day < dob.day)) {
                                age--;
                              }
                              //print(age);
                              _showMemberDetails(
                                  context,
                                  '${dummems[indexx]["name"]}',
                                  '${dummems[indexx]["city"]}',
                                  ('${dummems[indexx]["mobile_number"]}')
                                      .toString(),
                                  age.toString(),
                                  groupss[index]["reference_number"],
                                  index,
                                  indexx,
                                  dummems[indexx]["profile_photo"]?.length);
                            },
                            child: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 10, 3, 0), // Button color
                            ),
                          ),
                          (aumm.length > 0 &&
                                  checkifadmin('${groupss[index]["_id"]}') &&
                                  getadminnumber('${groupss[index]["_id"]}') !=
                                      int.parse(
                                          '${dummems[indexx]["mobile_number"]}'))
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    // Handle Delete Member action
                                    //print("pressed");
                                    await makedeleteRequest(
                                        '${dummems[indexx]["mobile_number"]}');
                                    //Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                )
                              : SizedBox(width: 1.0),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              aumm.length > 0 && checkifadmin('${groupss[index]["_id"]}')
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle Add Member action
                            _addmemberGroupModal(
                                context, '${groupss[index]["_id"]}');
                          },
                          child: const Text('Add Member'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle Add Member action
                            _showEditModal(index);
                          },
                          child: const Text('Edit Group'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showDialog('${groupss[index]["reference_number"]}'
                                .toString());
                          },
                          child: const Text('Invite ID'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 10, 3, 0), // Button color
                          ),
                        ),
                      ],
                    )
                  : SizedBox(width: 1.0),
            ],
          ),
        );
      },
    );
  }

  void _showMemberDetails(
      BuildContext context,
      String name,
      String location,
      String mobile,
      String age,
      int ref_no,
      int indexc,
      int ogindd,
      int plength) {
    int getadminnumber(int ind) {
      return int.parse('${groupss[ind]["admin"]}');
    }

    Future<void> makeadminchange() async {
      final url = Uri.parse('$envUrl/groups/changeadmin');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'reference_number': ref_no,
        'mobile_number': int.parse(mobile),
      });

      try {
        final response = await http.put(url, headers: headers, body: data);

        if (response.statusCode == 200) {
          // Success response
          dumma = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print(dumma);
        } else {
          // Failure response
          ////print(response.body);

          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: plength != 3
                    ? NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ) as ImageProvider
                    : MemoryImage(Uint8List.fromList(coving(
                        dummems[ogindd]["profile_photo"]["file"]["data"]))),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age),
                ],
              ),
            ],
          ),
          actions: [
            getadminnumber(indexc) != int.parse(mobile)
                ? TextButton(
                    onPressed: () async {
                      await makeadminchange();
                      Navigator.of(context).pop();
                    },
                    child: const Text('make admin'),
                  )
                : const SizedBox(width: 1.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String max_size = '20';
  void _showAddGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal occupy 60-70% of the screen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the modal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _groupnameController,
                decoration: InputDecoration(labelText: 'Group Name'),
              ),
              // Label for the image upload
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Upload Group Image:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // File picker button for image upload
              ElevatedButton(
                onPressed: () async {
                  // Use file_picker to allow image selection
                  //logic for group create
                },
                child: Text('Upload Image'),
              ),
              DropdownButtonFormField<String>(
                value: max_size,
                items: <String>['20', '30', '40', '50'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    max_size = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Group Size'),
              ),
              TextField(
                controller: _groupdescController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitDetails();
                },
                child: Text('Create Group'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addmemberGroupModal(BuildContext context, String grid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal occupy 60-70% of the screen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the modal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _addController,
                decoration: InputDecoration(
                  labelText:
                      'Enter Mobile Number', // Prompt for reference number
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitmobnumber(_addController.text, grid);
                  ////print("Group joined!");
                  //Navigator.pop(context); // Close the modal after submit
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 10, 3, 0), // Button color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> makedeleteRequest(String mbno, int inkex) async {
    //rint(mbno);
    //int(dumm[index]);
    final url = Uri.parse('$envUrl/groups/deletemember');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'mobile_number': int.parse(mbno),
      'group': {"_id": dumm[inkex]["_id"]},
    });

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //dummems = jsonDecode(response.body);
        //_showDialog('Requested. Kindly wait for confirmation.');
        _showDialog("left the group");
        ////print('deleted');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> makeadminchange(int ref_no, String mobile) async {
    final url = Uri.parse('$envUrl/groups/changeadmin');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'reference_number': ref_no,
      'mobile_number': int.parse(mobile),
    });

    try {
      final response = await http.put(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('Requested. Kindly wait for confirmation.');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> makedeletegroup(int ref_no) async {
    final url = Uri.parse('$envUrl/groups/deletegroup');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      'reference_number': ref_no,
    });

    try {
      final response = await http.delete(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //dumma = jsonDecode(response.body);
        _showDialog('deleted the group');
        ////print(dumma);
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("some error occured in fetching ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  Future<void> makefavouriteRequest(int ref_noo, String param) async {
    final url = Uri.parse('$envUrl/workers/createfavourite');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      "type": param,
      "reference_number": ref_noo,
    });

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
        //_showDialog('Requested. Kindly wait for confirmation.');
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
        _showDialog("check the fields once.try again ${response.body}");
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  String filt_size = 'any';
  List<int> coving(List a) {
    List<int> inti = a.map((element) => int.parse(element.toString())).toList();
    return inti;
  }

  @override
  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CurrentJobPage(
                                title: 1,
                              )),
                    )
                  },
                  child: const Text('Add favourites'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        const Color.fromARGB(255, 10, 3, 0), // Button color
                  ),
                ),
                DropdownButton<String>(
                  value: filt_size,
                  items: <String>['any', '20', '30', '40', '50']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      filt_size = newValue!;
                      if (filt_size == 'any') {
                        groupss = dumm;
                      } else {
                        groupss = dumm
                            .where((group) =>
                                group["size"] == int.parse('${filt_size}'))
                            .toList();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: groupss.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount:
                        int.parse('${groupss.length}'), // Example item count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GFCard(
                          boxFit: BoxFit.cover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePosition: GFPosition.start,
                          title: GFListTile(
                            avatar: GFAvatar(
                              backgroundImage:
                                  groupss[index]["profile_photo"].length != 3
                                      ? NetworkImage(url, scale: 10.0)
                                          as ImageProvider
                                      : MemoryImage(Uint8List.fromList(coving(
                                          groupss[index]["profile_photo"]
                                              ["file"]["data"]))),
                            ),
                            title: Text(
                              '${groupss[index]["name"]}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${groupss[index]["description"]}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GFButton(
                                      onPressed: () {
                                        _showManageModal(
                                            "${groupss[index]["name"]}", index);
                                      },
                                      text: "Manage",
                                      color:
                                          const Color.fromARGB(255, 10, 3, 0),
                                    ),
                                    GFIconButton(
                                      onPressed: () async {
                                        // Handle Favorite action

                                        await makefavouriteRequest(
                                            int.parse(
                                                "${groupss[index]["reference_number"]}"),
                                            "remove");
                                        setState(() {
                                          groupss = groupss
                                              .where((gps) =>
                                                  gps["reference_number"] !=
                                                  int.parse(
                                                      "${groupss[index]["reference_number"]}"))
                                              .toList();
                                        });
                                      },
                                      icon: Icon(Icons.favorite),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Contsfave extends StatefulWidget {
  const Contsfave({super.key});

  @override
  State<Contsfave> createState() => _ContsfaveState();
}

class _ContsfaveState extends State<Contsfave> {
  List<dynamic> groupss = [];
  List<dynamic> dumm = [];
  List<dynamic> dummems = [];
  List<dynamic> aumm = [];
  List<dynamic> dumma = [];
  List fumm = [];
  final TextEditingController _groupnameController = TextEditingController();
  final TextEditingController _groupsizeController = TextEditingController();
  final TextEditingController _groupdescController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _gncontroller = TextEditingController();
  final TextEditingController _gdcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchog(); // Fetch data on init
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse(
        '$envUrl/groups/allgroupss')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        dumm = json.decode(response.body);
        //print("dumm: $dumm");
        //dumm = dumm[0]["members"]; // Parse JSON data into the list
      });
      //groupss = dumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchfavs() async {
    final response = await http.get(Uri.parse(
        '$envUrl/contractors/favgroupscon')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      // If the server returns a successful response
      setState(() {
        fumm = json.decode(response.body);
        //print("fumm: $fumm");
        //dumm = dumm[0]["members"]; // Parse JSON data into the list
      });
      //groupss = fumm;
      ////print(items);
    } else {
      // If the server doesn't return a 200 response
      throw Exception('Failed to load items ${response.body}');
    }
  }

  Future<void> fetchog() async {
    await fetchItems();
    await fetchfavs();
    for (Map i in fumm[0]["favourites"]) {
      for (Map k in dumm) {
        if (k["reference_number"] == i["reference_number"]) {
          groupss.add(k);
        }
      }
    }
  }

  void dispose() {
    _groupnameController.dispose();
    _groupsizeController.dispose();
    _groupdescController.dispose();
    _refController.dispose();
    _addController.dispose();
    _gncontroller.dispose();
    _gdcontroller.dispose();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail'),
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

  void _showManageModal(String groupName, int index) async {
    Future<void> makeadminRequest() async {
      List memlist = groupss[index]["members"];
      List<int> mobileNumbers =
          memlist.map((member) => member['mobile_number'] as int).toList();
      final url = Uri.parse('$envUrl/workers/getallmembers');
      final headers = {"Content-Type": "application/json"};
      final data = jsonEncode({
        'members': mobileNumbers,
      });

      try {
        final response = await http.post(url, headers: headers, body: data);

        if (response.statusCode == 201) {
          // Success response
          dummems = jsonDecode(response.body);
          //_showDialog('Requested. Kindly wait for confirmation.');
          //print(dummems);
        } else {
          // Failure response
          ////print(response.body);
          ////print(resp["error"]["errors"]);
          //final ers = resp as List;
          //for (var error in ers) {
          ////print(error['field']);
          ////print(error['message']);
          //}

          ////print(ar.)
          //final asd=JsonDecoder(response.body);
          //final ss=asd["error"];
          _showDialog("some error occured in fetching ${response.body}");
        }
      } catch (e) {
        // Catch network or other errors
        //String s = e.toString();
        _showDialog("error");
      }
    }

    await makeadminRequest();
    List<int> coving(List a) {
      List<int> inti =
          a.map((element) => int.parse(element.toString())).toList();
      return inti;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 78.0),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      int.parse('${dummems.length}'), // Example item count
                  itemBuilder: (context, indexx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                dummems[indexx]["profile_photo"].length != 3
                                    ? NetworkImage(
                                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                      ) as ImageProvider
                                    : MemoryImage(Uint8List.fromList(coving(
                                        dummems[indexx]["profile_photo"]["file"]
                                            ["data"]))),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              '${dummems[indexx]["name"]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              String dobString =
                                  '${dummems[indexx]["date_of_birth"]}';
                              DateTime dob = DateTime.parse(dobString);
                              DateTime now = DateTime.now();
                              int age = now.year - dob.year;
                              if (now.month < dob.month ||
                                  (now.month == dob.month &&
                                      now.day < dob.day)) {
                                age--;
                              }
                              //print(age);
                              _showMemberDetails(
                                  context,
                                  '${dummems[indexx]["name"]}',
                                  '${dummems[indexx]["city"]}',
                                  ('${dummems[indexx]["mobile_number"]}')
                                      .toString(),
                                  age.toString(),
                                  groupss[index]["reference_number"],
                                  indexx,
                                  dummems[indexx]["profile_photo"]?.length);
                            },
                            child: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 10, 3, 0), // Button color
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMemberDetails(BuildContext context, String name, String location,
      String mobile, String age, int ref_no, int indexc, int plength) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: plength == 3
                    ? MemoryImage(Uint8List.fromList(coving(
                        dummems[indexc]["profile_photo"]["file"]["data"])))
                    : NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ) as ImageProvider,
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(mobile),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.cake),
                  const SizedBox(width: 8.0),
                  Text(age),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String max_size = '20';

  Future<void> makefavouriteRequest(int ref_noo, String param) async {
    final url =
        Uri.parse('$envUrl/contractors/contractorfavourite');
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({
      "type": param,
      "reference_number": ref_noo,
    });

    try {
      final response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        // Success response
      } else {
        // Failure response
        ////print(response.body);

        ////print(resp["error"]["errors"]);
        //final ers = resp as List;
        //for (var error in ers) {
        ////print(error['field']);
        ////print(error['message']);
        //}

        ////print(ar.)
        //final asd=JsonDecoder(response.body);
        //final ss=asd["error"];
      }
    } catch (e) {
      // Catch network or other errors
      //String s = e.toString();
      _showDialog("error");
    }
  }

  String filt_size = 'any';
  List<int> coving(List a) {
    List<int> inti = a.map((element) => int.parse(element.toString())).toList();
    return inti;
  }

  @override
  @override
  Widget build(BuildContext context) {
    const url =
        "https://static.vecteezy.com/system/resources/previews/002/534/006/original/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg";

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const _ManageWorkersContent())),
                  },
                  child: const Text('Add favourites'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        const Color.fromARGB(255, 10, 3, 0), // Button color
                  ),
                ),
                DropdownButton<String>(
                  value: filt_size,
                  items: <String>['any', '20', '30', '40', '50']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      filt_size = newValue!;
                      if (filt_size == 'any') {
                        groupss = dumm;
                      } else {
                        groupss = dumm
                            .where((group) =>
                                group["size"] == int.parse('${filt_size}'))
                            .toList();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: groupss.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount:
                        int.parse('${groupss.length}'), // Example item count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GFCard(
                          boxFit: BoxFit.cover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePosition: GFPosition.start,
                          title: GFListTile(
                            avatar: GFAvatar(
                              backgroundImage:
                                  groupss[index]["profile_photo"].length != 3
                                      ? NetworkImage(url, scale: 10.0)
                                          as ImageProvider
                                      : MemoryImage(Uint8List.fromList(coving(
                                          groupss[index]["profile_photo"]
                                              ["file"]["data"]))),
                            ),
                            title: Text(
                              '${groupss[index]["name"]}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${groupss[index]["description"]}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GFButton(
                                      onPressed: () {
                                        _showManageModal(
                                            "${groupss[index]["name"]}", index);
                                      },
                                      text: "View Members",
                                      color:
                                          const Color.fromARGB(255, 10, 3, 0),
                                    ),
                                    GFIconButton(
                                      onPressed: () async {
                                        // Handle Favorite action

                                        await makefavouriteRequest(
                                            int.parse(
                                                "${groupss[index]["reference_number"]}"),
                                            "remove");
                                        setState(() {
                                          groupss = groupss
                                              .where((gps) =>
                                                  gps["reference_number"] !=
                                                  int.parse(
                                                      "${groupss[index]["reference_number"]}"))
                                              .toList();
                                        });
                                      },
                                      icon: Icon(Icons.favorite),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
*/
