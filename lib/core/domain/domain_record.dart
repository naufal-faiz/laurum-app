import 'package:equatable/equatable.dart';
import 'package:laurum/core/domain/domain_enums.dart';

abstract class DomainRecord extends Equatable {
  const DomainRecord({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    this.syncState = RecordSyncState.pending,
  });
  final String id, ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final RecordSyncState syncState;
  @override
  List<Object?> get props => [id, ownerId, createdAt, updatedAt, syncState];
}
