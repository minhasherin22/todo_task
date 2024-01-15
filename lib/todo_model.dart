import 'package:hive/hive.dart';
part 'todo_model.g.dart';
@HiveType(typeId: 0)
class  TodoModel{
  @HiveField(0)
  String description;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String title;

  TodoModel({required this.description,required this.title,  this.isDone = false});

}