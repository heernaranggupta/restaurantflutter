import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:orderingsystem/DatabaseOperation/FoodCollectionDatabase.dart';
import 'constants.dart';
import 'models/FoodItem.dart';

class FormToAddFoodItems extends StatefulWidget {
  @override
  _FormToAddFoodItemsState createState() => _FormToAddFoodItemsState();
}

class _FormToAddFoodItemsState extends State<FormToAddFoodItems> {


  Future _data;
  var ingredientWidgets = List<Widget>();
  final foodController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final moreInfoController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var timingBoolList = [false, false, false, false];
  List<String> timingsListToDisplay = List();
  List<bool> time=[false, false, false, false];
  var timingDisplayAsHint = "Timing";
  FirebaseStorage rf;
  CollectionReference ingredientlist = Firestore.instance.collection('Ingredients');
  Future getPosts() async{
    var firestore =Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Ingredients").getDocuments();
    return qn.documents;
  }
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
  var showIngredientsList = false;
  bool isSpecial = false;
  bool isQuantitative = false;
  bool isVeg = true;
  Row someColumn = Row(
    children: [],
  );
  Color themeBlueColor = Color(0xff1c2843);
  Color themeWhiteColor = Color(0xFFF5F5F5);
  UploadTask uploadTask;
  Map<String, bool> timing = {
    'Morning': false,
    'Afternoon': false,
    'Evening':false,
    'Night': false
  };
  // PickedFile _image;
  File _imageFile;
  List itemsList = [];
  Future _getIngredientsFromFirestore() async {

   await ingredientlist.getDocuments().then((querySnapshot){
     querySnapshot.documents.forEach((element){
      itemsList.add(element.data);
     });
   });
  }
  Future<String> uploadImage(var imageFile ) async {
    Reference ref = FirebaseStorage.instance.ref().child("foods_images_uploaded/${DateTime.now()}.jpg");
    await ref.putFile(imageFile) ;
    return await ref.getDownloadURL();
  }

  // var streamBuilder =
  Future chooseOrClickPicture(ImageSource source) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(
        source: source, imageQuality: 20);
    Navigator.pop(context);
    setState(() {
      _imageFile = File(image.path);
    });
  }
  Future addFoodItemToDataBase(BuildContext context) async{

    showCupertinoDialog(context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Uploading ! "),
        content: Container(
          child: Center(
            child:  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1c2843)),
                ),
            ),
        ),
      ),
      barrierDismissible: false,
    );
    await FoodCollectionDatabase().addData(imageFile: _imageFile, priceController: priceController,isQuantitative: isQuantitative,
        isVeg: isVeg,isSpecial: isSpecial,categoryListToDisplay: categoryListToDisplay
        ,descriptionController: descriptionController,foodController: foodController,
        timingsListToDisplay: timingsListToDisplay, moreInfoController:moreInfoController, timing: timing
    );
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("\ndata-----------------------------------------");
    var data =  FoodCollectionDatabase().fetchData();
    print("\ndata-----------------${data.toString()}");
    _getIngredientsFromFirestore();
    fetchDatabaseList();
    _data= getPosts();
  }
  fetchDatabaseList() async{
    dynamic resultant = await _getIngredientsFromFirestore();
    if(resultant==null)
      {
        print('Unable to retrieve');
      }else{
      setState(() {
        itemsList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('Ingredients').get().then((QuerySnapshot querySnapshot) => {querySnapshot.docs.forEach((doc) {
    print(doc["ingredient"]);
    })
    });

    final mediaQuery = MediaQuery.of(context).size;
    for (var comment in itemsList) {
      ingredientWidgets.add(Text(comment.text));
      print(comment.text);// TODO: Whatever layout you need for each widget.
    }
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
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0), child: Container(
            width: mediaQuery.width * 0.9,
            child:
            CupertinoButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Color(0xff1c2843),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6.0),
              // ),
              onPressed: () => addFoodItemToDataBase(context),//addData(),
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
                GestureDetector(
                    child: Icon(Icons.fastfood_sharp),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                ),
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
                                    ? Center(child: Icon(
                                  const IconData(0xe900,
                                      fontFamily: 'addimage'),
                                  color: Color(0xff1c2843),
                                  size: 22,
                                ),
                                  /*Text("Add Image")*/)
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
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
                                                width: mediaQuery.width / 3.5,
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
                                          ),
//                                          Container(
//                                            child: Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment.spaceAround,
//                                              children: [
//                                                //Icon(CupertinoIcons.left_chevron),
//                                                InkWell(
//                                                  onTap: () {
//                                                    setState(() {
//                                                      isQuantitative = false;
//                                                    });
//                                                  },
//                                                  child: Container(
//                                                      child: Center(
//                                                          child: Text(
//                                                    "Count",
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.bold,
//                                                        fontSize: 12,
//                                                        color: isQuantitative
//                                                            ? Color(0xff1c2843)
//                                                            : Color(0xFFF5F5F5)),
//                                                  ))),
//                                                ),
//                                                //  Icon(CupertinoIcons.right_chevron),
//                                              ],
//                                            ),
//                                            width: mediaQuery.width / 4,
//                                            height: 35,
//                                            decoration: BoxDecoration(
//                                              color: isQuantitative
//                                                  ? Color(0xFFF5F5F5)
//                                                  : Color(0xff1c2843),
//                                              borderRadius:
//                                                  BorderRadius.circular(6),
//                                              boxShadow: boxShadowTwo,
//                                            ),
//                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isVeg = true;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
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
                                                width: mediaQuery.width / 3.5,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //if(isSpecial==false)
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0),
                                      child: Container(
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
                                                  "Available",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: isSpecial
                                                          ? Color(0xff1c2843)
                                                          : Color(0xFFF5F5F5)),
                                                )),
                                                width: mediaQuery.width /1.65,
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
//                                          InkWell(
//                                            onTap: () {
//                                              setState(() {
//                                                isQuantitative = true;
//                                                print(
//                                                    "isQuantitative- $isQuantitative");
//                                              });
//                                            },
//                                            child: Container(
//                                              child: Row(
//                                                mainAxisAlignment:
//                                                    MainAxisAlignment.spaceAround,
//                                                crossAxisAlignment: CrossAxisAlignment.center,
//                                                children: [
//                                                  //Icon(CupertinoIcons.left_chevron),
//                                                  Container(
//                                                      child: Center(
//                                                          child: Text(
//                                                    "Quantity",
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.bold,
//                                                        fontSize: 12,
//                                                        color: isQuantitative
//                                                            ? Color(0xFFF5F5F5)
//                                                            : Color(0xff1c2843)),
//                                                  ))),
//                                                  // Icon(CupertinoIcons.right_chevron),
//                                                ],
//                                              ),
//                                              width: mediaQuery.width / 4,
//                                              height: 35,
//                                              decoration: BoxDecoration(
//                                                color: isQuantitative
//                                                    ? Color(0xff1c2843)
//                                                    : Color(0xFFF5F5F5),
//                                                borderRadius:
//                                                    BorderRadius.circular(6),
//                                                boxShadow: boxShadowTwo,
//                                              ),
//                                            ),
//                                          ),
//                                          InkWell(
//                                            onTap: () {
//                                              setState(() {
//                                                isVeg = false;
//                                              });
//                                            },
//                                            child: Container(
//                                              child: Center(
//                                                  child: Center(
//                                                      child: Text(
//                                                "Non\nVeg",
//                                                style: TextStyle(
//                                                    fontWeight: FontWeight.bold,
//                                                    fontSize: 12,
//                                                    color: isVeg
//                                                        ? themeBlueColor
//                                                        : themeWhiteColor),
//                                              ))),
//                                              width: mediaQuery.width / 9,
//                                              height: 35,
//                                              decoration: BoxDecoration(
//                                                color: isVeg
//                                                    ? themeWhiteColor
//                                                    : themeBlueColor,
//                                                borderRadius:
//                                                    BorderRadius.circular(6),
//                                                boxShadow: boxShadowTwo,
//                                              ),
//                                            ),
//                                          ),
                                          ],
                                        ),
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
                      Row(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                width: mediaQuery.width / 3.5,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: boxShadowTwo,
                                ),
                                child: _imageFile == null
                                    ? Center(child: Icon(
                                  const IconData(0xe900,
                                      fontFamily: 'addimage'),
                                  color: Color(0xff1c2843),
                                  size: 22,
                                ),
                                  /*Text("Add Image")*/)
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
                            ),
                            onTap: () => showCupertinoModalPopup(
                                context: context,
                                builder: (context) => actionsheet),
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                width: mediaQuery.width / 3.5,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: boxShadowTwo,
                                ),
                                child: _imageFile == null
                                    ? Center(child: Icon(
                                  const IconData(0xe900,
                                      fontFamily: 'addimage'),
                                  color: Color(0xff1c2843),
                                  size: 22,
                                ),
                                  /*Text("Add Image")*/)
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
                            ),
                            onTap: () => showCupertinoModalPopup(
                                context: context,
                                builder: (context) => actionsheet),
                          ),
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
                                  ? Center(child: Icon(
                                const IconData(0xe900,
                                    fontFamily: 'addimage'),
                                color: Color(0xff1c2843),
                                size: 22,
                              ),
                                /*Text("Add Image")*/)
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
                        ],
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
                              Icons.restaurant_menu,
                              color: themeBlueColor
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
                                  itemCount: timings.length,
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
                                                timing[timings[i]]=true;
//                                                print(map[timings[i]]);
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
                                        child:
                                        CheckboxListTile(
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
                                  Icon(Icons.calendar_view_day_outlined),
                                  // Icon(
                                  //   const IconData(0xe903,
                                  //       fontFamily: 'newcustomfonts'),
                                  //   color: Color(0xff1c2843),
                                  //   size: 22,
                                  // ),
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
                                              color: categoryListToDisplay.length == 0 ? Colors.grey[400]: themeBlueColor),
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
                      SizedBox(height: 20),
                      Stack(
                        children: [
                          if (showIngredientsList)
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
                                  child:  SizedBox(
                                        height: 32,
                                        child: Column(

                                          children: <Widget>[
                                            FutureBuilder(
                                              future: _data,
                                                builder: (context, snapshot){
                                              if(snapshot.connectionState == ConnectionState.waiting)
                                              {
                                                return Center(
                                                  child: Text("Loading"),
                                                );
                                              }
                                              else{
                                                return ListView.builder(
                                                  itemCount: snapshot.data.length,
                                                    itemBuilder: (context,index){
                                                    return ListTile(
                                                      title: Text(snapshot.data[index].data["ingredient"]),
                                                    );
                                                    });
                                              }
                                            }),

                                        /* StreamBuilder<DocumentSnapshot>(
                                            stream: ingredientlist.snapshots(),
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                      }else{
                                        Map<String, dynamic> data = snapshot.data.data();
                                              return new ListView(
                                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                              return new ListTile(

                                              title: new Text(document.data().toString()),
                                              subtitle: new Text(document.data()['ingredientId'].toString()),
                                              );
                                              }).toList(),
                                              );
                                      }
                                        },
                                      ),*/

//                                            StreamBuilder(
//                                              stream: Firestore.instance.collection('Ingredients').snapshots(),
//                                              builder: (context, snapshot){
//                                                          if (!snapshot.hasData) {
//                                                          return Center(
//                                                             child: CircularProgressIndicator(),
//                                                          );
//                                                          }
//
//                                                          return ListView(
//                                                          children: snapshot.data.docs.map((document) {
//                                                             return Container(
//                                                                     child: Center(child: Text(document['ingredient'])),
//                                                          );
//                                                          }).toList(),
//                                                          );
//    );
//                                              }
                                     ],
                                        )
                                      ),

                                  )),

                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (showIngredientsList) {
                                setState(() {
                                  showIngredientsList = false;
                                  showTimingList = false;
                                });
                              } else {
                                setState(() {
                                  showIngredientsList = true;
                                  showTimingList = false;
                                });
                              }
                              print("clicked - $showIngredientsList");
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
                                  Icon(Icons.calendar_view_day_outlined),
                                  // Icon(
                                  //   const IconData(0xe903,
                                  //       fontFamily: 'newcustomfonts'),
                                  //   color: Color(0xff1c2843),
                                  //   size: 22,
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                        child: Text(
                                          "Ingredients",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: categoryListToDisplay.length == 0 ? Colors.grey[400]: themeBlueColor),
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
                      SizedBox(height: 20),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: boxShadowTwo,
                        ),
                        child: TextField(
                          controller: moreInfoController,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintStyle:
                            TextStyle(fontSize: 14, color: Colors.grey[400]),
                            hintText: 'More Info',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
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
