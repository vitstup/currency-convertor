import 'dart:convert';

import 'package:dio/dio.dart';

class RatesRepository {
  String codeOne;
  String codeTwo;

  RatesRepository(this.codeOne, this.codeTwo);

  Future<List<double>> GetRates() async {
    try{
    final response = await Dio().get(
        'http://api.currencylayer.com/live?access_key=95ed7bdeb3f1198018bbf414147ea944&source=$codeOne&currencies=$codeTwo');

    Map<String, dynamic> data = json.decode(response.toString());

    double rate = data['quotes'][codeOne + codeTwo];

    double reversRate = 1 / rate;

    return [rate, reversRate];
    }
    catch(e){
      throw new Error();
    }
  }
}