
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  String get jenis;
  int get tarifPerJam;

  int biaya(DateTime keluar) {
    final durasi = keluar.difference(waktuMasuk);
    final jam = (durasi.inMinutes / 60).ceil();

    // Minimal biaya 1 jam
    final totalJam = jam < 1 ? 1 : jam;

    return totalJam * tarifPerJam;
  }
}

// Kendaraan Motor
class Motor extends Kendaraan {
  Motor(String plat, DateTime waktuMasuk)
      : super(plat, waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 3000;
}

// Kendaraan Mobil
class Mobil extends Kendaraan {
  Mobil(String plat, DateTime waktuMasuk)
      : super(plat, waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

// Kendaraan Truk
class Truk extends Kendaraan {
  Truk(String plat, DateTime waktuMasuk)
      : super(plat, waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 8000;
}

// Mixin untuk kendaraan member
mixin Berlangganan {
  int diskon(int biaya) {
    return (biaya * 0.5).round();
  }
}

// Mobil khusus member
class MobilMember extends Mobil with Berlangganan {
  MobilMember(String plat, DateTime waktuMasuk)
      : super(plat, waktuMasuk);

  @override
  int get tarifPerJam => 5000;

  @override
  String get jenis => 'Mobil (member)';

  @override
  int biaya(DateTime keluar) {
    return diskon(super.biaya(keluar));
  }
}
