// ignore_for_file: file_names

import 'package:currency_convertor/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertorWidget extends StatefulWidget {
  final bool isInput;
  final String topText;
  final String bottomText;
  final Color backgroundColor;

  final Currency currency;
  final double rate;
  final void Function(String) valueChangedAction;
  final void Function() dropdawnAction;

  const ConvertorWidget(this.isInput, this.topText, this.bottomText, this.backgroundColor,
      this.currency, this.rate, this.valueChangedAction, this.dropdawnAction,
      {super.key});

  @override
  State<StatefulWidget> createState() => ConvertorWidgetState();
}

class ConvertorWidgetState extends State<ConvertorWidget> {

  TextEditingController textController = TextEditingController();

  void changeTextValue(int summ){
    textController.text = (summ / widget.rate).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.topText,
                style: TextStyle(color: Colors.black.withOpacity(0.6))),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: widget.isInput ? "Введите сумму" : '',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none)),
                    controller: textController,
                    enabled: widget.isInput,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => widget.valueChangedAction(value),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Image.asset(widget.currency.imageSource,
                          width: 30, height: 30),
                      const SizedBox(width: 8),
                      Text(widget.currency.code),
                      IconButton(
                        onPressed: widget.dropdawnAction,
                        icon: const Icon(Icons.arrow_drop_down),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 3),
            Text(widget.bottomText,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}