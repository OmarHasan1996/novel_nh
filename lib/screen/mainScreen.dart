import 'package:novel_nh/api.dart';
import 'package:novel_nh/screen/filterScreen.dart';
import 'package:novel_nh/screen/productDetails.dart';
import 'package:novel_nh/screen/resetPasswordScreen.dart';
import 'package:novel_nh/screen/signUpScreen.dart';

import '/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../MyWidget.dart';
import '../const.dart';
import '../localizations.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key,}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(() {
      setState(() {
        if(_searchController.text.isNotEmpty){
          _search = true;
          if(_categoryNum == 0){
            _internalProduct = productList.where((element) =>
                element['name_ar'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_en'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_fr'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
            ).toList();
          }else{
            /*_internalProduct = _internalProduct.where((element) =>
            element['name_ar'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_en'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
                ||
                element['name_fr'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
            ).toList();*/
          }
        }
        else _search = false;
      });
    });
  }

  TextEditingController _searchController = new TextEditingController();

  //TextEditingController _passwordController = new TextEditingController();
  MyWidget? _m;
  List _internalProduct = [];
  List _subCategoryList = [];
  List topHeader = [];
  var _categoryNum = 0;
  bool _main = true;
  bool _search = false;
  var _brandId = '1';


  @override
  Widget build(BuildContext context) {
    topHeader.clear();
    topHeader.add({'text': AppLocalizations.of(context)!.translate('All'), "click": _main? ()async=> await _clickHeader(0):null});
    for(int i=0; i< categoryList.length; i++){
      topHeader.add({'text': getCategoryName(i), "click": ()async=> await _clickHeader(i+1)});
    }
    _subCategoryList.clear();
    _subCategoryList.add({'text':AppLocalizations.of(context)!.translate('All')});
    for(int i=0; i< subCategoryList.length; i++){
      _subCategoryList.add(subCategoryList[i]);
    }
    if(!homeNotCategory && _categoryNum ==0 && topHeader.length>2) _clickHeader(1);
    salesList.shuffle();
    //homeSection1List.shuffle();
    /*_internalProduct.clear();
    for(int i =0; i < productList.length; i++){
     // print(productList[i]['CATId'].toString());
      //print(categoryNum.toString());
      if(!_main){
        if(productList[i]['brandId'].toString() == _brandId.toString())
          _internalProduct.add(productList[i]);
        //break;
      }
      else{
        if(subCategoryList.isEmpty) break;
        if(productList[i]['CATId'].toString()==categoryNum.toString() && productList[i]['SCId'].toString()==subCategoryList[_subCategorySelectNum]['SCId'].toString()){
          _internalProduct.add(productList[i]);
        }
      }
    }*/
      //_backMethod();
    //MyAPI(context: context).getProducts(token);
    _m = MyWidget(context);
    if(filter){
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.isEmpty) break;
        if(productList[i]['CATId'].toString() == categoryNum.toString() &&
            productList[i]['SCId'].toString() == _subCategoryList[subCategorySelectNum]['SCId'].toString() &&
            double.parse(productList[i]['price'].toString()) <= maxPrice
        ){
            _internalProduct.add(productList[i]);
        }
      }
      _internalProduct.sort((a, b) {
        if(!highToLowPriceFilter) return a['price'].toString().toLowerCase().compareTo(b['price'].toString().toLowerCase());
        else return b['price'].toString().toLowerCase().compareTo(a['price'].toString().toLowerCase());
      });
      _internalProduct.sort((a, b) {
        if(!highToLowRateFilter) return a['rating'].toString().toLowerCase().compareTo(b['rating'].toString().toLowerCase());
        else return b['rating'].toString().toLowerCase().compareTo(a['rating'].toString().toLowerCase());
      });
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.metal,
          MyColors.metal,
          MyColors.metal,
        ],
          transform: GradientRotation(3.14 / 4),),
      ),
      child: Scaffold(
        backgroundColor: MyColors.trans,
        body: initScreen(context),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  var _password = true;

  initScreen(BuildContext context) {
    var curve = MediaQuery
        .of(context)
        .size
        .width / 20;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height/5/2,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: MediaQuery.of(context).size.height/60),
                      color: MyColors.mainColor,
                      child: Row(
                        children: [
                          _m!.comimaniaLogo(scale: 0.6, color: true),
                          Expanded(child: SizedBox(height: 0.0,)),
                          _m!.notificationButton(),
                          //SizedBox(height: MediaQuery.of(context).size.height / 25,),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height/5/2,
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5/2),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/170),
                        color: MyColors.orange,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                            Flexible(
                              flex: 2,
                              child: _horisintalListHeader(),
                            ),
                          ],
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/5,
                        //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4/2),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/80),
                        //color: MyColors.orange,
                        child: Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: _container(curve,
                                TextField(
                                  //obscureText: password,
                                  //readOnly: readOnly,
                                  //maxLines: password? 1: null,
                                  //validator: requiredValidator,
                                  //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                                  //keyboardType: password? TextInputType.visiblePassword: number?  TextInputType.number : TextInputType.text,
                                  controller: _searchController,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/22,
                                      color: MyColors.black,
                                      fontFamily: 'SairaMedium'),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: InputBorder.none,
                                    //labelText: titleText,
                                    hintText: AppLocalizations.of(context)!.translate('Search '),
                                    hintStyle: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: MyColors.black,
                                        fontFamily: 'SairaLight'),
                                    errorStyle: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/2400,
                                    ),
                                  ),
                                ),),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/30,),
                            Expanded(
                                flex:1,
                                child: _container(
                                  curve,
                                  IconButton(
                                    padding: EdgeInsets.all(0.1),
                                    icon: Icon(Icons.filter_alt_outlined, color: !filter?MyColors.gray:MyColors.orange, size: MediaQuery.of(context).size.width/12,),
                                    onPressed: ()=> Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => FilterScreen(),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            final tween = Tween(begin: begin, end: end);
                                            final offsetAnimation = animation.drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                            },
                                        )
                                    //    MaterialPageRoute(builder: (context)=> FilterScreen())
                                    ).then((value) => setState((){
                                      if(!filter)_clickHeader(_categoryNum);
                                      else _categoryNum = categoryNum;
                                    })),
                                  ),
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 14,
              child:
                  RefreshIndicator(
                    onRefresh: ()=> _onRefresh(),
                    child: _categoryNum == 0 && _main && !_search ?
                    ListView(
                      children: [
                        salesList.length>0?_sales(0)
                            : homeSection1List.length > 0 ?
                        Image.network(homeSection1List[0]['ImageUrl'],
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width/2.3,
                          fit: BoxFit.contain,):
                        SizedBox(),
                        _newArrivals(),
                        //_mostPopulars(),
                        _shopNow(),
                        salesList.length>1?_sales(1)
                            : homeSection1List.length > 1 ?
                        Image.network(homeSection1List[1]['ImageUrl'],
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width/2.3,
                          fit: BoxFit.fitWidth,):
                        SizedBox(),
                        _brands(),
                        //_m!.cardMain(sale: 30),
                      ],
                    )
                        : _categoryNum == 0 || homeNotCategory || filter?
                        Column(
                          children: [
                            Flexible(
                              flex: 1,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width/40, left: MediaQuery.of(context).size.width/40,right: MediaQuery.of(context).size.width/40),
                                  itemCount: _subCategoryList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: _containerText(index == _subCategorySelectNum? MyColors.mainColor:MyColors.bodyText1,index == 0? _subCategoryList[index]['text'] : lng == 0?_subCategoryList[index]['name_en']:_subCategoryList[index]['name_ar']),
                                      onTap: ()=> _selectCategory(index),
                                    );
                                  },
                                ),
                            ),
                            Flexible(
                              flex: 10,
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                                  itemCount: _internalProduct.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2),
                                  itemBuilder: (BuildContext context, int index) {
                                    return _m!.cardMain(
                                      height: MediaQuery.of(context).size.width/1.58,
                                      name: getProductName(_internalProduct[index]),
                                      starRate: double.parse(_internalProduct[index]['rating'].toString()),
                                      price: double.parse(_internalProduct[index]['price'].toString()),
                                      sale: int.parse(_internalProduct[index]['discount'].toString()),
                                      image: _internalProduct[index]['photoUrls'][0]['name'],
                                      select: ()=> _select(_internalProduct[index]),
                                      favoraite: getIfFavorite(_internalProduct[index]['PROId']),
                                      favorite: ()async=> await _addOrDeleteWishlist(_internalProduct[index]['PROId']),
                                    );
                                  },
                                )),

                            ],
                        )
                        :
                    _category(),
                  ),

            ),
            Flexible(
              flex: 2,
              child: _m!.bottomContainer(homeNotCategory?0:1, curve*0, bottomConRati: 0.1, setState: ()=>_setState()),
            ),
          ],
        )  ,
        Align(
          alignment: Alignment.center,
          child: pleaseWait?
          _m!.progress()
              :
          const SizedBox(),
        ),
      ],
    )
      ;
  }

  _horisintalListHeader(){
    return ListView.builder(
      padding: EdgeInsets.all(0.1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: topHeader.length,
      itemBuilder: (BuildContext context, int i) {
        return GestureDetector(
          onTap: ()async=> await _clickHeader(i),
          child: _m!.bodyText1(topHeader[i]['text'], color: _categoryNum == 0&& !_main? MyColors.whiteNight : _categoryNum == i ? MyColors.white : MyColors.whiteNight, scale: 1.3, padding: MediaQuery.of(context).size.width/35, padV: 0.0),
        );
      },
    );
  }

  _container(curve, _child){
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white.withOpacity(0.99),
        /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
        border: Border.all(
          color: MyColors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(curve/2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: curve/2),
      child: _child,
    );
  }

  _sales(index, {color}){
    var sales = salesList[index];
    var pad = MediaQuery.of(context).size.height/80;
    homeSection1List.shuffle();
    return Column(
      children: [
        SizedBox(height: pad,),
        _m!.cardSales(
    backgroundColor: color,
    name: getProductName(sales),
    supName: getProductDesc(sales),
    //head: _internalProduct[index]['price'],
    image: homeSection1List.length > 0 ? homeSection1List[0]['ImageUrl'] : sales['photoUrls'][0]['name'],
    viewAll: ()=> setState((){
      _main = false;
      _internalProduct.clear();
      for(int i =0; i < salesList.length; i++){
        _internalProduct.add(salesList[i]);
      }
    }),
    ),
        SizedBox(height: pad,),
      ],
    );
  }

  _newArrivals(){
    List newArrivals = newArrivalList.where((element) => true).toList();
    var pad = MediaQuery.of(context).size.height/70;
    var hight = MediaQuery.of(context).size.width/1.5 + pad*2;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      color: MyColors.white,
        margin: EdgeInsets.symmetric(vertical: pad),
        padding: EdgeInsets.symmetric(vertical: pad),
        child: Column(
        children: [
          Row(
            children: [
              _m!.bodyText1(AppLocalizations.of(context)!.translate('New Arrivals')),
              //_m!.bodyText1(AppLocalizations.of(context)!.translate('وصل حديثا')),
              Expanded(child: SizedBox()),
              GestureDetector(
                child: _m!.bodyText1(AppLocalizations.of(context)!.translate('View All')),
                onTap: ()=> setState((){
                  _main = false;
                  _internalProduct.clear();
                  for(int i =0; i < newArrivals.length; i++){
                    _internalProduct.add(getProduct(newArrivals[i]['PROId']));
                  }             //_brandId = brand[i]['brandId'];
                  // categoryNum = 11111;
                }),
              ),

            ],
          ),
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: newArrivals.length,
                itemBuilder: (BuildContext context, int i) {
                  return _m!.cardMain(
                    height: hight-MediaQuery.of(context).size.width/8 - pad*2,
                    //select: ()=> _select(i),
                    name: newArrivals[i][lng==0?'name_en':lng==1?'name_fr':'name_ar'],
                    price: double.parse(newArrivals[i]['price'].toString()),
                    sale: int.parse(newArrivals[i]['discount'].toString()),
                    image: newArrivals[i]['photoUrls'],
                    select: ()=> _select(getProduct(newArrivals[i]['PROId'])),
                    favoraite: getIfFavorite(newArrivals[i]['PROId']),
                    favorite: ()async=> await _addOrDeleteWishlist(newArrivals[i]['PROId']),
                    //starRate: newArrivals[i]['price'],
                  );
                },
              )
          ),
        ],
      )
    );

  }
/*
  _mostPopulars(){
    List mostPopular = mostPopularList.where((element) => true).toList();
    var hight = MediaQuery.of(context).size.width/1.5;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      color: MyColors.white,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80),
      child: Column(
        children: [
          Row(
            children: [
              _m!.bodyText1(AppLocalizations.of(context)!.translate('The Most Popular')),
              Expanded(child: SizedBox()),
              _m!.bodyText1(AppLocalizations.of(context)!.translate('View All')),
            ],
          ),
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: mostPopular.length,
                itemBuilder: (BuildContext context, int i) {
                  return _m!.cardMain(height: hight-MediaQuery.of(context).size.width/8, sale: 20, select: ()=> _select(i));
                },
              )
          ),

        ],
      )
    );

  }
*/
  _brands(){
    List brand = brandsList.where((element) => true).toList();
    var pad = MediaQuery.of(context).size.height/80;
    var hight = MediaQuery.of(context).size.width/1.9 + pad*2;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      color: MyColors.color1,
      margin: EdgeInsets.symmetric(vertical: pad),
      padding: EdgeInsets.symmetric(vertical: pad),
      child: Column(
        children: [
          _m!.bodyText1(AppLocalizations.of(context)!.translate("Today's Popular Brands")),
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: brand.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    /*onTap: ()=> setState((){
                      _main = false;
                      _brandId = brand[i]['brandId'];
                    }),*/
                    child: _m!.cardBrand(
                        image: brand[i]['ImageUrl'],
                        brandName: lng == 2? brand[i]['name_ar']:brand[i]['name_en'],
                      select: ()=> setState((){
                        _main = false;
                        _brandId = brand[i]['brandId'];
                        _internalProduct.clear();
                        for(int i = 0; i< productList.length; i++){
                          if(productList[i]['brandId'].toString() == _brandId.toString())
                            _internalProduct.add(productList[i]);
                        }
                       // categoryNum = 11111;
                      }),
                    ),

                  );
                },
              )
          ),
        ],
      )
    );

  }

  _shopNow(){
    List shopNow = shopNowList.where((element) => true).toList();
    var pad = MediaQuery.of(context).size.height/80;
    var hight = MediaQuery.of(context).size.width/2.5 + pad * 2;
    return Container(
      height: hight,
      width: MediaQuery.of(context).size.width,
      //color: MyColors.white,
      margin: EdgeInsets.symmetric(vertical: pad),
      child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: shopNow.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: ()=> null,
                    child: _m!.cardShopNow(height: hight,
                        image: shopNow[i]['ImageUrl'],
                      name: getProductName(getProduct(shopNow[i]['PROId'])),
                      supName: '',
                      select: ()=> _select(getProduct(shopNow[i]['PROId'])),
                    ),
                  );
                },
              )
    );

  }

  _clickHeader(num) async{
    setState((){
      pleaseWait =true;
      _categoryNum = num;
    });
    if(num !=0) {await MyAPI(context: context).getSubCategories(token, num);
    _subCategoryList.clear();
    _subCategoryList.add({'text':AppLocalizations.of(context)!.translate('All')});
    for(int i=0; i< subCategoryList.length; i++) {
      _subCategoryList.add(subCategoryList[i]);
    }
    }
    else _main = true;
    setState((){
      pleaseWait =false;
      _categoryNum = num;
      _subCategorySelectNum = 0;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.length==1) break;
        if(_subCategorySelectNum == 0 && productList[i]['CATId'].toString()==_categoryNum.toString()){
          _internalProduct.add(productList[i]);
        }
        else if(productList[i]['CATId'].toString()==_categoryNum.toString() && productList[i]['SCId'].toString()==_subCategoryList[_subCategorySelectNum]['SCId'].toString()){
          _internalProduct.add(productList[i]);
        }
        /*if(homeNotCategory){
          if(productList[i]['CATId'].toString() == _categoryNum.toString()){
            _internalProduct.add(productList[i]);
          }
        }else{
          if(productList[i]['CATId'].toString() == _categoryNum.toString() && productList[i]['SCId'].toString() == _subCategoryList[_subCategorySelectNum]['SCId'].toString()){
            _internalProduct.add(productList[i]);
          }
        }*/
      }
    });

  }

  _select(i){
    print(i.toString());
    if(i['items'].isEmpty){
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Items is empty in this product'));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProductDetails(i)
      ),);
  }

  var _subCategorySelectNum = 0;
  _category(){
    return Row(
      children: [
        Container(
          color: MyColors.white,
          width: MediaQuery.of(context).size.width/7*2,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: _subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _m!.headText(index==0?_subCategoryList[index]['text']:lng == 0?_subCategoryList[index]['name_en']:_subCategoryList[index]['name_ar'], color: index == _subCategorySelectNum? MyColors.orange:MyColors.bodyText1, paddingV: MediaQuery.of(context).size.height/100, scale: 0.75, paddingH: MediaQuery.of(context).size.width/30),
                ),
                onTap: ()=> _selectCategory(index),
              );
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/7*5,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
            itemCount: _internalProduct.length,
            itemBuilder: (BuildContext context, int index) {
              return _m!.cardMainHorizental(height: MediaQuery.of(context).size.width/2.99,
                  name: getProductName(_internalProduct[index]),
                  starRate: double.parse(_internalProduct[index]['rating'].toString()),
                  price: double.parse(_internalProduct[index]['price'].toString()),
                  sale: int.parse(_internalProduct[index]['discount'].toString()),
                  image: _internalProduct[index]['photoUrls'][0]['name'],
                  select: ()=> _select(_internalProduct[index]),
                favoraite: getIfFavorite(_internalProduct[index]['PROId']),
                favorite: ()async=> await _addOrDeleteWishlist(_internalProduct[index]['PROId'])
              );
            },
          ),
        ),
      ],
    );
  }

  _selectCategory(i) {
    setState((){
      _subCategorySelectNum = i;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.length==1) break;
        if(_subCategorySelectNum == 0 && productList[i]['CATId'].toString()==_categoryNum.toString()){
          _internalProduct.add(productList[i]);
        }
        else if(productList[i]['CATId'].toString()==_categoryNum.toString() && productList[i]['SCId'].toString()==_subCategoryList[_subCategorySelectNum]['SCId'].toString()){
          _internalProduct.add(productList[i]);
        }
      }
    });
  }

  _addToWishlist(productId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).addWishlist(token: token, productId: productId);
    setState(() {
      pleaseWait = false;
    });
  }

  _deleteWishlist(productId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).deleteWishlist(token: token, productId: productId);
    setState(() {
      pleaseWait = false;
    });
  }

  _addOrDeleteWishlist(productId) async{
    if(!getIfFavorite(productId)){
      await _addToWishlist(productId);
    }
    else{
      await _deleteWishlist(productId);
    }
  }

  _onRefresh() async{
    await MyAPI(context: context).getProducts();
    await MyAPI(context: context).getCategories();
    await MyAPI(context: context).getBrands();
    await MyAPI(context: context).getHomeSection1();
    await MyAPI(context: context).getHomeSection2();
    await MyAPI(context: context).getHomeSection4();
    await MyAPI(context: context).getShopCartGuest();
    await MyAPI(context: context).getCurrency();
    setState(() {

    });
  }

  _setState(){
    setState((){
      pleaseWait =false;
      _subCategorySelectNum = 0;
      _internalProduct.clear();
      for(int i =0; i < productList.length; i++){
        // print(productList[i]['CATId'].toString());
        //print(categoryNum.toString());
        if(_subCategoryList.isEmpty) break;
        if(homeNotCategory){
          if(productList[i]['CATId'].toString() == _categoryNum.toString()){
            _internalProduct.add(productList[i]);
          }
        }else{
          if(productList[i]['CATId'].toString() == _categoryNum.toString() && productList[i]['SCId'].toString() == _subCategoryList[_subCategorySelectNum]['SCId'].toString()){
            _internalProduct.add(productList[i]);
          }
        }
      }
    });
  }

  _containerText(color, text){
    var pad = MediaQuery.of(context).size.width/60;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(pad)),
          color: MyColors.white,
          border: Border.all(color: color == MyColors.mainColor? color: MyColors.white),
        ),
        padding: EdgeInsets.all(pad),
        margin: EdgeInsets.symmetric(horizontal: pad/2),
        child: _m!.bodyText1(text, padV: 0.0,padding: 0.0, color: color),
      ),
    );
  }
}