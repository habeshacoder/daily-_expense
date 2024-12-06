import 'package:exp_tracker/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exp_tracker/nfc_app/model/write_record.dart';
import 'package:exp_tracker/nfc_app/repository/repository.dart';
import 'package:exp_tracker/nfc_app/view/common/form_row.dart';
import 'package:exp_tracker/nfc_app/view/common/nfc_session.dart';
import 'package:exp_tracker/nfc_app/view/edit_text.dart';
import 'package:exp_tracker/nfc_app/view/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_style.dart';
import '../../common/ui_helpers.dart';

class NdefWriteModel with ChangeNotifier {
  NdefWriteModel(this._repo);
  final Repository _repo;

  Stream<Iterable<WriteRecord>> subscribe() {
    return _repo.subscribeWriteRecordList();
  }

  Future<void> delete(WriteRecord record) {
    return _repo.deleteWriteRecord(record);
  }

  Future<void> deleteAll() async {
    await _repo.deleteAllWriteRecord();
    notifyListeners();
  }

  Future<String?> handleTag(
    NfcTag tag,
    Iterable<WriteRecord> recordList,
  ) async {
    final tech = Ndef.from(tag);

    if (tech == null) throw ('Tag is not ndef.');
    if (!tech.isWritable) throw ('Tag is not ndef writable.');
    try {
      if (tech.cachedMessage!.records.isNotEmpty) {
        print("cached message is :${tech.cachedMessage!.records}");
        //validate the id on the nfc card against the logged in user's id.
        // await validateNFCToWriteOnIt(tech.cachedMessage);
      }
      final message = NdefMessage(recordList.map((e) => e.record).toList());
      print("message issss: $message");
      await tech.write(message);
    } on PlatformException catch (e) {
      throw (e.message ?? 'Some error has occurred.');
    } catch (e) {
      throw Exception('Some error has occurred.');
    }

    return '[Ndef - Write] is completed.';
  }
}

void _showUsageSteps(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: darkGreyColor,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Steps to Add Info to NFC Tag',
              style: AppTextStyle.h3Normal,
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Tap on "Add Record" button.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '2. Enter the desired information.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '3. Tap on "Save" button.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '4. You have one record. Here you can add more records by following steps 1, 2, 3.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '5. Now you have record/s on your app. To write your record/s, Tap on the "Start session to write data to your NFC',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '6.  place your NFC tag near the phone.".',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '7. You will see a confirmation message when done.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '8. If writing to the NFC tag fails, it’s okay; just try again!',
              style: AppTextStyle.h3Normal,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.pop(context); // Close the BottomSheet
              },
              child: const Text(
                'Close',
                style: AppTextStyle.h3Normal,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class NdefWritePage extends StatelessWidget {
  const NdefWritePage({super.key});

  static Widget withDependency() => ChangeNotifierProvider<NdefWriteModel>(
        create: (context) =>
            NdefWriteModel(Provider.of(context, listen: false)),
        child: const NdefWritePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.help_outline),
        onPressed: () => _showUsageSteps(context),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: smallSize),
        // decoration: BoxDecoration(gradient: bgdGradiant),
        child: StreamBuilder<Iterable<WriteRecord>>(
          stream:
              Provider.of<NdefWriteModel>(context, listen: false).subscribe(),
          builder: (context, ss) => ListView(
            padding: const EdgeInsets.only(bottom: 100, left: 10, right: 10),
            children: [
              verticalSpaceLarge,
              Row(
                children: [
                  horizontalSpaceSmall,
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const DefaultTextStyle(
                      style: AppTextStyle.h3Normal,
                      child: IconTheme(
                        data:
                            IconThemeData(color: whiteColor, size: mediumSize),
                        child: Icon(Icons.chevron_left),
                      ),
                    ),
                  ),
                  horizontalSpaceMedium,
                  const Text(
                    'Write to NFC Card ',
                    style: AppTextStyle.h3Normal,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              verticalSpaceLarge,
              CustomeButton(
                width: screenWidth(context) * customButtonWidth,
                text: 'Add Record',
                loading: false,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => EditTextPage.withDependency(),
                    ),
                  );
                },
              ),
              verticalSpaceMedium,
              if (ss.data?.isNotEmpty == true)
                FormSection(
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'RECORDS (${ss.data!.map((e) => e.record.byteLength).reduce((a, b) => a + b)} bytes)',
                        style: AppTextStyle.h3Normal,
                      ),
                      InkWell(
                        onTap: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: mediumGrey,
                              title: const Text(
                                'Delete Record/s?',
                                style: AppTextStyle.h3Normal,
                              ),
                              content: const Text(
                                'Are you sure you want to delete all records from your device?',
                                style: AppTextStyle.h3Normal,
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'CANCEL',
                                    style: AppTextStyle.withColor(
                                      color: primaryColor,
                                      style: AppTextStyle.h4Normal,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text(
                                    'DELETE All',
                                    style: AppTextStyle.withColor(
                                      color: dangerColor,
                                      style: AppTextStyle.h3Normal,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );
                          if (result == true) {
                            Provider.of<NdefWriteModel>(context, listen: false)
                                .deleteAll();
                          }
                        },
                        child: Text(
                          'Clean Records',
                          style: AppTextStyle.withColor(
                            color: primaryColor,
                            style: AppTextStyle.h3Normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    verticalSpaceMiddle,
                    ...List.generate(
                      ss.data!.length,
                      (i) {
                        final record = ss.data!.elementAt(i);
                        return _WriteRecordFormRow(i, record);
                      },
                    ),
                  ],
                ),
              const SizedBox(
                height: 12,
              ),
              if (ss.data?.isNotEmpty == true)
                CustomeButton(
                  width: screenWidth(context) * customButtonWidth,
                  text: 'Write record/s to your NFC',
                  loading: false,
                  onTap: ss.data?.isNotEmpty == true
                      ? () {
                          startSession(
                            context: context,
                            handleTag: (tag) => Provider.of<NdefWriteModel>(
                                    context,
                                    listen: false)
                                .handleTag(tag, [...ss.data!]),
                          );
                        }
                      : () {}, // Provide an empty function when ss.data is empty
                ),
              const SizedBox(
                height: 12,
              ),
              if (ss.data?.isNotEmpty == true)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    textAlign: TextAlign.justify,
                    'All the above records are saved to your app. You have to sync with the NFC tag ( by write record/s to your NFC) to see them on the tag.',
                    style: AppTextStyle.h4Normal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WriteRecordFormRow extends StatelessWidget {
  const _WriteRecordFormRow(this.index, this.record);

  final int index;

  final WriteRecord record;

  @override
  Widget build(BuildContext context) {
    final info = NdefRecordInfo.fromNdef(record.record);
    return FormRow(
      title: Text('Record - ${index + 1}'),
      subtitle: Text(info.subtitle),
      trailing: const Icon(Icons.more_vert),
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          backgroundColor: mediumGrey,
          context: context,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  title: Text(
                    '#$index ${info.title}',
                    style: AppTextStyle.h4Normal,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'View Details',
                    style: AppTextStyle.h4Normal,
                  ),
                  onTap: () => Navigator.pop(context, 'view_details'),
                ),
                ListTile(
                  title: const Text(
                    'Delete',
                    style: AppTextStyle.h4Normal,
                  ),
                  onTap: () => Navigator.pop(context, 'delete'),
                ),
              ],
            ),
          ),
        );
        switch (result) {
          case 'view_details':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NdefRecordPage(index, record.record),
                ));
            break;
          case 'delete':
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: mediumGrey,
                title: const Text(
                  'Delete Record?',
                  style: AppTextStyle.h3Normal,
                ),
                content: Text('#$index ${info.title}'),
                actions: [
                  TextButton(
                    child: Text(
                      'CANCEL',
                      style: AppTextStyle.withColor(
                        color: primaryColor,
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text(
                      'DELETE',
                      style: AppTextStyle.withColor(
                        color: dangerColor,
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );
            if (result == true) {
              Provider.of<NdefWriteModel>(context, listen: false)
                  .delete(record)
                  .catchError((e) => print('=== $e ==='));
            }
            break;
          case null:
            break;
          default:
            throw ('unsupported result: $result');
        }
      },
    );
  }
}
