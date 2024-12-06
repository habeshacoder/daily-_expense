import 'package:exp_tracker/common/app_colors.dart';
import 'package:exp_tracker/common/app_text_style.dart';
import 'package:exp_tracker/common/ui_helpers.dart';
import 'package:exp_tracker/nfc_app/model/record.dart';
import 'package:exp_tracker/widget/custome_button.dart';
import 'package:exp_tracker/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/write_record.dart';
import '../repository/repository.dart';
import '../utility/upercase_letter.dart';

class EditTextModel with ChangeNotifier {
  EditTextModel(this._repo, this.old) {
    if (old == null) return;
    final record = WellknownTextRecord.fromNdef(old!.record);
    textController.text = record.text.split(":").last;
    selectedDataType = record.text.split(':').first.toLowerCase();
  }
  final Repository _repo;
  final WriteRecord? old;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  String? selectedDataType;
  final List<Map<String, String>> entries = [];

  void updateDropDownValue(var value) {
    selectedDataType = value;
    notifyListeners();
  }

  void removeOne(dynamic value) {
    entries.remove(value);
    notifyListeners();
  }

  Future<void> save() async {
    if (entries.isEmpty) {
      return;
    }
    for (var entry in entries) {
      await saveToDataBase(
        selectedDataTypeText: entry["dataType"],
        textControllerText: entry["actualData"],
      );
    }
    notifyListeners();
  }

  Future<void> add() async {
    if (!formKey.currentState!.validate() &&
        selectedDataType != null &&
        selectedDataType!.isNotEmpty) throw ('Form is invalid.');
    entries.add({
      'dataType': selectedDataType == "other"
          ? otherController.text
          : toTitleCase(selectedDataType!),
      'actualData': toTitleCase(textController.text),
    });
    textController.clear();
    otherController.clear();
    notifyListeners();
  }

  Future<Object> saveToDataBase({
    required var selectedDataTypeText,
    required var textControllerText,
  }) async {
    final record = WellknownTextRecord(
      languageCode: 'en', // todo:
      text:
          '${toTitleCase(selectedDataTypeText ?? '')}: ${toTitleCase(textControllerText)}',
    );
    return _repo.createOrUpdateWriteRecord(WriteRecord(
      id: old?.id,
      record: record.toNdef(),
    ));
  }
}

class EditTextPage extends StatelessWidget {
  const EditTextPage({super.key});

  static Widget withDependency([WriteRecord? record]) =>
      ChangeNotifierProvider<EditTextModel>(
        create: (context) =>
            EditTextModel(Provider.of(context, listen: false), record),
        child: const EditTextPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: mediumSize),
        // decoration: BoxDecoration(gradient: bgdGradiant),
        child: Form(
          key: Provider.of<EditTextModel>(context, listen: false).formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                verticalSpaceLarge,
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const DefaultTextStyle(
                        style: AppTextStyle.h3Normal,
                        child: IconTheme(
                          data: IconThemeData(
                              color: whiteColor, size: mediumSize),
                          child: Icon(Icons.chevron_left),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                DropdownButtonFormField<String>(
                  value: Provider.of<EditTextModel>(context).selectedDataType,
                  decoration: InputDecoration(
                    hintText: 'Select Data Type',
                    hintStyle: AppTextStyle.h3Normal,
                    filled: true, // Enable background fill
                    fillColor: mediumGrey, // Background color of the input
                    helperText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(largeSize),
                      borderSide: BorderSide.none, // No border
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text(
                        'Name',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'phone',
                      child: Text(
                        'Phone Number',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'email',
                      child: Text(
                        'Email',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'age',
                      child: Text(
                        'Age',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'profession',
                      child: Text(
                        'Profession',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Text(
                        'Other',
                        style: AppTextStyle.h3Normal,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    Provider.of<EditTextModel>(context, listen: false)
                        .updateDropDownValue(value);
                  },
                  validator: (value) => value == null ? 'Required' : null,
                  dropdownColor:
                      Colors.grey.shade900, // Background color of the dropdown
                ),
                // Conditionally show the TextField for "Other"
                if (Provider.of<EditTextModel>(context).selectedDataType ==
                    'other')
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        vertical: smallSize, horizontal: middleSize),
                    decoration: const BoxDecoration(
                        color: mediumGrey,
                        borderRadius:
                            BorderRadius.all(Radius.circular(largeSize))),
                    child: InputField(
                      stroke: false,
                      controller:
                          Provider.of<EditTextModel>(context, listen: false)
                              .otherController,
                      hint: 'Please specify',
                      inputType: TextInputType.text,
                      validator: (value) =>
                          value?.isNotEmpty != true ? 'Required' : null,
                    ),
                  ),
                if (Provider.of<EditTextModel>(context).selectedDataType ==
                    'other')
                  verticalSpaceMiddle,
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                      vertical: smallSize, horizontal: middleSize),
                  decoration: const BoxDecoration(
                      color: mediumGrey,
                      borderRadius:
                          BorderRadius.all(Radius.circular(largeSize))),
                  child: InputField(
                    stroke: false,
                    controller:
                        Provider.of<EditTextModel>(context, listen: false)
                            .textController,
                    hint: 'Enter Actual Data',
                    inputType: Provider.of<EditTextModel>(context,
                                        listen: false)
                                    .selectedDataType ==
                                "phone" ||
                            Provider.of<EditTextModel>(context, listen: false)
                                    .selectedDataType ==
                                "age"
                        ? TextInputType.number
                        : Provider.of<EditTextModel>(context, listen: false)
                                    .selectedDataType ==
                                "email"
                            ? TextInputType.emailAddress
                            : TextInputType.text,
                    validator: (value) =>
                        value?.isNotEmpty != true ? 'Required' : null,
                  ),
                ),
                verticalSpaceMiddle,
                CustomeButton(
                  width: screenWidth(context) * customButtonWidth,
                  text: 'Add',
                  loading: false,
                  onTap: () {
                    Provider.of<EditTextModel>(context, listen: false)
                        .add()
                        .then((_) => print('------------added---------'))
                        .catchError(
                          (e) => print('=== $e ==='),
                        );
                  },
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                Consumer<EditTextModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: model.entries.map((entry) {
                        return ListTile(
                          title: Wrap(
                            runAlignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                '${entry['dataType']}: ${entry['actualData']}',
                                style: AppTextStyle.h3Normal,
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () => Provider.of<EditTextModel>(context,
                                        listen: false)
                                    .removeOne(entry),
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: dangerColor,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (Provider.of<EditTextModel>(context, listen: false)
                    .entries
                    .isNotEmpty)
                  CustomeButton(
                    width: screenWidth(context) * customButtonWidth,
                    text: 'Save',
                    loading: false,
                    onTap: () {
                      Provider.of<EditTextModel>(context, listen: false)
                          .save()
                          .then((_) => print('------------saved---------'))
                          .catchError(
                            (e) => print('=== $e ==='),
                          );
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
