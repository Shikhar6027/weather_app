import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: "weather app",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var humidity;
  var windSpeed;
  var currently;
  bool isSearch = false;
  var city = 'Lucknow';
  TextEditingController t = new TextEditingController();

  Future getWeather(String city) async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=" +
            city +
            "&units=metric&appid=490d95bf629a0e211f423eae681b97a6");
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather("lucknow");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearch
            ? Text('Weather..')
            : TextField(
                controller: t,
              ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                if (!isSearch)
                  setState(() {
                    this.isSearch = true;
                  });
                else {
                  await getWeather(t.text);

                  setState(() {
                    isSearch = false;
                    city = t.text;
                  });
                  t.clear();
                }
              })
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange[800],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                  child: Text(
                    'In  ' + city,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + '\u00B0' : 'Loading',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? currently.toString() : 'Loading',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerQuarter),
                  title: Text('Temperature..'),
                  trailing: Text(
                      temp != null ? temp.toString() + '\u00B0' : 'Loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text('Weather..'),
                  trailing: Text(
                      description != null ? description.toString() : 'Loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text('Wind Speed..'),
                  trailing: Text(
                      windSpeed != null ? windSpeed.toString() : 'Loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text('Humidity'),
                  trailing:
                      Text(humidity != null ? humidity.toString() : 'Loading'),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
