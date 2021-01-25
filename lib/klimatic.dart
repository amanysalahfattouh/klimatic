import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'utils.dart' as util;
import 'dart:async';

class klimatic extends StatefulWidget {
  @override
  klimaticState createState() => new klimaticState();
}

class klimaticState extends State<klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map resultes = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new changeCity();
    }));
if(resultes !=null && resultes.containsKey('enter'))
{  _cityEntered = resultes['enter'];

  //print("From Frist Screen"+resultes['enter'].toString());
}

  }

  void showStaff() async {
    Map data = await getweather(util.appId, util.defaultcity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);
              }),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "image/umbrella.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text('${_cityEntered==null ? util.defaultcity:_cityEntered}', 
            style: cityStyle()),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset("image/light_rain.png"),
          ),
          updataTempWidget(_cityEntered)
         // Container(
              //margin: EdgeInsets.fromLTRB(30.0, 290.0, 0, 0),

           //   child: updataTempWidget(_cityEntered))
        ],
      ),
    );
  }

  Future<Map> getweather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updataTempWidget(String city) {
    return new FutureBuilder(
        future: getweather(util.appId, city==null ?util.defaultcity:city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map contect = snapshot.data;
            return new Container(
              margin: EdgeInsets.fromLTRB(30.0, 250, 0.0, 0.0),
                child: new Column(
                  mainAxisAlignment:MainAxisAlignment.center ,
              children: <Widget>[
                new ListTile(
                  title: Text(
                    contect['main']['temp'].toString() +"F",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 49.9,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: ListTile(
                    title: new Text(
                      "Humidity:${contect['main']['humidity'].toString()}\n"
                      "Min:${contect['main']['temp_min'].toString()} F\n"
                      "Max:${contect['main']['temp_max'].toString()} F",
                      style: extraData(),
                      ),
                  ),
                )
              ],
            ));
          } else {
            return Container();
          }
        });
  }
}

class changeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: Text("change city"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
              new Center(
                child: Image.asset(
                  'image/white_snow.png',
                  width: 490.0,
                  height: 1200.0,
                  fit: BoxFit.fill,
                ),
              ),
         new ListView(
           children: <Widget>[
             new ListTile(
              title: new TextField(
                decoration: InputDecoration(
                  hintText: "Enter City",
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              ),
             ),
             new ListTile(
               title: new FlatButton(
                 onPressed: (){
                 Navigator.pop(context,{
                   'enter':_cityFieldController.text

                 }
                 );
                 },
                 color:  Colors.redAccent,
                 textColor: Colors.white70,
                 child:Text("Get Weather") ,
               ),
             )
           ],
         )
          
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}
TextStyle extraData(){
   return new TextStyle(
    color: Colors.white70,
    fontSize: 17,
    fontStyle: FontStyle.normal,
    
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
