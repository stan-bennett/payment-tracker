import 'package:payment_tracker/model/payment.dart';
import "package:test/test.dart";

void main() {
  test("testBlueSky_defaultValues", () {
    // exercise
    Payment payment = new Payment("Capital One");

    // post-conditions
    expect(0.0, payment.amount);
    expect(DateTime.now().day, payment.day);
    expect(null, payment.id);
    expect("Capital One", payment.name);
  });
}
