import 'dart:async';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:batteryplus/globals/global_var.dart';
import 'package:expand_widget/expand_widget.dart';

// Import package

class BatteryInfoList extends StatefulWidget {
  const BatteryInfoList({Key? key}) : super(key: key);

  @override
  State<BatteryInfoList> createState() => _BatteryInfoListState();
}

class _BatteryInfoListState extends State<BatteryInfoList>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer timer;

  @override
  void initState() {
    super.initState();
    //getBatteryPercentage();
    initPlatformState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //getBatteryPercentage();
      initPlatformState();
    });
  }

  Future<void> initPlatformState() async {
    var batteryDetails = <String, dynamic>{};
    batteryDetails = batteryDetailsListData();
    batteryDetailsDataListVar = batteryDetails.keys
        .map((String property) => batteryDetails[property])
        .toList();
    batteryDetailsTitleListVar =
        batteryDetails.keys.map((String property) => property).toList();

    setState(() {});
  }

  Map<String, dynamic> batteryDetailsListData() {
    return <String, dynamic>{
      'Battery Temperature': temperature,
      'Battery Current Now': currentNow,
      'Battery Charging Status': batteryStatus.toTitleCase(),
      'Battery Current Average': currentAverage,
      'Battery Capacity': batteryCapacity,
      'Battery Remaining Energy': remainingEnergy,
      'Battery Technology': technology,
    };
  }

  @override
  Widget build(BuildContext context) {
    //getThemeData();
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        // Wrapper before Scroll view!
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    SingleChildScrollView(
                      child: Hero(
                        tag: "DemoTag",
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return SingleChildScrollView(
                            child: toHeroContext.widget,
                          );
                        },
                        child: CircularPercentIndicator(
                          animation: false,
                          animationDuration: 1000,
                          radius: (screenWidth * 0.35) - 90,
                          lineWidth: (screenWidth * 0.07) - 20,
                          percent: percentage.toDouble() / 100,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                          progressColor: batterycolor,
                          backgroundColor:
                              const Color.fromARGB(255, 97, 97, 97),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<AndroidBatteryInfo?>(
                              future: BatteryInfoPlugin().androidBatteryInfo,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var health = formatBatteryHealth(
                                      '${snapshot.data!.health}');
                                  return Text('Battery Health: $health');
                                }
                                return const CircularProgressIndicator();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Plugged Status:  $pluggedStatus"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Voltage:  $voltage"),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 20, right: 0, bottom: 10),
                  child: Container(
                    color: themedata
                        ? const Color.fromARGB(255, 85, 85, 85).withOpacity(0.2)
                        : const Color.fromARGB(255, 122, 122, 122)
                            .withOpacity(0.2),
                    width: screenWidth,
                    height: 48.0,
                    child: const Padding(
                      padding: EdgeInsets.all(11.0),
                      child: Text("More Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                for (int i = 0; i < batteryDetailsDataListVar.length; i++)
                  Container(
                    width: screenWidth,
                    color: themedata
                        ? const Color.fromARGB(255, 236, 236, 236)
                            .withOpacity(0.2)
                        : const Color.fromARGB(255, 71, 71, 71)
                            .withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              batteryDetailsTitleListVar[i].toString() +
                                  ": " +
                                  batteryDetailsDataListVar[i].toString(),
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                Container(
                  width: screenWidth,
                  color: themedata
                      ? const Color.fromARGB(255, 236, 236, 236)
                          .withOpacity(0.2)
                      : const Color.fromARGB(255, 71, 71, 71).withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(chargeTimeRemaining),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: screenWidth,
                  color: themedata
                      ? const Color.fromARGB(255, 236, 236, 236)
                          .withOpacity(0.2)
                      : const Color.fromARGB(255, 71, 71, 71).withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Center(
                            child: Text(
                          "Battery Charging History",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ExpandChild(
                          child: OutlinedButton(
                            child: const Text(
                                'Battery Charging History coming soon'),
                            onPressed: () {},
                          ),
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
