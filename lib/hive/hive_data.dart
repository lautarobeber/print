



import 'package:hive_flutter/adapters.dart';
import 'package:sunmi/hive/ticket.dart';

class HiveData {
  const HiveData();

  Future<int> saveTicket(Ticket ticket) async {
    final Box<Ticket> box = await Hive.openBox<Ticket>("tickets");
    return box.add(ticket);
  }

  Future<List<Ticket>> get tickets async {
    final Box<Ticket> box = await Hive.openBox<Ticket>('tickets');

    // Asegúrate de que la lista tenga el tipo correcto
    return box.values.cast<Ticket>().toList(); // Usa cast para obtener List<Ticket>
  }
}
