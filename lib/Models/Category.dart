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
}
