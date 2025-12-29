// lib/models/plan_model.dart
class Plan {
  final String id;
  final String name;
  final String duration;
  final String price;
  Plan({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'].toString(),
      name: json['plan_name'] ?? 'Unknown',
      duration: json['plan_type'] ?? 'N/A',
      price: json['price'].toString(),
    );
  }
}
