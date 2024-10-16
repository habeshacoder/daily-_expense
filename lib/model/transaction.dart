// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: unused_import
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});

  @override
  String toString() {
    return 'Transaction(amount: $amount, id: $id, title: $title, date: $date)';
  }
}
