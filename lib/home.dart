import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List currencies;
  final List<MaterialColor> colors = [
    Colors.brown,
    Colors.pink,
    Colors.green,
    Colors.red
  ];

  @override
  void initState() async{
    super.initState;
    currencies = await getCurrencies();
  }

  Future<List> getCurrencies() async {
    String cryptourl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
    http.Response response = await http.get(cryptourl);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WaveCoin'),
      ),
      body: _cryptowidget(),
    );
  }


  Widget _cryptowidget() {
    return Container(
      child: Flexible(
          child: ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (BuildContext context, int index) {
              Map currency = currencies[index];
              MaterialColor color = colors[index % colors.length];
              return getListItemUI(currency,color);
            },
          )
      ),
    );
  }

  Widget getListItemUI(Map currency,MaterialColor color){
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(currency['name'][0]),
      ),
      title: Text(currency['name'],
       style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: getSubtitleText(currency['price_usd'],currency['percentage_change_1h'])
    );
  }
  Widget getSubtitleText(String price,String percentage){
    TextSpan priceText = TextSpan(
      text: "\$$price"
    );
    String percentageChange = "1 Hour: $percentage%";
    TextSpan percentageChangeWidget;
    if(double.parse(percentage)>0){
      percentageChangeWidget = TextSpan(
        text: percentageChange,
        style: TextStyle(color: Colors.green)
      );
    }
    else{
      percentageChangeWidget = TextSpan(
          text: percentageChange,
          style: TextStyle(color: Colors.red));
  }
}}
