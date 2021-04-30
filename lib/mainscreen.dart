//@dart = 2.9
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:Medico/DBService/DatabaseConnection.dart';
import 'package:Medico/DBService/saveservice.dart';
import 'package:Medico/Model/dataDetails.dart';
import 'package:Medico/utility.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utility/utility.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _date = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _amounttype = TextEditingController();
  TextEditingController _producttype = TextEditingController();

  var _data = DataDetails();
  var _saveservice = SaveService();
  String direc = "";
  String globalimgurl = "";
  // ignore: deprecated_member_use
  List<DataDetails> _dataList = List<DataDetails>();
  int listlength;
  File _image;
  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    _dataList = List<DataDetails>();
    var datas = await _saveservice.readData();
    datas.forEach((data) {
      setState(() {
        var datamodel = DataDetails();
        datamodel.id = data['id'];
        datamodel.name = data['name'];
        datamodel.phone = data['phone'];
        datamodel.amount = data['amount'];
        datamodel.date = data['date'];
        datamodel.amounttype = data['amtype'];
        datamodel.productype = data['ptype'];

        _dataList.add(datamodel);
      });
    });
  }

  _showFormDialog(BuildContext context) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text(
              "Add Details",
              style: GoogleFonts.lato(color: Colors.black),
            ),
            content: Container(
              width: 500,
              height: 350,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pickImagefromGalary();
                        var value = _image;
                        setState(() {
                          Navigator.pop(context);
                          globalimgurl =
                              Utility.base64String(_image.readAsBytesSync());
                          print("AAAAAAAAAAAAAAAAAAAAA${globalimgurl}");
                        });
                        //do what you want here
                      },
                      child: CircleAvatar(
                        radius: 55.0,
                        backgroundImage: _image != null
                            ? FileImage(_image)
                            : NetworkImage(""),
                      ),
                    ),
                    TextField(
                      controller: _name,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          hintText: "Name", icon: Icon(Icons.person)),
                    ),
                    TextField(
                        cursorColor: Colors.green,
                        controller: _mobile,
                        decoration: InputDecoration(
                            hintText: "Mobile No",
                            icon: Icon(Icons.phone_iphone_rounded),
                            hoverColor: Colors.green),
                        keyboardType: TextInputType.number),
                    TextField(
                        controller: _amount,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                            hintText: "Amount", icon: Icon(Icons.attach_money)),
                        keyboardType: TextInputType.number),
                    TextField(
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        hintText: "Select Date",
                        icon: Icon(Icons.date_range_outlined),
                      ),
                      controller: _date,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        ).then((pickedDate) {
                          _date.text = pickedDate == null
                              ? DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now())
                                  .toString()
                              : DateFormat('dd-MM-yyyy')
                                  .format(pickedDate)
                                  .toString();
                        });
                      },
                    ),
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>['Cash', 'Online', 'Gpay']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Amount Type",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _amounttype.text = value;
                          Fluttertoast.showToast(msg: "You Selected ${value}");
                        });
                      },
                    ),
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>['Product', 'Service']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Product Type",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _producttype.text = value;
                          Fluttertoast.showToast(msg: "You Selected ${value}");
                        });
                      },
                    ),
                    Container(
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          _data.date = _date.text;
                          _data.name = _name.text;
                          _data.phone = _mobile.text;
                          _data.amount = _amount.text;
                          _data.productype = _amounttype.text;
                          _data.amounttype = _producttype.text;

                          var result = await _saveservice.saveData(_data);
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/main', (route) => false);
                          Fluttertoast.showToast(
                              msg: "Data Inserted Successfully");

                          print(result);
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    listlength = _dataList.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Medico",
          style: GoogleFonts.satisfy(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: listlength > 0
          ? ListView.builder(
              itemCount: _dataList.length,
              padding: EdgeInsets.only(bottom: 145),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.green,
                  shape: Border(right: BorderSide(color: Colors.red, width: 5)),
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          _dataList[index].name,
                          style: GoogleFonts.openSans(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataList[index].phone,
                          style: GoogleFonts.openSans(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataList[index].date,
                          style: GoogleFonts.openSans(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataList[index].amounttype,
                          style: GoogleFonts.openSans(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataList[index].productype,
                          style: GoogleFonts.openSans(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₹${_dataList[index].amount}",
                      style: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.w800, color: Colors.red),
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
              "No Data Inserted",
              style: GoogleFonts.mcLaren(
                  color: Colors.red, fontWeight: FontWeight.w800),
            )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              print("Pressed");

              _showFormDialog(context);
            },
            backgroundColor: Colors.green,
            child: Icon(CupertinoIcons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(CupertinoIcons.share),
            onPressed: () {
              _generate_CSV(context);

              print("nd TAGGGGGGGG=>${direc}");
              Fluttertoast.showToast(msg: "File Generated at ${direc}");
            },
            heroTag: null,
          )
        ],
      ),
    );
  }

  Future<Void> _generate_CSV(context) async {
    List<List<dynamic>> csvData = [
      <String>[
        'Name',
        'Mobile',
        'Amount(INR)                                                                                                                                                                                                                                                                                                                                                  )',
        'Date',
        'Amount Type',
        'Product Type',
      ],
      ..._dataList.map((e) => [
            e.name,
            e.phone,
            e.amount,
            e.date,
            e.amounttype,
            e.productype,
          ]),
    ];

    direc = (await getExternalStorageDirectory()).absolute.path + "/";
    print("TAG==================================${direc}");

    final File f = File(direc + "data.csv");

    String csv = const ListToCsvConverter().convert(csvData);

    await f.writeAsString(csv);
  }

  final picker = ImagePicker();
  pickImagefromGalary() {
    PickImage();

    /*_image =
        ImagePicker.platform.pickImage(source: ImageSource.gallery);
    ImagePicker.platform.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString =
          Utility.base64String((File('${imgFile}').readAsBytesSync()));
      globalimgurl = imgString;
      print("ajkkkkkkkkkkkkkkkkkkkkkkkkksdv=>${globalimgurl} ++ ${imgString}");
    });*/
  }

  Future<File> PickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
      globalimgurl = _image.toString();
      print(globalimgurl);
      print("++++++++++++++++++++++++++++++++++${_image}");
    });

    return _image;
  }
}
