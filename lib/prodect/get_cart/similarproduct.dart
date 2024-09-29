class SimilarProduct {
  final int id;
  final String name;
  final String desc;
  final String price;
  final String priceAfter;
  final String amount;
  final String stock;
  final String subCategoryId;
  final bool isFavorite;
  final String image;

  SimilarProduct({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.priceAfter,
    required this.amount,
    required this.stock,
    required this.subCategoryId,
    required this.isFavorite,
    required this.image,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      priceAfter: json['price_after'],
      amount: json['amount'],
      stock: json['stock'],
      subCategoryId: json['sub_category_id'],
      isFavorite: json['is_favorite'],
      image: json['image'],
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
