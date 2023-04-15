import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AchievementBar extends StatefulWidget {
  final int todaysStepCount;

  AchievementBar({Key? key, required this.todaysStepCount}) : super(key: key);

  @override
  State<AchievementBar> createState() => _AchievementBarState();
}

class _AchievementBarState extends State<AchievementBar> {
  double _width = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _width = (MediaQuery.of(context).size.width / 1.2) /
          (10000 / widget.todaysStepCount);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Opacity(
              opacity: 0,
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(child: SvgPicture.asset('assets/coin.svg'))),
            ),
            SizedBox(
                height: 25,
                width: 25,
                child: Center(child: SvgPicture.asset('assets/coin.svg'))),
            SizedBox(
                height: 25,
                width: 25,
                child: Center(child: SvgPicture.asset('assets/coin.svg'))),
            SizedBox(
                height: 25,
                width: 25,
                child: Center(child: SvgPicture.asset('assets/coin.svg'))),
            SizedBox(
                height: 25,
                width: 25,
                child: Center(child: SvgPicture.asset('assets/coin.svg'))),
            SizedBox(
                height: 30,
                width: 30,
                child: Center(child: SvgPicture.asset('assets/coin.svg'))),
          ],
        ),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 15,
              color: Colors.deepOrange[200],
            ),
            AnimatedContainer(
              width: _width,
              height: 15,
              color: Colors.deepOrange[500],
              duration: const Duration(milliseconds: 500),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(opacity: 0, child: Text("0K")),
            Text("2K"),
            Text("4K"),
            Text("6K"),
            Text("8K"),
            Text("10K")
          ],
        )
      ],
    );
  }
}
