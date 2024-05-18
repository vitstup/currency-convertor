import 'package:currency_convertor/bloc/convertor_bloc.dart';
import 'package:currency_convertor/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final ConvertorBloc convertorBloc;

  @override
  void initState() {
    super.initState();

    convertorBloc = ConvertorBloc(this);

    convertorBloc.add(LoadCurrencies(null));
  }

  void changeCurrency(Currency currency){
    if (convertorBloc.editableWidget == 0) {
      convertorBloc.currencyOne = currency;
    }
    else if (convertorBloc.editableWidget == 1){
      convertorBloc.currencyTwo = currency;
    }
    convertorBloc.add(LoadCurrencies(null));
    Navigator.of(context).pop();
  }

  Future displayBottomSheet() {
    Currency curCurrecny = convertorBloc.editableWidget == 0 ? convertorBloc.currencyOne : convertorBloc.currencyTwo;

    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Выберите валюту", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                    IconButton(
                      onPressed: () {Navigator.of(context).pop();},
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: convertorBloc.availableCurrencies.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.05),
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                                    curCurrecny = convertorBloc.availableCurrencies[index];
                                  }); 
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(convertorBloc.availableCurrencies[index].imageSource, width: 40, height: 40),
                                const SizedBox(width: 12),
                                Text(convertorBloc.availableCurrencies[index].code, style: const TextStyle(fontSize: 19, color: Colors.black,fontWeight: FontWeight.w500)),
                                const SizedBox(width: 12),
                                Text(convertorBloc.availableCurrencies[index].nameInRussian, style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.8))),
                                const Expanded(child: SizedBox()),
                                Radio(
                                  value: convertorBloc.availableCurrencies[index], 
                                  groupValue: curCurrecny, 
                                  onChanged: (value) { setState(() {
                                    curCurrecny = value!;
                                  }); }
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => changeCurrency(curCurrecny), 
                    style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 6, 19, 201),
                            ),
                    child: const Text("Применить", style: TextStyle(color: Colors.white, fontSize: 20))
                    ),
                )
              ],
            ),
          ),
        ),
      )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: false,
          title: const Text(
            "Конвертер валют онлайн",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color.fromARGB(255, 237, 242, 254),
          leading: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 27.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Colors.grey.withOpacity(0.33)),
            child: const Icon(Icons.arrow_back_ios_sharp),
          ),
        ),
        body: BlocBuilder<ConvertorBloc, ConvertorState>(
          bloc: convertorBloc,
          builder: (context, state) {
            return state.getBuildInfo();
          },
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Главная",
            ),
            NavigationDestination(
              icon: Icon(Icons.place),
              label: "Банкоматы",
            ),
            NavigationDestination(
              icon: Icon(Icons.currency_ruble),
              label: "Копилка",
            ),
          ],
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          elevation: 30,
        ),
      );
  }
}
