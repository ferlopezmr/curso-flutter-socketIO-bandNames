import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { 
  late SocketService socketService; 
  List<Band> bands = [];
  @override
  void initState() {
    super.initState();
  }

  _getActiveBands(){
    socketService.socket.on('bands', (payload){
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });
  }

  @override
  void dispose(){
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    socketService = Provider.of<SocketService>(context);
    _getActiveBands();
    
    return Scaffold(
      appBar: AppBar(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Bands"),
            _serverStatusIcon()
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body:Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
              return bandTile(bands[index]);
            }),
          ),
        ],
      ),
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
      onDismissed: (direction)=> socketService.emit("delete-band", {"id":band.id})
      ,
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
          onTap: ()=>socketService.emit('vote-band', {"id":band.id})
      ),
    );
  }

  void addNewBand(){
    final TextEditingController textController =  TextEditingController();

    showDialog(
    context: context, 
    builder: (BuildContext context)=>  AlertDialog(
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
      )
    
    );
  }

  void addBandToList(String? bandName){
    if(bandName != null && bandName.length> 1){
      socketService.emit('add-band', {"name":bandName});
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _serverStatusIcon(){
    return Container(
      child: socketService.serverStatus == "ServerStatus.Online"?
              const Icon(Icons.circle, color: Colors.green,)
             : (socketService.serverStatus == "ServerStatus.Connecting")?
              const Icon(Icons.circle, color: Colors.blue,)
             :
              const Icon(Icons.circle, color: Colors.red,)
    );
  }

  Widget _showGraph(){
      Map<String, double> dataMap = {};
      
      for (var element in bands) { 
        dataMap[element.name] = element.votes.toDouble();
      } 
    return SizedBox(
      height: 200,
      child: PieChart(dataMap: dataMap)
    );
  }
}
