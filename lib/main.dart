import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/focus_home_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/todo_tasks.dart';
import 'screens/pomodoro_timer.dart';
import 'screens/select_apps_screen.dart';
import 'screens/select_contacts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/home': (context) => const FocusHomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/tasks': (context) => const TodoTasksScreen(),
        '/pomodoro': (context) => const PomodoroTimer(),
        '/select_apps': (context) => const SelectAppsScreen(),
        '/select_contacts': (context) => const SelectContactsScreen(),
      },
    );
  }   
}        