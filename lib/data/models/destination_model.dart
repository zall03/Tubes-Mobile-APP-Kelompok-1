class DestinationModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String category;

  DestinationModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.rating = 4.5,
    required this.category,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      // PERBAIKAN KRITIS: Tambahkan .toString() untuk menangani ID berupa angka
      id: json['id'].toString(),

      // PERBAIKAN KEAMANAN: Berikan nilai default string kosong jika name null
      name: json['name'] ?? '',

      // PERBAIKAN KEAMANAN: Handle jika gambar null agar UI tidak error
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',

      // Sudah Bagus: Cara Anda menangani rating sudah aman (parsing ke string dulu)
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,

      category: json['category'] ?? 'Lainnya',
    );
  }
}
