import 'package:flutter/material.dart';
import 'package:payment_tracker/model/payment.dart';
import 'package:payment_tracker/service/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final Payment payment;
  PaymentScreen(this.payment);

  @override
  State<StatefulWidget> createState() => new _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentService paymentService = new PaymentService();

  TextEditingController _nameController;
  TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _nameController = new TextEditingController(text: widget.payment.name);
    _amountController = new TextEditingController(text: widget.payment.amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.payment.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.payment.id != null) {
                  paymentService.updatePayment(Payment.fromMap({
                    'id': widget.payment.id,
                    'title': _nameController.text,
                    'description': _amountController.text
                  })).then((_) {
                    Navigator.pop(context, 'update');
                  });
                }else {
                  Payment payment = Payment(_nameController.text);
                  payment.setAmount(_amountController.text);
                  paymentService.savePayment(payment).then((_) {
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}