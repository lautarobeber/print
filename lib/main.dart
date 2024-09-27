import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sunmi/hive/ticket.dart';
import 'package:sunmi/widgets/admin_screen.dart';
import 'widgets/home_screen.dart';
import 'widgets/list_tickets.dart';


//impresora
/* import 'package:sunmi/sunmi_screen.dart';
SunmiScreen(), */

void main() async {
  // Asegúrate de que los widgets estén vinculados
  WidgetsFlutterBinding.ensureInitialized();

  // Registra el adaptador de tu modelo Ticket
  Hive.registerAdapter(TicketAdapter());

  // Inicia tu aplicación
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
       initialRoute: '/',
      routes: {
        // Ruta principal que será la pantalla Home
        '/': (context) => const HomeScreen(),
        // Ruta para la pantalla Admin
        '/admin': (context) => const AdminScreen(),
        
        ListarScreen.nameRoute: (context) =>  ListarScreen(),
      },
    );
  }
}



