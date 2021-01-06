class Ingredients {
  String id;
  String name;
  bool value;
  String price;

  Ingredients({
    this.id,
    this.name,
    this.price,
    this.value,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) => Ingredients(
        id: json["ingredientId"],
        name: json["ingredient"],
        price: json["price"] ?? null,
        value: json["value"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "ingredientId": id,
        "ingredient": name,
        "price": price,
      };
}
