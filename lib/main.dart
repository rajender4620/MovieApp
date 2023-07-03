import 'package:flutter/material.dart';
import 'package:movies_app/models/MovieDetails.dart';
import 'package:movies_app/service/movie_service.dart';

void main() async {
  // final movieService = MovieService();
  // GetIt.I.registerSingletonAsync<Map<String, dynamic>>(
  //     () async => movieService.fetchData(),
  //     instanceName: 'movieData');
  // await GetIt.I.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Movies App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final movieService = MovieService();
  List<MovieDetails> listOfmovieDetails = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    fetchMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        loadMoreMOvies();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final movieData = await movieService.fetchData();
    final res1 = (movieData['results'] as List<dynamic>).map((e) {
      final title = e['titleText']['text'];
      final String? imageLink = e['primaryImage']?['url'];
      final movieType = e['titleType']['text'];
      final releaseYear = e['releaseYear']['year'];
      return MovieDetails(title, imageLink, movieType, releaseYear);
    }).toList();
    for (var element in res1) {
      listOfmovieDetails.add(element);
    }
    final movieDataa = await movieService.fetchData(page: 2);
    final res2 = (movieDataa['results'] as List<dynamic>).map((e) {
      final title = e['titleText']['text'];
      final String? imageLink = e['primaryImage']?['url'];
      final movieType = e['titleType']['text'];
      final releaseYear = e['releaseYear']['year'];
      return MovieDetails(title, imageLink, movieType, releaseYear);
    }).toList();
    for (var element in res2) {
      listOfmovieDetails.add(element);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final listOfmovieDetails = movieService.fetchMovieDetails();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemCount: listOfmovieDetails.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index < listOfmovieDetails.length) {
              return ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Image.network(
                    listOfmovieDetails[index].imageLink ??
                        'Something went wrong',
                  ),
                ),
                title: Text(listOfmovieDetails[index].movieName),
                subtitle: Text(listOfmovieDetails[index].movieType),
              );
            } else if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('No more movies'),
              );
            }
          },
        ));
  }

  Future<void> loadMoreMOvies() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    final movieData = await movieService.fetchData(page: currentPage + 1);
    final res = (movieData['results'] as List<dynamic>).map((e) {
      final title = e['titleText']['text'];
      final String? imageLink = e['primaryImage']?['url'];
      final movieType = e['titleType']['text'];
      final releaseYear = e['releaseYear']['year'];
      return MovieDetails(title, imageLink, movieType, releaseYear);
    }).toList();
    currentPage++;
    listOfmovieDetails.addAll(res);
    setState(() {
      isLoading = false;
    });
  }
}
