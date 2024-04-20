import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/AuthScreen";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final LocalAuthentication auth;
 bool _supportState=false;
 
 @override
void initState(){
  super.initState();
  auth=LocalAuthentication();
  auth.isDeviceSupported().then(
    (bool isSupported)=>setState((){
      _supportState=isSupported;
    }),
    ); 

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Biometrics Authentication'),
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if(_supportState)
          const Text('this device is supported')
          else
          const Text('this device is not supported'),

          const Divider(height: 100,),
          ElevatedButton(
            onPressed: _getAvailableBiometrics
          , child: const Text('get available biometrics',
          )
          ),

          const Divider(height: 100,),
          ElevatedButton(
            onPressed: _authenticate, 
            child: Text('Authenticate',
            )
            )
        ],
      ),
      

    );
  }

  Future<void> _authenticate() async{
     
     try{
      bool authenticated =await auth.authenticate(localizedReason: 'why you here',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
      );
      print('Authenticated : $authenticated');
     } on PlatformException catch(e){
      print(e);
     }
  }
    Future<void> _getAvailableBiometrics() async{
      List<BiometricType> availableBiometrics=await auth.getAvailableBiometrics();

      print ('List of availableBiometrics : $availableBiometrics');

      if(!mounted){
        return;
      }

    }
  }
