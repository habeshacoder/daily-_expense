import 'package:hive/hive.dart';
import '../model/transaction.dart';

class TransactionNotifier {
  late Box<Transaction> _transactionBox;

  TransactionNotifier() {
    _transactionBox = Hive.box<Transaction>('transactions');
  }

  // Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.add(transaction);
  }

  // List all transactions
  List<Transaction> listTransactions() {
    return _transactionBox.values.toList();
  }

  // Delete a transaction by index
  Future<void> deleteTransaction(int index) async {
    await _transactionBox.deleteAt(index);
  }
}
