class Product {
  int? id;
  String? name;
  String? desc;
  String? price;
  String? priceAfter;
  String? amount;
  String? stock;
  String? subCategoryId;
  bool? isFavorite;
  String? image;

  Product({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.priceAfter,
    this.amount,
    this.stock,
    this.subCategoryId,
    this.isFavorite,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        name: json['name'] as String?,
        desc: json['desc'] as String?,
        price: json['price'] as String?,
        priceAfter: json['price_after'] as String?,
        amount: json['amount'] as String?,
        stock: json['stock'] as String?,
        subCategoryId: json['sub_category_id'] as String?,
        isFavorite: json['is_favorite'] as bool?,
        image: json['image'] as String?,
      );

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
