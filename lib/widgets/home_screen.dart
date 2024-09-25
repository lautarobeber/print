import 'package:flutter/material.dart';
import 'package:sunmi/hive/hive_data.dart';
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

  @override
  void initState() {
    super.initState();
    // Inicializar algunos tickets
    /* tickets = [
      Ticket(id: 1, name: 'Ticket 1', price: 10.0),
      Ticket(id: 2, name: 'Ticket 2', price: 20.0),
      Ticket(id: 3, name: 'Ticket 3', price: 30.0),
    ]; */
     _loadTickets(); // Cargar los tickets desde Hive
  }
  

  

  Future<void> _loadTickets() async {
    List<Ticket> loadedTickets =
        await HiveData().tickets; // Obtener los tickets de Hive
    setState(() {
      tickets = loadedTickets; // Asignar los tickets cargados
    });
  }

  void _addMoney(double amount) {
    setState(() {
      moneyList.add(amount); // Agrega el monto a la lista
      totalMoney = moneyList.reduce((a, b) => a + b); // Calcula la suma total
    });
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

  void _removeTicket(Ticket ticket) {
    setState(() {
      // Buscamos el índice del ticket en el carrito
      final existingTicketIndex = cart.indexWhere((t) => t.id == ticket.id);

      if (existingTicketIndex != -1) {
        // Si el ticket existe
        if (cart[existingTicketIndex].quantity > 1) {
          // Disminuimos la cantidad si hay más de uno
          cart[existingTicketIndex].quantity -= 1;
        } else {
          // Si solo queda uno, lo quitamos del carrito
          cart.removeAt(existingTicketIndex);
        }
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
      body: ListView(
        children: tickets.map((ticket) {
          return Padding(
            padding:
                const EdgeInsets.all(8.0), // Margen alrededor de cada ticket
            child: _buildContainerWithButton(
              context,
              Colors
                  .blue, // Puedes cambiar el color dinámicamente si es necesario
              ticket.price, // Usamos el precio del ticket
              ticket, // Pasamos el ticket para usarlo en la lógica de eliminar
            ),
          );
        }).toList(),
      ),

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
