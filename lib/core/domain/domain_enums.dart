enum OrderStatus { menungguJemput, diproses, siap, selesai, dibatalkan }

enum PayStatus { belumBayar, dp, lunas }

enum ServiceKind { kiloan, satuan }

enum PayMethod { tunai, qris, transfer, tabungan }

enum SavingsKind { setor, pakai, penyesuaian }

enum ProposalStatus { menunggu, disetujui, ditolak, ditutupOtomatis }

enum OrderSource { kasir, whatsappAi }

// Metadata lokal sesuai PRD B 5, bukan status sinkron UI.
enum RecordSyncState { synced, pending }
