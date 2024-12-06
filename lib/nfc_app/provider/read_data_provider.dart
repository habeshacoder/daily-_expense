import 'dart:convert';
import 'package:exp_tracker/service/user_service.dart';

import '../model/connected_friends_model.dart';

class ReadDataProvider {
  //add each records of a tag recordsFromTag on user instance just after the NFC is Read.
  final userInstance = UserService.instance;
  List<String> addRecordFromSharedTag(var cachedMessage) {
    final List<String> recordsFromTag = [];
    if (cachedMessage != null) {
      for (var i in Iterable.generate(cachedMessage.records.length)) {
        final record = cachedMessage.records[i];
        final languageCodeLength = record.payload.first;
        final textBytes = record.payload.sublist(1 + languageCodeLength);
        recordsFromTag.add(utf8.decode(textBytes));
      }
    }
    return recordsFromTag;
  }
}
