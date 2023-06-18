class Product {
  final int id;
  final String name;
  final String description;
  final int price;

  const Product({
    this.id = 0,
    this.name = "",
    this.description = "",
    this.price = 0,
  });

  factory Product.fromJson(Map json) {
    return Product(
        id: json['Id'],
        name: json['Name'],
        description: json['Description'],
        price: json['Price']);
  }
}
