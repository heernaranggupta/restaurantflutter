import 'package:flutter/material.dart';
import 'package:orderingsystem/models/FoodItem.dart';

import '../constants.dart';

class OtherFoodItems extends StatelessWidget {
  List<FoodItem> foodItems;
  double appBarHeight;

  OtherFoodItems({@required this.foodItems,@required this.appBarHeight});

  @override
  Widget build(BuildContext context) {
    print("actual lenth  - ${foodItems.length}");

    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height:  foodItems.length < 4 ? MediaQuery.of(context).size.height - appBarHeight - MediaQuery.of(context).padding.top:foodItems.length * 125.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(right: 20),
        itemCount: foodItems.length,
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
                child: foodItems[index].imageUrl != null
                    ? Image.network(
                        foodItems[index].imageUrl,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: mediaQuery.height*0.02,
                            ),
                            Text(
                              foodItems[index].foodName,
                              style: TextStyle(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              foodItems[index].description,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600]
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
                  !isEditScreen ? "${foodItems[index].price} ₹" : 'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                decoration: BoxDecoration(
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
