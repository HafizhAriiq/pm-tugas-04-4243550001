
import '../lib/kendaraan.dart';
import '../lib/parkiran.dart';

Future<void> main() async {
  print('======================================');
  print('       SISTEM PARKIR KAMPUS FMIPA');
  print('======================================');

  // Membuat objek parkiran dengan kapasitas 3
  final parkiran = Parkiran(kapasitas: 3);

  // Mendengarkan aktivitas parkir melalui Stream
  final subscription = parkiran.aktivitas.listen((pesan) {
    print('[POS JAGA] $pesan');
  });

  // Waktu masuk kendaraan dibuat berbeda
  final sekarang = DateTime.now();

  // List berisi berbagai jenis kendaraan
  // Ini merupakan contoh penerapan polymorphism
  List<Kendaraan> daftarKendaraan = [
    Motor(
      'BK 1234 AB',
      sekarang.subtract(const Duration(hours: 1, minutes: 1)),
    ),
    Mobil(
      'BK 88 UN',
      sekarang.subtract(const Duration(hours: 2, minutes: 1)),
    ),
    MobilMember(
      'BK 7 MIPA',
      sekarang.subtract(const Duration(hours: 2, minutes: 1)),
    ),
    Truk(
      'BK 9999 XY',
      sekarang,
    ),
  ];

  print('\n--- PROSES KENDARAAN MASUK ---');

  // Memasukkan kendaraan ke parkiran
  for (final kendaraan in daftarKendaraan) {
    try {
      await parkiran.masuk(kendaraan);
    } on ParkirPenuh catch (e) {
      print('Ditolak: $e');
    }
  }

  print('\nSisa kapasitas: ${parkiran.sisa}');

  // Memberi jeda sebelum kendaraan keluar
  await Future.delayed(const Duration(seconds: 1));

  print('\n--- PROSES KENDARAAN KELUAR ---');

  // Mengeluarkan tiga kendaraan pertama
  final daftarKeluar = [
    'BK 1234 AB',
    'BK 88 UN',
    'BK 7 MIPA',
  ];

  for (final plat in daftarKeluar) {
    try {
      await parkiran.keluar(plat);
    } catch (e) {
      print('Error: $e');
    }
  }

  // Menampilkan total pendapatan
  print('\n======================================');
  print('          LAPORAN PARKIR');
  print('======================================');
  print('Sisa kapasitas : ${parkiran.sisa}');
  print('Pendapatan     : Rp${parkiran.pendapatan}');
  print('======================================');

  // Menutup Stream
  await parkiran.tutup();
  await subscription.cancel();

  print('Program selesai.');
}
