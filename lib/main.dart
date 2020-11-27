import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantflutter/widgets/speciality_item.dart';

import 'constants.dart';
import 'widgets/other_food_items.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodito',
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        iconTheme: IconThemeData(
          color: Color(0xff1c2843),
        ),
        primaryIconTheme: IconThemeData(
          color: Color(0xff1c2843),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Color(0xfff5f5f5),
        title: Text(
          'Foodito',
          style: TextStyle(color: Color(0xff1c2843), fontSize: 30),
        ),
        actions: [
          Icon(Icons.fastfood_sharp),
          SizedBox(width: mediaQuery.width * 0.03),
          Icon(Icons.grid_view),
          SizedBox(width: mediaQuery.width * 0.03),
          Icon(Icons.add_circle),
          SizedBox(width: mediaQuery.width * 0.03),
          Icon(Icons.edit),
          SizedBox(width: mediaQuery.width * 0.03),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(mediaQuery.height/9),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: mediaQuery.width * 0.55,
                    height: 50,
                    padding: EdgeInsets.only(left: 15),
                    margin: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffe6e6e6),
                          offset: Offset(3, 3),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: Color(0xfffcfcfc),
                          offset: Offset(-3, -3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search',
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffe6e6e6),
                            offset: Offset(3, 3),
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            color: Color(0xfffcfcfc),
                            offset: Offset(-3, -3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt),
                          SizedBox(width: 5),
                          Text('Filter'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Text(
                'Our Speciality',
                style: TextStyle(color: Color(0xff1c2843), fontSize: 17),
              ),
            ),
            Container(
              height: 130,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 5, right: 10),
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => SpecialityItem(),
              )
            ),
            Divider(thickness: 1, indent: 20, endIndent: 20),
            OtherFoodItems(),
          ],
        ),
      ),
    );
  }
}
