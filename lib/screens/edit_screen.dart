import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantflutter/constants.dart';

class EditItems extends StatefulWidget {
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit', style: TextStyle(color: fontColor)),
          centerTitle: true,
          elevation: 0,
          leading: CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(CupertinoIcons.chevron_left, color: fontColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: boxShadow,
                  ),
                  height: 104,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        child: Image.network(
                          'https://punampaul.com/wp-content/uploads/2020/03/Veg-Toast-Sandwich.jpg',
                          fit: BoxFit.cover,
                          height: mediaQuery.height * 0.3,
                          width: mediaQuery.width * 0.3,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: appColor,
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
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: appColor,
                    boxShadow: boxShadow,
                  ),
                  child: TextField(
                    maxLines: 4,
                    cursorColor: fontColor,
                    decoration: InputDecoration(
                      hintText: 'Short Description',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    boxShadow: boxShadow,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: appColor,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: fontColor,
                    decoration: InputDecoration(
                      hintText: 'Price',
                      hintStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(
                        CupertinoIcons.money_dollar,
                        color: fontColor,
                      ), //Temporary Doller Icon
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    if (isExpanded)
                      Container(
                        height: 125,
                        width: mediaQuery.width,
                        decoration: BoxDecoration(
                          boxShadow: boxShadow,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          color: appColor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 60),
                            Text('Morning'),
                            Text('Afternoon'),
                            Text('Evening'),
                            Text('Night'),
                          ],
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: boxShadow,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: appColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.time, color: fontColor),
                                SizedBox(width: 13),
                                Text('Timing'),
                              ],
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: fontColor, size: 35),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: CupertinoButton(
            pressedOpacity: 0.8,
            color: fontColor,
            onPressed: () {},
            child: Text('Save'),
          ),
        ),
      ),
    );
  }
}
