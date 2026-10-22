# SKILLS.md - Skill, memori, dan handoff untuk agen Laurum

Aturan AGENTS.md menang atas skill mana pun. Skill mengatur CARA kerja; skill tidak boleh menambah widget, fitur, atau mengubah registry, lint, dan PRD.
Periksa skill SEKALI di awal tugas. Pertanyaan singkat, status, atau perubahan sekitar 20 baris atau kurang: tanpa skill.

## 1. Niat -> skill

| Niat atau perintah | Skill | Batas di proyek ini |
| --- | --- | --- |
| Spec ambigu, keputusan desain/perilaku baru, "rancang/usulkan/bagaimana sebaiknya" | brainstorming | Hasil berupa rencana atau usulan (docs/plans, docs/design/proposals), bukan kode widget. Jangan dipakai untuk hal yang sudah ditetapkan PRD atau spec. Maksimal 3 pertanyaan sekaligus. |
| Tugas multi-langkah (lebih dari sekitar 3 berkas) dengan spec jelas | writing-plans lalu executing-plans | Rencana maksimal 40 baris di docs/plans/NNN-nama.md, langsung dieksekusi. Berhenti hanya jika butuh widget di luar registry. |
| Logika (core/domain, formatter, notifier, repository) atau widget | test-driven-development | Tes lebih dulu untuk logika murni. Widget: tes widget dibuat bersama widgetnya. Tanpa tes tautologis. |
| Bug, tes gagal, error analyzer atau lint yang tidak jelas | systematic-debugging | Cari akar masalah dulu. Dilarang menekan lint atau memakai ignore sebagai solusi. |
| Sebelum menyebut selesai, hijau, atau siap commit | verification-before-completion | Jalankan dart run tool/check_all.dart dan sertakan ringkasan keluarannya. |
| Satu kelompok widget atau satu layar selesai | requesting-code-review | Self-review terhadap daftar: registry, 100 baris, token, fixture, selisih .pen. Tanpa subagen kecuali diminta. |
| Menerima komentar atau koreksi | receiving-code-review | Verifikasi dulu klaimnya terhadap kode dan PRD. Jangan setuju mentah-mentah. |
| Cabang kerja selesai | finishing-a-development-branch | Tanyakan pengguna. Jangan merge atau push sendiri. |
| Tugas independen lebih dari satu | dispatching-parallel-agents, subagent-driven-development | MATI (boros usage). Aktif hanya jika pengguna menulis "paralel" atau "subagen". |
| Dua agen aktif di repo yang sama | using-git-worktrees | MATI. Wajib bila lebih dari satu agen aktif bersamaan. |
| Skill superpowers aneh, lambat, atau boros | diagnosing-superpowers | Hanya atas permintaan pengguna. |
| Membuat atau mengubah skill | writing-skills | Di luar tugas aplikasi. Jangan dipakai tanpa diminta. |

## 2. Memori

| Alat | Nama atau perintah | Untuk apa |
| --- | --- | --- |
| codebase memory | [ISI: nama alat/perintah] | "Di mana X?", "siapa yang memakai Y?", struktur kode |
| ai memory | [ISI: nama alat/perintah] | keputusan, alasan, konteks proyek |
| ponytail | [ISI: fungsi dan kapan dipakai] | [ISI] |

Selama kolom [ISI] belum diisi pengguna, jangan memakai ponytail otomatis dan jangan menebak perintah alat memori.

Aturan:
- Urutan mencari: (1) memori codebase atau docs/REPO_MAP.md, (2) grep terarah di folder yang sudah diketahui, (3) buka berkasnya. Dilarang tree atau ls rekursif seluruh repo.
- Setelah membuat, memindah, atau menghapus berkas: perbarui indeks memori codebase (jika alatnya mengharuskan) dan jalankan check_all (otomatis membuat ulang REPO_MAP).
- AI memory menyimpan KEPUTUSAN dan ALASAN, bukan kode atau salinan PRD. Format: "Keputusan: ... | Alasan: ... | Tanggal | Berlaku untuk". Cari dulu sebelum bertanya ke pengguna.
- Memori tidak dibagi antar alat dan antar agen. Segala hal yang perlu diketahui agen lain WAJIB ada di repo (STATE.md, spec, PRD). Repo adalah satu-satunya medium yang pasti terbaca semua agen.
- Jangan menyimpan rahasia (kunci, token, data pelanggan).
- Jika memori bertentangan dengan repo atau PRD, repo dan PRD yang benar. Perbarui memorinya.

## 3. Handoff (usage habis atau ganti agen)

Tulis handoff: (a) setiap tugas atomik selesai, (b) saat pengguna berkata usage hampir habis atau kamu menilai usage menipis, (c) sebelum berhenti karena alasan apa pun.

1. Selesaikan atau rapikan langkah atomik saat ini. Jangan tinggalkan berkas setengah jadi tanpa catatan.
2. Jalankan dart run tool/check_all.dart bila memungkinkan. Catat hasilnya (hijau, atau gagal di langkah apa).
3. Perbarui docs/progress/STATE.md: posisi, selesai, sedang dikerjakan (berkas dan LANGKAH BERIKUTNYA yang tepat), antrean, keputusan baru, blokir. Ringkas, maksimal sekitar 60 baris.
4. Tambah entri di docs/progress/fase-N.md hanya untuk hal yang perlu jejak (selisih .pen, hal tidak pasti).
5. Commit semua di cabang kerja: "wip: <ringkas>" jika belum hijau, atau "<jenis>: <ringkas>" jika hijau. Jangan push atau merge tanpa izin.
6. Simpan keputusan baru ke AI memory. Balas pengguna dengan: commit terakhir, langkah berikutnya, dan kalimat untuk agen penerus.

Kalimat untuk agen penerus:
"Lanjutkan Laurum. Baca AGENTS.md, SKILLS.md, dan docs/progress/STATE.md. Verifikasi dengan git status dan git log -5, lalu lanjutkan dari bagian 'Sedang dikerjakan'."

## 4. Resep operasi

- **Kerjakan kelompok widget X (Fase 1):** mulai sesi -> rencana hanya bila perlu -> TDD per widget -> component_catalog.md -> check_all -> self-review -> perbarui STATE.md -> berhenti dan tunggu tinjauan Widgetbook.
- **Kerjakan layar N:** mulai sesi -> baca screens/NN -> rencana pendek bila lebih dari 3 berkas -> fixture, provider, page dengan TDD -> verification -> self-review -> STATE.md.
- **Perbaiki error atau lint:** systematic-debugging -> perbaiki akar masalah -> check_all.
- **Butuh widget baru:** brainstorming ringkas -> tulis proposal -> berhenti.
- **Usage hampir habis:** handoff 6 langkah.
- **Melanjutkan dari agen lain:** mulai sesi + verifikasi git, lalu "Sedang dikerjakan".

## 5. Anti-pola
- Memindai ulang struktur repo setiap sesi.
- Membaca PRD utuh, bukan bagian yang relevan.
- Memanggil skill untuk tugas kecil.
- Mengerjakan banyak kelompok atau layar dalam satu sesi tanpa tinjauan.
- Menyimpan hal penting hanya di memori alat.
- Menyatakan selesai tanpa bukti check_all.
- Meninggalkan perubahan yang belum di-commit saat berhenti.
- Mengubah registry, lint, atau PRD lewat "rencana" tanpa izin.
