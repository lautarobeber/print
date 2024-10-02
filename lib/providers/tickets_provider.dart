import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sunmi/hive/ticket.dart';

class TicketsProvider with ChangeNotifier {
  late Box box;

  Future<bool> inicializarBox() async {
    final directorio = await getApplicationSupportDirectory();
    Hive.init(directorio.path);
    box = await Hive.openBox('ticketsBox');
    return box.isOpen;
  }

  Future<bool> addTicket(var ticket) async {
    await box.put(ticket.id, ticket);
    notifyListeners();
    return true;
  }

  List<Ticket> getTickets() {
    return box.values.cast<Ticket>().toList();
  }

  Future<bool> deleteTicket(int id) async {
    print(id);
    print('IDs en la base de datos: ${box.keys.toList()}');
    if (box.containsKey(id)) {
      await box.delete(id);
      notifyListeners(); // Elimina el ticket por su ID
      return true;
    } else {
      print('El ID no existe');
      return false;
    }
  }

  Future<void> vaciarBox() async {
    await box.clear(); // Elimina todos los elementos del box
    print('El box ha sido vaciado.');
  }

  Future<bool> updateTicket(int id, var ticket) async {
    await box.put(id, ticket);
    notifyListeners(); // Actualizar el ticket con la misma clave (ID)
    return true;
  }

  @override
  void dispose() {
    box.close();
    super.dispose(); // Asegúrate de llamar a super.dispose() también
  }
}
