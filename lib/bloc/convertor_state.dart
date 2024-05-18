part of 'convertor_bloc.dart';

abstract class ConvertorState {
  Widget getBuildInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: 
      ListView(
        children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 40, spreadRadius: 0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(25)),
                    child: const Text("Конвертер",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Курсы валют",
                        style:
                            TextStyle(color: Colors.black.withOpacity(0.75))),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Конвертер валют",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        _getMainUi(),
        const SizedBox(height: 25),
      ]),
    );
  }

  Widget _getMainUi();
}

abstract class BasicState extends ConvertorState{
  String getChatText();

  @override
  Widget _getMainUi(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.message_sharp,
                  color: Colors.amber,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(getChatText())),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
        _getOtherPart(),
      ],
    );
  }

  Widget _getOtherPart();
}

class ConvertorInitial extends ConvertorState {
  @override
  Widget _getMainUi() {
    return Container();
  }
  
}

class ConvertorLoading extends ConvertorState {
  @override
  Widget getBuildInfo() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  @override
  Widget _getMainUi() {
    return Container();
  }

}

class ConvertorLoadingFailed extends BasicState {
  final ConvertorBloc convertorBloc;

  ConvertorLoadingFailed(this.convertorBloc);

  @override
  String getChatText() {
    return "Не удалось получить обменные курсы валют. Повторите запрос позже.";
  }

  @override
  Widget _getOtherPart() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: () {convertorBloc.add(LoadCurrencies(null));}, 
          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                          ),
          child: const Text("Повторить")
          ),
      ),
    );
  }


}

class ConvertorLoaded extends BasicState {
  final HomePageState homePageState;
  final ConvertorBloc convertorBloc;

  final Currency currencyOne;
  final Currency currencyTwo;

  final List<double> rates;

  GlobalKey<ConvertorWidgetState> secondWidget = GlobalKey<ConvertorWidgetState>();

  ConvertorLoaded(this.currencyOne, this.currencyTwo, this.rates, this.homePageState, this.convertorBloc){
    tz.initializeTimeZones();
  }

  void changeRecieveValue(String value)
  {
    int? summ = int.tryParse(value);
    summ ??= 0;
    secondWidget.currentState?.changeTextValue(summ);
  }

  void changeFirstCurrency(){
    convertorBloc.editableWidget = 0;

    homePageState.displayBottomSheet();
  }

  void changeSecondCurrency(){
    convertorBloc.editableWidget = 1;
    homePageState.displayBottomSheet();
  }

  @override
  String getChatText() {
    return "Все переводы курсов конвертер осуществляет на основе стоимости валют по данным ЦБ РФ.";
  }

  @override
  Widget _getOtherPart() {
    return Column(
      children: [
        const SizedBox(height: 25),
              ConvertorWidget(true, "Хочу обменять:", "1 ${currencyOne.code} = ${rates[0]} ${currencyTwo.code}", Colors.blue.withOpacity(0.2), currencyOne, rates[0], changeRecieveValue, changeFirstCurrency),
              const SizedBox(height: 25),
              ConvertorWidget(key: secondWidget, false, "Вы получите:", "1 ${currencyTwo.code} = ${rates[1]} ${currencyOne.code}", Colors.purple.withOpacity(0.2), currencyTwo,rates[1],(value) {} ,changeSecondCurrency),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Данные за ${DateFormat('yyyy-MM-dd HH:mm', 'en_US').format(DateTime.now())} ${tz.local.name}",
                    style: TextStyle(color: Colors.black.withOpacity(0.66)),
                  )
                ],
              ),
      ],
    );
  }
}