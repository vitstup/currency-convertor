import 'dart:async';

import 'package:currency_convertor/convertorwidget.dart';
import 'package:currency_convertor/currency.dart';
import 'package:currency_convertor/home.dart';
import 'package:currency_convertor/repository/ratesrepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


part 'convertor_event.dart';
part 'convertor_state.dart';

class ConvertorBloc extends Bloc<ConvertorEvent, ConvertorState> {
  final HomePageState homePageState;
  
  List<Currency> availableCurrencies = [];

  late Currency currencyOne;
  late Currency currencyTwo;

  int editableWidget = 0;

  ConvertorBloc(this.homePageState) : super(ConvertorInitial()) {


    availableCurrencies.addAll({
      Currency("assets/rus.png", "RUB", "Российский рубль"),
      Currency("assets/usa.png", "USD", "Доллар США"),
      Currency("assets/eu.png", "EUR", "Евро"),
      Currency("assets/swi.png", "CHF", "Швейцарский франк"),
      Currency("assets/japan.png", "JPY", "Японская йена"),
      Currency("assets/georgia.png", "GEL", "Грузинский лари"),
    });

    currencyOne = availableCurrencies[0];
    currencyTwo = availableCurrencies[1];

    on<LoadCurrencies>((event, emit) async {
      emit(ConvertorLoading());
      try {
        var rates = await RatesRepository(currencyOne.code, currencyTwo.code).GetRates();
        emit(ConvertorLoaded(currencyOne, currencyTwo, rates, homePageState, this));
      }
      catch(e){
        emit(ConvertorLoadingFailed(this));
      }
    });

  }
}