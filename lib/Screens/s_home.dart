import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CIconData.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Screens/s_add_items.dart';
import 'package:orderingsystem/Widgets/other_food_items.dart';
import 'package:orderingsystem/Widgets/speciality_item.dart';
import '../constants.dart';

class SHome extends StatefulWidget {
  @override
  _SHomeState createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  bool _isLoading = false;

  SizedBox buildSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.04);

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    await FoodItem().getFoodItems();

    setState(() {
      _isLoading = false;
    });
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
            child: CIconData(
              codePoint: 0xe900,
              fontFamily: 'foodIcon',
            ),
            onTap: () {
              setState(() {
                if (isEditScreen) {
                  isEditScreen = false;
                }
              });
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: CIconData(
              codePoint: 0xe902,
              fontFamily: 'dashboardIcon',
            ),
            onTap: () {}),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: CIconData(
              codePoint: 0xe900,
              fontFamily: 'addIcon',
            ),
            onTap: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (ctx) => SAddItems()));
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: CIconData(
              codePoint: 0xe900,
              fontFamily: 'editIcon',
            ),
            onTap: () {
              setState(() {
                isEditScreen = !isEditScreen;
              });
            }),
        buildSizedBox(mediaQuery),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(mediaQuery.height / 8),
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
    return _isLoading
        ? CLoadingIndicator()
        : Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  OtherFoodItems()
                  // : Center(
                  //     child: Text("Menu is Empty"),
                  //   ),
                ],
              ),
            ),
          );
  }
}
