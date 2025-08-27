import 'package:hive/hive.dart';
part 'hive_task.g.dart';

@HiveType(typeId: 0)
class HiveTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final DateTime? completedAt;

  HiveTask({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
  });
}
