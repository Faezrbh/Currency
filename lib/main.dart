import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:currency/model/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa'),
      ],
      theme: ThemeData(
        fontFamily: 'dana',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          displayMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          headlineLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse() async {
    var url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    if (!mounted) return;
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context , "بروزرسانی با موفقیت انجام شد.");
        var jsonResponse = convert.jsonDecode(value.body) as List;
        if (jsonResponse.isNotEmpty) {
          setState(() {
  currency = jsonResponse.map((item) => Currency(
    id: item['id'],
    title: item['title'],
    price: item['price'],
    changes: item['changes'],
    status: item['status'],
  )).toList();
});
        }
      }
    }
    return value;
  }
  

  @override
  void initState() {
    super.initState();
    getResponse();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          const SizedBox(width: 14),
          Image.asset('assets/images/icon.png'),
          const SizedBox(width: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "قیمت بروز سکه و ارز",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.menu),
            ),
          ),

          const SizedBox(width: 14),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/q.png'),
                  SizedBox(width: 10),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 130, 130, 130),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "نام آزاد ارز",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "قیمت",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "تغییر",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/2,
                child: listFutureBuilder(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height/16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height/16,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 202, 193, 255),
                            ),
                          ),
                          onPressed: () {
                            currency.clear();
                            listFutureBuilder(context);
                          },
                          icon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                            child: Icon(
                              CupertinoIcons.refresh_bold,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                            child: Text(
                              "بروزرسانی",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ),
                      Text("آخرین بروزرسانی ${_getTime()}"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
                builder: (context, snapshot) {
                  return snapshot.hasData ? 
                  ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: currency.length,
                  itemBuilder: (BuildContext context, int postion) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: MyItem(postion, currency),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    if (index % 12 == 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Advertisement(),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ) : Center(child: CircularProgressIndicator(),);
                },
                future: getResponse(),
              );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return getFarsiNumber(DateFormat('kk:mm:ss').format(now));
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: Theme.of(context).textTheme.displayMedium),
      backgroundColor: Colors.green,
    ),
  );
}

class MyItem extends StatelessWidget {
  final int postion;
  final List<Currency> currency;
  const MyItem(this.postion, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 1, color: Colors.grey)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[postion].title!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber( currency[postion].price.toString()),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber(currency[postion].changes.toString()),
            style: currency[postion].status == "n"
                ? Theme.of(context).textTheme.displaySmall
                : Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 1, color: Colors.grey)],
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("تبلیغات", style: Theme.of(context).textTheme.displayMedium),
        ],
      ),
    );
  }
}

String getFarsiNumber(String number){
  const en = ['0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9'];
  const fa = ['۰' , '۱' , '۲' , '۳' , '۴' , '۵' , '۶' , '۷' , '۸' , '۹'];

  for (var element in en) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);

  }

  return number;
}