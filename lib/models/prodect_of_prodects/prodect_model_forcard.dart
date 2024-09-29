class ProdectModel {
  int? id;
  String? name;
  String? desc;
  String? price;
  String? priceAfter;
  String? amount;
  String? stock;
  String? subCategoryId;
  bool isFavorite;
  String? image;

  ProdectModel({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.priceAfter,
    this.amount,
    this.stock,
    this.subCategoryId,
    bool? isFavorite,
    this.image,
  }) : isFavorite = isFavorite ?? false;

  factory ProdectModel.fromJson(Map<String, dynamic> jsonData) {
    return ProdectModel(
      id: jsonData['id'] as int?,
      name: jsonData['name'] as String?,
      desc: jsonData['desc'] as String?,
      price: jsonData['price'] as String?,
      priceAfter: jsonData['price_after'] as String?,
      amount: jsonData['amount'] as String?,
      stock: jsonData['stock'] as String?,
      subCategoryId: jsonData['sub_category_id'] as String?,
      isFavorite: jsonData['is_favorite'] as bool? ?? false,
      image: jsonData['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'price': price,
        'price_after': priceAfter,
        'amount': amount,
        'stock': stock,
        'sub_category_id': subCategoryId,
        'is_favorite': isFavorite,
        'image': image,
      };
}
