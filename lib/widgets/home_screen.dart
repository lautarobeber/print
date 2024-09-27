import 'package:flutter/material.dart';
import 'package:sunmi/providers/tickets_provider.dart';

import 'drawer.dart';
import '/hive/ticket.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/* class Ticket {
  final int id;
  final String name;
  final double price;
  int quantity;

  Ticket(
      {required this.id,
      required this.name,
      required this.price,
      this.quantity = 0});
} */

class _HomeScreenState extends State<HomeScreen> {
  List<double> moneyList = []; // Lista para almacenar los montos
  List<Ticket> tickets = []; // Lista para almacenar los tickets
  List<Ticket> cart = []; // Lista para almacenar los tickets en el carrito.
  double totalMoney = 0.0; // Variable para almacenar la suma total

  var ticketsProvider = TicketsProvider();

  @override
  void initState() {
    super.initState();
    // Inicializar algunos tickets

    _loadTickets(); // Cargar los tickets desde Hive
  }

  Future<List<Ticket>> _loadTickets() async {
    var loadedTickets = ticketsProvider.getTickets();
    print('Tickets cargados: ${loadedTickets.length}');
    // Guardar los tickets cargados en el estado
    setState(() {
      tickets =
          loadedTickets; // Ahora tickets está disponible para toda la clase
    });

    return loadedTickets; // Retornar los tickets para el FutureBuilder
  }

  @override
  void dispose() {
    super.dispose();
    ticketsProvider.dispose();
  }

 
  int getCartQuantity(Ticket ticket) {
    final cartTicket = cart.firstWhere(
      (t) => t.id == ticket.id,
      orElse: () => Ticket(
          id: ticket.id, name: ticket.name, price: ticket.price, quantity: 0),
    );
    return cartTicket.quantity;
  }

  void _decreaseTicketQuantity(Ticket ticket) {
    setState(() {
      final existingTicketIndex = cart.indexWhere((t) => t.id == ticket.id);

      if (existingTicketIndex != -1) {
        if (cart[existingTicketIndex].quantity > 1) {
          cart[existingTicketIndex].quantity -= 1;
        } else {
          cart.removeAt(existingTicketIndex);
        }
      }

      _calculateTotal(); // Recalcular el total
    });
  }

  void _addTicket(Ticket ticket) {
    setState(() {
      final existingTicketIndex = cart.indexWhere((t) => t.id == ticket.id);

      if (existingTicketIndex == -1) {
        // Si no está en el carrito, agrégalo con cantidad 1
        cart.add(Ticket(
            id: ticket.id,
            name: ticket.name,
            price: ticket.price,
            quantity: 1));
      } else {
        // Si está en el carrito, aumenta la cantidad
        cart[existingTicketIndex].quantity += 1;
      }

      _calculateTotal(); // Recalcular el total
    });
  }

  // Función para calcular el total.
  void _calculateTotal() {
    totalMoney =
        cart.fold(0.0, (sum, ticket) => sum + (ticket.price * ticket.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      drawer: const AppDrawer(),
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
                  : Text('hay tickets'); /* _getTickets(context); */
            }
            return Container();
          }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cart.isNotEmpty
          ? SizedBox(
              width: 200, // Ancho del botón
              height: 50, // Alto del botón
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón
                  // Puedes agregar la lógica para el pago aquí
                },
                child: Text(
                  'COBRAR \$${totalMoney.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black, // Cambia el color del texto aquí
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 232, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Bordes redondeados si lo deseas
                  ),
                ),
              ),
            )
          : null, // Si moneyList está vacío, no muestra el botón
    );
  }

  Widget _buildContainerWithButton(
      BuildContext context, Color color, double amount, Ticket ticket) {
    return Container(
      decoration: BoxDecoration(
        color: color, // El color del contenedor es dinámico
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Fila superior: Nombre a la izquierda y botón de eliminar a la derecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        ticket.name, // Mostramos el nombre del ticket
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red, size: 46),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // Lógica para eliminar el ticket
                      _decreaseTicketQuantity(ticket);
                    },
                  ),
                ],
              ),
              // Fila inferior: Precio a la izquierda y botón "Agregar" a la derecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Precio: \$${ticket.price.toStringAsFixed(2)}', // Precio del ticket
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Cantidad: ${getCartQuantity(ticket)}', // Precio del ticket
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTicket(ticket); // Agrega el monto del ticket
                    },
                    child: const Text(
                      'Agregar',
                      style: TextStyle(
                        color: Colors.black, // Cambia el color del texto aquí
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
