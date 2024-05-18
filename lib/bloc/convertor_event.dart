part of 'convertor_bloc.dart';

abstract class ConvertorEvent{}

class LoadCurrencies extends ConvertorEvent{
  final Completer? completer;

  LoadCurrencies(this.completer);
}