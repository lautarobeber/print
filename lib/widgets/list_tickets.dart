import 'package:flutter/material.dart';
import 'package:sunmi/hive/ticket.dart';

import 'package:sunmi/providers/tickets_provider.dart';
import 'package:sunmi/widgets/update_screen.dart';

class ListarScreen extends StatefulWidget {
  static const nameRoute = 'listar';

  @override
  _ListarState createState() => _ListarState();
}

class _ListarState extends State<ListarScreen> {
  var ticketsProvider = TicketsProvider();

  @override
  void dispose() {
    super.dispose();
    ticketsProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listar Tickets'),
      ),
      body: FutureBuilder(
          future: ticketsProvider.inicializarBox(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              return (ticketsProvider.box.length < 1)
                  ? Container(
                      alignment: Alignment.center, // Centra el texto
                      child: const Text(
                        'No hay tickets',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                  : _getTickets(context);
            }
            return Container();
          }),
      floatingActionButton: IconButton(
          onPressed: () {
            var tickets = Ticket(id: 9, name: 'lautaro', price: 10);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateScreen(
                        ticket: tickets, indiceTicket: null, guardar: true)));
          },
          icon: Icon(Icons.add_circle)),
    );
  }

  ListView _getTickets(BuildContext context) {
    var tickets = ticketsProvider.getTickets();

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, ticketsIndex) {
        var ticketIndividual =
            tickets[ticketsIndex]; // Cambia 'id' por 'ticketsIndex'
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
          child: ListTile(
            title: GestureDetector(
              child: Text(
                '${ticketIndividual.name}\nEntrenador: ${ticketIndividual.price}', // Cambia 'ticket' por 'ticketIndividual'
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateScreen(
                      ticket:
                          ticketIndividual, // Cambia 'ticket' por 'ticketIndividual'
                      indiceTicket: ticketIndividual.id,
                      guardar: false,
                    ),
                  ),
                );
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteTicket(ticketIndividual
                    .id); // Cambia 'ticket' por 'ticketIndividual'
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteTicket(int id) {
    ticketsProvider.deleteTicket(id);
  }
}
