class FoodItem{
  List<String> category;
  List<String> timing;
  String description;
  String foodId;
  String foodName;
  String imageUrl;
  bool isSpecial;
  bool isVeg;
  bool isQuantitative;
  String price;



FoodItem({this.category,this.description,this.foodId,this.foodName,
  this.imageUrl,this.isSpecial,this.isVeg,this.price,this.isQuantitative,this.timing});

  Map<String, dynamic> toJson() =>
      {
        'foodId':foodId,
        'foodName':foodName,
        'price':price,
        'description':description,
        'timing': timing,
        'category': category,
        'imageUrl':imageUrl,
        'isSpecial':isSpecial,
        'isVeg':isVeg,
        'isQuantitative':isQuantitative,

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
    timing = json['timing'].cast<String>();
    foodName = json['foodName'];
  }
}