class Product {
  int? id;
  String? name;
  String? desc;
  String? price;
  String? priceAfter;
  String? amount;
  String? stock;
  bool? isFavorite;
  String? subCategoryId;
  String? image;
  List<dynamic>? sectors;

  Product({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.priceAfter,
    this.amount,
    this.stock,
    this.isFavorite,
    this.subCategoryId,
    this.image,
    this.sectors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        name: json['name'] as String?,
        desc: json['desc'] as String?,
        price: json['price'] as String?,
        priceAfter: json['price_after'] as String?,
        amount: json['amount'] as String?,
        stock: json['stock'] as String?,
        isFavorite: json['is_favorite'] as bool?,
        subCategoryId: json['sub_category_id'] as String?,
        image: json['image'] as String?,
        sectors: json['sectors'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'price': price,
        'price_after': priceAfter,
        'amount': amount,
        'stock': stock,
        'is_favorite': isFavorite,
        'sub_category_id': subCategoryId,
        'image': image,
        'sectors': sectors,
      };
}
