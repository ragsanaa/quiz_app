class Categories {
  final List<QCategory> categories;

  Categories({
    required this.categories,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categories: List<QCategory>.from(
            json["trivia_categories"].map((x) => QCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trivia_categories":
            List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class QCategory {
  final int id;
  final String name;

  QCategory({
    required this.id,
    required this.name,
  });

  factory QCategory.fromJson(Map<String, dynamic> json) => QCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
