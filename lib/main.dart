import 'package:expenses_app/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

//
main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ]);

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                //liha abaixo muda o titulo do app bar
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Compra ${Random().nextDouble().toString()}',
      value: Random().nextDouble(),
      date: DateTime.now(),
    ),
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Compra ${Random().nextDouble().toString()}',
      value: Random().nextDouble(),
      date: DateTime.now(),
    ),
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Compra ${Random().nextDouble().toString()}',
      value: Random().nextDouble(),
      date: DateTime.now(),
    ),
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Compra ${Random().nextDouble().toString()}',
      value: Random().nextDouble(),
      date: DateTime.now(),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime selectedDate) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: selectedDate,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        ),
      ),
      actions: <Widget>[
        if (isLandscape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart_rounded),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
/*             if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Exibir Gráfico'),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ), */
            if (_showChart || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 0.8 : 0.3),
                  child: Chart(_recentTransactions)),
            if (!_showChart || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 1 : 0.7),
                  child: TransactionList(_transactions, _removeTransaction)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
