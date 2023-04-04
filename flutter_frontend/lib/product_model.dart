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
        id: json['Id'],
        name: json['Name'],
        description: json['Description'],
        price: json['Price']);
  }
}
