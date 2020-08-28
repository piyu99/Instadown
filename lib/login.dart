import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'error.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginpage(),
    );
  }
}


class loginpage extends StatefulWidget {
  @override
  _loginpageState createState() => _loginpageState();
}

enum FormType { login, register }

class _loginpageState extends State<loginpage> {
  @override
  GlobalKey<FormState> Fkey = new GlobalKey<FormState>();
  FormType Ftype = FormType.login;
  String _email = "";
  String _password = "";

  void toregister() {
    Fkey.currentState.reset();

    setState(() {
      Ftype = FormType.register;
    });
  }

  void tologin() {
    Fkey.currentState.reset();

    setState(() {
      Ftype = FormType.login;
    });
  }


//  bool validateandsave() {
//    final form = Fkey.currentState;
//    if(form.validate()){
//      form.save();
//      return true;
//    }
//    else{
//      return false;
//    }
//  }
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomPadding: false,
        //backgroundColor: Colors.black87,
          backgroundColor: Colors.transparent,
//            leading: IconButton(
//                icon: Icon(Icons.arrow_back_ios), onPressed: () {  AlertDialog(
//              title: Text('Very, very large title', textScaleFactor: 5),
//              content: Text('Very, very large content', textScaleFactor: 5),
//              actions: <Widget>[
//                FlatButton(child: Text('Button 1'), onPressed: () {}),
//              ],
//            );}),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellowAccent,Colors.orange,Colors.pink,Colors.purple,Colors.indigo

              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft
            )
          ),
        child : Form(
          key: Fkey,
          child: Column(
              children: Fields() + Buttons()
          ),
        ),
        )
    );
  }

  List<Widget> Fields() {
    return [
//      SizedBox(
//        height: 50,
//      ),
      Expanded(
        child: Image(
          image: AssetImage('assets/instadown.png'),
        ),

      ),

      Expanded(
        child: Column(
          children: <Widget>[
            TextFormField(

              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'YOUR EMAIL',
              ),
              validator: (value) {
                return value.isEmpty ? 'Email is required' : null;
              },
              onSaved: (value) {
                return _email = value;
              },
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,

                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'YOUR PASSWORD',
              ),
              validator: (value) {
                return value.isEmpty ? 'Password is required' : null;
              },
              onSaved: (value) {
                return _password = value;
              },
            ),
          ],
        ),
      ),



    ];
  }

  List<Widget> Buttons() {
    if (Ftype == FormType.login) {
      return [
        RaisedButton(
          child: Text('LOGIN',
            style: TextStyle(
                color: Colors.red
            ),),
          color: Colors.white,
          onPressed: () {
            SignIn();
          },
        ),
        FlatButton(
          child: Text('New User? Create an account.',
            style: TextStyle(
                color: Colors.white           ),),
          onPressed: () {
            toregister();
          },

        )
      ];
    }
    else {
      return [
        RaisedButton(
          child: Text('SIGNUP',
            style: TextStyle(
                color: Colors.red
            ),),
          color: Colors.white,
          onPressed: () {
            SignUp();
          },
        ),
        FlatButton(
          child: Text('Already a User? Login.',
            style: TextStyle(
                color: Colors.white
            ),),
          onPressed: () {
            tologin();
          },

        )
      ];
    }
  }
  Error error= new Error();

  Future<void> SignIn() async {
    final formState = Fkey.currentState;

    if (formState.validate()) {
      formState.save();
      try {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        print('Im in');
        Navig();
      }
      catch (e) {
        error.showerror(context, 'Error', e.toString());
        print(e.message);
      }
    }
  }

  void Navig() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  Future<void> SignUp() async {
    final formState = Fkey.currentState;

    if (formState.validate()) {
      formState.save();
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        print('Im in');
        Navig();
      }
      catch (e) {
        error.showerror(context, 'Error', e.toString());
        print(e.message);
      }
    }
  }
}
