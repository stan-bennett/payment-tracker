import 'package:payment_tracker/model/payment.dart';
import "package:test/test.dart";

void main() {
  // blue sky tests
  test("testBlueSky_defaultValues", () {
    // exercise
    Payment payment = new Payment("capital one");

    // post-conditions
    expect(0.0, payment.amount);
    expect(null, payment.id);
    expect("Capital One", payment.name);
  });

  test("testBlueSky_setAmount", () {
    // set-up
    Payment payment = new Payment("Capital One");

    // pre-conditions
    expect(0.0, payment.amount);

    // exercise
    payment.setAmount("85.93");

    // post-conditions
    expect(85.93, payment.amount);
  });

  test("testBlueSky_setDate", () {
    // set-up
    Payment payment = new Payment("Capital One");
    DateTime date = new DateTime(2018, 11, 24);

    // exercise
    payment.setDate(date);

    // post-conditions
    expect(date, DateTime.fromMillisecondsSinceEpoch(payment.date));
  });

  // non blue sky tests
  test("testNonBlueSky_setAmount_withInvalidValue", () {
    // set-up
    Payment payment = new Payment("Capital One");

    // pre-conditions
    expect(0.0, payment.amount);

    // exercise
    payment.setAmount("abc");

    // post-conditions
    expect(0.0, payment.amount);
  });
}
