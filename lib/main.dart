import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './constants.dart';
import './widgets/speciality_item.dart';
import './widgets/other_food_items.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodito',
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        iconTheme: IconThemeData(
          color: Color(0xff1c2843),
        ),
        scaffoldBackgroundColor: appColor,
        appBarTheme: AppBarTheme(
          color: appColor,
          iconTheme: IconThemeData(
            color: Color(0xff1c2843),
          ),
          
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SizedBox buildSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.03);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Foodito',
            style: TextStyle(color: Color(0xff1c2843), fontSize: 30),
          ),
          actions: [
            GestureDetector(
                child: Icon(Icons.fastfood_sharp),
                onTap: () {
                  if (isMenuScreen == false) {
                    setState(() {
                      isMenuScreen = true;
                      isEditScreen = false;
                    });
                  }
                }),
            buildSizedBox(mediaQuery),
            GestureDetector(child: Icon(Icons.grid_view), onTap: () {}),
            buildSizedBox(mediaQuery),
            GestureDetector(child: Icon(Icons.add_circle), onTap: () {}),
            buildSizedBox(mediaQuery),
            GestureDetector(
                child: Icon(Icons.edit),
                onTap: () {
                  if (isEditScreen == false) {
                    setState(() {
                      isMenuScreen = false;
                      isEditScreen = true;
                    });
                  }
                }),
            buildSizedBox(mediaQuery),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(mediaQuery.height / 9),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: mediaQuery.width * 0.55,
                      height: 50,
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffe6e6e6),
                            offset: Offset(3, 3),
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            color: Color(0xfffcfcfc),
                            offset: Offset(-3, -3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: TextField(
                        cursorColor: fontColor,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: fontColor),
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffe6e6e6),
                              offset: Offset(3, 3),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: Color(0xfffcfcfc),
                              offset: Offset(-3, -3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt),
                            SizedBox(width: 5),
                            Text('Filter'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Text(
                  'Our Speciality',
                  style: TextStyle(color: Color(0xff1c2843), fontSize: 17),
                ),
              ),
              Container(
                  height: 130,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) => SpecialityItem(),
                  )),
              Divider(thickness: 1, indent: 20, endIndent: 20),
              OtherFoodItems(),
            ],
          ),
        ),
      ),
    );
  }
}
