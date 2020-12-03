import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/other_food_items.dart';
import './widgets/speciality_item.dart';
import './DatabaseOperation/FoodCollectionDatabase.dart';
import 'FormToAdd.dart';
import './constants.dart';

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
  bool showFilter = false;

  SizedBox buildSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.03);

  @override
  void initState() {
    fetchAllFoods();

    super.initState();
  }

  Future<void> fetchAllFoods() async {
    print("checkkkkkkkkk 111 ------------");
    var foodItemsTemp = await FoodCollectionDatabase().fetchData();
    print("checkkkkkkkkk 2222------------${foodItemsTemp.length}");

    if (foodItemsTemp == null) {
      print("------------------------\nNO DATA\n-----------------------------");
    } else {
      setState(() {
        foodItems = foodItemsTemp;
      });
    }
  }

  bool getSpecialFoodItems() {
    specialFoodItems = [];
    bool specialItemsAvailable = false;
    if (foodItems != null) {
      foodItems.forEach((item) {
        if (item.isSpecial) {
          specialFoodItems.add(item);
          specialItemsAvailable = true;
        }
      });
    }
    print("specialFoodItems length - ${specialFoodItems.length}");
    return specialItemsAvailable;
  }

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
              // if (isMenuScreen == false) {
              //   setState(() {
              //     isMenuScreen = true;
              //     isEditScreen = false;
              //   });
              // }
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
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (ctx) => FormToAddFoodItems()));
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: Icon(Icons.edit),
            onTap: () {
              // if (isEditScreen == false) {
              //   setState(() {
              //     isMenuScreen = false;
              //     isEditScreen = true;
              //   });
              // } else if (isEditScreen == true) {
              //   setState(() {
              //     isMenuScreen = true;
              //     isEditScreen = false;
              //   });
              // }
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
                      boxShadow: boxShadowSmall,
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
                      boxShadow: boxShadowSmall,
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
                      boxShadow: boxShadowSmall,
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
                // Container(
                //   height: 50,
                //   width: 120,
                //   //padding: EdgeInsets.only(left: 15),
                //   margin: EdgeInsets.only(right: 15, left: 15),
                //   decoration: BoxDecoration(
                //     color: Color(0xfff5f5f5),
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(30),
                //     ),
                //     boxShadow: boxShadowSmall,
                //   ),
                //   child: Stack(
                //     alignment: Alignment.topLeft,
                //     overflow: Overflow.visible,
                //     children: [
                //       if (showFilter)
                //         Positioned(
                //           top: 1,
                //           child: Container(
                //             padding: EdgeInsets.only(top: 60),
                //             height: 120,
                //             width: 120,
                //             decoration: BoxDecoration(
                //               color: Color(0xfff5f5f5),
                //               borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(30),
                //                 topRight: Radius.circular(30),
                //                 bottomRight: Radius.circular(10),
                //                 bottomLeft: Radius.circular(10),
                //               ),
                //               boxShadow: boxShadowSmall,
                //             ),
                //             child: Column(
                //               children: [
                //                 GestureDetector(
                //                   behavior: HitTestBehavior.translucent,
                //                   onTap: () {
                //                     print("------------------test - veg");
                //                     // foodItems.forEach((item) {
                //                     //   if(item.isVeg ){
                //                     //     setState(() {
                //                     //       foodItems = [];
                //                     //       foodItems.add(item);
                //                     //     });
                //                     //   }
                //                     // });
                //                   },
                //                   child: Container(
                //                     child: Text("Veg"),
                //                   ),
                //                 ),
                //                 Divider(thickness: 1, indent: 5, endIndent: 5),
                //                 GestureDetector(
                //                   behavior: HitTestBehavior.translucent,
                //                   onTap: () {
                //                     print("------------------test - non veg");
                //                     // foodItems.forEach((item) {
                //                     //   if(!item.isVeg ){
                //                     //     setState(() {
                //                     //       foodItems = [];
                //                     //       foodItems.add(item);
                //                     //     });
                //                     //   }
                //                     // });
                //                   },
                //                   child: Container(
                //                     child: Text("Non Veg"),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             showFilter = !showFilter;
                //           });
                //         },
                //         child: Container(
                //           height: 50,
                //           width: 120,
                //           padding: EdgeInsets.only(left: 15),
                //           decoration: BoxDecoration(
                //             color: Color(0xfff5f5f5),
                //             borderRadius: BorderRadius.all(
                //               Radius.circular(30),
                //             ),
                //             boxShadow: boxShadowSmall,
                //           ),
                //           child: Row(
                //             children: [
                //               Icon(Icons.filter_alt),
                //               SizedBox(width: 5),
                //               Text('Filter'),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
    //print("checkkkkkkkkk 3333333------------${foodItems.length}");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: appBar,
        body: RefreshIndicator(
          onRefresh: fetchAllFoods,
          backgroundColor: Color(0xff1c2843),
          color: Colors.white,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (getSpecialFoodItems())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Text(
                          'Our Speciality',
                          style:
                              TextStyle(color: Color(0xff1c2843), fontSize: 17),
                        ),
                      ),
                      SpecialityItem(),
                      Divider(thickness: 1, indent: 20, endIndent: 20),
                    ],
                  ),
                foodItems != null
                    ? OtherFoodItems()
                    : Center(
                        child: Text("Menu is Empty"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
