// ignore_for_file: prefer_const_constructors, unused_field, use_key_in_widget_constructors

import 'package:exp_tracker/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:exp_tracker/widget/transaction_item.dart';

import '../model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  // ignore: prefer_const_constructors_in_immutables
  TransactionList(this.transactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 570,
      child: transactions.isEmpty
          ? Center(
              child: Text(
                'You Haven\'t Added Any Expenses Yet.',
                style: AppTextStyle.h3Bold,
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return TransactionItem(
                    transaction: transactions[index],
                    deleteTransaction: deleteTransaction);
              },
              itemCount: transactions.length,
            ),
    );
  }
}
