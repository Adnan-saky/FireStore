import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CURD_ops.dart';
import 'package:toast/toast.dart';

class fireStore extends StatefulWidget {
  @override
  _fireStoreState createState() => _fireStoreState();
}

class _fireStoreState extends State<fireStore> {
  String varsity;
  String name;
  Stream Stud;
  CURD_methos curd_methos = new CURD_methos();

  ///Main screen

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue[700],
        actions: <Widget>[
         /* IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addDialog(context);
            },
          ),*/
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              curd_methos.getData().then((results) {
                setState(() {
                  Stud = results;
                });
              });
            },
          )
        ],
      ),
      body: Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.blue[200],
              child: student_List()),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
          floatingActionButton: new FloatingActionButton(
            backgroundColor: Colors.deepPurple[400],
            child: Icon(Icons.add,color: Colors.blue[200],),
            onPressed: () {
              addDialog(context);
            }
            ),
          ),
    );
  }

  ///Adding
  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 200,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter Student Name'),
                    onChanged: (value) {
                      this.name = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter Varsity name'),
                    onChanged: (value) {
                      this.varsity = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  if (this.name != null && this.varsity != null) {
                    curd_methos.addData({
                      'Name': this.name,
                      'Varsity': this.varsity
                    }).then((result) {
                      dialogTrigger(context);
                    }).catchError((e) {
                      print(e);
                    });
                  } else {
                    Toast.show(
                      "Invalid Input",
                      context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.CENTER,
                      textColor: Colors.black,
                      backgroundColor: Colors.red.withOpacity(.5),
                      backgroundRadius: 50,
                    );
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  ///DialogTrigger After adding a data
  ///

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  ///update data

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 125.0,
              width: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter Student Name'),
                    onChanged: (value) {
                      this.name = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration:
                        InputDecoration(hintText: 'Enter Varsity color'),
                    onChanged: (value) {
                      this.varsity = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Toast.show(
                    "Updated Successfully",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.CENTER,
                    textColor: Colors.black,
                    backgroundColor: Colors.green.withOpacity(.5),
                    backgroundRadius: 50,
                  );
                  Navigator.of(context).pop();
                  curd_methos.updateData(selectedDoc, {
                    'Name': this.name,
                    'Varsity': this.varsity
                  }).then((result) {
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  /// List View with state management

  Widget student_List() {
    if (Stud != null) {
      return StreamBuilder(
          stream: Stud,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(5.0),
                itemBuilder: (context, i) {
                  return Card(
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    color: Colors.cyan[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: new ListTile(
                      title: Text(
                        snapshot.data.documents[i].data['Name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Varsity : ' +
                            snapshot.data.documents[i].data['Varsity'],
                        textAlign: TextAlign.center,
                      ),
                      leading: IconButton(
                        onPressed: () {
                          updateDialog(
                              context, snapshot.data.documents[i].documentID);
                        },
                        icon: Icon(
                          Icons.update,
                          size: 30,
                          color: Colors.blue[700],
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Toast.show(
                            "Deleted Successfully",
                            context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER,
                            textColor: Colors.black,
                            backgroundColor: Colors.green.withOpacity(.5),
                            backgroundRadius: 50,
                          );
                          curd_methos.deleteData(
                              snapshot.data.documents[i].documentID);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.red[400],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Loading, Please wait..'));
            }
          });
    }
  }
}
