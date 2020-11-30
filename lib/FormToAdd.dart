import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'constants.dart';
import 'models/FoodItem.dart';


class FormToAddFoodItems extends StatefulWidget {
  @override
  _FormToAddFoodItemsState createState() => _FormToAddFoodItemsState();
}

class _FormToAddFoodItemsState extends State<FormToAddFoodItems> {
  final foodController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var timingBoolList = [false, false, false, false];
  List<String> timingsListToDisplay = List();
  var timingDisplayAsHint = "Timing";
  FirebaseStorage rf;
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
  List<String> categoryListToDisplay = List();
  var categoryDisplayAsHint = "Category";
  var showTimingList = false;
  var showCategoryList = false;
  bool isSpecial = false;
  bool isQuantitative = false;
  bool isVeg = true;
  Color themeBlueColor = Color(0xff1c2843);
  Color themeWhiteColor = Color(0xFFF5F5F5);

  // PickedFile _image;
  File _imageFile;

  // Future clickPicture() async {
  //   final imagePicker = ImagePicker();
  //   final image = await imagePicker.getImage(
  //       source: ImageSource.camera, imageQuality: 30);
  //   Navigator.pop(context);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  Future chooseOrClickPicture(ImageSource source) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(
        source: source, imageQuality: 30);
    Navigator.pop(context);
    setState(() {

      _imageFile = File(image.path);
    });
  }

  Future<String> uploadImage(var imageFile ) async {
    String url;
    Reference ref = FirebaseStorage.instance.ref().child("foods_images_uploaded/${DateTime.now()}.jpg");
    TaskSnapshot uploadTask = await ref.putFile(imageFile);
    url =  await ref.getDownloadURL();
    return url;
  }

  Future<void> addData() async {
    print("url-----------------------------------------");
    var DemoReferance = firestore.collection("FoodsCollection").doc();
    List<String> finalCategories = List();
    List<String> finalTimings = List();
    int j = 0;
    for (int i = 0; i < category.length; i++) {
      if (categoryBoolList[i] == true) {
        finalCategories.add(category[i]);
        // finalList[j++]=category[i];
      }
    }
    j = 0;
    for (int i = 0; i < timings.length; i++) {
      if (timingBoolList[i] == true) {
        finalTimings.add(timings[i]);
        // finalList[j++]=category[i];
      }
    }

    print("final Categories - $finalCategories \nfinal Timing - $finalTimings");

    String url;
    if(_imageFile != null)
         url = await uploadImage(_imageFile);
    else{
      url="no url";
    }

    print("url- $url");



    final FoodItem item = FoodItem(
        categories: categoryListToDisplay,//finalCategories,
        description: descriptionController.text,
        foodId: DemoReferance.id,
        foodName: foodController.text,
        imageUrl: url,
        isSpecial: isSpecial,
        isVeg: isVeg,
        price: priceController.text,
        isQuantitative: isQuantitative,
        timings: timingsListToDisplay//finalTimings
    );

    DemoReferance.set(item.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // final List _timinglist = ['Morning', 'Afternoon', 'Evening', 'Night'];
    // String _timingValue;
    final actionsheet = CupertinoActionSheet(
      title: Text(
        "Add or Change Picture",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: ()=>chooseOrClickPicture(ImageSource.camera),
          child: Text("Take Picture"),
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          onPressed: ()=>chooseOrClickPicture(ImageSource.gallery),
          child: Text("Open Gallery"),
          isDefaultAction: true,
        ),
        if(_imageFile != null)
        CupertinoActionSheetAction(
          onPressed: (){
          setState(() {
            _imageFile = null;
            Navigator.pop(context);
          });
          },
          child: Text("Delete Image"),
          isDefaultAction: true,
          isDestructiveAction: true,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      ),

    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Container(
            width: mediaQuery.width * 0.9,
            child: CupertinoButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Color(0xff1c2843),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6.0),
              // ),
              onPressed: () => addData(),
              child: Text("Add Item"),
              pressedOpacity: 0.8,
              //textColor: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 7,
          centerTitle: false,
          backgroundColor: Color(0xfff5f5f5),
          actions: [
            Icon(Icons.fastfood_sharp),
            SizedBox(width: 15),
            Icon(
              const IconData(0xe903, fontFamily: 'newcustomfonts'),
            ),
            SizedBox(width: 15),
            Icon(
              CupertinoIcons.add_circled_solid,
              color: Colors.grey,
            ),
            SizedBox(width: 15),
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Color(0xFFF5F5F5),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          children: [
                            InkWell(
                              child: Container(
                                width: mediaQuery.width / 3.5,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: boxShadowTwo,
                                ),
                                child: _imageFile == null
                                    ? Center(child: Text("Add Image"))
                                    : ClipRRect(
                                        child: Image.file(
                                          _imageFile,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                //   child: Container(
                                //     child: Image.file(File(_image.path),
                                // ),
                              ),
                              onTap: () => showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => actionsheet),
                            ),
                            // if(isSpecial)
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSpecial = true;
                                                print(isSpecial);
                                              });
                                            },
                                            child: Container(
                                              child: Center(
                                                  child: Text(
                                                "Special",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: isSpecial
                                                        ? Color(0xFFF5F5F5)
                                                        : Color(0xff1c2843)),
                                              )),
                                              width: mediaQuery.width / 6,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isSpecial
                                                    ? Color(0xff1c2843)
                                                    : Color(0xFFF5F5F5),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: boxShadowTwo,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                //Icon(CupertinoIcons.left_chevron),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isQuantitative = false;
                                                    });
                                                  },
                                                  child: Container(
                                                      child: Center(
                                                          child: Text(
                                                    "Count",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: isQuantitative
                                                            ? Color(0xff1c2843)
                                                            : Color(0xFFF5F5F5)),
                                                  ))),
                                                ),
                                                //  Icon(CupertinoIcons.right_chevron),
                                              ],
                                            ),
                                            width: mediaQuery.width / 4,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: isQuantitative
                                                  ? Color(0xFFF5F5F5)
                                                  : Color(0xff1c2843),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: boxShadowTwo,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isVeg = true;
                                              });
                                            },
                                            child: Container(
                                              child: Center(
                                                  child: Center(
                                                      child: Text(
                                                "Veg",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: isVeg
                                                      ? themeWhiteColor
                                                      : themeBlueColor,
                                                ),
                                              ))),
                                              width: mediaQuery.width / 9,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isVeg
                                                    ? themeBlueColor
                                                    : themeWhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: boxShadowTwo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //if(isSpecial==false)
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSpecial = false;
                                                print(isSpecial);
                                              });
                                            },
                                            child: Container(
                                              child: Center(
                                                  child: Text(
                                                "General",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: isSpecial
                                                        ? Color(0xff1c2843)
                                                        : Color(0xFFF5F5F5)),
                                              )),
                                              width: mediaQuery.width / 6,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isSpecial
                                                    ? Color(0xFFF5F5F5)
                                                    : Color(0xff1c2843),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: boxShadowTwo,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isQuantitative = true;
                                                print(
                                                    "isQuantitative- $isQuantitative");
                                              });
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  //Icon(CupertinoIcons.left_chevron),
                                                  Container(
                                                      child: Center(
                                                          child: Text(
                                                    "Quantity",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: isQuantitative
                                                            ? Color(0xFFF5F5F5)
                                                            : Color(0xff1c2843)),
                                                  ))),
                                                  // Icon(CupertinoIcons.right_chevron),
                                                ],
                                              ),
                                              width: mediaQuery.width / 4,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isQuantitative
                                                    ? Color(0xff1c2843)
                                                    : Color(0xFFF5F5F5),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: boxShadowTwo,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isVeg = false;
                                              });
                                            },
                                            child: Container(
                                              child: Center(
                                                  child: Center(
                                                      child: Text(
                                                "Non\nVeg",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: isVeg
                                                        ? themeBlueColor
                                                        : themeWhiteColor),
                                              ))),
                                              width: mediaQuery.width / 9,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: isVeg
                                                    ? themeWhiteColor
                                                    : themeBlueColor,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: boxShadowTwo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: boxShadowTwo,
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,

                          controller: foodController,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey[400]),
                            hintText: 'Food Name',
                            prefixIcon: Icon(
                              Icons.fastfood_sharp,
                              color: Color(0xff1c2843),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: boxShadowTwo,
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey[400]),
                            hintText: 'Price',
                            prefixIcon: Icon(
                              const IconData(0xe900,
                                  fontFamily: 'newcustomfonts'),
                              color: Color(0xff1c2843),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Stack(
                        children: [
                          if (showTimingList)
                            Container(
                                padding: EdgeInsets.only(top: 50),
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  //Colors.red,//Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6)),
                                  boxShadow: boxShadowTwo,
                                ),
                                child: ListView.builder(
                                  //physics: BouncingScrollPhysics(),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
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
                                            timingsListToDisplay.clear();
                                            for(int i =0 ;i<timingBoolList.length;i++){
                                              if(timingBoolList[i]){
                                                timingsListToDisplay.add(timings[i]);
                                              }
                                            }
                                            if(timingsListToDisplay.length == 0){
                                              timingDisplayAsHint= "Timing";
                                            }else{
                                              timingDisplayAsHint= timingsListToDisplay.toString().substring(1,timingsListToDisplay.toString().length-1);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  },
                                )),
                          InkWell(
                            // splashColor: Colors.red,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (showTimingList) {
                                setState(() {
                                  showTimingList = false;
                                  showCategoryList = false;
                                });
                              } else {
                                setState(() {
                                  showTimingList = true;
                                  showCategoryList = false;
                                });
                              }
                              print("clicked - $showTimingList");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: boxShadowTwo,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    const IconData(0xe904,
                                        fontFamily: 'newcustomfonts'),
                                    color: Color(0xff1c2843),
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(top: 15, bottom: 15),
                                        child: Text(
                                          timingDisplayAsHint,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: timingsListToDisplay.length == 0 ? Colors.grey[400]: themeBlueColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Stack(
                        children: [
                          if (showCategoryList)
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 500, minHeight: 0.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    //Colors.red,//Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                    boxShadow: boxShadowTwo,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(top: 50, bottom: 10),
                                    shrinkWrap: true,
                                    // physics: BouncingScrollPhysics(),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 8,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 32,
                                        child: CheckboxListTile(
                                          dense: true,
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
                                              categoryListToDisplay.clear();
                                              for(int i =0 ;i<categoryBoolList.length;i++){
                                                if(categoryBoolList[i]){
                                                  categoryListToDisplay.add(category[i]);
                                                }
                                              }
                                              if(categoryListToDisplay.length == 0){
                                                categoryDisplayAsHint= "Category";
                                              }else{
                                                categoryDisplayAsHint= categoryListToDisplay.toString().substring(1,categoryListToDisplay.toString().length-1);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (showCategoryList) {
                                setState(() {
                                  showCategoryList = false;
                                  showTimingList = false;
                                });
                              } else {
                                setState(() {
                                  showCategoryList = true;
                                  showTimingList = false;
                                });
                              }
                              print("clicked - $showCategoryList");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: boxShadowTwo,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    const IconData(0xe903,
                                        fontFamily: 'newcustomfonts'),
                                    color: Color(0xff1c2843),
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(top: 15, bottom: 15),
                                        child: Text(
                                          categoryDisplayAsHint,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: timingsListToDisplay.length == 0 ? Colors.grey[400]: themeBlueColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: boxShadowTwo,
                        ),
                        child: TextField(
                          controller: descriptionController,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey[400]),
                            hintText: 'Short Description',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      )),
    );
  }
}
