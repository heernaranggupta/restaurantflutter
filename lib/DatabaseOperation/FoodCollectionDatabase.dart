import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:orderingsystem/models/FoodItem.dart';

class FoodCollectionDatabase{
  var foodCollection = FirebaseFirestore.instance.collection("FoodsCollection");

  // Future<String> uploadImage(var imageFile ) async {
  //   String url;
  //   Reference ref = FirebaseStorage.instance.ref().child("foods_images_uploaded/${DateTime.now()}.jpg");
  //   TaskSnapshot uploadTask = await ref.putFile(imageFile);
  //   url =  await ref.getDownloadURL();
  //   return url;
  // }
  Future<String> uploadImage(var imageFile ) async {
    Reference ref = FirebaseStorage.instance.ref().child("foods_images_uploaded/${DateTime.now()}.jpg");
    await ref.putFile(imageFile) ;
    return await ref.getDownloadURL();
  }

  Future<void> addData({@required imageFile,@required List<String> categoryListToDisplay,@required final descriptionController,@required final priceController
    ,@required final foodController,@required bool isSpecial,@required  bool isQuantitative,@required bool isVeg ,@required List<String> timingsListToDisplay,@required final moreInfoController/*,@required final timingBoolList*/, @required  Map<String, bool> timing}) async {
    print("url-----------------------------------------");
    var documnent = foodCollection.doc();
    String url;
    if(imageFile != null)
      url = await uploadImage(imageFile);
    else{
      url=null;
    }
    // print("url- $url");
    final FoodItem item = FoodItem(
        category: categoryListToDisplay,//finalCategories,
        description: descriptionController.text,
        foodId: documnent.id,
        foodName: foodController.text,
        imageUrl: url,
        isSpecial: isSpecial,
        isVeg: isVeg,
        price: priceController.text,
        isQuantitative: isQuantitative,
       // timing: timingsListToDisplay,//finalTimings
         moreInfo: moreInfoController.text,
//      timingBoolList:timingBoolList,
        timing:timing,
    );
    documnent.set(item.toJson());
  }


  Future<List<FoodItem>> fetchData()async{
    List<FoodItem> foodList = [];
    try{
      await foodCollection.get().then((querySnapshot) => querySnapshot.docs.forEach((element) {
        FoodItem foodItem = FoodItem.fromJson(element.data());
        print("\n--------------\n${foodItem.toJson()}\n--------------\n");
        foodList.add(foodItem);
      }));
      print("fetchdata -${foodList.toString()}\nlength - ${foodList.length}");
      return foodList;
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}