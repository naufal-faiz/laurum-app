import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class AntreanStatusSection extends StatelessWidget {
  const AntreanStatusSection({
    super.key,
    this.loading = false,
    this.error = false,
    this.filtered = false,
    this.reviewOnly = false,
    this.onRetry,
    this.onCreate,
    this.searching = false,
  });
  final bool loading, error, filtered, reviewOnly, searching;
  final VoidCallback? onRetry, onCreate;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: const [
          Center(child: AppLoader()),
        ],
      );
    }
    return EmptyState(
      title: error
          ? 'Gagal memuat data'
          : searching
          ? 'Tidak ada hasil pencarian'
          : reviewOnly
          ? 'Belum ada usulan yang perlu dicek'
          : filtered
          ? 'Tidak ada order di status ini'
          : 'Belum ada order aktif',
      icon: error ? AppIcons.alert : AppIcons.queue,
      description: error
          ? 'Periksa koneksi dan coba lagi.'
          : searching
          ? 'Coba nama pelanggan, nomor nota, atau layanan lain.'
          : reviewOnly
          ? 'Usulan WhatsApp yang menunggu pemeriksaan akan muncul di sini.'
          : filtered
          ? 'Coba pilih status lain.'
          : 'Order dari kasir atau usulan WhatsApp akan muncul di sini.',
      actionLabel: error
          ? 'Coba lagi'
          : filtered || reviewOnly || searching
          ? null
          : 'Transaksi baru',
      onAction: error
          ? onRetry
          : filtered || reviewOnly || searching
          ? null
          : onCreate,
    );
  }
}
