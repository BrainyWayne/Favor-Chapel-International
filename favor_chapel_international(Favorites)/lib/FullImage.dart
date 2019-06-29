import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {

  final String imageUrl;

  FullImage({Key key, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Center(child: Image.network(imageUrl)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: InkWell(
              child:
              Icon(Icons.arrow_back, color: Colors.white,),
              onTap: (){
                Navigator.pop(context);
              },

            ),
          ),
        ],
      )
    );
  }
}
