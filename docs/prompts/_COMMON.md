# Aturan bersama semua prompt

Setiap berkas prompt di folder ini diawali "Ikuti _COMMON.md". Isinya berlaku untuk semuanya.

## A. Awal sesi (wajib)
1. Ikuti AGENTS.md dan SKILLS.md. Baca docs/progress/STATE.md dan docs/REPO_MAP.md. Jangan memindai folder atau membaca PRD utuh; baca hanya bagian yang disebut prompt.
2. Jalankan `git status` dan `dart run tool/check_all.dart` sebagai baseline. Jika ada perubahan belum ter-commit dari sesi lama, commit dengan pesan "chore: simpan pekerjaan sebelumnya". Jika baseline merah karena pekerjaan sebelumnya, perbaiki HANYA itu dulu dan catat.
3. Pastikan baris prompt sebelumnya di docs/prompts/INDEX.md berstatus SELESAI. Jika tidak, berhenti dan laporkan.
4. Membaca desain: `dart run tool/pen_frame.dart` (daftar frame), `... "Nama Frame"` (teks), `... State --children` (varian state). Jika ada PNG di docs/design/screens/png/, lihat gambarnya. Jangan memuat seluruh .pen ke konteks.

## B. Standar setiap widget
1. Satu berkas, maksimal 100 baris (batas keras 110). Semua varian dan parameter sesuai PRD A bagian 5.2.
2. Gaya dari core/theme, ikon lewat AppIcon. Tanpa hex, TextStyle, atau Icon() langsung.
3. Satu use-case Widgetbook yang menampilkan SEMUA varian.
4. Satu tes widget untuk render varian utama.
5. Satu entri di docs/design/component_catalog.md (parameter, varian, contoh).
6. Bandingkan visual dengan frame .pen; catat selisih di docs/progress/fase-N.md.
7. Organisms dan molecules menerima data lewat konstruktor dengan tipe primitif atau enum dari core/domain. Dilarang mengimpor features atau Riverpod.

## C. Standar setiap layar
1. Spec: jika docs/design/screens/NN-nama.md belum ada, buat dari _TEMPLATE.md memakai teks frame .pen dan HANYA nama widget registry.
2. Data: pakai model, fixture, dan repository dari core/domain dan data in-memory. Tambah hanya yang diperlukan.
3. Page (ConsumerWidget) maksimal 100 baris, dibangun dari templates, organisms, molecules, dan Section sefitur. Jika panjang, pindahkan logika ke controller Notifier dan pemetaan data ke fungsi biasa di features/<f>/state/, dan potongan tampilan ke Section di features/<f>/widgets/ (AGENTS.md aturan 14-15). Dilarang menamai potongan layar dengan akhiran Page.
4. State sementara layar (filter, tab, isi numpad, draf) di Notifier; tanpa setState.
5. State pendukung: ambil varian dari frame State yang relevan (kosong, loading, error, modal, validasi) dan implementasikan.
6. Daftarkan rute di go_router. Dependensi platform (cetak, kontak, kamera, pembuka tautan, ekspor) lewat antarmuka di core dengan implementasi palsu; tanpa dependensi baru.
7. Tes page: override repository/provider, periksa teks kunci dan angka PERSIS dari data_master.md, plus satu interaksi yang mengubah state.
8. Alur dummy harus nyata: aksi mengubah state dan layar lain ikut berubah.
9. Bandingkan dengan .pen, catat selisih. Perbarui spec layar dan component_catalog.md bila berubah.
10. Input: ikuti AGENTS.md aturan 16. Setiap layar atau sheet berinput punya tes keyboard (viewInsets 300 dp).

## D. Titik simpan dan handoff
Pada prompt yang membagi pekerjaan menjadi kelompok, setelah tiap kelompok: check_all hijau, perbarui STATE.md, commit. Bila usage menipis, ikuti prosedur handoff di SKILLS.md (commit "wip:", status SEDANG di INDEX.md).

## E. Larangan
- Widget baru di luar registry: potongan layar satu fitur = Section (tanpa proposal); selain itu tulis proposal di docs/design/proposals/, lanjutkan yang lain.
- Prompt revisi (R0-R7) memuat bagian IZIN TERTULIS; hanya perubahan yang tercantum di sana yang boleh menyentuh atoms/molecules/organisms/templates, tema, registry, dependensi, atau PRD.
- Atoms, molecules, dan organisms yang sudah ada tidak diubah diam-diam. Kekurangan dicatat sebagai temuan dan diminta izinnya.
- Tanpa subagen, tanpa dependensi baru, tanpa mengubah registry, lint, PRD, atau token.

## F. Penutup (wajib)
1. check_all hijau; sertakan ringkasan keluaran.
2. Ubah status baris prompt ini di INDEX.md menjadi SELESAI (atau SEDANG bila terpotong) dengan tanggal.
3. Perbarui STATE.md: Posisi, Selesai, Antrean (tulis berkas prompt berikutnya dari INDEX.md), keputusan baru.
4. Commit dengan pesan jelas (feat:/chore:/test:).
5. Laporkan: widget atau layar yang dibuat (dengan jumlah baris), temuan pada lapisan lain, selisih terhadap .pen, hal yang tidak pasti, "Yang perlu ditinjau" (maksimal 3 butir), dan "Prompt berikutnya: <berkas>".
6. BERHENTI. Jangan memulai prompt berikutnya.
