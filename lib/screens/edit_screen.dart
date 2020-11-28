import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantflutter/constants.dart';

class EditItems extends StatefulWidget {
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  bool isExpandedTiming = false;
  bool isExpandedCategories = false;
  var timingBoolList = [false, false, false, false];
  var categoryBoolList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  var timings = ["Morning", "Afternoon", "Evening", "Night"];
  var category = [
    "Vegetables",
    "Grains",
    "Legumes",
    "Meat and poultry",
    "Fish and Seafood",
    "Dairy Foods",
    "Eggs",
    "Bread"
  ];
  Container buildContainer(String title) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: boxShadowSmall,
        color: appColor,
      ),
      child: Center(child: Text(title)),
    );
  }

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
              children: [
                Row(
                  children: [
                    Container(
                      height: 104,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: appColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: boxShadow,
                      ),
                      child: ClipRRect(
                        child: Image.network(
                          'https://punampaul.com/wp-content/uploads/2020/03/Veg-Toast-Sandwich.jpg',
                          fit: BoxFit.cover,
                          height: mediaQuery.height * 0.3,
                          width: mediaQuery.width * 0.275,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: buildContainer('Special'),
                              ),
                              Expanded(
                                child: buildContainer('Count'),
                              ),
                              Expanded(
                                child: buildContainer('Veg'),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: buildContainer('General'),
                              ),
                              Expanded(
                                child: buildContainer('Quantity'),
                              ),
                              Expanded(
                                child: buildContainer('Non Veg'),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: 55,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  decoration: BoxDecoration(
                    boxShadow: boxShadowSmall,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: appColor,
                  ),
                  child: TextField(
                    cursorColor: fontColor,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(
                        Icons.fastfood_sharp,
                        color: fontColor,
                      ), //Temporary Doller Icon
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    boxShadow: boxShadowSmall,
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
                    if (isExpandedTiming)
                      Container(
                        height: 200,
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 50),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 32,
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Color(0xff1c2843),
                                title: Text(
                                  timings[index],
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: timingBoolList[index],
                                onChanged: (value) {
                                  setState(() {
                                    timingBoolList[index] = value;
                                  });
                                },
                              ),
                            );
                          },
                          itemCount: timingBoolList.length,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: boxShadowSmall,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: appColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpandedTiming = !isExpandedTiming;
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
                Stack(
                  children: [
                    if (isExpandedCategories)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 330,
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 50),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: category.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 32,
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Color(0xff1c2843),
                                title: Text(
                                  category[index],
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: categoryBoolList[index],
                                onChanged: (value) {
                                  setState(() {
                                    categoryBoolList[index] = value;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: boxShadowSmall,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: appColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpandedCategories = !isExpandedCategories;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.grid_view, color: fontColor),
                                SizedBox(width: 13),
                                Text('Category'),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: appColor,
                    boxShadow: boxShadowSmall,
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
