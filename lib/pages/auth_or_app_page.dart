// ignore_for_file: use_build_context_synchronously

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth.service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'AIzaSyCwMyGcxE2sTVszpkK4UU6tsGALieRTMc4',
              appId: '1:522022005069:android:10a80c76924dae73876f04',
              messagingSenderId: '522022005069',
              projectId: 'chat0-8942b',
            ),
          )
        : await Firebase.initializeApp();
    await Provider.of<ChatNotificationService>(
      context,
      listen: false,
    ).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return StreamBuilder<ChatUser?>(
              stream: AuthService().userChanges,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else {
                  return snapshot.hasData ? const ChatPage() : const AuthPage();
                }
              },
            );
          }
        });
  }
}
