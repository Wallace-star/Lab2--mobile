import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Note/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'adminproduct.dart';
import 'cartscreen.dart';
import 'paymenthistoryscreen.dart';
import 'profilescreen.dart';

class MainScreen extends StatefulWidget {


  const MainScreen({Key key, }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading products...";
  String server = "https://slumberjer.com/grocery";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text(
              'Products List',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: _visible
                    ? new Icon(Icons.expand_more)
                    : new Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    if (_visible) {
                      _visible = false;
                    } else {
                      _visible = true;
                    }
                  });
                },
              ),

              //
            ],
          ),
          body: Container(
          )

          
        ));
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.5,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(server +
                                  "/productimage/${productdata[index]['id']}.jpg")))),
                ],
              ),
            ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {

  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(

          ),
          ListTile(
              title: Text(
                "Product List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    
                  }),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    
                  }),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                      "My Products",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          
                        }),
                ListTile(
                  title: Text(
                    "Customer Orders",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text(
                    "Report",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _addtocartdialog(int index) {

  }

  void _addtoCart(int index) {

  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            productdata = null;
            curtype = type;
            titlecenter = "No product found";
          });
          pr.dismiss();
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            productdata = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              setState(() {
                titlecenter = "No product found";
                curtype = "search for " + "'" + prname + "'";
                productdata = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["products"];
                FocusScope.of(context).requestFocus(new FocusNode());
                //curtype = prname;
                curtype = "search for " + "'" + prname + "'";
                pr.dismiss();
              });
            }
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
