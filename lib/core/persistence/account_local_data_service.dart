import 'package:laurum/core/persistence/drift_local_data_service.dart';
import 'package:laurum/core/services/local_data_service.dart';

class AccountLocalDataService implements LocalDataService {
  AccountLocalDataService(this.rows, this.removeFiles);
  final DriftLocalDataService rows;
  final Future<void> Function() removeFiles;
  bool _cleared = false;
  @override
  Future<void> deleteLocalData() async {
    await rows.deleteLocalData();
    _cleared = true;
  }

  @override
  Future<void> finishDelete() async {
    if (!_cleared) throw StateError('Account rows have not been cleared');
    for (final table in rows.db.allTables) {
      if ((await rows.db.customSelect('SELECT 1 FROM ${table.actualTableName} LIMIT 1').get())
          .isNotEmpty) {
        throw StateError('Account transaction was rolled back or new data exists');
      }
    }
    await removeFiles();
    _cleared = false;
  }
}
