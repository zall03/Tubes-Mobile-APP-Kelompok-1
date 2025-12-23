class DestinationModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int price;
  // [BARU] Tambahkan field ini
  final String location;
  final String description;

  DestinationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    // [BARU]
    required this.location,
    required this.description,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['price'] ?? 0,
      // [BARU] Mapping dari Supabase (sesuikan nama kolom di table Anda)
      location: json['location'] ?? 'Lokasi belum tersedia',
      description: json['descriptions'] ?? 'Tidak ada deskripsi.',
    );
  }
}
