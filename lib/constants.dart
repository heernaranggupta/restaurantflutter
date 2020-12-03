import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/FoodItem.dart';

const appColor = Color(0xfff5f5f5);
const fontColor = Color(0xff1c2843);

// bool isMenuScreen = true;
bool isEditScreen = false;

bool isVeg = false;
bool isNonVeg = false;

List<FoodItem> foodItems;
List<FoodItem> specialFoodItems = [];
List<FoodItem> vegFoodItems = [];
List<FoodItem> nonVegFoodItems = [];

const List<BoxShadow> boxShadowSmall = const [
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
];

const List<BoxShadow> boxShadow = const [
  BoxShadow(
    color: Colors.grey,
    offset: Offset(1, 1),
    blurRadius: 5,
  ),
  BoxShadow(
    color: Colors.white,
    offset: Offset(-8, -8),
    blurRadius: 5,
  ),
];
const List<BoxShadow> boxShadowTwo = const [
//color: Colors.white, //background color of box
  BoxShadow(
    color: Color(0xFFE0E0E0),
    blurRadius: 2.0,
    offset: Offset(3.0, 3.0),
  ),
  BoxShadow(
    color: Colors.white,
    blurRadius: 2.0,
    offset: Offset(-3.0, -3.0),
  ),
];
