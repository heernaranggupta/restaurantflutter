class FoodItem{
  List<String> category;
  //List<String> timing;
  String description;
  String foodId;
  String foodName;
  String imageUrl;
  bool isSpecial;
  bool isVeg;
  bool isQuantitative;
  String price;
  String moreInfo;
 // var timingBoolList;
  Map<String, bool> timing;

FoodItem({this.category,this.description,this.foodId,this.foodName,
  this.imageUrl,this.isSpecial,this.isVeg,this.price,this.isQuantitative,/*this.timing*/this.moreInfo/*,this.timingBoolList*/,this.timing});

  Map<String, dynamic> toJson() =>
      {
        'foodId':foodId,
        'foodName':foodName,
        'price':price,
        'description':description,
        //'timing': timing,
        'category': category,
        'imageUrl':imageUrl,
        'isSpecial':isSpecial,
        'isVeg':isVeg,
        'isQuantitative':isQuantitative,
        'moreInfo':moreInfo,
        //'timingBoolList':timingBoolList,
        'timing':timing,
      };

   FoodItem.fromJson(Map<String, dynamic> json) {
    isQuantitative = json['isQuantitative'];
    foodId = json['foodId'];
    isSpecial = json['isSpecial'];
    price = json['price'];
    description = json['description'];
    category = json['category'].cast<String>();
    isVeg = json['isVeg'];
    imageUrl = json['imageUrl'];
   // timing = json['timing'].cast<String>();
    foodName = json['foodName'];
    moreInfo = json['moreInfo'];
    //timingBoolList=json['timingBoolList'];
    timing=json['timing'];
  }
}