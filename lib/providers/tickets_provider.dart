import 'package:path_provider/path_provider.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sunmi/hive/ticket.dart';

class TicketsProvider {
  late Box box;

  Future<bool> inicializarBox() async {
    final directorio = await getApplicationSupportDirectory();
    Hive.init(directorio.path);
    box = await Hive.openBox('ticketsBox');
    return box.isOpen;
  }

  Future<bool> addTicket(var ticket) async {
    await box.add(ticket);
    return true;
  }

  List<Ticket> getTickets() {
    return box.values.cast<Ticket>().toList();
    
  }

  Future<bool> deleteTicket(int indice) async {
    await box.deleteAt(indice);
    return true;
  }

  Future<bool> updateTicket(int id, var ticket) async {
    await box.put(id, ticket); // Actualizar el ticket con la misma clave (ID)
    return true;
  }

  dispose() {
    box.close();
  }
}
