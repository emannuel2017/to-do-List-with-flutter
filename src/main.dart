import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_second_app/models/Item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(   
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var items = new List<Item>();
   
   MyHomePage(){
     items = []; 
    //  items.add(Item(title: "item 1", done: false));
    //  items.add(Item(title: "item 2", done: true));
    //  items.add(Item(title: "item 3", done: false));
   }
 
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var newTaskCtrl = TextEditingController();
 

  void add(){
      if(newTaskCtrl.text.isEmpty) return ;
     setState(() {
       widget.items.add(Item(title: newTaskCtrl.text, done: false)); 
       newTaskCtrl.clear();
       save(); 
     });
     
  }
  
  void remove(index){
    setState(() {
       widget.items.removeAt(index);
       save(); 
    });
  }
 
  Future load() async{
     var prefs = await SharedPreferences.getInstance();
     var data = prefs.getString('data');

     if(data != null){
       Iterable decode = jsonDecode(data);
       List<Item> result = decode.map((x) => Item.fromJson(x)).toList(); 
      setState(() {
         widget.items = result; 
      });
     }
  }
  
  void save() async{
    print("saved");
    print(widget.items);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _MyHomePageState(){
    print("load");
    load();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: newTaskCtrl,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          child:ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index){
              final item = widget.items[index];
              return Dismissible(
                child: CheckboxListTile(
                   title: Text(item.title),
                   value: item.done,
                   onChanged: (value){
                       setState(() {
                       item.done = value;
                       save(); 
                       });
                    },
               ),
               key: Key(item.title),
               background: Container(
                 color: Colors.red[300].withOpacity(0.5),
               ),
               onDismissed: (direction){
                  remove(index);
               },
              );
            },
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            add();
          },
          child: Icon(Icons.add_circle_outline),
          backgroundColor: Colors.blueGrey,
        ),
    );
  }
}