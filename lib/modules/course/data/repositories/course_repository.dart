import '../../model/course_model.dart';
import '../../model/module_model.dart';
import '../apis/course_api.dart';

class CourseRepository {
  final CourseApi _api = CourseApi();

  Future<List<CourseModel>> getCourses() => _api.getCourses();

  Future<List<ModuleModel>> getModules(int courseId) =>
      _api.getModules(courseId);
}