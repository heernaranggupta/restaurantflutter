import 'package:flutter/material.dart';

class FoodItem{
  List<String> categories;
  List<String> timings;
  String description;
  String foodId;
  String foodName;
  String imageUrl;
  bool isSpecial;
  bool isVeg;
  bool isQuantitative;
  String price;



FoodItem({this.categories,this.description,this.foodId,this.foodName,
  this.imageUrl,this.isSpecial,this.isVeg,this.price,this.isQuantitative,this.timings});

  Map<String, dynamic> toJson() =>
      {
        'foodId':foodId,
        'foodName':foodName,
        'price':price,
        'description':description,
        'timing': timings,
        'category': categories,
        'imageUrl':imageUrl,
        'isSpecial':isSpecial,
        'isVeg':isVeg,
        'isQuantitative':isQuantitative,

      };
}