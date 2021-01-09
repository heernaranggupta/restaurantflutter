
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FoodItem with ChangeNotifier {
  static List<FoodItem> _allItems = [];
  List<FoodItem> get allItems {
    return [..._allItems];
  }

  static List<FoodItem> _specialItems = [];
  List<FoodItem> get specialItems {
    return [..._specialItems];
  }

  static List<FoodItem> _otherItems = [];
  List<FoodItem> get otherItems {
    return [..._otherItems];
  }

  static List<FoodItem> _itemsNotAvailable = [];
  List<FoodItem> get itemsNotAvailable {
    return [..._itemsNotAvailable];
  }

  FoodItem({
    this.ingredients,
    this.category,
    this.description,
    this.foodId,
    this.foodName,
    this.imageUrl,
    this.isAvailable,
    this.isSpecial,
    this.isVeg,
    this.moreInfo,
    this.optional,
    this.price,
    this.timing,
  });

  Map ingredients;
  List<dynamic> category;
  String description;
  String foodId;
  String foodName;
  List<dynamic> imageUrl;
  bool isAvailable;
  bool isSpecial;
  bool isVeg;
  String moreInfo;
  Map optional;
  String price;
  Map timing;

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        ingredients: json["Ingredients"] == null ? null : json["Ingredients"],
        category: json["category"] == null ? null : json["category"],
        description: json["description"] == null ? null : json["description"],
        foodId: json["foodId"] == null ? null : json["foodId"],
        foodName: json["foodName"] == null ? null : json["foodName"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        isAvailable: json["isAvailable"] == null ? null : json["isAvailable"],
        isSpecial: json["isSpecial"] == null ? null : json["isSpecial"],
        isVeg: json["isVeg"] == null ? null : json["isVeg"],
        moreInfo: json["moreInfo"] == null ? null : json["moreInfo"],
        optional: json["optional"] == null ? null : json["optional"],
        price: json["price"] == null ? null : json["price"],
        timing: json["timing"] == null ? null : json["timing"],
      );

  Map<String, dynamic> toJson() => {
        "Ingredients": ingredients == null ? null : ingredients,
        "category": category == null ? null : category,
        "description": description == null ? null : description,
        "foodId": foodId == null ? null : foodId,
        "foodName": foodName == null ? null : foodName,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "isAvailable": isAvailable == null ? null : isAvailable,
        "isSpecial": isSpecial == null ? null : isSpecial,
        "isVeg": isVeg == null ? null : isVeg,
        "moreInfo": moreInfo == null ? null : moreInfo,
        "optional": optional == null ? null : optional,
        "price": price == null ? null : price,
        "timing": timing == null ? null : timing,
      };

  Future<dynamic> getAllFoodItems() async {
    _allItems.clear();
    _otherItems.clear();
    _specialItems.clear();
    _itemsNotAvailable.clear();
    notifyListeners();
    CollectionReference foodsCollection =
        FirebaseFirestore.instance.collection('FoodsCollection');

    await foodsCollection
        .get()
        .then(
          (querySnapshot) => querySnapshot.docs.forEach(
            (element) {
              FoodItem item = FoodItem.fromJson(element.data());
              _allItems.add(item);
            },
          ),
        )
        .then((_) => _allItems.forEach((element) {
              if (!element.isAvailable) {
                _itemsNotAvailable.add(element);
              } else if (element.isSpecial && element.isAvailable) {
                _specialItems.add(element);
              } else if (!element.isSpecial && element.isAvailable) {
                _otherItems.add(element);
              }
            }));
    notifyListeners();
    print('notified');
  }

  Future<dynamic> getFoodItemById(String foodId) async {
    FoodItem item;
    CollectionReference foodsCollection =
        FirebaseFirestore.instance.collection('FoodsCollection');

    await foodsCollection.doc(foodId).get().then((querySnapshot) {
      item = FoodItem.fromJson(querySnapshot.data());
    });
    return item ?? null;
  }

  Future<dynamic> addFoodItem(FoodItem foodItem) async {
    CollectionReference foodsCollection =
        FirebaseFirestore.instance.collection('FoodsCollection');
    await foodsCollection.add(foodItem.toJson()).then((value) async =>
        await foodsCollection
            .doc(value.id)
            .update({'foodId': value.id}).then((_) => print('Successss!!!')));
  }

  Future<dynamic> updateFoodItem(FoodItem foodItem) async {
    CollectionReference foodsCollection =
        FirebaseFirestore.instance.collection('FoodsCollection');
    await foodsCollection
        .doc(foodItem.foodId)
        .update(foodItem.toJson())
        .then((value) => print('Successss!!!'));
  }
}
