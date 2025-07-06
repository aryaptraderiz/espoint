class Minuman {
  final String id;
  final String nama;
  final int harga;

  Minuman({required this.id, required this.nama, required this.harga});

  factory Minuman.fromMap(Map<String, dynamic> data, String docId) {
    return Minuman(
      id: docId,
      nama: data['nama'] ?? '',
      harga: data['harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'harga': harga,
    };
  }
}