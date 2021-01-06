import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/FoodItem.dart';

import '../constants.dart';

class OtherFoodItems extends StatefulWidget {
  @override
  _OtherFoodItemsState createState() => _OtherFoodItemsState();
}

class _OtherFoodItemsState extends State<OtherFoodItems> {
  List<FoodItem> otherFoodItems = [];

  @override
  void initState() {
    otherFoodItems = Provider.of<FoodItem>(context, listen: false).otherItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    // print("actual lenth  - ${foodItemsDisplay.length}");
    // if (isVeg) {
    //   foodItemsDisplay = vegFoodItems;
    // } else if (isNonVeg) {
    //   foodItemsDisplay = nonVegFoodItems;
    // } else {
    //   foodItemsDisplay = foodItems;
    // }
    // print("actual lenth  - ${foodItemsDisplay.length}");

    return Container(
      height: otherFoodItems.length * 125.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(right: 20),
        itemCount: otherFoodItems.length,
        itemBuilder: (ctx, index) => Container(
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
                child: otherFoodItems[index].imageUrl != null
                    ? Image.network(
                        otherFoodItems[index].imageUrl[0],
                        fit: BoxFit.cover,
                        height: mediaQuery.height * 0.3,
                        width: mediaQuery.width * 0.275,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              otherFoodItems[index].foodName,
                              style: TextStyle(fontSize: 20),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              otherFoodItems[index].description,
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
                child: Text(
                  !isEditScreen ? "${otherFoodItems[index].price} ₹" : 'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
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
    );
  }
}
