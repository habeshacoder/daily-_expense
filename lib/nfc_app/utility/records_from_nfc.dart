import 'dart:convert';

import '../provider/read_data_provider.dart';

void recordsFromNfc(var cachedMessage) {
  if (cachedMessage != null) {
    for (var i in Iterable.generate(cachedMessage.records.length)) {
      final record = cachedMessage.records[i];
      final languageCodeLength = record.payload.first;
      final textBytes = record.payload.sublist(1 + languageCodeLength);
      ReadDataProvider().addRecordFromSharedTag(utf8.decode(textBytes));
    }
  }
}
