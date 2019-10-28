import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  String value0 = '?';
  String value1 = '?';
  String value2 = '?';

  void getData() async {
    try {
      Map<String, double> data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        value0 = data[cryptoList[0]].toStringAsFixed(0);
        value1 = data[cryptoList[1]].toStringAsFixed(0);
        value2 = data[cryptoList[2]].toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<Widget> cryptoCardList() {
    List<Widget> cryptoCards = [];
    for (int i = 0; i < cryptoList.length; i++) {
      String cryptoValue;
      if (i == 0) {
        cryptoValue = value0;
      } else if (i == 1) {
        cryptoValue = value1;
      } else {
        cryptoValue = value2;
      }
      cryptoCards.add(CryptoCard(
          selectedCurrency: selectedCurrency,
          value: cryptoValue,
          cryptoCurrency: cryptoList[i]));
    }
    //Adding the picker at the end.
    cryptoCards.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? iOSPicker() : androidDropdown(),
    ));
    return cryptoCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoCardList(),
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String selectedCurrency;
  final String value;
  final String cryptoCurrency;

  CryptoCard({this.cryptoCurrency, this.selectedCurrency, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
