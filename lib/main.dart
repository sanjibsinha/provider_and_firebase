import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/state_of_application.dart';

import 'view/chat_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateOfApplication(),
      builder: (context, _) => const ChatApp(),
    ),
  );
}
// 