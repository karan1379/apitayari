import 'package:apitayari/app/data/local/storage_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper{

  late IO.Socket socket;

  bool isConnected = false, isUserConnected = false;
  Future<void> initSocket() async{
    socket = IO.io("https://sdfsdf",
        IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect()  // disable auto-connection
        .build()
      );
    socket.connect();

    _initListener();

  }

  _initListener(){
     socket.onConnect((data) {
       isConnected  = true ;

       if(StorageHelper.getUser() !=null){
         connectUser();
       }

     },);
     socket.onConnectError((data) {
       isConnected = false;
       print(data.toString());
     },);

     socket.onError((data) {
       print(data.toString());
     },);

     socket.on("connect_user", (data){
       isUserConnected = true;
       print("socket user connected : $data");

     });


  }


  connectUser(){
    Map <String,dynamic> map ={
      "userId" :StorageHelper.getUser()
    };

    socket.emit("connect_user",map);

  }

  disconnectUser(){

    socket.off("connect_user");
    isUserConnected = false;

  }





}