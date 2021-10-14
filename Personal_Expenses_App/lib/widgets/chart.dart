import './chartBar.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get weeklyTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].value;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalAmount {
    return weeklyTransactionValues.fold(
        0.0, (previousValue, element) => previousValue + element["amount"]);
  }

  @override
  Widget build(BuildContext context) {
    print(weeklyTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weeklyTransactionValues
              .map(
                (e) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    e["day"],
                    totalAmount == 0.0
                        ? 0.0
                        : (e["amount"] as double) / totalAmount,
                    e["amount"],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
