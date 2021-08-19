import 'package:hive/hive.dart';
import 'package:yellowtaskmovieapp/model/movie.dart';

class Boxes {
  static Box<Movie> getMovies() => Hive.box<Movie>('movies');
}
