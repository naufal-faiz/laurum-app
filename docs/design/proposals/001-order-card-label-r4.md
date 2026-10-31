# R4: label status OrderCard

Status: DISETUJUI pengguna pada 31 Oktober 2026: "Ya, lanjutkan sesuai dua mode R4".

R4 mengizinkan showAction (default true) untuk menyembunyikan tombol. Label
OrderCard masih dibentuk di dalam widget, sehingga mode sederhana belum bisa
menampilkan 'Sedang dikerjakan' tanpa perubahan API tambahan.

Usulan API pada widget yang sudah ada:
`OrderCard(..., showAction: false, statusLabel: 'Sedang dikerjakan')`.
`String? statusLabel` default null mempertahankan label enum lama. Pemetaan label
mode tetap di core/domain/order_rules.dart dan diteruskan oleh Antrean.

Layar: Antrean. Tidak membuat widget bersama baru atau mengubah token/registry.
Tes memastikan default, label override, tombol tersembunyi dan kartu tetap terbuka.
