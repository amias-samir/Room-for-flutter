import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'moor_database.g.dart';

class Tasks extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id, name};
}

@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase{

  AppDatabase()
      :super((
    FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true)
  ));

  @override
  int get schemaVersion =>1;


}

@UseDao(
  tables: [Tasks],
//queries: {
//  'completedTasksGenerated' : 'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_date DESC, name;'
//    },
)
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;
  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTask() => select(tasks).get();

  Stream<List<Task>> watchAllTask(){
    return(
    select(tasks)
        ..orderBy(([
          (t)=> OrderingTerm(expression:t.dueDate,mode: OrderingMode.desc ),

          (t)=> OrderingTerm(expression: t.name)
        ]))

    ).watch();
  }

  Stream<List<Task>> watchAllCompletedTask(){
    return(
        select(tasks)
          ..orderBy(([
                (t)=> OrderingTerm(expression:t.dueDate,mode: OrderingMode.desc ),

                (t)=> OrderingTerm(expression: t.name)
          ]))
          ..where((t)=> t.completed.equals(true))

    ).watch();
  }

  Future insertTask(Task task) => into(tasks).insert(task);

  Future updateTask(Task task) => update(tasks).replace(task);

  Future deleteTask(Task task) => delete(tasks).delete(task);

}

