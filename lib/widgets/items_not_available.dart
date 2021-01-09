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

  Widget buildText(String title) {
    return CText(
      text: title,
      textColor: Colors.white,
      fontSize: 18,
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
                height: itemsNotAvailable.length * 125.0,
                child: ListView.builder(
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
                      height: 104,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            child: itemsNotAvailable[index].imageUrl != null
                                ? Image(
                                    image: CachedNetworkImageProvider(
                                      itemsNotAvailable[index].imageUrl[0],
                                    ),
                                    height: mediaQuery.height * 0.3,
                                    width: mediaQuery.width * 0.275,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    child: Center(child: Text("No Image")),
                                    height: mediaQuery.height * 0.3,
                                    width: mediaQuery.width * 0.275,
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
                                        Text(
                                          itemsNotAvailable[index].foodName,
                                          style: TextStyle(fontSize: 20),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          itemsNotAvailable[index].description,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
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
                            width: 90,
                            alignment: Alignment.center,
                            height: 120,
                            child: !isEditScreen
                                ? buildText(
                                    "${itemsNotAvailable[index].price} ₹")
                                : GestureDetector(
                                    child: buildText('Edit'),
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
