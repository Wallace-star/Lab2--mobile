import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:Note/mainscreen.dart';
import 'package:Note/user.dart';
import 'dart:async';


void main() => runApp(MyApp());
bool rememberMe = false;
bool acceptTerm = false;
String urlRegister = "https://yhkywy.com/mynote/php/registration.php";
String urlLogin = "https://yhkywy.com/mynote/php/login_user.php";
TextEditingController _nameEditingController = new TextEditingController();
TextEditingController _emailEditingController = new TextEditingController();
TextEditingController _phoneEditingController = new TextEditingController();
TextEditingController _passEditingController = new TextEditingController();
TextEditingController _emailEditingController1 = new TextEditingController();
TextEditingController _passEditingController1 = new TextEditingController();



enum AuthMode { LOGIN, SINGUP }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // To adjust the layout according to the screen size
  // so that our layout remains responsive ,we need to
  // calculate the screen height
  double screenHeight;

  // Set intial mode to login
  AuthMode _authMode = AuthMode.LOGIN;
  


@override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  }


  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              _authMode == AuthMode.LOGIN
                ? loginCard(context)
                : singUpCard(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.book,
            size: 48,
            color: Colors.lightBlueAccent,
          ),
          Text(
            "PersonalBook",
            style: TextStyle(
                fontSize: 34, color: Colors.black, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 3),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailEditingController1,
                    decoration: InputDecoration(
                        labelText: "Email", 
                        hasFloatingPlaceholder: true),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passEditingController1,
                    decoration: InputDecoration(
                        labelText: "Password", 
                        hasFloatingPlaceholder: true),
                        obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      FlatButton(
                        child: Text("Login"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: this._userLogin,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
            height: 10,
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "New User?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.SINGUP;
                });
              },
              textColor: Colors.black87,
              child: Text("Create Account"),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Forgot password?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: _forgotPassword,
                child: Text("Resert Password ?"),
            ),
          ],
        )
      ],
    );
  }

void _userLogin() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Log in...");
    pr.show();
    String email = _emailEditingController1.text;
    String password = _passEditingController1.text;

    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      
      print(res.body);
      var string = res.body;
        List userdata = string.split(",");
      if (userdata[0] == "success") {        
        User _user = new User(
              name: userdata[1],
              email: email,
              password: password,
              phone: userdata[3],
              credit: userdata[4],
              datereg: userdata[5],
              quantity: userdata[6]);
              pr.dismiss();
              print("test");
        Toast.show("Login success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(user: _user                      
                      )));
      
      }else{
        pr.dismiss();
        Toast.show("Login failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }


  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  

Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit")),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
            ],
          ),
        ) ??
        false;
  }

Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController1.text = email;
        _passEditingController1.text = password;
        rememberMe = true;
      });
    }
  }

void _onRememberMeChanged(bool value) {
    setState(() {
      rememberMe = value;
      print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      //savepref(value);
    });
  }


void savepref(bool value) async {
    String email = _emailEditingController1.text;
    String password = _passEditingController1.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController1.text = '';
        _passEditingController1.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }


  //########################################################################################
  //########################################################################################


  Widget singUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                   TextFormField(
                    controller: _nameEditingController,
                    decoration: InputDecoration(
                        labelText: "Name", 
                        icon: Icon(Icons.person),),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailEditingController,
                    decoration: InputDecoration(
                        labelText: "Email", 
                        icon: Icon(Icons.email),),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _phoneEditingController,
                    decoration: InputDecoration(
                        labelText: "Phone", 
                        icon: Icon(Icons.phone),),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passEditingController,
                    decoration: InputDecoration(
                        labelText: "Password", 
                        icon: Icon(Icons.lock),),
                        obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value:acceptTerm,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                          onTap: _eEULA,
                          child: Text('Accept Term',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))
                              ),
                      FlatButton(
                        child: Text("Sign Up"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: _onRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Already have an account?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.LOGIN;
                });
              },
              textColor: Colors.black87,
              child: Text("Login"),
            )
          ],
        ),
      ],
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: 450,
      child: Image.asset(
        'assets/main.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }

  


  void _onChange(bool value) {
    setState(() {
      acceptTerm = value;
      //savepref(value);
    });
  }

void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String password = _passEditingController.text;


    if(name.length<1){
      Toast.show("Username must must be least one words", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    else if(password.length<1){
      Toast.show("Password must must be least one words", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(email.indexOf('@')<0 || email.indexOf('.com')<0){
      Toast.show("Invalid Email", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else{

    if (!acceptTerm) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      'name': name,
      'email': email,
      'password': password,
    }).then((res) {
      if (res.body == "success") {
           setState(() {
            _authMode = AuthMode.LOGIN;
      });
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
}
}


void _eEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement (EULA) is a legal agreement between you and MyNote.This EULA agreement governs your acquisition and use of our PersonalNote software (Software) directly from MyNote or indirectly through a MyNote authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the PersonalNote software. It provides a license to use the PersonalNote software and contains warranty information and liability disclaimers.If you register for a free trial of the PersonalNote software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the PersonalNote software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. lick https://www.eulatemplate.com/live.php?token=3SQ65WI76cviSbX17hxAcvm1lOfXRDx9 to raed details"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

}
