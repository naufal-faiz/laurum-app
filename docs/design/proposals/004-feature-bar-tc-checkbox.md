# 004 - Feature Bar & T&C Checkbox (Redesign UI, tampilan saja)

**Izin pengguna:** 9 Nov 2026 (redesign branch, UI-9 + UI-15)

## Masalah

Figma Masuk (29) + Daftar (31) menambah dua elemen baru tanpa PRD:

### 1. Feature bar (Masuk, bawah kartu)
- Tiga chip: "Antrean rapi", "Struk otomatis", "Laporan harian"
- Warna/ukuran: belum ada spek detail

### 2. T&C Checkbox (Daftar, dalam kartu)
- Checkbox + "Saya setuju dengan" + link "Syarat & Ketentuan"
- Fungsi: TAMPILAN SAJA, tidak perlu validasi/logika bisnis
- Catatan: calon fitur untuk reminder 95% (PR T&C nyata di backend)

## Keputusan

Kedua elemen baru tetap tampilan visual di Figma. **Jangan implementasikan sampai PRD resmi memasukkan fungsionalnya.**

### Feature bar
- Status: **SKIP sampai ada PRD untuk fitur/pemakaian di mana**
- Proposal upgrade: docs/design/proposals/NNN-feature-bar-ui.md (sebelum 95%)

### T&C Checkbox
- Status: **SKIP logika validasi; buat widget bisu** (tidak perlu provider/state)
- atau: **tampilkan text saja tanpa checkbox** jika user hanya ingin dekoratif
- Proposal upgrade: docs/design/proposals/NNN-tc-agreement-workflow.md (target 95%, siapkan backend T&C endpoint)

## Konteks

Aturan UI-9 & UI-15 (AGENTS.md):
- Elemen Figma tanpa PRD → jangan dibuat
- Teks contoh Figma → jangan disalin, pakai label spec

## Persetujuan

- [ ] Feature bar: SKIP untuk saat ini?
- [ ] T&C Checkbox: Buat widget bisu (hanya text) atau SKIP juga?
