import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/edit_screen.dart';
import '../constants.dart';

class SpecialityItem extends StatelessWidget {
  Text buildText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
        decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: boxShadow,
        ),
        width: mediaQuery.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              child: Image.network(
                'https://static.toiimg.com/thumb/56933159.cms?imgsize=686279&width=800&height=800',
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
                            "Salad",
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Description",
                            style: TextStyle(fontSize: 13),
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
              child: !isEditScreen
                  ? buildText('238 Rs')
                  : GestureDetector(
                      child: buildText('Edit'),
                      onTap: () {
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (ctx) => EditItems()));
                      },
                    ),
              decoration: BoxDecoration(
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
    );
  }
}
