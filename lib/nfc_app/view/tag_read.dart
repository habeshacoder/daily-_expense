import 'dart:io';
import 'package:exp_tracker/nfc_app/view/common/form_row.dart';
import 'package:exp_tracker/nfc_app/view/common/nfc_session.dart';
import 'package:exp_tracker/nfc_app/view/ndef_record.dart';
import 'package:exp_tracker/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_style.dart';
import '../../common/ui_helpers.dart';

class TagReadModel with ChangeNotifier {
  NfcTag? tag;
  Map<String, dynamic>? additionalData;

  Future<String?> handleTag(NfcTag tag) async {
    this.tag = tag;
    additionalData = {};

    Object? tech;

    // todo: more additional data
    if (Platform.isIOS) {
      tech = FeliCa.from(tag);
      if (tech is FeliCa) {
        final polling = await tech.polling(
          systemCode: tech.currentSystemCode,
          requestCode: FeliCaPollingRequestCode.noRequest,
          timeSlot: FeliCaPollingTimeSlot.max1,
        );
        additionalData!['manufacturerParameter'] =
            polling.manufacturerParameter;
      }
    }
    //call an aler message for specific data
    notifyListeners();
    return 'Tag - Read is completed.';
  }
}

void _showUsageSteps(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: mediumGrey,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Steps to read Info from NFC Tag',
              style: AppTextStyle.h3Normal,
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Tap on the "Start session to Read Tag".',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '2. Place your NFC tag near the phone".',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '3. You will see a confirmation message when done.',
              style: AppTextStyle.h3Normal,
            ),
            const Text(
              '4. If reading from the NFC tag fails, it’s okay; just try again!',
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

class TagReadPage extends StatefulWidget {
  const TagReadPage({super.key});

  static Widget withDependency() => ChangeNotifierProvider<TagReadModel>(
        create: (context) => TagReadModel(),
        child: const TagReadPage(),
      );

  @override
  State<TagReadPage> createState() => _TagReadPageState();
}

class _TagReadPageState extends State<TagReadPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor.withOpacity(.5),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: smallSize),
        // decoration: BoxDecoration(gradient: bgdGradiant),
        child: ListView(
          children: [
            verticalSpaceSmall,
            Row(
              children: [
                horizontalSpaceSmall,
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
                const Text(
                  'NFC Card Read',
                  style: AppTextStyle.h3Normal,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            verticalSpaceLarge,
            CustomeButton(
              width: screenWidth(context) * customButtonWidth,
              text: 'Start Session to Read Tag',
              loading: false,
              onTap: () => startSession(
                context: context,
                handleTag:
                    Provider.of<TagReadModel>(context, listen: false).handleTag,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 10, right: 10),
              child: Consumer<TagReadModel>(
                builder: (context, model, _) {
                  final tag = model.tag;
                  final additionalData = model.additionalData;
                  if (tag != null && additionalData != null) {
                    return _TagInfo(
                      tag,
                      additionalData,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.help_outline),
        onPressed: () => _showUsageSteps(context),
      ),
    );
  }
}

class _TagInfo extends StatefulWidget {
  const _TagInfo(this.tag, this.additionalData);

  final NfcTag tag;

  final Map<String, dynamic> additionalData;

  @override
  State<_TagInfo> createState() => _TagInfoState();
}

class _TagInfoState extends State<_TagInfo> {
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  var cachedMessage;
  bool isSaveTagInfoLoading = false;

  @override
  Widget build(BuildContext context) {
    final ndefWidgets = <Widget>[];
    Object? tech;

    tech = Ndef.from(widget.tag);

    //extract data from the tag instance
    if (tech is Ndef) {
      cachedMessage = tech.cachedMessage;

      //Check if the tag contains actual data and extract each record
      if (cachedMessage != null) {
        for (var i in Iterable.generate(cachedMessage.records.length)) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);
          ndefWidgets.add(
            FormRow(
              title: const Text(''),
              subtitle: Text(info.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NdefRecordPage(i, record),
                  )),
            ),
          );
        }
      }
    }

    return Column(
      children: [
        verticalSpaceMiddle,
        if (ndefWidgets.isNotEmpty) ...ndefWidgets,
      ],
    );
  }
}

String _getNdefType(String code) {
  switch (code) {
    case 'org.nfcforum.ndef.type1':
      return 'NFC Forum Tag Type 1';
    case 'org.nfcforum.ndef.type2':
      return 'NFC Forum Tag Type 2';
    case 'org.nfcforum.ndef.type3':
      return 'NFC Forum Tag Type 3';
    case 'org.nfcforum.ndef.type4':
      return 'NFC Forum Tag Type 4';
    default:
      return 'Unknown';
  }
}
