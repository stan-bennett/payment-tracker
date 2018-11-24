class Payment {
  Payment(this.name) {
    _amount = 0.0;
    _date = DateTime.now().millisecondsSinceEpoch;
  }

  // fields
  double _amount;
  double get amount => _amount;

  int _date;
  int get date => _date;

  int id;
  String name;

  // map
  Payment.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this._amount = map['amount'];
    this._date = map['date'];
    this.name = map['name'];
  }

  Payment.map(dynamic obj) {
    this.id = obj['id'];
    this._amount = obj['amount'];
    this._date = obj['date'];
    this.name = obj['name'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['amount'] = amount;
    map['date'] = date;
    map['name'] = name;
    return map;
  }

  // public methods
  void setAmount(String amountText) {
    double amountValue = double.tryParse(amountText);
    _amount = amountValue != null ? amountValue : 0.0;
  }

  void setDate(DateTime dateValue) {
    _date = dateValue.millisecondsSinceEpoch;
  }
}
