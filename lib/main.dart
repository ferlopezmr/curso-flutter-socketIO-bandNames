
import 'package:bands/pages/home.dart';
import 'package:flutter/material.dart';

void main()=> runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"material App",
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_)=>const HomePage()
      },
/*       home: Scaffold(
        appBar: AppBar(
          title: const Text("Band"),
        ),
        body: Center(child: Container(child: Text("Band"),)),
      ), */
    );
  }
}