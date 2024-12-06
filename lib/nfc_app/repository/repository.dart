import 'dart:async';

import 'package:exp_tracker/nfc_app/model/write_record.dart';
import 'package:exp_tracker/nfc_app/repository/database.dart';
import 'package:exp_tracker/nfc_app/repository/repository_impl.dart';


abstract class Repository {
  static Future<Repository> createInstance() async =>
      RepositoryImpl(await getOrCreateDatabase());

  Stream<Iterable<WriteRecord>> subscribeWriteRecordList();

  Future<WriteRecord> createOrUpdateWriteRecord(WriteRecord record);

  Future<void> deleteWriteRecord(WriteRecord record);
  Future<void> deleteAllWriteRecord();
}

class SubscriptionManager {
  final Map<int, StreamController> _controllers = {};
  final Map<int, StreamController> _subscribers = {};

  Stream<T> createStream<T>(Future<T> Function() fetcher) {
    final key = DateTime.now().microsecondsSinceEpoch;
    final controller = StreamController<T>(onCancel: () {
      _controllers.remove(key)?.close();
      _subscribers.remove(key)?.close();
    });
    void publisher(Future<T> future) =>
        future.then(controller.add).catchError(controller.addError);
    _subscribers[key] = StreamController(onListen: () => publisher(fetcher()))
      ..stream.listen((_) => publisher(fetcher()));
    _controllers[key] = controller;
    return controller.stream;
  }

  void publish() => _subscribers.values.forEach((e) => e.add(null));
}
