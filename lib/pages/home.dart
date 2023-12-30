import 'package:flutter/material.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { 
  List<Band> bands = [
    Band(id: '0', name: 'Bon Jovi', votes: 1),
    Band(id: '1', name: 'Metallica', votes: 1),
    Band(id: '2', name: 'Soda stereo', votes: 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("data"),
        backgroundColor: Colors.blue,
      ),
      body:ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
        return bandTile(bands[index]);
      }),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (direction){
        print("id: ${band}");
      },
      background: Container(
        padding: const EdgeInsets.only(left: 5),
        color: Colors.red[100],
        alignment: Alignment.centerLeft,
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.red,),
            Text("Delete Band", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),),
          ],
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(band.name.substring(0,2), style:const TextStyle(fontSize: 20),),
          ),
          title: Text(band.name),
          trailing: Text("${band.votes}"),
          onTap: ()=>print(band),
      ),
    );
  }

  void addNewBand(){
    final TextEditingController textController =  TextEditingController();

    showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: const Text("New band"),
        content: TextField(controller: textController,),
        actions: [
          MaterialButton(
            onPressed: ()=> Navigator.of(context).pop(),
            color: Colors.red,
            child:const Text("Close", style: TextStyle(color: Colors.white),),
          ),
          MaterialButton(
            onPressed: ()=> addBandToList(textController.text),
            color: Colors.blue,
            child:const Text("Add", style: TextStyle(color: Colors.white),),
          )
        ],
      );
    }
    );
  }

  void addBandToList(String? bandName){
    if(bandName != null && bandName.length> 1){
      bands.add(Band(id: bands.length.toString(), name: bandName, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
