// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison
import 'package:exp_tracker/common/app_colors.dart';
import 'package:exp_tracker/common/app_text_style.dart';
import 'package:exp_tracker/common/ui_helpers.dart';
import 'package:exp_tracker/widget/custome_button.dart';
import 'package:exp_tracker/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final textControler = TextEditingController();
  final amountController = TextEditingController();

  dynamic SelectedDate;
  //Validation related
  final Map<dynamic, String> _formError = {};
  Map<dynamic, String> get formError => _formError;
  void submitData() {
    _formError.clear();

    if (textControler.text.isEmpty) {
      _formError[textControler] = 'Add title.';
      setState(() {});
      return;
    }
    // Validate amount
    if (amountController.text.isEmpty) {
      _formError[amountController] = 'Add amount.';
      setState(() {});
      return;
    }

    if (SelectedDate == null) {
      _formError[SelectedDate] = 'Add date.';
      setState(() {});
      return;
    }

    final enteredTitle = textControler.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty || SelectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      SelectedDate,
    );
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          SelectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                verticalSpaceSmall,
                Container(
                  height: largeSize,
                  padding: const EdgeInsets.symmetric(
                      vertical: smallSize, horizontal: middleSize),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(largeSize),
                    ),
                  ),
                  child: InputField(
                    inputType: TextInputType.name,
                    controller: textControler,
                    style: AppTextStyle.h4Normal.copyWith(color: Colors.black),
                    hint: 'Enter Title',
                    stroke: false,
                  ),
                ),
                if (formError[textControler] != null) ...<Widget>[
                  verticalSpaceSmall,
                  Center(
                    child: Text(
                      formError[textControler]!,
                      style: AppTextStyle.withColor(
                          color: dangerColor, style: AppTextStyle.h5Normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpaceMiddle,
                ] else ...<Widget>[
                  verticalSpaceMedium
                ],
                Container(
                  height: largeSize,
                  padding: const EdgeInsets.symmetric(
                      vertical: smallSize, horizontal: middleSize),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(largeSize),
                    ),
                  ),
                  child: InputField(
                    inputType: TextInputType.number,
                    controller: amountController,
                    style: AppTextStyle.h4Normal.copyWith(color: Colors.black),
                    hint: 'Enter Amount',
                    stroke: false,
                  ),
                ),
                if (formError[amountController] != null) ...<Widget>[
                  verticalSpaceSmall,
                  Center(
                    child: Text(
                      formError[amountController]!,
                      style: AppTextStyle.withColor(
                          color: dangerColor, style: AppTextStyle.h5Normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpaceMiddle,
                ] else ...<Widget>[
                  verticalSpaceMedium
                ],
                InkWell(
                  onTap: presentDatePicker,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    height: largeSize,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(largeSize),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: smallSize),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              style: AppTextStyle.h4Normal
                                  .copyWith(color: Colors.black),
                              SelectedDate == null
                                  ? 'No Date Chosen'
                                  : 'Picked Date: ${DateFormat.yMd().format(SelectedDate)}',
                            ),
                          ),
                          const Icon(Icons.date_range),
                        ],
                      ),
                    ),
                  ),
                ),
                if (formError[SelectedDate] != null) ...<Widget>[
                  verticalSpaceSmall,
                  Center(
                    child: Text(
                      formError[SelectedDate]!,
                      style: AppTextStyle.withColor(
                          color: dangerColor, style: AppTextStyle.h5Normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpaceMiddle,
                ] else ...<Widget>[
                  verticalSpaceMedium
                ],
                CustomeButton(
                  text: 'Add Expense',
                  loading: false,
                  onTap: submitData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
