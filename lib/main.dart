import 'dart:convert';

import 'package:backdrop/backdrop.dart';
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

// class CurrencyRepository {
//   final client = Client();
//   final baseUrl =
//       'https://api.metalpriceapi.com/v1/latest?api_key=5cd53bd36052db79255652503c7325f7&base=INR&currencies=XAU,XAG,XPT';

//   Future<Map<String, dynamic>> getCurrencySymbols() async {
//     final response = await client.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       Map<String, dynamic> data = json['rates'];
//       print(data);
//       return data;
//     } else {
//       throw Exception('Faileddddd');
//     }
//   }
// }

// Map<String, dynamic> selectedValue = {};
// Future<Map<String, dynamic>> getCurrencies() async {
//   try {
//     Map<String, dynamic> currency =
//         await CurrencyRepository().getCurrencySymbols();
//     if (currency.isNotEmpty) {
//       setState(() => selectedValue = currency);
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Something wents wrong')));
//     }
//     return currency;
//   } catch (_) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('No internet connection')));
//     rethrow;
//   }
// }

void setState(Map<String, dynamic> Function() param0) {}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final client = Client();
  // final baseUrl =
  //     'https://clubits-hrms-demo.azurewebsites.net/trpc/user.signIn';
  // Future<Map<String, dynamic>> login() async {
  //   final response = await client.post(
  //     Uri.parse(baseUrl),
  //     body: jsonEncode({"username": "balaji", "password": "balaji"}),
  //   );
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     Map<String, dynamic> data = json['json'];
  //     print(data);
  //     return data;
  //   } else {
  //     throw Exception('Faileddddd');
  //   }
  // }

  Future<Map<String, dynamic>> login() async {
    Map<String, dynamic> users;
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final Map<String, dynamic> data = {
      "json": {"username": username, "password": password}
    };
    var headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
        Uri.parse(
            'https://clubits-hrms-demo.azurewebsites.net/trpc/user.signIn'),
        headers: headers,
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      users = responseData["result"];
      print("Login successful");
      print("Data : " + users.toString());
    } else {
      throw Exception('Failed.');
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'username'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 32.0),
          GestureDetector(
            onTap: () {
              login();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text("login"),
          )
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
//import 'dart:convert';
//import 'package:http/http.dart' as http;

//import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? users;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<String> fetch() async {
    final data = {
      "category": "movies",
      "language": "kannada",
      "genre": "all",
      "sort": "voting"
    };
    var headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
        Uri.parse('https://hoblist.com/api/movieList'),
        headers: headers,
        body: jsonEncode(data));
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      users = responseData["result"];
      print("Data : " + users.toString());
    } else {
      throw Exception('Failed.');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
      ),
      headerHeight: 400,
      frontLayer: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
            future: fetch(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: users!.length,
                  itemBuilder: (BuildContext context, int i) {
                    final user = users![i];
                    final genre = user!['genre'];
                    final director = user!['director'];
                    final title = user!['title'];
                    final poster = user!['poster'];
                    final stars = user!['stars'];
                    final language = user!['language'];
                    final releasedDate = user!['releasedDate'];
                    final pageViews = user!['pageViews'];
                    final totalVoted = user!['totalVoted'];
                    final voting = user!['voting'];
                    double width = MediaQuery.of(context).size.width / 1.9;
                    return Container(
                      // width: width,
                      child: Column(children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up,
                                      size: 50,
                                    ),
                                    Text(
                                      voting.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 50,
                                    ),
                                    Text('Votes')
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 120,
                                    width: 75,
                                    child: Image.network(poster)),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Genre: ' + genre),
                                      Text('Director: ' + director.toString()),
                                      Text('Starring: ' + stars.toString()),
                                      Text('Mins | ' +
                                          language +
                                          ' | ' +
                                          releasedDate.toString()),
                                      Text(
                                        pageViews.toString() +
                                            ' Views | Voted by ' +
                                            totalVoted.toString() +
                                            ' People',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(300, 40)),
                            child: Text('Watch Trailer')),
                        SizedBox(
                          height: 10,
                        )
                      ]),
                    );
                  },
                );
              } else {
                return Container(
                    child: Center(
                  child: Text('Failed'),
                ));
              }
            }),
      ),
      backLayer: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Company: Geeksynergy Technologies Pvt Ltd',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Address: Sanjayanagar, Bengaluru-56',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Phone: XXXXXXXXX09',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Email: XXXXXX@gmail.com',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
