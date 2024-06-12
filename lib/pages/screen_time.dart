import 'dart:ui';
import 'package:capstone/data/user.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

import '../services/myapi.dart';
import '../services/mycolor.dart';

class ScreenTime extends StatefulWidget {
  User? user;
  ScreenTime({required this.user, super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  Service? service;
  List<dynamic> usageStats = [];

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(
          endDate.year, endDate.month, endDate.day, 0, 0, 0);

      var result = await service?.postUsageStats
        (
          startDate,
          endDate
      );
      if (result!.isEmpty){
        print("postUsageStats: Wrong input");
      } else {
        print("usageStats: $result");
        if (!mounted) return;
        setState(() {
          usageStats = result;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    service = Service(user: widget.user);
    initUsage();
  }

  /*
  void cardClickEvent(BuildContext context, String name) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return AppPage(appName: name);
      },
    );
  }
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.deepGreenBlue,
        padding: const EdgeInsets.all(10.0),

        child: Container(
          width: double.infinity, height: 800,
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyColors.brightGreenBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 410,
                  child: Text(
                      'Screen Time Ranking',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)
                  ),
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      itemCount: usageStats.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 1,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(20, 20))),

                            child: GestureDetector(
                              //onTap: () => cardClickEvent(context, usageStats[index]),
                              child: Container(
                                height: 70,
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                //margin: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.redAccent,
                                        Colors.pink,
                                        Colors.purpleAccent,
                                        Color(0xFF846AFF),
                                        Color(0xFF755EE8),

                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                // Adds a gradient background and rounded corners to the container
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 5,),
                                            Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight
                                                        .w700,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 5.0,  // shadow blur
                                                        color: Colors.white, // shadow color
                                                        offset: Offset(0,0), // how much shadow will be shown
                                                      ),
                                                    ],
                                                ),
                                            ),
                                            const SizedBox(width: 15,),
                                            Text(
                                                '${usageStats[index]['appEntry']}',
                                                style: const TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                    color: Colors.white)
                                            ),
                                            const Spacer(),
                                            Text(
                                                '${usageStats[index]['appTime']}',
                                                style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                    color: Colors.white,
                                                )
                                            ),
                                            const Text(
                                                ' m',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight
                                                      .w500,
                                                  color: Colors.white,
                                                )
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15.0,),
                                            const SizedBox(width: 5,),
                                            Text(
                                                '${usageStats[index]['appCarbon']}',
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w500,
                                                  color: Colors.white,
                                                )
                                            ),
                                            const Text(
                                                ' g',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight
                                                      .w500,
                                                  color: Colors.white,
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
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

/*
class AppPage extends StatefulWidget {
  final String appName;
  AppPage({Key? key, required this.appName}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  bool _isAlarmOff = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: MyColors.brightGreenBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
                child: Text(
                    "${widget.appName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                )
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Text(
                  "Do you want turn off alarm?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isAlarmOff,
                  onChanged: (value) {
                    setState(() {
                      _isAlarmOff = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/