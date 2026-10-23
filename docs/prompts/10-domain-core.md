# 10 - Domain inti (enum, model, logika murni)
Ikuti _COMMON.md. Prasyarat: Molecules SELESAI. Baca: PRD B bagian 5 dan 6, data_master.md, tokens.md (bagian Format).

Keputusan (catat di STATE.md): enum, model, dan logika murni hidup di lib/core/domain/ karena dipakai lintas fitur; antarmuka repository juga di core/domain/repositories/ (dikerjakan di prompt 11).

TUGAS
1. Enum: OrderStatus (menungguJemput, diproses, siap, selesai, dibatalkan), PayStatus (belumBayar, dp, lunas), ServiceKind (kiloan, satuan), PayMethod (tunai, qris, transfer, tabungan), SavingsKind (setor, pakai, penyesuaian), ProposalStatus (menunggu, disetujui, ditolak, ditutupOtomatis), OrderSource (kasir, whatsappAi).
2. Model immutable (Equatable, id String, uang int rupiah, qtyMilli int): BusinessProfile, Customer, ServiceItem, Order, OrderItem, Payment, SavingsEntry, ExpenseCategory, Expense, Proposal, ReceiptSettings, OrderEvent (jejak aktivitas). Kolom sesuai PRD B bagian 5.
3. Fungsi murni tanpa Flutter: lineTotal, orderTotal (dengan diskon), paidAmount, payStatus, estimateReady (tanggal masuk + durasi layanan terlama, jam 17.00, waktu WIB lokal), savingsBalance, outstanding (piutang), nextStatus (alur status; final tidak bisa mundur), cancelOrder (membalik pembayaran dengan entri koreksi), applySavings (membuat Payment tabungan + SavingsEntry pakai), buildReport(baseline, orders, payments, expenses, savings, range) menurut PRD B bagian 6, dan topServices (berdasar pendapatan).
4. Tes unit untuk semua fungsi, memakai data kecil buatan sendiri dan kasus tepi (pembulatan, kelebihan bayar, DP, pembatalan, status final).
5. Formatters yang sudah ada tidak diubah kecuali ada celah; catat sebagai temuan.

Tanpa Flutter, tanpa Riverpod di core/domain. Tiap berkas maksimal 100 baris; pecah per model dan per kelompok fungsi.
