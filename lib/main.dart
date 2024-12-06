// ignore_for_file: prefer_const_constructors, unused_element

import 'package:exp_tracker/common/app_colors.dart'; // Your existing color file
import 'package:exp_tracker/common/app_text_style.dart';
import 'package:exp_tracker/common/ui_helpers.dart';
import 'package:exp_tracker/nfc_app/view/app.dart';
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
      theme: ThemeData(
        primaryColor: primaryColor, // Set the primary color globally
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(color: whiteColor, fontSize: 20),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
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

  void _deleteTransactionsByDate(DateTime date) {
    final allKeys = transactionBox.keys.toList();
    for (var key in allKeys) {
      final transaction = transactionBox.get(key);
      if (transaction != null && transaction.date.isAtSameMomentAs(date)) {
        transactionBox.delete(key);
        break;
      }
    }

    fetchTransactions();
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

  void _startAddNewTransaction(BuildContext ctx) {
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
      actions: [
        InkWell(
            onTap: () async {
              final app = await App.withDependency();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => app,
                  ));
            },
            child: Icon(
              Icons.menu,
              color: whiteColor,
            )),
        horizontalSpaceSmall
      ],
      title: Text(
        'Recod Expenses',
        style: TextStyle(color: whiteColor),
      ),
    );
    final chartWidget = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.2,
      child: Chart(_recenttransactions),
    );
    final txListWidget = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(transactions, _deleteTransactionsByDate),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: middleSize),
          child: Column(
            children: <Widget>[
              verticalSpaceSmall,
              Text(
                'Once added, the chart only compares the records from the past seven days.',
                style: AppTextStyle.h3Normal,
                textAlign: TextAlign.justify,
              ),
              verticalSpaceSmall,
              if (!islandscape && transactions.isNotEmpty) chartWidget,
              if (!islandscape) txListWidget,
              showswitch ? chartWidget : txListWidget,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          return _startAddNewTransaction(context);
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
