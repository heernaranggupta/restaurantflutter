import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

import './constants.dart';
import 'screens/s_add_items.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      title: 'Foodito',
      home: HomePage(),
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
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFilter = false;

  SizedBox buildSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.03);

  @override
  void initState() {
    // fetchAllFoods();
    super.initState();
  }

  // Future<void> fetchAllFoods() async {
  //   var foodItemsTemp = await FoodCollectionDatabase().fetchData();

  //   if (foodItemsTemp == null) {
  //   } else {
  //     setState(() {
  //       foodItems = foodItemsTemp;
  //     });
  //   }
  // }

  // bool getSpecialFoodItems() {
  //   specialFoodItems = [];
  //   bool specialItemsAvailable = false;
  //   if (foodItems != null) {
  //     foodItems.forEach((item) {
  //       if (item.isSpecial) {
  //         specialFoodItems.add(item);
  //         specialItemsAvailable = true;
  //       }
  //     });
  //   }
  //   return specialItemsAvailable;
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    AppBar appBar = AppBar(
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
              setState(() {
                if (isEditScreen) {
                  isEditScreen = false;
                }
              });
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(child: Icon(Icons.grid_view), onTap: () {}),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: Icon(Icons.add_circle),
            onTap: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (ctx) => SAddItems()));
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: Icon(Icons.edit),
            onTap: () {
              setState(() {
                isEditScreen = !isEditScreen;
              });
            }),
        buildSizedBox(mediaQuery),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(mediaQuery.height / 8), //
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
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
                      boxShadow: boxShadow,
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: fontColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: fontColor),
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(99),
                      ),
                      border: Border.all(
                        color: isVeg ? Color(0xff397c24) : appColor,
                        width: 3,
                      ),
                      boxShadow: boxShadow,
                    ),
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(left: 15, right: 10),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff397c24),
                      radius: 8,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (isNonVeg) {
                        isVeg = !isVeg;
                        isNonVeg = false;
                      } else {
                        isVeg = !isVeg;
                      }
                    });
                  },
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(99),
                      ),
                      border: Border.all(
                          color: isNonVeg ? Color(0xff8e4426) : appColor,
                          width: 3),
                      boxShadow: boxShadow,
                    ),
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff8e4426),
                      radius: 8,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (isVeg) {
                        isNonVeg = !isNonVeg;
                        isVeg = false;
                      } else {
                        isNonVeg = !isNonVeg;
                      }
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: appBar,
        body: Center(
          child: Text("Menu is Empty"),
        ),
        // RefreshIndicator(
        //   onRefresh: fetchAllFoods,
        //   backgroundColor: Color(0xff1c2843),
        //   color: Colors.white,
        //   child: SingleChildScrollView(
        //     physics: BouncingScrollPhysics(),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         if (getSpecialFoodItems())
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 15.0, top: 10),
        //                 child: Text(
        //                   'Our Speciality',
        //                   style:
        //                       TextStyle(color: Color(0xff1c2843), fontSize: 17),
        //                 ),
        //               ),
        //               SpecialityItem(),
        //               Divider(thickness: 1, indent: 20, endIndent: 20),
        //             ],
        //           ),
        //         foodItems != null
        //             ? OtherFoodItems()
        //             : Center(
        //                 child: Text("Menu is Empty"),
        //               ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
