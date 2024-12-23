import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexstream/presentation/admin_page/admin_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'presentation/utils/theme_service.dart';
import 'presentation/auth_screens/service/auth_service.dart';
import 'routes/app_routes.dart';
import 'presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyA-SV4Ie1rufX9bLpQTNlbC6a5nHZmJNKs',
          appId: '1:871004067694:android:03c9ea1b5d406e5cae537f',
          messagingSenderId: '871004067694',
          projectId: 'nexstream-e0c0d'));

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Nexstream',
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
