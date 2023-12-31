import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{
  final String _url = "http://192.168.1.113:3000/";
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  get serverStatus => _serverStatus.toString();
  get socket => _socket;
  Function get emit => _socket.emit;

  SocketService(){
    initConfig();
  }

  void initConfig(){
    _socket = IO.io(_url, {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners(); 
    });

    _socket.onConnectError((data) {
      print('Connection error: $data');
    }); 

    _socket.onDisconnect((_) => {
      _serverStatus = ServerStatus.Offline,
      notifyListeners()
    });


    _socket.on('bands', (data) => print(data));  
  }
}