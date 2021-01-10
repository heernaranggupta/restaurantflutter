import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Screens/s_edit.dart';
import 'package:provider/provider.dart';
import '../Models/FoodItem.dart';

import '../constants.dart';

class ItemsNotAvailable extends StatefulWidget {
  @override
  _ItemsNotAvailableState createState() => _ItemsNotAvailableState();
}

class _ItemsNotAvailableState extends State<ItemsNotAvailable> {
  List<FoodItem> itemsNotAvailable;

  Widget buildText(String title, Size mediaQuery) {
    return CText(
      text: title,
      textColor: Colors.white,
      fontSize: mediaQuery.width * 0.045,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Consumer<FoodItem>(
      builder: (context, foodItem, _) {
        itemsNotAvailable = isVeg
            ? foodItem.itemsNotAvailable
                .where((element) => (element.isVeg))
                .toList()
            : isNonVeg
                ? foodItem.itemsNotAvailable
                    .where((element) => (!element.isVeg))
                    .toList()
                : foodItem.itemsNotAvailable;
        return itemsNotAvailable.length != 0
            ? Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(right: 20),
                  itemCount: itemsNotAvailable.length,
                  itemBuilder: (ctx, index) => Opacity(
                    opacity: 0.5,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: boxShadow,
                      ),
                      width: mediaQuery.width * 0.9,
                      height: mediaQuery.width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            child: itemsNotAvailable[index].imageUrl != null
                                ? Image(
                                    image: CachedNetworkImageProvider(
                                      itemsNotAvailable[index].imageUrl[0],
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
                                              itemsNotAvailable[index].foodName,
                                          fontSize: mediaQuery.width * 0.05,
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                            height: mediaQuery.height * 0.005),
                                        CText(
                                          text: itemsNotAvailable[index]
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
                                    "${itemsNotAvailable[index].price} ₹",
                                    mediaQuery)
                                : GestureDetector(
                                    child: buildText('Edit', mediaQuery),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          SEditItems.routeName,
                                          arguments:
                                              itemsNotAvailable[index].foodId);
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
                              color: Color(0xff1c2843),
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
                  child: Center(child: CText(text: 'Menu Is Empty.')),
                ),
              );
      },
    );
  }
}
