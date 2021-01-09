import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orderingsystem/Components/CDropdownRow.dart';
import 'package:orderingsystem/Components/CGridView.dart';
import 'package:orderingsystem/Components/CIconData.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Components/CTextField.dart';
import 'package:orderingsystem/Components/dialog_box.dart';
import 'package:orderingsystem/Models/Category.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Models/Ingredients.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:orderingsystem/Screens/s_home.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../Components/CText.dart';
import '../Components/CContainer.dart';
import '../Components/CBottomBarButton.dart';
import '../Components/CUploadBottomSheet.dart';

class SAddItems extends StatefulWidget {
  static const routeName = 'add-items';
  @override
  _SAddItemsState createState() => _SAddItemsState();
}

class _SAddItemsState extends State<SAddItems> {
  //Fields Which Will Be Send To The Firebase
  bool _isVeg = true;
  bool _isSpecial = false;
  bool _isAvailable = false;
  String _firstImageURL;
  String _secondImageURL;
  String _thirdImageURL;
  String _fourthImageURL;
  Map _choosentiming = {
    "Morning": false,
    "Afternoon": false,
    "Evening": false,
    "Night": false,
  };
  Map _choosenIngredients = {};
  List<String> _choosenCategories = [];
  Map _choosenExtraIngredients = {};
  TextEditingController _foodPriceController = TextEditingController();
  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _moreInfoController = TextEditingController();
  TextEditingController _shortDescriptionController = TextEditingController();

  File _choosenFile1;
  File _choosenFile2;
  File _choosenFile3;
  File _choosenFile4;
  File _categoryFile;

  String _categoryImageURL;

  bool _isLoading = false;

  bool isTimingExpanded = true;
  bool isCategoryExpanded = true;
  bool isIngredientsExpanded = true;
  bool isExtraIngredientsExpanded = true;

  bool isAddCategory = false;
  bool isAddIngredients = false;
  bool isAddExtraIngredient = false;

  TextEditingController _addCategoryNameController = TextEditingController();
  TextEditingController _addIngredientNameController = TextEditingController();
  TextEditingController _addExtraIngredientNameController =
      TextEditingController();
  TextEditingController _addExtraIngredientPriceController =
      TextEditingController();

  List<Categories> _categoriesList = [];
  List<Ingredients> _ingredientsList = [];
  List<Ingredients> _extraIngredientsList = [];

  Map _timingToDisplay = {};
  List<String> _categoriesToDisplay = [];
  List<Ingredients> _ingredientsToDisplay = [];
  List<Ingredients> _extraIngredientsToDisplay = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
    });
    await firestoreInstance
        .collection("Ingredients")
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              _ingredientsList.add(Ingredients.fromJson(result.data()));
              _extraIngredientsList.add(Ingredients.fromJson(result.data()));
            }))
        .catchError((error) {
      print(error);
    });

    await firestoreInstance
        .collection('Categories')
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              _categoriesList.add(Categories.fromJson(result.data()));
            }))
        .catchError((error) {
      print(error);
    });

    setState(() {
      _isLoading = false;
    });
  }

  void addCategoryToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    var id;
    var isExist;
    CollectionReference categoryCollection =
        FirebaseFirestore.instance.collection('Categories');

    if (_addCategoryNameController.text.isNotEmpty) {
      isExist = _categoriesList.firstWhere(
          (element) =>
              element.categoryName == _addCategoryNameController.text.trim(),
          orElse: () {
        return null;
      });
    } else {
      print('TextField or Image Empty');
    }

    if (_categoryFile != null &&
        _addCategoryNameController.text.isNotEmpty &&
        isExist == null) {
      FirebaseStorage storageInstance = FirebaseStorage.instance;
      Reference ref = storageInstance
          .ref()
          .child('cat_icon/${_addCategoryNameController.text.trim()}');
      print(ref);
      var data = await ref.putFile(_categoryFile);
      print(data.state);
      if (data.state == TaskState.success) {
        _categoryImageURL = await data.ref.getDownloadURL();
        await categoryCollection.add({
          'categoryName': _addCategoryNameController.text.trim(),
          'imgUrl': _categoryImageURL
        }).then((value) async {
          id = value.id;
          await categoryCollection
              .doc(value.id)
              .update({'categoryId': value.id})
              .then((value) => print('Successss!!!'))
              .then((value) async => await categoryCollection
                      .doc(id)
                      .get()
                      .then((querySnapshot) => querySnapshot.data())
                      .then((value) {
                    _categoriesList.add(Categories.fromJson(value));
                  }))
              .catchError((error) {
                print(error);
              });
        });
        _categoryFile = null;
        _categoryImageURL = null;
        _addCategoryNameController.clear();
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addIngredientToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    var id;
    var isExist;
    CollectionReference ingredientCollection =
        FirebaseFirestore.instance.collection('Ingredients');
    if (_addIngredientNameController.text.isNotEmpty) {
      isExist = _ingredientsList.firstWhere(
          (element) => element.name == _addIngredientNameController.text.trim(),
          orElse: () {
        return null;
      });
    } else {
      print('Empty Text Field');
    }
    if (_addIngredientNameController.text.isNotEmpty && isExist == null) {
      await ingredientCollection.add({
        'ingredient': _addIngredientNameController.text.trim(),
        'price': null
      }).then((value) async {
        id = value.id;
        await ingredientCollection
            .doc(value.id)
            .update({"ingredientId": value.id})
            .then((value) => print('successs!!!!'))
            .then((value) async => await ingredientCollection
                    .doc(id)
                    .get()
                    .then((querySnapshot) => querySnapshot.data())
                    .then((value) {
                  _ingredientsList.add(Ingredients.fromJson(value));
                  _extraIngredientsList.add(Ingredients.fromJson(value));
                }))
            .catchError((error) {
              print(error);
            });
        _addIngredientNameController.clear();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addExtraIngredientToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference ingredientCollection =
        FirebaseFirestore.instance.collection('Ingredients');
    if (_addExtraIngredientNameController.text.isNotEmpty &&
        _addExtraIngredientPriceController.text.isNotEmpty) {
      var selected = _extraIngredientsList.firstWhere(
          (result) => result.name == _addExtraIngredientNameController.text,
          orElse: () {
        return null;
      });
      if (selected != null) {
        await ingredientCollection.doc(selected.id).update(
            {'price': _addExtraIngredientPriceController.text}).then((_) {
          print('Successss!');
          _extraIngredientsList.forEach((result) {
            if (result.name == selected.name) {
              result.price = _addExtraIngredientPriceController.text;
            }
          });
          _addExtraIngredientNameController.clear();
          _addExtraIngredientPriceController.clear();
        }).catchError((error) {
          print(error);
        });
      } else {
        var id;
        await ingredientCollection.add({
          'ingredient': _addExtraIngredientNameController.text.trim(),
          'price': _addExtraIngredientPriceController.text.trim(),
        }).then((value) async {
          id = value.id;
          await ingredientCollection
              .doc(value.id)
              .update({"ingredientId": value.id})
              .then((value) => print('successs!!!!'))
              .then((value) async => await ingredientCollection
                  .doc(id)
                  .get()
                  .then((querySnapshot) => querySnapshot.data())
                  .then((value) =>
                      _extraIngredientsList.add(Ingredients.fromJson(value))))
              .catchError((error) {
                print(error);
              });
          _addExtraIngredientNameController.clear();
          _addExtraIngredientPriceController.clear();
        });
      }
    } else {
      print('Empty Field');
    }
    setState(() {
      _isLoading = false;
    });
  }

  GestureDetector buildImageBox(
      BuildContext context, Size mediaQuery, int imageCount,
      {double height, double width}) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            context: context,
            builder: (context) {
              return CUploadBottomSheet(
                chooseImage: _chooseImage,
                choosenFile: imageCount == 1
                    ? _choosenFile1
                    : imageCount == 2
                        ? _choosenFile2
                        : imageCount == 3
                            ? _choosenFile3
                            : imageCount == 4
                                ? _choosenFile4
                                : _categoryFile,
                removeFile: _removeFile,
                imageCount: imageCount,
              );
            });
      },
      child: CContainer(
        width: width,
        height: height ?? mediaQuery.height * 0.15,
        borderRadius: BorderRadius.circular(15),
        alignment: null,
        child: imageCount == 1
            ? buildClipRRect(_choosenFile1)
            : imageCount == 2
                ? buildClipRRect(_choosenFile2)
                : imageCount == 3
                    ? buildClipRRect(_choosenFile3)
                    : imageCount == 4
                        ? buildClipRRect(_choosenFile4)
                        : buildClipRRect(_categoryFile),
      ),
    );
  }

  dynamic _chooseImage(ImageSource source, int imageCount) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: source);
    if (imageFile != null) {
      setState(() {
        imageCount == 1
            ? _choosenFile1 = File(imageFile.path)
            : imageCount == 2
                ? _choosenFile2 = File(imageFile.path)
                : imageCount == 3
                    ? _choosenFile3 = File(imageFile.path)
                    : imageCount == 4
                        ? _choosenFile4 = File(imageFile.path)
                        : _categoryFile = File(imageFile.path);
      });
    }
  }

  void _removeFile(int imageCount) {
    setState(() {
      imageCount == 1
          ? _choosenFile1 = null
          : imageCount == 2
              ? _choosenFile2 = null
              : imageCount == 3
                  ? _choosenFile3 = null
                  : imageCount == 4
                      ? _choosenFile4 = null
                      : _categoryFile = null;
    });
  }

  Container buildClipRRect(File file) {
    return Container(
      child: file != null
          ? ClipRRect(
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            )
          : CIconData(fontFamily: 'addIcon', codePoint: 0xe900),
    );
  }

  showErrorDialog(String title) {
    showCupertinoDialog(
        context: context,
        builder: (context) => DialogBox(
              title: title,
              isError: true,
            ));
  }

  Future<dynamic> putFile(File file) async {
    FirebaseStorage storageInstance = FirebaseStorage.instance;

    Reference ref =
        storageInstance.ref().child('foods_images_uploaded/${DateTime.now()}');
    print(ref);
    TaskSnapshot data = await ref.putFile(file).catchError((error) {
      print(error);
    });
    print('--------------');
    print(data.state);
    if (data.state == TaskState.success) {
      String imageURL = await data.ref.getDownloadURL();
      return imageURL;
    }

    return null;
  }

  void _addItem() async {
    if (_choosenFile1 == null ||
        _choosenFile2 == null ||
        _choosenFile3 == null ||
        _choosenFile4 == null) {
      showErrorDialog('Please upload all the four images of the item!');
      return;
    }

    if (_foodNameController.text.isEmpty) {
      showErrorDialog('Please provide food item name!');
      return;
    }

    if (_foodPriceController.text.isEmpty) {
      showErrorDialog('Please provide the price of the item!');
      return;
    }

    if (_shortDescriptionController.text.isEmpty) {
      showErrorDialog('Please provide a description!');
      return;
    }

    if (_moreInfoController.text.isEmpty) {
      showErrorDialog('Please provide more information!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _firstImageURL = await putFile(_choosenFile1);
    _secondImageURL = await putFile(_choosenFile2);
    _thirdImageURL = await putFile(_choosenFile3);
    _fourthImageURL = await putFile(_choosenFile4);

    FoodItem foodItem = FoodItem(
      foodName: _foodNameController.text.trim(),
      price: _foodPriceController.text.trim(),
      description: _shortDescriptionController.text.trim(),
      moreInfo: _moreInfoController.text.trim(),
      isVeg: _isVeg,
      isSpecial: _isSpecial,
      isAvailable: _isAvailable,
      imageUrl: [
        _firstImageURL,
        _secondImageURL,
        _thirdImageURL,
        _fourthImageURL,
      ],
      category: _choosenCategories,
      ingredients: _choosenIngredients,
      optional: _choosenExtraIngredients,
      timing: _choosentiming,
    );

    Provider.of<FoodItem>(context, listen: false)
        .addFoodItem(foodItem)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          SHome.routeName, ModalRoute.withName(SHome.routeName));
    }).catchError((error) {
      print(error);
    });

    setState(() {
      _isLoading = false;
    });
  }

  GestureDetector buildBoolBox(
      {Size mediaQuery, String title, Function onTap, bool value}) {
    return GestureDetector(
      onTap: onTap,
      child: CContainer(
        height: mediaQuery.height * 0.065,
        borderRadius: BorderRadius.circular(10),
        backgroundColor: value ? fontColor : appColor,
        child: CText(
          text: title,
          textColor: value ? Colors.white : fontColor,
        ),
      ),
    );
  }

  CContainer buildGridContainer(
      {bool isBoxShadow = true, @required Widget child, double width}) {
    return CContainer(
      height: null,
      width: width ?? MediaQuery.of(context).size.width,
      isBoxShadow: isBoxShadow,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      child: child,
    );
  }

  CContainer buildCContainer(
      {Widget child,
      double width,
      double height = 55,
      double circularBorderRadius = 30}) {
    return CContainer(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(circularBorderRadius),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: child,
    );
  }

  SizedBox buildHeightSizedBox(Size mediaQuery) =>
      SizedBox(height: mediaQuery.height * 0.02);

  SizedBox buildWidthSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.04);

  Icon buildIcon(Size mediaQuery, {@required IconData icon}) {
    return Icon(
      icon,
      size: mediaQuery.width * 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaQuery = MediaQuery.of(context).size;

    return _isLoading
        ? CLoadingIndicator()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: CText(text: 'Add Item'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: CupertinoScrollbar(
                controller: ScrollController(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: mediaQuery.width * 0.3,
                              height: mediaQuery.height * 0.15,
                              child: buildImageBox(context, mediaQuery, 1),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildBoolBox(
                                          value: _isSpecial,
                                          mediaQuery: mediaQuery,
                                          title: 'Special',
                                          onTap: () {
                                            setState(() {
                                              _isSpecial = !_isSpecial;
                                            });
                                          },
                                        ),
                                      ),
                                      buildWidthSizedBox(mediaQuery),
                                      Expanded(
                                        child: buildBoolBox(
                                          value: _isVeg,
                                          mediaQuery: mediaQuery,
                                          title: 'Veg',
                                          onTap: () {
                                            setState(() {
                                              _isVeg = !_isVeg;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  buildHeightSizedBox(mediaQuery),
                                  buildBoolBox(
                                    value: _isAvailable,
                                    mediaQuery: mediaQuery,
                                    title: 'Available',
                                    onTap: () {
                                      setState(() {
                                        _isAvailable = !_isAvailable;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buildHeightSizedBox(mediaQuery),
                        Row(
                          children: [
                            Expanded(
                              child: buildImageBox(context, mediaQuery, 2),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: buildImageBox(context, mediaQuery, 3),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: buildImageBox(context, mediaQuery, 4),
                            ),
                          ],
                        ),
                        buildHeightSizedBox(mediaQuery),
                        buildCContainer(
                          child: CTextField(
                            hintText: 'Food Name',
                            controller: _foodNameController,
                            leading: CIconData(
                                codePoint: 0xe900, fontFamily: 'foodIcon'),
                          ),
                        ),
                        buildHeightSizedBox(mediaQuery),
                        buildCContainer(
                          child: CTextField(
                            hintText: 'Price',
                            controller: _foodPriceController,
                            leading: CIconData(
                                codePoint: 0xe900, fontFamily: 'rupeesIcon'),
                          ),
                        ),
                        buildHeightSizedBox(mediaQuery),
                        Stack(
                          children: [
                            Offstage(
                              offstage: isTimingExpanded,
                              child: buildGridContainer(
                                child: CGridView(
                                    itemCount: _choosentiming.length,
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 65,
                                        bottom: 10),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _choosentiming.update(
                                                _choosentiming.keys
                                                    .elementAt(index), (value) {
                                              return value = !value;
                                            });
                                            _timingToDisplay.clear();
                                            _choosentiming
                                                .forEach((key, value) {
                                              if (value == true) {
                                                _timingToDisplay.putIfAbsent(
                                                    key, () => value);
                                              }
                                            });
                                          });
                                        },
                                        child: CContainer(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          isBoxShadow: false,
                                          backgroundColor: _choosentiming.values
                                                  .elementAt(index)
                                              ? fontColor
                                              : appColor,
                                          child: CText(
                                            fontSize: 13,
                                            text: _choosentiming.keys
                                                .elementAt(index),
                                            textColor: _choosentiming.values
                                                    .elementAt(index)
                                                ? Colors.white
                                                : fontColor,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            buildCContainer(
                              child: CDropdownRow(
                                title: 'Timing',
                                codePoint: 0xe901,
                                isExpanded: isTimingExpanded,
                                fontFamily: 'timingFilterIcon',
                                onTap: () {
                                  setState(() {
                                    isTimingExpanded = !isTimingExpanded;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        if (_timingToDisplay.isNotEmpty)
                          buildHeightSizedBox(mediaQuery),
                        if (_timingToDisplay.isNotEmpty)
                          buildGridContainer(
                            isBoxShadow: false,
                            child: CGridView(
                              itemCount: _timingToDisplay.length,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return CContainer(
                                  borderRadius: BorderRadius.circular(30),
                                  backgroundColor: fontColor,
                                  child: CText(
                                    fontSize: 13,
                                    text:
                                        _timingToDisplay.keys.elementAt(index),
                                    textColor: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        buildHeightSizedBox(mediaQuery),
                        Stack(
                          children: [
                            Offstage(
                              offstage: isCategoryExpanded,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: buildGridContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CGridView(
                                      itemCount: _categoriesList.length,
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 65,
                                          bottom: 10),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _categoriesList[index].value =
                                                  !_categoriesList[index].value;

                                              _choosenCategories.clear();
                                              _categoriesToDisplay.clear();
                                              _categoriesList
                                                  .forEach((element) {
                                                if (element.value) {
                                                  _choosenCategories
                                                      .add(element.categoryId);
                                                  _categoriesToDisplay.add(
                                                      element.categoryName);
                                                }
                                              });
                                            });
                                          },
                                          child: CContainer(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            isBoxShadow: false,
                                            backgroundColor:
                                                _categoriesList[index].value
                                                    ? fontColor
                                                    : appColor,
                                            child: CText(
                                              fontSize: 13,
                                              textAlign: TextAlign.center,
                                              text: _categoriesList[index]
                                                  .categoryName,
                                              textColor:
                                                  _categoriesList[index].value
                                                      ? Colors.white
                                                      : fontColor,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                buildCContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CDropdownRow(
                                    title: 'Categories',
                                    codePoint: 0xe902,
                                    isExpanded: isCategoryExpanded,
                                    fontFamily: 'dashboardIcon',
                                    onTap: () {
                                      setState(() {
                                        isCategoryExpanded =
                                            !isCategoryExpanded;
                                      });
                                    },
                                  ),
                                ),
                                buildWidthSizedBox(mediaQuery),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAddCategory = !isAddCategory;
                                      });
                                    },
                                    child: buildIcon(mediaQuery,
                                        icon: CupertinoIcons.plus_circle_fill),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (isAddCategory) buildHeightSizedBox(mediaQuery),
                        if (isAddCategory)
                          Row(
                            children: [
                              buildImageBox(context, mediaQuery, 5,
                                  height: 55, width: mediaQuery.width * 0.2),
                              buildWidthSizedBox(mediaQuery),
                              Expanded(
                                child: buildCContainer(
                                  child: CTextField(
                                    hintText: 'Category Name',
                                    controller: _addCategoryNameController,
                                  ),
                                ),
                              ),
                              buildWidthSizedBox(mediaQuery),
                              GestureDetector(
                                onTap: () {
                                  addCategoryToFirebase();
                                },
                                child: buildIcon(mediaQuery,
                                    icon: CupertinoIcons
                                        .checkmark_alt_circle_fill),
                              )
                            ],
                          ),
                        if (_categoriesToDisplay.isNotEmpty)
                          buildHeightSizedBox(mediaQuery),
                        if (_categoriesToDisplay.isNotEmpty)
                          buildGridContainer(
                            width: mediaQuery.width,
                            isBoxShadow: false,
                            child: CGridView(
                              itemCount: _categoriesToDisplay.length,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return CContainer(
                                  borderRadius: BorderRadius.circular(30),
                                  backgroundColor: fontColor,
                                  child: CText(
                                    fontSize: 13,
                                    text: _categoriesToDisplay[index],
                                    textColor: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        buildHeightSizedBox(mediaQuery),
                        Stack(
                          children: [
                            Offstage(
                              offstage: isIngredientsExpanded,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: buildGridContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CGridView(
                                      width: mediaQuery.width * 0.8,
                                      itemCount: _ingredientsList.length,
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 65,
                                          bottom: 10),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _ingredientsList[index].value =
                                                  !_ingredientsList[index]
                                                      .value;

                                              _ingredientsToDisplay.clear();
                                              _ingredientsList
                                                  .forEach((element) {
                                                if (element.value) {
                                                  _ingredientsToDisplay
                                                      .add(element);
                                                }
                                              });
                                              _choosenIngredients.clear();
                                              _ingredientsToDisplay
                                                  .forEach((element) {
                                                _choosenIngredients.putIfAbsent(
                                                    element.id,
                                                    () => element.value);
                                              });
                                            });
                                          },
                                          child: CContainer(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            isBoxShadow: false,
                                            backgroundColor:
                                                _ingredientsList[index].value
                                                    ? fontColor
                                                    : appColor,
                                            child: CText(
                                              fontSize: 13,
                                              textAlign: TextAlign.center,
                                              text:
                                                  _ingredientsList[index].name,
                                              textColor:
                                                  _ingredientsList[index].value
                                                      ? Colors.white
                                                      : fontColor,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                buildCContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CDropdownRow(
                                    title: 'Ingredients',
                                    codePoint: 0xe901,
                                    isExpanded: isIngredientsExpanded,
                                    fontFamily: 'wrenchIcon',
                                    onTap: () {
                                      setState(() {
                                        isIngredientsExpanded =
                                            !isIngredientsExpanded;
                                      });
                                    },
                                  ),
                                ),
                                buildWidthSizedBox(mediaQuery),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAddIngredients = !isAddIngredients;
                                      });
                                    },
                                    child: buildIcon(mediaQuery,
                                        icon: CupertinoIcons.plus_circle_fill),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (isAddIngredients) buildHeightSizedBox(mediaQuery),
                        if (isAddIngredients)
                          Row(
                            children: [
                              Expanded(
                                child: buildCContainer(
                                  child: CTextField(
                                    hintText: 'Ingredient Name',
                                    controller: _addIngredientNameController,
                                  ),
                                ),
                              ),
                              buildWidthSizedBox(mediaQuery),
                              GestureDetector(
                                onTap: () {
                                  addIngredientToFirebase();
                                },
                                child: buildIcon(mediaQuery,
                                    icon: CupertinoIcons
                                        .checkmark_alt_circle_fill),
                              )
                            ],
                          ),
                        if (_ingredientsToDisplay.isNotEmpty)
                          buildHeightSizedBox(mediaQuery),
                        if (_ingredientsToDisplay.isNotEmpty)
                          buildGridContainer(
                            width: mediaQuery.width,
                            isBoxShadow: false,
                            child: CGridView(
                              isBoxShadow: false,
                              itemCount: _ingredientsToDisplay.length,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return CContainer(
                                  borderRadius: BorderRadius.circular(30),
                                  backgroundColor: fontColor,
                                  child: CText(
                                    fontSize: 13,
                                    text: _ingredientsToDisplay[index].name,
                                    textColor: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        buildHeightSizedBox(mediaQuery),
                        Stack(
                          children: [
                            Offstage(
                              offstage: isExtraIngredientsExpanded,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: buildGridContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CGridView(
                                      childAspectRatio: 1 / 0.5,
                                      itemCount: _extraIngredientsList.length,
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 65,
                                          bottom: 10),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _extraIngredientsList[index]
                                                      .value =
                                                  !_extraIngredientsList[index]
                                                      .value;

                                              _extraIngredientsToDisplay
                                                  .clear();
                                              _extraIngredientsList
                                                  .forEach((element) {
                                                if (element.value) {
                                                  _extraIngredientsToDisplay
                                                      .add(element);
                                                }
                                              });
                                              _choosenExtraIngredients.clear();
                                              _extraIngredientsToDisplay
                                                  .forEach((element) {
                                                _choosenExtraIngredients
                                                    .putIfAbsent(element.id,
                                                        () => element.value);
                                              });
                                              print(_choosenExtraIngredients);
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              CContainer(
                                                  height: null,
                                                  padding: EdgeInsets.only(
                                                      bottom: 2),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  isBoxShadow: false,
                                                  backgroundColor: fontColor
                                                      .withOpacity(0.35),
                                                  child: _extraIngredientsList[
                                                                  index]
                                                              .price !=
                                                          null
                                                      ? CText(
                                                          fontSize: 13,
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: 'Rs ' +
                                                              _extraIngredientsList[
                                                                      index]
                                                                  .price,
                                                          textColor: fontColor,
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isAddExtraIngredient =
                                                                  true;
                                                              _addExtraIngredientNameController
                                                                      .text =
                                                                  _extraIngredientsList[
                                                                          index]
                                                                      .name;
                                                            });
                                                          },
                                                          child: CText(
                                                            fontSize: 13,
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: 'Add Price',
                                                            textColor:
                                                                Colors.white,
                                                          ),
                                                        )),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 17),
                                                child: CContainer(
                                                  height: null,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  isBoxShadow: false,
                                                  backgroundColor:
                                                      _extraIngredientsList[
                                                                  index]
                                                              .value
                                                          ? fontColor
                                                          : appColor,
                                                  child: CText(
                                                    fontSize: 13,
                                                    textAlign: TextAlign.center,
                                                    text: _extraIngredientsList[
                                                            index]
                                                        .name,
                                                    textColor:
                                                        _extraIngredientsList[
                                                                    index]
                                                                .value
                                                            ? Colors.white
                                                            : fontColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                buildCContainer(
                                  width: mediaQuery.width * 0.8,
                                  child: CDropdownRow(
                                    title: 'Extra Ingredients',
                                    codePoint: 0xe900,
                                    iconSize: 13,
                                    isExpanded: isExtraIngredientsExpanded,
                                    fontFamily: 'extraIngredientsIcon',
                                    onTap: () {
                                      setState(() {
                                        isExtraIngredientsExpanded =
                                            !isExtraIngredientsExpanded;
                                      });
                                    },
                                  ),
                                ),
                                buildWidthSizedBox(mediaQuery),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAddExtraIngredient =
                                          !isAddExtraIngredient;
                                    });
                                  },
                                  child: buildIcon(mediaQuery,
                                      icon: CupertinoIcons.plus_circle_fill),
                                )),
                              ],
                            ),
                          ],
                        ),
                        if (isAddExtraIngredient)
                          buildHeightSizedBox(mediaQuery),
                        if (isAddExtraIngredient)
                          Row(
                            children: [
                              Expanded(
                                child: buildCContainer(
                                  child: CTextField(
                                    controller:
                                        _addExtraIngredientNameController,
                                    hintText: 'Ingredient Name',
                                  ),
                                ),
                              ),
                              buildWidthSizedBox(mediaQuery),
                              buildCContainer(
                                width: mediaQuery.width * 0.3,
                                child: CTextField(
                                  controller:
                                      _addExtraIngredientPriceController,
                                  hintText: 'Price',
                                ),
                              ),
                              buildWidthSizedBox(mediaQuery),
                              GestureDetector(
                                onTap: () async {
                                  addExtraIngredientToFirebase();
                                },
                                child: buildIcon(mediaQuery,
                                    icon: CupertinoIcons
                                        .checkmark_alt_circle_fill),
                              ),
                            ],
                          ),
                        if (_extraIngredientsToDisplay.isNotEmpty)
                          buildHeightSizedBox(mediaQuery),
                        if (_extraIngredientsToDisplay.isNotEmpty)
                          buildGridContainer(
                            isBoxShadow: false,
                            child: CGridView(
                              childAspectRatio: 1 / 0.45,
                              isBoxShadow: false,
                              itemCount: _extraIngredientsToDisplay.length,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    CContainer(
                                        height: null,
                                        padding: EdgeInsets.only(bottom: 2),
                                        alignment: Alignment.bottomCenter,
                                        borderRadius: BorderRadius.circular(13),
                                        isBoxShadow: false,
                                        backgroundColor:
                                            fontColor.withOpacity(0.35),
                                        child: _extraIngredientsToDisplay[index]
                                                    .price !=
                                                null
                                            ? CText(
                                                fontSize: 13,
                                                textAlign: TextAlign.center,
                                                text: 'Rs ' +
                                                    _extraIngredientsToDisplay[
                                                            index]
                                                        .price,
                                                textColor: fontColor,
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isAddExtraIngredient = true;
                                                    _addExtraIngredientNameController
                                                            .text =
                                                        _extraIngredientsToDisplay[
                                                                index]
                                                            .name;
                                                  });
                                                },
                                                child: CText(
                                                  fontSize: 13,
                                                  textAlign: TextAlign.center,
                                                  text: 'Add Price',
                                                  textColor: Colors.white,
                                                ),
                                              )),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 18),
                                      child: CContainer(
                                        height: null,
                                        borderRadius: BorderRadius.circular(30),
                                        isBoxShadow: false,
                                        backgroundColor: fontColor,
                                        child: CText(
                                          fontSize: 13,
                                          textAlign: TextAlign.center,
                                          text:
                                              _extraIngredientsToDisplay[index]
                                                  .name,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        buildHeightSizedBox(mediaQuery),
                        buildCContainer(
                          height: null,
                          circularBorderRadius: 15,
                          child: CTextField(
                            maxLines: 2,
                            hintText: 'Short Description',
                            controller: _shortDescriptionController,
                          ),
                        ),
                        buildHeightSizedBox(mediaQuery),
                        buildCContainer(
                          height: null,
                          circularBorderRadius: 15,
                          child: CTextField(
                            maxLines: 4,
                            hintText: 'More Info',
                            controller: _moreInfoController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: CBottomBarButton(
                title: 'Add Item',
                onPressed: () {
                  _addItem();
                },
              ),
            ),
          );
  }
}
