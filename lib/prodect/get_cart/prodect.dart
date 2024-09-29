import 'package:hezmaa/prodect/get_cart/similarproduct.dart';

class Product {
  final int id;
  final String name;
  final String desc;
  final String price;
  final String priceAfter;
  final String amount;
  final String stock;
  final bool isFavorite;
  final String subCategoryId;
  final String image;
  final List<dynamic> sectors;
  final List<SimilarProduct> similarProduct;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.priceAfter,
    required this.amount,
    required this.stock,
    required this.isFavorite,
    required this.subCategoryId,
    required this.image,
    required this.sectors,
    required this.similarProduct,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var similarProductsFromJson = json['similar_product'] as List;
    List<SimilarProduct> similarProductsList =
        similarProductsFromJson.map((i) => SimilarProduct.fromJson(i)).toList();

    return Product(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      priceAfter: json['price_after'],
      amount: json['amount'],
      stock: json['stock'],
      isFavorite: json['is_favorite'],
      subCategoryId: json['sub_category_id'],
      image: json['image'],
      sectors: json['sectors'].cast<dynamic>(),
      similarProduct: similarProductsList,
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
        'is_favorite': isFavorite,
        'sub_category_id': subCategoryId,
        'image': image,
        'sectors': sectors,
        'similar_product': similarProduct.map((e) => e.toJson()).toList(),
      };
}
