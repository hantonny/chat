import 'dart:io';

import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/auth_or_app_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
            iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                    iconColor: MaterialStateProperty.all(Colors.white)))),
        home: const AuthOrAppPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
