import 'package:flutter/material.dart';
import 'package:payment_tracker/model/payment.dart';
import 'package:payment_tracker/util/database_helper.dart';
import 'package:payment_tracker/ui/payment_screen.dart';

class ListViewPayment extends StatefulWidget {
  @override
  _ListViewPaymentState createState() => new _ListViewPaymentState();
}

class _ListViewPaymentState extends State<ListViewPayment> {
  List<Payment> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllPayments().then((payments) {
      setState(() {
        payments.forEach((payment) {
          items.add(Payment.fromMap(payment));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].name}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${items[position].amount}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deletePayment(context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToPayment(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewPayment(context),
        ),
      ),
    );
  }

  void _deletePayment(BuildContext context, Payment payment, int position) async {
    db.deletePayment(payment.id).then((payments) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToPayment(BuildContext context, Payment payment) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen(payment)),
    );

    if (result == 'update') {
      db.getAllPayments().then((payments) {
        setState(() {
          items.clear();
          payments.forEach((payment) {
            items.add(Payment.fromMap(payment));
          });
        });
      });
    }
  }

  void _createNewPayment(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen(Payment(''))),
    );

    if (result == 'save') {
      db.getAllPayments().then((payments) {
        setState(() {
          items.clear();
          payments.forEach((payment) {
            items.add(Payment.fromMap(payment));
          });
        });
      });
    }
  }
}