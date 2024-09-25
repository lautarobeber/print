import "package:hive_flutter/hive_flutter.dart";

part 'ticket.g.dart';

@HiveType(typeId:0)
class Ticket extends HiveObject {


  Ticket(
      {required this.id,
      required this.name,
      required this.price,
      this.quantity = 0});


  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  int quantity;
}
