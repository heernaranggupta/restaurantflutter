import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  Categories({
    this.categoryId,
    this.categoryName,
    this.imgUrl,
    this.value,
  });

  String categoryId;
  String categoryName;
  String imgUrl;
  bool value;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        imgUrl: json["imgUrl"] ?? null,
        value: json["value"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "imgUrl": imgUrl,
      };

  Future<dynamic> getCategories() async {
    List<Categories> _categoryList = [];
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection('Categories')
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              _categoryList.add(Categories.fromJson(result.data()));
            }));
    return _categoryList;
  }
}
