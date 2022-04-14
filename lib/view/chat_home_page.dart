import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:provider_and_firebase/view/let_us_chat.dart';
import '../model/state_of_application.dart';
import '../controller/authenticate_to_firebase.dart';
import '../controller/all_widgets.dart';

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Firebase Chatting'),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(
              'https://cdn.pixabay.com/photo/2022/04/07/11/45/bird-7117346_960_720.jpg'),
          const SizedBox(height: 8),
          Consumer<StateOfApplication>(
            builder: (context, appState, _) => AuthenticationForFirebase(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Let's Chat for a While"),
          const Paragraph(
            'Join your friends and chat for a while!',
          ),
          Consumer<StateOfApplication>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == UserStatus.loggedIn) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LetUsChat(
                            addMessage: (message) =>
                                appState.addMessageToChatBook(message),
                            messages: appState.chatBookMessages,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Let\'s Chat',
                      style: GoogleFonts.laila(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
