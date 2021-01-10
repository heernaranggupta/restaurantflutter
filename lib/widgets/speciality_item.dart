import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Screens/s_edit.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SpecialityItem extends StatefulWidget {
  @override
  _SpecialityItemState createState() => _SpecialityItemState();
}

class _SpecialityItemState extends State<SpecialityItem> {
  List<FoodItem> specialFoodItems = [];

  Widget buildText(String title, Size mediaQuery) {
    return CText(
      text: title,
      textColor: Colors.white,
      fontSize: mediaQuery.width * 0.045,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Consumer<FoodItem>(
      builder: (context, foodItem, _) {
        specialFoodItems = isVeg
            ? foodItem.specialItems.where((element) => (element.isVeg)).toList()
            : isNonVeg
                ? foodItem.specialItems
                    .where((element) => (!element.isVeg))
                    .toList()
                : foodItem.specialItems;
        return specialFoodItems.length != 0
            ? Container(
                height: mediaQuery.width * 0.32,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  itemCount: specialFoodItems.length,
                  itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: boxShadow,
                      ),
                      width: mediaQuery.width * 0.9,
                      height: mediaQuery.width * 0.32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            child: specialFoodItems[index].imageUrl != null
                                ? Image(
                                    image: CachedNetworkImageProvider(
                                      specialFoodItems[index].imageUrl[0],
                                    ),
                                    height: mediaQuery.height,
                                    width: mediaQuery.width * 0.26,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    child: Center(child: Text("No Image")),
                                    height: mediaQuery.height,
                                    width: mediaQuery.width * 0.26,
                                  ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff5f5f5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-3, -3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CText(
                                          text:
                                              specialFoodItems[index].foodName,
                                          fontSize: mediaQuery.width * 0.05,
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                            height: mediaQuery.height * 0.005),
                                        CText(
                                          text: specialFoodItems[index]
                                              .description,
                                          fontSize: mediaQuery.width * 0.03,
                                          textColor: Colors.grey[600],
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: mediaQuery.width * 0.22,
                            alignment: Alignment.center,
                            child: !isEditScreen
                                ? buildText(
                                    "${specialFoodItems[index].price} ₹",
                                    mediaQuery)
                                : GestureDetector(
                                    child: buildText('Edit', mediaQuery),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          SEditItems.routeName,
                                          arguments:
                                              specialFoodItems[index].foodId);
                                    },
                                  ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-3, -3),
                                  blurRadius: 4,
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: <Color>[
                                  Color(0xFFFF7D55),
                                  Color(0xFFF4197E),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: CContainer(
                  borderRadius: BorderRadius.circular(15),
                  child: Center(child: CText(text: 'Nothing Special.')),
                ),
              );
      },
    );
  }
}
