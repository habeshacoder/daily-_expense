import 'package:flutter/material.dart';
import 'package:exp_tracker/nfc_app/model/record.dart';
import 'package:exp_tracker/nfc_app/utility/extensions.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_style.dart';
import '../../common/ui_helpers.dart';

class NdefRecordPage extends StatelessWidget {
  const NdefRecordPage(this.index, this.record, {super.key});
  final int index;
  final NdefRecord record;

  @override
  Widget build(BuildContext context) {
    final info = NdefRecordInfo.fromNdef(record);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Record #$index'),
      // ),
      backgroundColor: darkGreyColor,
      body: Container(
        // decoration: BoxDecoration(gradient: bgdGradiant),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            verticalSpaceLarge,
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const DefaultTextStyle(
                    style: AppTextStyle.h3Normal,
                    child: IconTheme(
                      data: IconThemeData(color: whiteColor, size: mediumSize),
                      child: Icon(Icons.chevron_left),
                    ),
                  ),
                ),
                horizontalSpaceMedium,
                Text(
                  'Record #$index',
                  style: AppTextStyle.h3Normal,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            verticalSpaceMedium,
            _RecordColumn(
              title: Text(
                info.title,
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                info.subtitle,
                style: AppTextStyle.h3Normal,
              ),
            ),
            const SizedBox(height: 12),
            _RecordColumn(
              title: const Text(
                'Size',
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                '${record.byteLength} bytes',
                style: AppTextStyle.h3Normal,
              ),
            ),
            const SizedBox(height: 12),
            _RecordColumn(
              title: const Text(
                'Type Name Format',
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                record.typeNameFormat.index.toHexString(),
                style: AppTextStyle.h3Normal,
              ),
            ),
            const SizedBox(height: 12),
            _RecordColumn(
              title: const Text(
                'Type',
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                record.type.toHexString(),
                style: AppTextStyle.h3Normal,
              ),
            ),
            const SizedBox(height: 12),
            _RecordColumn(
              title: const Text(
                'Identifier',
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                record.identifier.toHexString(),
                style: AppTextStyle.h3Normal,
              ),
            ),
            const SizedBox(height: 12),
            _RecordColumn(
              title: const Text(
                'Payload',
                style: AppTextStyle.h3Normal,
              ),
              subtitle: Text(
                record.payload.toHexString(),
                style: AppTextStyle.h3Normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordColumn extends StatelessWidget {
  const _RecordColumn({required this.title, required this.subtitle});

  final Widget title;

  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
          child: title,
        ),
        const SizedBox(height: 2),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
          child: subtitle,
        ),
      ],
    );
  }
}

class NdefRecordInfo {
  const NdefRecordInfo(
      {required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final record0 = Record.fromNdef(record);
    if (record0 is WellknownTextRecord) {
      return NdefRecordInfo(
        record: record0,
        title: 'Wellknown Text',
        subtitle: record0.text,
      );
    }
    if (record0 is UnsupportedRecord) {
      // more custom info from NdefRecord.
      if (record.typeNameFormat == NdefTypeNameFormat.empty) {
        return NdefRecordInfo(
          record: record0,
          title: _typeNameFormatToString(record0.record.typeNameFormat),
          subtitle: '-',
        );
      }
      return NdefRecordInfo(
        record: record0,
        title: _typeNameFormatToString(record0.record.typeNameFormat),
        subtitle:
            '(${record0.record.type.toHexString()}) ${record0.record.payload.toHexString()}',
      );
    }
    throw UnimplementedError();
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
  }
}
