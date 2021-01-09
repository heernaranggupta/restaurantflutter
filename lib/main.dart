import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Screens/s_add_items.dart';
import 'package:orderingsystem/Screens/s_edit.dart';
import 'package:orderingsystem/Screens/s_home.dart';
import 'package:provider/provider.dart';

import './constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().catchError((error) {
    print('------------');
    print(error);
    print('------------');
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FoodItem(),
      child: MaterialApp(
        title: 'Foodito',
        home: SHome(),
        theme: ThemeData(
          primaryColor: fontColor,
          fontFamily: 'Roboto',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: fontColor,
          ),
          appBarTheme: AppBarTheme(
            color: appColor,
            iconTheme: IconThemeData(
              color: fontColor,
            ),
          ),
          scaffoldBackgroundColor: appColor,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) {
          String foodId = settings.arguments;
          switch (settings.name) {
            case SAddItems.routeName:
              return CupertinoPageRoute(builder: (_) => SAddItems());
            case SHome.routeName:
              return CupertinoPageRoute(builder: (_) => SHome());
            case SEditItems.routeName:
              return CupertinoPageRoute(
                  builder: (_) => SEditItems(foodId: foodId));
          }
        },
      ),
    );
  }
}
