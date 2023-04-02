class Product {
  final int id;
  final String name;
  final String description;
  final int price;

  const Product({
    this.id,
    this.name,
    this.description,
    this.price,
  });

  factory Product.fromJson(Map json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price']);
  }
}
