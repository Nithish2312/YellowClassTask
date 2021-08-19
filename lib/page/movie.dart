import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellowtaskmovieapp/boxes.dart';
import 'package:yellowtaskmovieapp/model/movie.dart';
import 'package:yellowtaskmovieapp/widget/movie_dialog.dart';
import 'package:intl/intl.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movie Tracker'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<Box<Movie>>(
          valueListenable: Boxes.getMovies().listenable(),
          builder: (context, box, _) {
            final movies = box.values.toList().cast<Movie>();

            return buildContent(movies);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MovieDialog(
              onClickedDone: addMovie,
            ),
          ),
        ),
      );

  Widget buildContent(List<Movie> movies) {
    if (movies.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 100),
            child: Image.asset("assets/nodata.jpg"),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 80.0, bottom: 50),
            child: Text("Click on + to add movies",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];

                return buildMovie(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMovie(
    BuildContext context,
    Movie movie,
  ) {
    final date = DateFormat.yMMMd().format(movie.createdDate);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        title: Row(
          children: [
            Container(
                height: 100,
                width: 100,
                child: Image.asset("assets/ironman.jpg")),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Movie: ",
                      maxLines: 2,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      movie.name,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Director: ",
                      maxLines: 2,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      movie.director,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        children: [
          buildButtons(context, movie),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Movie movie) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDialog(
                    transaction: movie,
                    onClickedDone: (name, director) =>
                        editMovie(movie, name, director),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteMovie(movie),
            ),
          )
        ],
      );

  Future addMovie(String name, String director) async {
    final movie = Movie()
      ..name = name
      ..createdDate = DateTime.now()
      ..director = director;

    final box = Boxes.getMovies();
    box.add(movie);
  }

  void editMovie(
    Movie movie,
    String name,
    String director,
  ) {
    movie.name = name;
    movie.director = director;

    movie.save();
  }

  void deleteMovie(Movie movie) {
    movie.delete();
  }
}
