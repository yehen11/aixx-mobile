import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/course/data/repositories/course_repository.dart';
import '../../modules/course/model/course_model.dart';
import '../../modules/course/model/module_model.dart';

final courseRepositoryProvider =
    Provider<CourseRepository>((ref) => CourseRepository());

/// List of available courses — used for the Hub's course tiles.
final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  final repo = ref.read(courseRepositoryProvider);
  return repo.getCourses();
});

/// Modules within a specific course — used by Course Contents screen.
/// courseId is int, matching the real backend's Course.id type.
final moduleListProvider =
    FutureProvider.family<List<ModuleModel>, int>((ref, courseId) async {
  final repo = ref.read(courseRepositoryProvider);
  return repo.getModules(courseId);
});