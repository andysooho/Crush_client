import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoordiEvalCard extends StatefulWidget {
  CoordiEvalCard({
    Key? key,
    required this.photoUri,
    required this.title,
    required this.onRated,
  }) : super(key: key);

  final String photoUri;
  final String title;
  final Function(double) onRated;

  @override
  State<CoordiEvalCard> createState() => _CoordiEvalCardState();
}

class _CoordiEvalCardState extends State<CoordiEvalCard> {
  bool _completedAnimation = false;
  bool _shouldAnimate = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        widget.onRated(0);
      },
      child: Center(
        child: AnimatedContainer(
          width: _shouldAnimate ? screenWidth * 0.01 : screenWidth * 0.9,
          height: _shouldAnimate ? screenHeight * 0.01 : screenHeight * 0.7,
          duration: const Duration(milliseconds: 1000),
          onEnd: () {
            if(_completedAnimation){
              widget.onRated(0);
              _completedAnimation = false;
            }
          },
          curve: Curves.easeOutCubic,
          transform: _shouldAnimate ? Matrix4.translationValues(screenWidth, -screenHeight*0.7,0)
              : Matrix4.identity(),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.photoUri,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: const Alignment(-0.8, 0.72),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text.rich(
                      TextSpan(
                        text: widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),
                              color: Colors.black,
                              blurRadius: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(1),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.05,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar(
                              initialRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              ratingWidget: RatingWidget(
                                full: const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                half: const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                ),
                                empty: Icon(
                                  Icons.star,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              itemSize: screenHeight * 0.065,
                              glow: false,
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _completedAnimation = true;
                                  _shouldAnimate = true;
                                });
                              },
                            ),
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
      ),
    );
  }
}
