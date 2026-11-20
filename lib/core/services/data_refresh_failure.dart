enum DataRefreshFailure implements Exception {
  offline('Sedang offline. Data di HP tetap tersimpan. Coba lagi saat terhubung.'),
  notReady('Sinkronisasi server belum siap. Data lokal tetap tersimpan.'),
  failed('Gagal menyegarkan data. Data lokal tetap tersimpan. Silakan coba lagi.');

  const DataRefreshFailure(this.message);
  final String message;
}
