import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'chat_home_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Firebase Chatting',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.black45,
            ),
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatHomePage(),
    );
  }
}
