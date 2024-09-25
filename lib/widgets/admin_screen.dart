import 'package:flutter/material.dart';
import 'package:sunmi/widgets/form_tickets.dart';


//ADMIN SCREEN
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body:TicketForm(),
    );
  }
}


