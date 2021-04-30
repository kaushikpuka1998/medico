//@dart =2.9

import 'package:Medico/DBService/repo.dart';
import 'package:Medico/Model/dataDetails.dart';

class SaveService {
  Repo _repo;

  SaveService() {
    _repo = Repo();
  }

  saveData(DataDetails dataDetails) async {
    return await _repo.InsertData('data', dataDetails.DataDetailsmap());

    //print(dataDetails.name);
    //print(dataDetails.phone);
    //print(dataDetails.amount);
    //print(dataDetails.date);
  }

  readData() async {
    return await _repo.readData('data');
  }
}
