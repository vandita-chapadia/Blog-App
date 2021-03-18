import 'package:flutter/material.dart';
import 'package:blogapp/Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({this.auth, this.onSignedIn});

  final AuthImplementaion auth;
  final VoidCallback onSignedIn;
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  bool _isHidden = true;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          // dialogBox.information(
          //     context, "Congratulation", "Your are logged in successfully.");

          print("login userId=" + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          // dialogBox.information(context, "Congratulation",
          //     "Your account has been created successfully.");
          print("Register userId=" + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error =", e.toString());
        print("Error=" + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? "Email is required" : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        obscureText: _isHidden,
        decoration: new InputDecoration(
          labelText: 'Password',
          suffix: InkWell(
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            child: Icon(Icons.visibility),
          ),
        ),
        validator: (value) {
          return value.isEmpty ? "Password is required" : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'Hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset(
          "images/logo.png",
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Not have an Account? Create Account?",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          textColor: Colors.blue,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text(
            "Create Account",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Already have an Account? Login",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          textColor: Colors.blue,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
