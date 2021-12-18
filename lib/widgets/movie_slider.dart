import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MoviewSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  final bool isLoadingMovies;

  MoviewSlider(
      {Key? key,
      required this.movies,
      this.title,
      required this.onNextPage,
      required this.isLoadingMovies})
      : super(key: key);

  @override
  State<MoviewSlider> createState() => _MoviewSliderState();
}

class _MoviewSliderState extends State<MoviewSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.onNextPage();
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260.0,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    widget.title!,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.movies.length,
                  itemBuilder: (_, int index) =>
                      _MoviePoster(widget.movies[index]),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
          if (widget.isLoadingMovies) Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  _MoviePoster(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        width: 130.0,
        height: 190.0,
        child: Column(children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 130.0,
                height: 190.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ]));
  }
}
