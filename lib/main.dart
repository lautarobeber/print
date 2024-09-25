import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sunmi/hive/ticket.dart';
import 'widgets/home_screen.dart';

//impresora
/* import 'package:sunmi/sunmi_screen.dart';
SunmiScreen(), */

Future<void> main()async{
  await Hive.initFlutter();
  Hive.registerAdapter(TicketAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunmi Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}



