# 032 — SegmentedControl (molekul)
Status: dipakai irisan Printer & Struk; dasar 4294969167, frame dibaca 14 Nov 2026.

## Komponen bersama
- SegmentedControl: kontrol pilih-satu berbentuk track dengan pil aktif.
  - API: labels (List<String>), selectedIndex (int), onSelected (ValueChanged<int>?).
  - Track: AppColors.chipIdle, radius AppRadius.small, padding AppControlTokens.switchInset.
  - Tinggi track 32 = AppControlTokens.switchHeight + 2 × switchInset.
  - Segmen aktif: latar AppColors.primary, teks AppColors.onPrimary.
  - Segmen diam: latar AppColors.chipIdle, teks AppColors.ink2.
  - Label AppTextVariant.label, lebar dibagi rata (Expanded per segmen).
  - onSelected null = nonaktif; Semantics selected per segmen.
- Daftarkan di widget_registry.yaml lapisan molecules.

## Dampak
- Hanya dipakai PrinterFormatSection (lebar kertas, ukuran huruf).
- Tanpa token baru, tanpa dependensi, tanpa perubahan API widget lain.
- Selector AppChip 58/80 mm dan Normal/Besar di layar printer diganti kontrol ini;
  perilaku (80 mm memunculkan notis coming soon, font 11/13) tetap.
