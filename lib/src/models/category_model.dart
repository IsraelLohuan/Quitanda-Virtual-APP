
class CategoryModel {
  String title;
  String id;

  CategoryModel({
    required this.title,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return _$CategoryModelFromJson(json);
  }
}
