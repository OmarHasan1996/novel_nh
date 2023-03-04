// ignore_for_file: file_names
//import 'package:ul_service/screen/selectScreen.dart';

//import '/api.dart';
import 'package:novel_nh/screen/letsGoScreen.dart';
import 'package:novel_nh/screen/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../boxes.dart';
import '../localization_service.dart';
import '../color/MyColors.dart';
//import '/screen/singnIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
//import '../boxes.dart';
import '../const.dart';
import '../localizations.dart';
import '../model/transaction.dart';
import 'countryAndLang.dart';
//import 'package:matrix4_transform/matrix4_transform.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  var _futures;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read();
    Timer(Duration(seconds: 1000000000), () => null/*navigate()*/);
    DateTime date = DateTime.now();
    var duration = date.timeZoneOffset;
    timeDiff = new Duration(hours: -duration.inHours, minutes: -duration.inMinutes % 60);
    _futures = _readText();
  }

  MyWidget? _m;

  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/images/splash_background.png"),
          fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: MyColors.trans,
        body: initScreen(context),
      ),
    );
  }

  startTime() async {
    /*final _keyWelcome = 'welcome';
    final prefs = await SharedPreferences.getInstance();
    welcom = prefs.getBool(_keyWelcome) ?? true;*/
  }

  bool welcom = false;

  navigate() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => welcom ?  MainScreen() : LetsGoScreen(),
        ));
  }

  bool ani = false;

  initScreen(BuildContext context) {
    return Column(
        children: [
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/splash.png', width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,),),
          ),
          Flexible(
            flex: 1,
            child: Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/25, horizontal: MediaQuery.of(context).size.width/7),
            child: Column(
              children: [
                GestureDetector(
                  child: FutureBuilder(
                    future: _futures,
                    builder : (BuildContext context, AsyncSnapshot snap){
                      if(snap.connectionState==ConnectionState.done){
                        return _m!.headText(AppLocalizations.of(context)!.translate(
                            'Comimania represents the passion for comics, characters, gaming & licensed brands'),
                            maxLine: 3, color: MyColors.white, scale: 0.85);
                      }
                      else{
                        return SizedBox();
                        return _m!.headText(AppLocalizations.of(context)!.translate(
                            'Comimania represents the passion for comics, characters, gaming & licensed brands'),
                            maxLine: 3, color: MyColors.white);
                      }
                    },
                  ),
                  onTap: ()=> navigate(),
                ),

                /*_m!.headText(AppLocalizations.of(context)!.translate(
                    'Comimania represents the passion for comics, characters, gaming & licensed brands'),
                    maxLine: 3, color: MyColors.white),*/
                Expanded(child: SizedBox()),

                GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height/100),
                        child: Icon(Icons.language_outlined, color: MyColors.white, size: MediaQuery.of(context).size.height/35,),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height/70+MediaQuery.of(context).size.height/50)),
                          color: MyColors.orange,
                        ),
                      ),
                      _m!.bodyText1(
                          AppLocalizations.of(context)!.translate('LANGUAGE'), maxLine: 1,
                          color: MyColors.white),
                    ],
                  ),
                  /*_m!.bodyText1(
                      AppLocalizations.of(context)!.translate('Skip'), maxLine: 1,
                      color: MyColors.white),*/
                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CountryAndLanguage())),
                ),

                IconButton(
                    onPressed: ()=> navigate(),
                    icon: Icon(Icons.navigate_next, color: MyColors.white,)
                ),

              ],
            ),
            ),
          ),
        ]
    );
  }

  _read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    welcom = sharedPreferences.getBool('logIn')??false;
    try{
      lng = sharedPreferences.getInt('lng')??0;
      await LocalizationService().changeLocale(lng, context);
      token = sharedPreferences.getString('token')??'';
      //welcom = false;
    }catch(e){
      welcom = false;
      print(e);
    }
    var box = Boxes.getTransactions();
    transactions = box.values.cast<Transaction>().toList();
    if(transactions!.isEmpty) {
      await addTransaction();
    } else{
      guestType = transactions![0].guestType;
      ordersList = transactions![0].ordersList;
      productList = transactions![0].productList;
      categoryList = transactions![0].categoryList;
      subCategoryList = transactions![0].subCategoryList;
      salesList = transactions![0].salesList;
      brandsList = transactions![0].brandsList;
      shippingMethodsList = transactions![0].shippingMethodsList;
      shopNowList = transactions![0].shopNowList;
      newArrivalList = transactions![0].newArrivalList;
      homeSection1List = transactions![0].homeSection1List;
      cartList = transactions![0].cartList;
      cartListTotal = transactions![0].cartListTotal;
      wishList = transactions![0].wishList;
      myAddress =transactions![0]. myAddress;
      selectedAddress = transactions![0].selectedAddress;
      countries = transactions![0].countries;
      currency = transactions![0].currency;
      currencyValue = transactions![0].currencyValue;
      paymentCard = transactions![0].paymentCard;
      notificationAndEmail = transactions![0].notificationAndEmail;
      userData = transactions![0].userData;
      userInfo = transactions![0].userInfo;
    }

  }

  _readText() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      lng = sharedPreferences.getInt('lng')??0;
      await LocalizationService().changeLocale(lng, context);
      return true;
    }catch(e){
      print(e);
      return false;
    }
    return true;
  }

}