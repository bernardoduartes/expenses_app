import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      recentTransactions.forEach((recentTransaction) {
        bool sameWeekDay = recentTransaction.date.day == weekDay.day;
        bool sameMonth = recentTransaction.date.month == weekDay.month;
        bool sameYear = recentTransaction.date.year == weekDay.year;

        if (sameWeekDay && sameMonth && sameYear) {
          totalSum += recentTransaction.value;
        }
      });

      print(DateFormat.E().format(weekDay)[0]);
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
