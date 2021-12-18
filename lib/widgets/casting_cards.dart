import 'package:flutter/material.dart';

class CastingCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: 180.0,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) {
          return _CastCard();
        },
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: 110.0,
      height: 100.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                height: 140.0,
                width: 110.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage('https://via.placeholder.com/200x300')),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Actor.name jjhj hghghjhgg ghfhgfhfg',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
