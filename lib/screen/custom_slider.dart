import 'dart:async';

import 'package:flutter/material.dart';

class CustomSliderScreen extends StatefulWidget {
  const CustomSliderScreen({super.key});

  @override
  State<CustomSliderScreen> createState() => _CustomSliderScreenState();
}

class _CustomSliderScreenState extends State<CustomSliderScreen> {
  int currentPage = 0;
  final animationDuration = 400;

  var isAutoScrollEnable = false;
  final autoSliderDuration = 3;
  Timer? _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  //Slider Bars
  final initialCircularBarSize = 8.0;
  final fullCircularBarSize = 20.0;
  final selectedCircularBarColor = Colors.grey.shade900;
  final deselectedCircularBarColor = Colors.grey.shade500;

  List<Widget> picturesList = [
    Image.asset(
      'assets/pictures/3.png',
      key: UniqueKey(),
    ),
    Image.asset(
      'assets/pictures/2.png',
      key: UniqueKey(),
    ),
    Image.asset(
      'assets/pictures/1.png',
      key: UniqueKey(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void enableTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: autoSliderDuration), (timer) {
      if (currentPage < picturesList.length) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      // print("CurrentPage: $currentPage");
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: animationDuration),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Images
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    color: Colors.red.shade200,
                  ),
                  Positioned(
                    top: 25,
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: animationDuration),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: picturesList[currentPage],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        const Text(
                          "AUTO",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              isAutoScrollEnable = value;
                              if (isAutoScrollEnable) {
                                enableTimer();
                              } else {
                                _timer!.cancel();
                              }
                            });
                          },
                          value: isAutoScrollEnable,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            ///Description Text
            Expanded(
              flex: 2,
              child: PageView.builder(
                controller: _pageController,
                itemCount: picturesList.length,
                onPageChanged: (value) {
                  setState(() => currentPage = value);
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Find your best outfit\nand look great',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, standard dummy text ever since the 1500s.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            ///Slider Bars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                picturesList.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    height: initialCircularBarSize,
                    width: currentPage == index
                        ? fullCircularBarSize
                        : initialCircularBarSize,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? selectedCircularBarColor
                          : deselectedCircularBarColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    duration: Duration(milliseconds: animationDuration),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
