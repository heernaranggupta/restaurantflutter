import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderingsystem/Components/CBottomBarButton.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CDropdownRow.dart';
import 'package:orderingsystem/Components/CGridView.dart';
import 'package:orderingsystem/Components/CIconData.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Components/CTextField.dart';
import 'package:orderingsystem/Components/CUploadBottomSheet.dart';
import 'package:orderingsystem/Components/dialog_box.dart';
import 'package:orderingsystem/Components/show_error_dialog.dart';
import 'package:orderingsystem/Models/Category.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Models/Ingredients.dart';
import 'package:orderingsystem/Screens/s_home.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SEditItems extends StatefulWidget {
  static const routeName = 'edit-items';
  final String foodId;
  SEditItems({this.foodId});

  @override
  _SEditItemsState createState() => _SEditItemsState();
}

class _SEditItemsState extends State<SEditItems> {
  //Fields Which Will Be Send To The Firebase

  Map _choosenIngredients = {};
  Map _choosenExtraIngredients = {};
  List<String> _choosenCategories = [];
  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _moreInfoController = TextEditingController();
  TextEditingController _foodPriceController = TextEditingController();
  TextEditingController _shortDescriptionController = TextEditingController();

  bool isTimingExpanded = true;
  bool isCategoryExpanded = true;
  bool isIngredientsExpanded = true;
  bool isExtraIngredientsExpanded = true;

  bool isAddCategory = false;
  bool isAddIngredients = false;
  bool isAddExtraIngredient = false;

  Map _timingToDisplay = {};
  List<String> _categoriesToDisplay = [];
  List<Ingredients> _ingredientsToDisplay = [];
  List<Ingredients> _extraIngredientsToDisplay = [];

  List<Categories> _categoriesList = [];
  List<Ingredients> _ingredientsList = [];
  List<Ingredients> _extraIngredientsList = [];

  FoodItem foodItem;
  File _choosenFile0;
  File _choosenFile1;
  File _choosenFile2;
  File _choosenFile3;

  String _categoryImageURL;
  File _categoryFile;

  bool _isLoading = false;

  TextEditingController _addCategoryNameController = TextEditingController();
  TextEditingController _addIngredientNameController = TextEditingController();
  TextEditingController _addExtraIngredientNameController =
      TextEditingController();
  TextEditingController _addExtraIngredientPriceController =
      TextEditingController();

  @override
  void initState() {
    getItemData();
    super.initState();
  }

  getItemData() async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
    });

    foodItem = await FoodItem().getFoodItemById(widget.foodId);

    await firestoreInstance
        .collection('Categories')
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              _categoriesList.add(Categories.fromJson(result.data()));
            }))
        .catchError((error) {
      print(error);
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

    foodItem.timing.forEach((key, value) {
      if (value == true) {
        _timingToDisplay.putIfAbsent(key, () => value);
      }
    });

    foodItem.category.forEach((value) {
      _categoriesList.forEach((element) {
        if (element.categoryId == value) {
          element.value = true;
          _choosenCategories.add(value);
          _categoriesToDisplay.add(element.categoryName);
        }
      });
    });

    foodItem.ingredients.forEach((key, value) {
      _ingredientsList.forEach((element) {
        if (element.id == key) {
          element.value = true;
          _ingredientsToDisplay.add(element);
          _choosenIngredients.putIfAbsent(key, () => value);
        }
      });
    });

    foodItem.optional.forEach((key, value) {
      _extraIngredientsList.forEach((element) {
        if (element.id == key) {
          element.value = true;
          _extraIngredientsToDisplay.add(element);
          _choosenExtraIngredients.putIfAbsent(key, () => value);
        }
      });
    });
    _foodNameController.text = foodItem.foodName;
    _foodPriceController.text = foodItem.price;
    _shortDescriptionController.text = foodItem.description;
    _moreInfoController.text = foodItem.moreInfo;
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
                choosenFile: imageCount == 0
                    ? _choosenFile0
                    : imageCount == 1
                        ? _choosenFile1
                        : imageCount == 2
                            ? _choosenFile2
                            : imageCount == 3
                                ? _choosenFile3
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
        child: imageCount == 0
            ? buildClipRRect(_choosenFile0, imageCount)
            : imageCount == 1
                ? buildClipRRect(_choosenFile1, imageCount)
                : imageCount == 2
                    ? buildClipRRect(_choosenFile2, imageCount)
                    : imageCount == 3
                        ? buildClipRRect(_choosenFile3, imageCount)
                        : buildClipRRectForCategory(_categoryFile),
      ),
    );
  }

  Container buildClipRRectForCategory(File file) {
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

  dynamic _chooseImage(ImageSource source, int imageCount) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: source).catchError((error) {
      print(error);
    });
    if (imageFile != null) {
      setState(() {
        if (imageCount == 0) {
          _choosenFile0 = File(imageFile.path);
          foodItem.imageUrl[0] = null;
        } else if (imageCount == 1) {
          _choosenFile1 = File(imageFile.path);
          foodItem.imageUrl[1] = null;
        } else if (imageCount == 2) {
          _choosenFile2 = File(imageFile.path);
          foodItem.imageUrl[2] = null;
        } else if (imageCount == 3) {
          _choosenFile3 = File(imageFile.path);
          foodItem.imageUrl[3] = null;
        } else if (imageCount == 4) {
          _categoryFile = File(imageFile.path);
        }
      });
    }
  }

  void _removeFile(int imageCount) {
    setState(() {
      imageCount == 0
          ? _choosenFile0 = null
          : imageCount == 1
              ? _choosenFile1 = null
              : imageCount == 2
                  ? _choosenFile2 = null
                  : imageCount == 3
                      ? _choosenFile3 = null
                      : _categoryFile = null;
    });
  }

  Container buildClipRRect(File file, int index) {
    return Container(
      child: foodItem.imageUrl[index] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: CachedNetworkImageProvider(
                  foodItem.imageUrl[index],
                ),
                fit: BoxFit.cover,
              ))
          : foodItem.imageUrl[index] == null && file != null
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

  Future<dynamic> putFile(File file) async {
    FirebaseStorage storageInstance = FirebaseStorage.instance;

    Reference ref =
        storageInstance.ref().child('foods_images_uploaded/${DateTime.now()}');
    print(ref);
    TaskSnapshot data = await ref.putFile(file);
    print(data.state);
    if (data.state == TaskState.success) {
      String imageURL = await data.ref.getDownloadURL();
      return imageURL;
    }
    return null;
  }

  void _addItem() async {
    if (foodItem.imageUrl[0] == null) {
      showErrorDialog('Please upload atleast 1 image.', context);
      return;
    }

    if (_foodNameController.text.isEmpty) {
      showErrorDialog('Please provide food item name!', context);
      return;
    }

    if (_foodPriceController.text.isEmpty) {
      showErrorDialog('Please provide the price of the item!', context);
      return;
    }

    if (_choosenCategories.isEmpty) {
      showErrorDialog('Please choose categories', context);
      return;
    }
    if (_choosenIngredients.isEmpty) {
      showErrorDialog('Please choose included ingredients', context);
      return;
    }

    if (_shortDescriptionController.text.isEmpty) {
      showErrorDialog('Please provide a description!', context);
      return;
    }

    if (_moreInfoController.text.isEmpty) {
      showErrorDialog('Please provide more information!', context);
      return;
    }

    setState(() {
      _choosenExtraIngredients.isNotEmpty
          ? foodItem.isCustomizable = true
          : foodItem.isCustomizable = false;
      _isLoading = true;
    });

    if (_choosenFile0 != null) {
      foodItem.imageUrl[0] = await putFile(_choosenFile0);
    }
    if (_choosenFile1 != null) {
      foodItem.imageUrl[1] = await putFile(_choosenFile1);
    }
    if (_choosenFile2 != null) {
      foodItem.imageUrl[2] = await putFile(_choosenFile2);
    }
    if (_choosenFile3 != null) {
      foodItem.imageUrl[3] = await putFile(_choosenFile3);
    }

    if (_choosenExtraIngredients.isNotEmpty) {
      _choosenExtraIngredients.updateAll((key, value) => value = false);
    }

    foodItem.foodName = _foodNameController.text.trim();
    foodItem.price = _foodPriceController.text.trim();
    foodItem.category = _choosenCategories;
    foodItem.ingredients = _choosenIngredients;
    foodItem.optional = _choosenExtraIngredients;
    foodItem.description = _shortDescriptionController.text.trim();
    foodItem.moreInfo = _moreInfoController.text.trim();

    Provider.of<FoodItem>(context, listen: false)
        .updateFoodItem(foodItem)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          SHome.routeName, ModalRoute.withName(SHome.routeName));
    }).catchError((error) {
      print(error);
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

  Icon buildIcon(Size mediaQuery, {@required IconData icon}) {
    return Icon(
      icon,
      size: mediaQuery.width * 0.08,
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

  SizedBox buildHeightSizedBox(Size mediaQuery) =>
      SizedBox(height: mediaQuery.height * 0.02);

  SizedBox buildWidthSizedBox(Size mediaQuery) =>
      SizedBox(width: mediaQuery.width * 0.04);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
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
                title: CText(text: 'Edit Item'),
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
                              child: buildImageBox(context, mediaQuery, 0),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildBoolBox(
                                          value: foodItem.isSpecial,
                                          mediaQuery: mediaQuery,
                                          title: 'Special',
                                          onTap: () {
                                            setState(() {
                                              foodItem.isSpecial =
                                                  !foodItem.isSpecial;
                                            });
                                          },
                                        ),
                                      ),
                                      buildWidthSizedBox(mediaQuery),
                                      Expanded(
                                        child: buildBoolBox(
                                          value: foodItem.isVeg,
                                          mediaQuery: mediaQuery,
                                          title: 'Veg',
                                          onTap: () {
                                            setState(() {
                                              foodItem.isVeg = !foodItem.isVeg;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  buildHeightSizedBox(mediaQuery),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildBoolBox(
                                          value: foodItem.isAvailable,
                                          mediaQuery: mediaQuery,
                                          title: 'Available',
                                          onTap: () {
                                            setState(() {
                                              foodItem.isAvailable =
                                                  !foodItem.isAvailable;
                                            });
                                          },
                                        ),
                                      ),
                                      buildWidthSizedBox(mediaQuery),
                                      Expanded(
                                        child: buildBoolBox(
                                          value: foodItem.isCustomizable,
                                          mediaQuery: mediaQuery,
                                          title: 'Customizable',
                                          onTap: () {
                                            setState(() {
                                              foodItem.isCustomizable =
                                                  !foodItem.isCustomizable;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
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
                              child: buildImageBox(context, mediaQuery, 1),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: buildImageBox(context, mediaQuery, 2),
                            ),
                            buildWidthSizedBox(mediaQuery),
                            Expanded(
                              child: buildImageBox(context, mediaQuery, 3),
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
                                    itemCount: foodItem.timing.length,
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 65,
                                        bottom: 10),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            foodItem.timing.update(
                                                foodItem.timing.keys
                                                    .elementAt(index), (value) {
                                              return value = !value;
                                            });
                                          });
                                        },
                                        child: CContainer(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          isBoxShadow: false,
                                          backgroundColor: foodItem
                                                  .timing.values
                                                  .elementAt(index)
                                              ? fontColor
                                              : appColor,
                                          child: CText(
                                            fontSize: 13,
                                            text: foodItem.timing.keys
                                                .elementAt(index),
                                            textColor: foodItem.timing.values
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
                                              _categoriesList
                                                  .forEach((element) {
                                                if (element.value) {
                                                  _choosenCategories
                                                      .add(element.categoryId);
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
                              buildImageBox(context, mediaQuery, 4,
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
                                              if (!_extraIngredientsList[index]
                                                  .value) {
                                                _ingredientsList[index].value =
                                                    !_ingredientsList[index]
                                                        .value;

                                                _choosenIngredients.clear();
                                                _ingredientsList
                                                    .forEach((element) {
                                                  if (element.value)
                                                    _choosenIngredients
                                                        .putIfAbsent(
                                                      element.id,
                                                      () => element.value,
                                                    );
                                                });
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => DialogBox(
                                                    title:
                                                        'Ingredient already added !',
                                                    isError: true,
                                                  ),
                                                );
                                              }
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
                                    title: 'Included Ingredients',
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
                                              if (!_ingredientsList[index]
                                                  .value) {
                                                _extraIngredientsList[index]
                                                        .value =
                                                    !_extraIngredientsList[
                                                            index]
                                                        .value;

                                                _choosenExtraIngredients
                                                    .clear();
                                                _extraIngredientsList
                                                    .forEach((element) {
                                                  if (element.value)
                                                    _choosenExtraIngredients
                                                        .putIfAbsent(
                                                            element.id,
                                                            () =>
                                                                element.value);
                                                });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => DialogBox(
                                                          title:
                                                              'Ingredient already added !',
                                                          isError: true,
                                                        ));
                                              }
                                              _choosenExtraIngredients
                                                      .isNotEmpty
                                                  ? foodItem.isCustomizable =
                                                      true
                                                  : foodItem.isCustomizable =
                                                      false;
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
                title: 'Update Item',
                onPressed: () {
                  _addItem();
                },
              ),
            ),
          );
  }
}
