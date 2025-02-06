import 'package:flutter/material.dart';
import 'transaction_screen.dart';
import 'history_screen.dart';
import 'package:raskara_boutique/widgets/chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboad'),
          automaticallyImplyLeading: false, 
        ),
        body: Column(
          children: [
            ChartWidget(),
          ],
        ),
      ),
    );
  }
}