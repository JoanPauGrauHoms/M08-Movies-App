import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/movie.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;
  @override
  void onInit() async {
    isLoading.value = true;
    mainTopRatedMovies.value = (await ApiService.popularActors())!;
    isLoading.value = false;
    super.onInit();
  }

  bool inWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  void addWatchList(Movie movie) {
    if (watchListMovies.any((m) => m.id == movie.id)) {
      watchListMovies.remove(movie);
      Get.snackbar('Success', 'removed from favorites list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 800));
    } else {
      watchListMovies.add(movie);
      Get.snackbar('Success', 'added to favorites list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 800));
    }
  }
}
