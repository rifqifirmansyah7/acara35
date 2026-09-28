import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minggu_10_moviedb/data/api_provider.dart';
import 'package:minggu_10_moviedb/model/popular_movies.dart';

void main() => runApp(MoviesApp());

class MoviesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiProvider apiProvider = ApiProvider();
  late Future<PopularMovies> popularMovies;
  String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    popularMovies = apiProvider.getPopularMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies App')),
      body: FutureBuilder<PopularMovies>(
        future: popularMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.results.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data!.results[index];
                return moviesItem(
                  poster: '$imageBaseUrl${movie.posterPath}',
                  title: movie.title,
                  date: movie.releaseDate,
                  voteAverage: movie.voteAverage.toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(movie: movie),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget moviesItem({
    required String poster,
    required String title,
    required String date,
    required String voteAverage,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                height:
                    180, // Tambahkan tinggi agar poster tidak hitam/collapse
                child: CachedNetworkImage(
                  imageUrl: poster,
                  fit: BoxFit.cover, // Agar gambar pas dan tidak gepeng
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Icon(Icons.calendar_today, size: 12),
                          SizedBox(width: 5),
                          Text(date),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, size: 12),
                          SizedBox(width: 5),
                          Text(voteAverage),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetail extends StatelessWidget {
  final Results movie;

  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              movie.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(movie.overview, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
