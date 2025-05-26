import 'package:doclense/constants/theme_constants.dart';
// import 'package:doclense/env.dart'; // Não mais necessário após remoção do Wiredash
import 'package:doclense/screens/intro_screen.dart';
import 'package:doclense/models/preferences.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:doclense/services/route_page.dart' as route_page;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';
// import 'package:wiredash/wiredash.dart'; // Comentado temporariamente

import 'configs/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Getting the documents directory to store the HiveDB instance
  final directory = await path.getApplicationDocumentsDirectory();

  // Initializing the HiveDB
  Hive.init(directory.path);

  await Hive.openBox('pdfs');
  await Hive.openBox('starred');
  Hive.registerAdapter(UserPreferencesAdapter());
  final res = await Hive.openBox('preferences');
  try {
    res.getAt(0) as UserPreferences;
  } catch (e) {
    print('Exception');
    res.add(UserPreferences(firstTime: true, darkTheme: false));
  }

  try {
    Hive.box('pdfs').getAt(0);
  } catch (e) {
    Hive.box('pdfs').add([]);
  }

  try {
    Hive.box('starred').getAt(0);
  } catch (e) {
    Hive.box('starred').add([]);
  }

  final r = res.getAt(0) as UserPreferences;
  print("First Time : ${r.firstTime}");

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void dispose() {
    Hive.box('preferences').close();
    Hive.box('pdfs').close();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return GestureDetector(
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: (themeChangeProvider.darkTheme == true)
                ? darkTheme
                : lightTheme,
            home: IntoScreen(),
            builder: (context, child) {
              App.init(context);
              return child ?? Scaffold();
            },
            onGenerateRoute: route_page.generateRoute,
          ),
        );
      },
    ));
  }
}
