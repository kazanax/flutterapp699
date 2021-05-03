import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Quote {
  final quote;

  Quote({@required this.quote});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String cytat = 'Miejsce na mądry cytat znanego rapera';
  bool isLoading = false;

  Future<Quote> getWestQuote() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get('https://api.kanye.rest/');

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      return Quote.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to download quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('randomowe cytaty kanye westa'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        cytat,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          getWestQuote().then((quote) => cytat = quote.quote);
                        },
                        child: Text('Get west quote'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
