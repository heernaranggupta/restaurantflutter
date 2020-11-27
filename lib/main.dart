import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

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
          SizedBox(width: 15),
          Icon(CupertinoIcons.rectangle_grid_2x2_fill),
          SizedBox(width: 15),
          Icon(CupertinoIcons.add_circled_solid),
          SizedBox(width: 15),
          Icon(Icons.edit),
          SizedBox(width: 15),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75),
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
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.search),
                        SizedBox(width: 5),
                        Text('Search'),
                      ],
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
                itemBuilder: (ctx, index) => Container(
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
                        child: Text(
                          "238 Rs.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
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
              ),
            ),
            Divider(thickness: 1, indent: 20, endIndent: 20),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
