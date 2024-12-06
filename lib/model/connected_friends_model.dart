class TagModel {
  final String? id;
  final String? driver;
  final String? user;
  final String? title;
  final List<String>? tagInformation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TagModel({
    this.id,
    this.driver,
    this.user,
    this.title,
    this.tagInformation,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a TagModel from JSON
  fromMap(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      driver: json['driver'],
      user: json['user'],
      title: json['title'],
      tagInformation: List<String>.from(json['tagInformation']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a TagModel to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driver': driver,
      'user': user,
      'title': title,
      'tagInformation': tagInformation,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
