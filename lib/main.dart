import 'package:flutter/material.dart';
import 'package:movies_app/service/movie_service.dart';
import 'package:get_it/get_it.dart';

void main() async {
  final movieService = MovieService();
  GetIt.I.registerSingletonAsync<Map<String, dynamic>>(
      () async => movieService.fetchData(),
      instanceName: 'movieData');
  await GetIt.I.allReady();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final int _counter = 0;

  final movieService = MovieService();

  @override
  Widget build(BuildContext context) {
    final movieDetails = movieService.fetchMovieDetails();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemCount: movieDetails.length,
          itemBuilder: (context, index) {
            return Container(child: Text(movieDetails[index].imageLink ?? ''));
          },
        ));
  }
}
