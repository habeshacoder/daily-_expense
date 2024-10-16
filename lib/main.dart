// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exp_tracker/widget/chart.dart';
import 'package:exp_tracker/widget/new_transaction.dart';
import 'package:exp_tracker/widget/transaction_list.dart';
import 'model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter()); // Register the adapter
  await Hive.openBox<Transaction>('transactions'); // Open a box
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'personal expense',
      theme: ThemeData(
        hintColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .bodyMedium,
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .titleLarge,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(error: Colors.red),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final List<Transaction> _userTransactions = [];
  bool showswitch = false;

  late Box<Transaction> transactionBox;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
    fetchTransactions();
  }

  void fetchTransactions() {
    setState(() {
      transactions = transactionBox.values.toList();
    });
  }

  // void _addNewTransaction(Transaction newTransaction) {
  //  // Refresh the transaction list
  // }

  void _deleteTransactionsByDate(DateTime date) {
    // Get all the keys from the box
    final allKeys = transactionBox.keys.toList();
    // Iterate over all keys and delete matching transactions
    for (var key in allKeys) {
      final transaction = transactionBox.get(key);
      if (transaction != null && transaction.date.isAtSameMomentAs(date)) {
        transactionBox.delete(key); // Delete using the key
      }
    }

    fetchTransactions(); // Refresh the transaction list
  }

  List<Transaction> get _recenttransactions {
    return transactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTilte, double txAmount, dynamic choosendate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTilte,
      amount: txAmount,
      date: choosendate,
    );

    transactionBox.add(newTx);
    fetchTransactions();
  }

  void _startAddNewTransction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  @override
  Widget build(BuildContext context) {
    final islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Track Your Daily Expenses',
        style: TextStyle(color: Colors.black),
      ),
    );
    final chartwidget = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.3,
      child: Chart(_recenttransactions),
    );
    final txlistwidget = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(transactions, _deleteTransactionsByDate),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (islandscape)
              Row(
                children: <Widget>[
                  Text('swich chart'),
                  Switch(
                    value: showswitch,
                    onChanged: (val) {
                      setState(() {
                        showswitch = val;
                      });
                    },
                  ),
                ],
              ),
            if (!islandscape) chartwidget,
            if (!islandscape) txlistwidget,
            showswitch ? chartwidget : txlistwidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return _startAddNewTransction(context);
        },
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
