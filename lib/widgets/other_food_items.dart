import 'package:flutter/material.dart';

import '../constants.dart';

class OtherFoodItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: 5 * 125.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 5, right: 15),
        itemCount: 5,
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
                child: Image.network(
                  'https://punampaul.com/wp-content/uploads/2020/03/Veg-Toast-Sandwich.jpg',
                  fit: BoxFit.cover,
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
                              "SandWich",
                              style: TextStyle(fontSize: 20),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              maxLines: 2,
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
                  '238 Rs.',
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
