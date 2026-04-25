import 'user.dart';
import 'task.dart';
import 'media.dart';
import 'dead_pig.dart';
import 'pen.dart';

class API {
  static final User = UserAPI();
  static final Task = TaskAPI();
  static final Media = MediaAPI();
  static final DeadPig = DeadPigAPI();
  static final Pen = PenAPI();
}
