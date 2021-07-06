import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation = Tween(begin: -35.0, end: -80.0).animate(
    CurvedAnimation(
      curve: Curves.easeInOut,
      parent: catController,
    ),
  );

  late AnimationController catController = AnimationController(
    duration: Duration(milliseconds: 200),
    vsync: this,
  );

  late Animation<double> boxAnimation = Tween(
    begin: pi * 0.6,
    end: pi * 0.65,
  ).animate(CurvedAnimation(
    parent: boxAnimationController,
    curve: Curves.easeInOut,
  ));

  late AnimationController boxAnimationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
  );

  initState() {
    super.initState();
    addEventListeners();
    boxAnimationController.forward();
  }

  addEventListeners() {
    boxAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxAnimationController.forward();
      }
    });
  }

  catTapped() {
    switch (catController.status) {
      case AnimationStatus.dismissed:
        catController.forward();
        boxAnimationController.stop();
        break;
      case AnimationStatus.completed:
        catController.reverse();
        boxAnimationController.forward();
        break;
      case AnimationStatus.forward:
        catController.reverse();
        boxAnimationController.forward();
        break;
      case AnimationStatus.reverse:
        catController.forward();
        break;
      default:
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlapAnimation(),
              buildRightFlapAnimation(),
            ],
            clipBehavior: Clip.none,
          ),
        ),
        onTap: catTapped,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child as Widget,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget flap() {
    return Container(
      height: 10.0,
      width: 125.0,
      color: Colors.brown,
    );
  }

  Widget buildRightFlapAnimation() {
    return AnimatedBuilder(
      animation: boxAnimation,
      child: flap(),
      builder: (context, child) => buildRightFlap(boxAnimation.value),
    );
  }

  Widget buildLeftFlapAnimation() {
    return AnimatedBuilder(
      animation: boxAnimation,
      child: flap(),
      builder: (context, child) => buildLeftFlap(boxAnimation.value),
    );
  }

  Widget buildRightFlap(double animationValue) {
    return Positioned(
      right: 3.0,
      child: Transform.rotate(
        child: flap(),
        angle: -animationValue,
        alignment: Alignment.topRight,
      ),
    );
  }

  Widget buildLeftFlap(double animationValue) {
    return Positioned(
      left: 3.0,
      child: Transform.rotate(
        child: flap(),
        angle: animationValue,
        alignment: Alignment.topLeft,
      ),
    );
  }
}
