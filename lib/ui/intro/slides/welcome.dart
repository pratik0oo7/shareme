import 'package:flutter/material.dart';

class welcomeslide extends StatefulWidget {
  final AnimationController animationController;

  const welcomeslide(
      {Key? key,
      required this.animationController,
      TextStyle? styleTitle,
      TextStyle? styleDescription,
      String? title,
      String? description,
      String? pathImage,
      Color? backgroundColor})
      : super(key: key);

  @override
  _welcomeslideState createState() => _welcomeslideState();
}

class _welcomeslideState extends State<welcomeslide> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _introductionanimation,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/introduction_animation/introduction_image.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                // ignore: unnecessary_const
                child: const Text(
                  "Welcome ",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),

                // ignore: unnecessary_const
                child: const Text(
                  "Sync & Share",
                  // ignore: unnecessary_const
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16),
                child: InkWell(
                  onTap: () {
                    widget.animationController.animateTo(0.2);
                  },
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.only(
                      left: 56.0,
                      right: 56.0,
                      top: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38.0),
                      color: const Color(0xff132137),
                    ),
                    child: const Text(
                      "Let's go",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
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
