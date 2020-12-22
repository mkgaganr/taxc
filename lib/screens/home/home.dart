import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxc/screens/home/policies.dart';
import 'package:taxc/screens/home/rules.dart';
import 'package:taxc/screens/home/settings.dart';
import 'package:taxc/screens/home/sidebar/sidebarlayout.dart';
import 'package:taxc/screens/home/tax.dart';
import 'package:taxc/services/auth.dart';
import 'package:taxc/screens/home/constants.dart';
import 'package:taxc/screens/home/profile.dart';
import 'package:taxc/shared/loading.dart';
import 'package:taxc/services/database.dart';
import 'package:taxc/models/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help.dart';
import 'ifaqs.dart';
import 'itax.dart';

void main() {
  runApp(
      MaterialApp(
        home: Home(),
      )
  );
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Homelayout(),
      ),
      endDrawer:SidebarLayout(),
    );
  }
}



class Homelayout extends StatefulWidget   {

  @override
  _HomelayoutState createState() => _HomelayoutState();
}

class _HomelayoutState  extends State<Homelayout> {
  final AuthService _auth = AuthService();

  final Color selectedTileColor = Colors.lightBlue;

  GlobalKey<ScaffoldState> _stackKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0, _selectedindex = -1;
  bool _toogle = true;
  dynamic _bottomSelect = MyApp2();

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed:  () {
        setState(() {
          _selectedindex = -1;
        });
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed:  () async {
        await _auth.signOut();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<Info>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Info userData = snapshot.data;
            return Scaffold(
              key: _stackKey,
              body: Stack(
                children: <Widget>[
                  Positioned(
                    top: 110,
                    left: 18,
                    right: 10,
                    bottom: 2,
                    child: _bottomSelect,
                  ),
                  Positioned(
                    width: 70,
                    top: 0,
                    bottom: 0,
                    right: -40,
                    child: ClipPath(
                      clipper: SidebarClipper(180, 290),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.lightBlue.shade400,
                                Colors.lightBlue.shade400,
                                Colors.lightBlue.shade400
                              ],
                              stops: [
                                0.0, 1.0, 1.0
                              ],
                            )
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: -10,
                    top: 211,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.grey[500]),
                      onPressed: () {},),
                    //Text('<<',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.grey[500]),),
                  ),
                  Positioned(
                    left: 3,
                    top: 15,
                    child: Column(
                      children: [
                        SizedBox(height: 22,),
                        IconButton(
                            icon: Icon(Icons.menu,
                              size: 30,
                              color: Colors.grey[800],
                            ),
                            onPressed: () {
                              _stackKey.currentState.openDrawer();
                            }
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 30,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text("Tax", style: TextStyle(fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent.shade400,),),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 148,
                    top: 30,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text("Calculator", style: TextStyle(fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900]),),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 46,
                    child: AnimatedSearchBar(),
                  ),

                ],


              ),


              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 16),
                              child: Icon(Icons.account_circle, size: 90,
                                color: Colors.lightBlue.shade400,),
                            ),
                            Text(userData.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.lightBlue.shade400,
                              ),
                            ),
                            Text(userData.email,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.lightBlue.shade400,
                              ),
                            ),
                            SizedBox(height: 18,),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    selected: _selectedindex == 0,
                                    selectedTileColor: Colors.grey,
                                    leading: Icon(Icons.account_box,
                                      color: Colors.lightBlue.shade400,
                                    ),
                                    title: Text('My Account', style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = Profile();
                                        _selectedindex = 0;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 1,
                                    selectedTileColor: Colors.grey,
                                    leading: Icon(Icons.build,
                                      color: Colors.lightBlue.shade400,
                                    ),
                                    title: Text('Settings', style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = SettingsScreen();
                                        _selectedindex = 1;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 2,
                                    selectedTileColor: Colors.grey,
                                    leading: Icon(Icons.lock_outline,
                                        color: Colors.lightBlue.shade400
                                    ),
                                    title: Text('Logout',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        _selectedindex = 2;
                                      });
                                      showAlertDialog(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 3,
                                    selectedTileColor: Colors.grey,
                                    leading: Icon(Icons.calculate,
                                      color: Colors.lightBlue.shade400,
                                    ),
                                    title: Text('Gst tax', style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = Rules();
                                        _selectedindex = 3;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 4,
                                    selectedTileColor: Colors.grey,
                                    leading: Icon(Icons.calculate_sharp,
                                      color: Colors.lightBlue.shade400,),
                                    title: Text('Income Tax',
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect =IncomeTax();
                                        _selectedindex = 4;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Container(
                                      height: 2.0,
                                      width: 290.0,
                                      color: Colors.grey,),),
                                  ListTile(
                                    selected: _selectedindex == 5,
                                    selectedTileColor: Colors.grey,
                                    title: Text('Privacy Policies',
                                      style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = Policies();
                                        _selectedindex = 5;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 6,
                                    selectedTileColor: Colors.grey,
                                    title: Text('Help Center', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = Help();
                                        _selectedindex = 6;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    selected: _selectedindex == 7,
                                    selectedTileColor: Colors.grey,
                                    title: Text(' Income Tax faqs',
                                      style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _bottomSelect = Faqs();
                                        _selectedindex = 7;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.grey[900],
                iconSize: 24.0,
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 16,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedFontSize: 12,
                items: [
                  new BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home, color: Colors.lightBlue.shade400,),
                    title: Text(
                      'Home', style: TextStyle(color: Colors.white,),),
                    backgroundColor: Colors.grey[900],
                  ),
                  new BottomNavigationBarItem(
                    icon: Icon(
                      Icons.receipt, color: Colors.lightBlue.shade400,),
                    title: Text('Tax Slabs', style: TextStyle(color: Colors.white,),),
                    backgroundColor: Colors.grey[900],
                  ),
                  new BottomNavigationBarItem(
                    icon: Icon(Icons.read_more,
                      color: Colors.lightBlue.shade400,),
                    title: Text(
                      'Tax Rules', style: TextStyle(color: Colors.white,),),
                    backgroundColor: Colors.grey[900],
                  ),
                  new BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone,
                      color: Colors.lightBlue.shade400,),
                    title: Text(
                      'Contact', style: TextStyle(color: Colors.white,),),
                    backgroundColor: Colors.grey[900],
                  ),
                  new BottomNavigationBarItem(
                    icon: Icon(Icons.mail,
                      color: Colors.lightBlue.shade400,),
                    title: Text(
                      'Suggestion box', style: TextStyle(color: Colors.white,),),
                    backgroundColor: Colors.grey[900],
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedindex = -1;
                    _currentIndex = index;
                    switch (_currentIndex) {
                      case 0 :
                        _bottomSelect = MyApp2();
                        break;
                      case 1 :
                        _bottomSelect = Message();
                        break;
                      case 2 :
                        _bottomSelect = GreenPay();
                        break;
                      case 3 :
                        _bottomSelect = Contact();
                        break;
                      case 4 :
                        _bottomSelect = Cart();
                        break;
                    }
                  }
                  );
                },
              ),
            );
          } else {
            return Loading();
          }
        }
    );
  }
}



class AnimatedSearchBar extends StatefulWidget {
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 180),
      duration: Duration(milliseconds: 400),
      width: _folded ? 280 : 320,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                decoration: InputDecoration(
                    hintText: 'Key Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(_folded ? 32 : 0),
                  topLeft: Radius.circular(32),
                  bottomRight: Radius.circular(_folded ? 32 : 0),
                  bottomLeft: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2,right: 8),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Colors.grey[900],
                    size: 28,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}








class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];



  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }
  void getPostsData() {
    List<dynamic> responseList = FARM_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["Tax rate"],
                      style: const TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$ ${post["price"]}",
                      style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/${post["image"]}",
                  height: double.infinity,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[

              const SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: categoriesScroller),
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform:  Matrix4.identity()..scale(scale,scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 250,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blueGrey.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tax of few Equipments",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 250,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Rules",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "of Tax",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Calculate",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ur tax in our app ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Tax rates latest(2020-21)"
          "                                1.Upto 2.5 annual income-nil"
          "                    2. Rs.2.5 lakh upto 5 lakh-5 percent "
          "3. Rs.5.0 lakh upto 7.5 lakh - 10 percent"
          "                                                       4. Rs.7.5 lakh upto 10.0 lakh - 15 percent"
          "                                                          5. Rs.10.0 lakh upto 12.5 lakh - 20 percent"
          "                                                      6.Rs.12.5 lakh upto 15 lakh - 25 percent"
          "                                                     7.Above Rs.15 lakh - 30 percent"
          "                                                     >This rates are for the individuals who are aged below 60"
          "                                                     *The users must go through the same and apply  tax rate accordingly"

          ,style: TextStyle(fontSize: 20,color: Colors.lightBlue[800]))),
    );
  }
}


class GreenPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("While the Income Tax Act, 1961 is the law enacted by the legislature for governing and administering income taxes in India, Income Tax Rules, 1962 has been framed to help apply and enforce the law contained in the Act. Further, the Rules cannot be read independently. They must be read in conjunction with the Act only. Further, the Rules must be within the framework of the Act and cannot override the provisions of the Act. For example, the Act lays down the law with regard to taxability of perquisites given by the employer to his employees as “salary”. However, it does not discuss how the perquisites must be valued. Such valuation is in turn prescribed under Rule 3 of the Income-tax Rules. ",
          style: TextStyle(fontSize: 18,color: Colors.deepPurple[800]))),
    );

  }
}

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60.0,),
                Text(
                  'contact',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 45,
                  ),
                ),
                SizedBox(height: 60.0,),
                Card(
                  color: Colors.blue[100],
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.mail_sharp,
                      color: Colors.red[900],
                    ),
                    title: Text(
                      'gagan.cs18@bmsce.ac.in',
                      style:
                      TextStyle(fontFamily: 'BalooBhai', fontSize: 18.0),
                    ),
                    onTap: () => launch("mailto:gagan.cs18@bmsce.ac.in"),
                  ),
                ),
                Card(
                  color: Colors.blue[100],
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blueAccent[900],
                    ),
                    title: Text(
                      '+91 9380417069',
                      style:
                      TextStyle(fontFamily: 'BalooBhai', fontSize: 18.0),
                    ),
                    onTap: () => launch("tel:+91 93804 17069"),
                  ),
                ),
              ]
          )
      ),
    );

  }
}

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60.0,),
                Text(
                  'throw any suggestions to improve our app or any issues faced',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 60.0,),
                Card(
                  color: Colors.lightBlueAccent[100],
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.mail_sharp,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      'gagan.cs18@bmsce.ac.in',
                      style:
                      TextStyle(fontFamily: 'BalooBhai', fontSize: 18.0),
                    ),
                    onTap: () => launch("mailto:gagan.cs18@bmsce.ac.in"),
                  ),
                ),
              ]
          )
      ),
    );

  }
}