class Stok {
  final String id;
  final String nama;
  final int jumlah;
  final int batasMinimum;

  Stok({required this.id, required this.nama, required this.jumlah, required this.batasMinimum});

  factory Stok.fromMap(Map<String, dynamic> data, String docId) {
    return Stok(
      id: docId,
      nama: data['nama'] ?? '',
      jumlah: data['jumlah'] ?? 0,
      batasMinimum: data['batasMinimum'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jumlah': jumlah,
      'batasMinimum': batasMinimum,
    };
  }
}