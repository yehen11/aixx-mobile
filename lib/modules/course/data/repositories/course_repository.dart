import '../../model/course_model.dart';
import '../../model/course_progress_model.dart';
import '../../model/module_model.dart';
import '../apis/course_api.dart';

class CourseRepository {
  final CourseApi _api = CourseApi();

  Future<List<CourseModel>> getCourses() => _api.getCourses();

  Future<({CourseProgress progress, List<ModuleModel> modules})> getModules(
    String courseSlug,
  ) =>
      _api.getModules(courseSlug);
}