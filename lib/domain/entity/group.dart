import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isOpen;

  Group({
    required this.title,
    required this.isOpen
  });
}