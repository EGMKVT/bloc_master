import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_login/login/bloc/login_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFaliure) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('${state.error}'),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            child: Form(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'username', icon: Icon(Icons.person)),
                      controller: _usernameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'password', icon: Icon(Icons.lock)),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text("Register",
                              style: TextStyle(fontSize: 20, color: Colors.white))),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => FormPage()));
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: RaisedButton(
                          onPressed: state is! LoginLoading
                              ? _onLoginButtonPressed
                              : null,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: state is LoginLoading
                          ? CircularProgressIndicator()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}
class _FormPageState extends State<FormPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image.network("https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png"),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _username,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Username', icon: Icon(Icons.person)),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (String username){
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Email', icon: Icon(Icons.email)),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter  email";
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
                      {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    onSaved: (String email){
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.lock)),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter password";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: (){
                      if(_formkey.currentState.validate())
                      {
                        RegistrationUser();
                        print("Successful");
                      }else
                      {
                        print("Unsuccessfull");
                      }

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue,width: 2)
                    ),
                    textColor:Colors.white,child: Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future RegistrationUser()  async{
    // url to registration php script
    String apiUrl = "http://10.0.10.49:8000/account/register/";

    final json ={
      'username':_username.text,
      'email':_email.text,
      'password':_password.text
    };

    http.Response reponse = await http.post(apiUrl,body: json );

    var data = jsonDecode(reponse.body);
    print(data);
  }
}