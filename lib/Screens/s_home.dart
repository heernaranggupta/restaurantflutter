import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CIconData.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Category.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Screens/s_add_items.dart';
import 'package:orderingsystem/Screens/s_approve_orders.dart';
import 'package:orderingsystem/Widgets/category_filter.dart';
import 'package:orderingsystem/Widgets/other_food_items.dart';
import 'package:orderingsystem/Widgets/speciality_item.dart';
import 'package:orderingsystem/widgets/items_not_available.dart';
import 'package:orderingsystem/widgets/search_results.dart';
import 'package:search_widget/search_widget.dart';
import '../constants.dart';

class SHome extends StatefulWidget {
  static const routeName = 'home';
  @override
  _SHomeState createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  String filterId;
  bool _isLoading = false;
  bool _isSearching = false;
  List<Categories> categories;
  List<FoodItem> searchedItems;

  SizedBox buildSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.04);

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
      _isSearching = false;
    });
    await FoodItem().getAllFoodItems().catchError((error) {
      print(error);
    });
    categories = await Categories().getCategories().catchError((error) {
      print(error);
    });
    setState(() {
      _isLoading = false;
    });
  }

  void filterSearchResults(String query) {

    List<FoodItem> dummySearchList = List<FoodItem>();
    dummySearchList.addAll(FoodItem().allItems);
    if(query.isNotEmpty) {
      List<FoodItem> dummyListData = List<FoodItem>();
      dummySearchList.forEach((item) {
        if(item.foodName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }

      });

      setState(() {
        _isSearching = true;
        searchedItems = dummyListData;
      });
      return;
    } else {
      setState(() {
        searchedItems.clear();
        _isSearching = false;
      });
    }
  }

  void onFilterChange(String id) {
    setState(() {
      if (filterId == id) {
        filterId = null;
      } else {
        filterId = id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
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
            onTap: () {
              Navigator.of(context).pushNamed(SApproveOrders.routeName);
            }),
        buildSizedBox(mediaQuery),
        GestureDetector(
            child: CIconData(
              codePoint: 0xe900,
              fontFamily: 'addIcon',
            ),
            onTap: () {
              Navigator.of(context).pushNamed(SAddItems.routeName);
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
                      onChanged: (value) {
                        print(value);
                        filterSearchResults(value);
                      },
                      onSubmitted: (value) {
                        print(value);
                        filterSearchResults(value);
                      },
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
        : GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
              appBar: appBar,
              body: RefreshIndicator(
                color: fontColor,
                displacement: 60,
                onRefresh: getData,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: _isSearching
                      ? SearchResults(searchedItems)
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: CText(
                          text: 'Our Speciality',
                          fontSize: 17,
                        ),
                      ),
                      SpecialityItem(),
                      CategoryFilter(categories, onFilterChange, filterId),
                      OtherFoodItems(filterId),
                      Divider(thickness: 1, indent: 20, endIndent: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: CText(
                          text: 'Unavailable',
                          fontSize: 17,
                        ),
                      ),
                      ItemsNotAvailable()
                    ],
                  ),
                ),
              ),
            ),
        );
  }
}
