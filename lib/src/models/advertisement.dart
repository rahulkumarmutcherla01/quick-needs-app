class Advertisement {
  final String id;
  final String title;
  final String imageUrl;
  final String targetUrl;
  final List<String> displayLocations;
  final bool isActive;

  Advertisement({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.targetUrl,
    required this.displayLocations,
    required this.isActive,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      targetUrl: json['target_url'],
      displayLocations: List<String>.from(json['display_locations']),
      isActive: json['is_active'],
    );
  }
}
