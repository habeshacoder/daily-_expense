import 'package:exp_tracker/utility/capitilize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exp_tracker/model/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      elevation: 5,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FittedBox(child: Text('\$${transaction.amount}')),
            ),
          ),
        ),
        title: Text(capitalizeTitle(transaction.title)),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: IconButton(
          onPressed: () => deleteTransaction(transaction.date),
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
