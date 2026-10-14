import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/course/data/repositories/course_repository.dart';
import '../../modules/course/model/course_model.dart';
import '../../modules/course/model/course_progress_model.dart';
import '../../modules/course/model/module_model.dart';

final courseRepositoryProvider =
    Provider<CourseRepository>((ref) => CourseRepository());

final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  final repo = ref.read(courseRepositoryProvider);
  return repo.getCourses();
});

/// Modules within a specific course — now keyed by slug, not id,
/// and returns progress alongside the module list.
final moduleListProvider = FutureProvider.family<
    ({CourseProgress progress, List<ModuleModel> modules}),
    String>((ref, courseSlug) async {
  final repo = ref.read(courseRepositoryProvider);
  return repo.getModules(courseSlug);
});