class Cloth {
  String clothId;
  final String name;
  final String color;
  final String type;
  final String thickness;
  final String imageURL;

  Cloth({
    required this.clothId,
    required this.name,
    required this.color,
    required this.type,
    required this.thickness,
    this.imageURL = '',
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      clothId: json['clothId'] ?? 'NoClothId',
      name: json['name'] ?? 'NoName',
      color: json['color'],
      type: json['type'],
      thickness: json['thickness'],
      imageURL: json['imageURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'clothId': clothId,
        'name': name,
        'color': color,
        'type': type,
        'thickness': thickness,
      };
}
