
import 'dart:async';
import 'kendaraan.dart';

// Exception khusus ketika parkiran penuh
class ParkirPenuh implements Exception {
  final String pesan;

  ParkirPenuh(this.pesan);

  @override
  String toString() => pesan;
}

// Class utama sistem parkir
class Parkiran {
  final int kapasitas;

  // Data kendaraan dibuat privat
  final List<Kendaraan> _kendaraan = [];

  // Menyimpan total pendapatan
  int _pendapatan = 0;

  // Stream untuk mengirimkan informasi aktivitas parkir
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Parkiran({required this.kapasitas});

  // Getter sisa kapasitas
  int get sisa => kapasitas - _kendaraan.length;

  // Getter total pendapatan
  int get pendapatan => _pendapatan;

  // Stream yang dapat didengarkan
  Stream<String> get aktivitas => _controller.stream;

  // Method kendaraan masuk
  Future<void> masuk(Kendaraan kendaraan) async {
    if (_kendaraan.length >= kapasitas) {
      throw ParkirPenuh('Parkiran penuh (kapasitas $kapasitas)');
    }

    // Simulasi palang otomatis
    print('Membuka palang masuk...');
    await Future.delayed(const Duration(seconds: 1));

    _kendaraan.add(kendaraan);

    _controller.add(
      'MASUK ${kendaraan.jenis} ${kendaraan.plat} (sisa $sisa)',
    );
  }

  // Method kendaraan keluar
  Future<void> keluar(String plat) async {
    // Mencari kendaraan berdasarkan nomor plat
    final index = _kendaraan.indexWhere(
      (kendaraan) => kendaraan.plat == plat,
    );

    if (index == -1) {
      throw Exception('Kendaraan dengan plat $plat tidak ditemukan');
    }

    final kendaraan = _kendaraan[index];

    // Simulasi palang keluar
    print('Membuka palang keluar...');
    await Future.delayed(const Duration(seconds: 1));

    // Menghitung biaya parkir
    final biaya = kendaraan.biaya(DateTime.now());

    // Menghapus kendaraan dari parkiran
    _kendaraan.removeAt(index);

    // Menambahkan pendapatan
    _pendapatan += biaya;

    _controller.add(
      'KELUAR ${kendaraan.jenis} ${kendaraan.plat} bayar Rp$biaya',
    );
  }

  // Menutup Stream
  Future<void> tutup() async {
    await _controller.close();
  }
}
