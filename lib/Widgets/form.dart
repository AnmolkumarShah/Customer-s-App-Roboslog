import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
// import '../Screens/manage_account.dart';
import '../Widgets/image_picker.dart';

class AccountForm extends StatefulWidget {
  final String name;
  final String email;
  final String addr1;
  final String addr2;
  final String state;
  final String pincode;
  AccountForm({
    this.name,
    this.email,
    this.pincode,
    this.state,
    this.addr2,
    this.addr1,
  });
  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();

  var _userName;
  var _addr1;
  var _addr2;
  var _state;
  var _pincode;

  var _password;
  File _imageUser;
  var _isLoading = false;
  var _oldPassword;

  void _pickImage(File image) {
    _imageUser = image;
  }

  void _trySubmitForm(BuildContext ctx1) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      await showDialog(
        context: ctx1,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Please Confirm!!",
            ),
            content: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "By clicking Yes, you confirm the following changes to your account!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    "Username:  $_userName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Address line 1:  $_addr1",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Address line 1:  $_addr2",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "State:  $_state",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "pincode:  $_pincode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Text(
                  //   "Password:  $_password",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // )
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await Provider.of<ProductProvider>(context, listen: false)
                        .updateUsers(
                      _userName,
                      _password.toString(),
                      _imageUser,
                      ctx,
                      widget.email,
                      _oldPassword.toString(),
                      _addr1,
                      _addr2,
                      _state,
                      _pincode.toString(),
                    );

                    setState(() {
                      _isLoading = false;
                    });

                    Navigator.of(context).pop();
                  } catch (err) {
                    showDialog(
                      context: ctx,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(err),
                        );
                      },
                    );
                  }
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RaisedButton.icon(
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog(
                    // barrierColor: Theme.of(context).errorColor,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Please Confirm!!",
                        ),
                        content: Container(
                          height: 220,
                          child: Column(
                            children: [
                              Text(
                                "Change only that Attribute that you really want.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Text(
                              //   "Changing the Password will Restart the app, and you have to Login again with new Credentials.",
                              //   textAlign: TextAlign.justify,
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 20,
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "If you want to change the Profile image then select new image file,otherwise it will remain as it is.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          RaisedButton(
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.dangerous),
                label: Text("Important README"),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      initialValue: widget.name,
                      decoration: InputDecoration(
                        labelText: "User Name",
                      ),
                      onSaved: (newValue) {
                        _userName = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter UserName";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.addr1,
                      decoration: InputDecoration(
                        labelText: "Address Line One",
                      ),
                      onSaved: (newValue) {
                        _addr1 = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter Address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.addr2,
                      decoration: InputDecoration(
                        labelText: "Address Line Two",
                      ),
                      onSaved: (newValue) {
                        _addr2 = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter Address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.state,
                      decoration: InputDecoration(
                        labelText: "Enter State",
                      ),
                      onSaved: (newValue) {
                        _state = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter State";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.pincode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Your Area Pincode",
                      ),
                      onSaved: (newValue) {
                        _pincode = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter pincode";
                        }
                        return null;
                      },
                    ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: "Confirm Password",
                    //   ),
                    //   keyboardType: TextInputType.visiblePassword,
                    //   onSaved: (newValue) {
                    //     _oldPassword = newValue;
                    //   },
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: "New Password",
                    //   ),
                    //   keyboardType: TextInputType.visiblePassword,
                    //   onSaved: (newValue) {
                    //     _password = newValue;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty && value.length < 6) {
                    //       return "Please Enter a good and long password";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    ImgPicker(_pickImage),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            color: Colors.red[100],
                            onPressed: () => _trySubmitForm(context),
                            child: Text("Save Changes"),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
