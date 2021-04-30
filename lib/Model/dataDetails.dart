//@dart=2.9

class DataDetails {
  int id;
  String name;
  String phone;
  String amount;
  String date;
  String productype;
  String amounttype;

  DataDetailsmap() {
    Map<String, dynamic> mappi = Map<String, dynamic>();
    mappi['id'] = id;
    mappi['name'] = name;
    mappi['phone'] = phone;
    mappi['amount'] = amount;
    mappi['date'] = date;
    mappi['ptype'] = productype;
    mappi['amtype'] = amounttype;

    return mappi;
  }
}
