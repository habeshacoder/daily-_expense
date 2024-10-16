// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison
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

  void submitData() {
    if (amountController.text.isEmpty) {
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
                TextField(
                  controller: textControler,
                  decoration: const InputDecoration(labelText: "title"),
                  onSubmitted: (_) {
                    submitData();
                  },
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: "amount"),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) {
                    submitData();
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 7,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            SelectedDate == null
                                ? 'no date chosen '
                                : 'picked date: ${DateFormat.yMd().format(SelectedDate)}',
                          ),
                        ),
                        TextButton(
                          onPressed: presentDatePicker,
                          child: const Text('choos the date'),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: submitData,
                  child: const Text("add transaction"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
