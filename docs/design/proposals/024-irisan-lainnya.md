# 024 — Irisan Lainnya
Status: DISETUJUI pengguna 12 Nov 2026, termasuk menu Laporan ke /laporan.
Dasar: b3dde16; frame MCP FigCraft 4294968100, dipilih/dibaca 12 Nov 2026.
Tujuan: kartu menu padat, ikon biru muda, akun rapat, header sesuai frame.
## Komponen bersama (urutan atomic)
- AppIcon: boxed=false; kotak primaryTint, ukuran/radius/padding token yang ada.
- MenuRow: compact=false; label/caption, ikon boxed, padding horizontal14/vertikal6,
  minimum sentuh44; bawaan tetap, callback/disabled/semantics dipertahankan.
- ToggleRow: compact=false; label/caption dan ikon boxed saat compact.
- NoticeAi: compact=false; padding8 dan caption untuk catatan Lainnya.
- AppBarRoot: subtitle opsional null; nama usaha, status dan aksi akun tetap.
- RootScaffold: subtitle opsional null diteruskan ke AppBarRoot.
- Revisi tambahan disetujui: AppCard.onTap opsional null, seluruh kartu pendapatan
  Beranda membuka /laporan setelah select(1), tanpa komponen/ikon visual tambahan.
- Izin eksplisit: provider mingguan Beranda dipisahkan dari pilihan periode Laporan;
  pemuatan awal mengikuti provider mingguan. Repository/perhitungan uang tetap.
- Tanpa token, dependensi, state, data atau perubahan API wajib baru.
## Page/Section
- RootShellPage: subtitle hanya indeks3: Pengaturan toko · Laurum v1.0.0.
- SettingsMenu/Operational/AccountSection: kartu padding0, divider inset14,
  gap kelompok8, judul caption ink3, padding konten horizontal24/vertikal10.
- Email caption + nilai label, subtitle Kelola akun dari frame, Keluar kecil.
- Versi tampil sekali melalui header; semua fungsi lama dipertahankan.
- Tambah Laporan ke rute /laporan yang ada, setelah Pengeluaran.
  Izin spesifik aksi UI diperlukan (UI-8/UI-9); router tidak diubah.
## Dampak dan verifikasi
- Varian baru hanya dipakai Lainnya; layar lain mempertahankan default.
- Font minimum11, radius kartu16/ikon memakai token terdekat dari frame.
- Tes komponen/Section, navigasi/logout/toggle,320px teks2x,golden Lainnya.
- check_arch dan check_all sekali di akhir; tanpa screenshot emulator.
