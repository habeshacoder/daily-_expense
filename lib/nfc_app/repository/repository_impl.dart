import 'package:exp_tracker/nfc_app/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/write_record.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl(this._db);

  final Database _db;

  final SubscriptionManager _subscriptionManager = SubscriptionManager();

  @override
  Stream<Iterable<WriteRecord>> subscribeWriteRecordList() {
    return _subscriptionManager.createStream(() async {
      return _db
          .query('record')
          .then((value) => value.map((e) => WriteRecord.fromJson(e)));
    });
  }

  @override
  Future<WriteRecord> createOrUpdateWriteRecord(WriteRecord record) async {
    final id = await _db.insert('record', record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _subscriptionManager.publish();
    return WriteRecord.fromJson(
        record.toJson()..[WriteRecord.ID] = id); // todo: copyWith
  }

  @override
  Future<void> deleteWriteRecord(WriteRecord record) async {
    await _db.delete('record', where: 'id = ?', whereArgs: [record.id!]);
    _subscriptionManager.publish();
  }

  @override
  Future<void> deleteAllWriteRecord() async {
    await _db.delete('record');
    _subscriptionManager.publish();
  }
}
