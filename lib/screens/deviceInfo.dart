import 'package:auto_animated/auto_animated.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:batteryplus/globals/global_var.dart';

class DeviceInfoList extends StatelessWidget {
  const DeviceInfoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: const <Widget>[
              Expanded(
                child: DeviceInfo(),
              ),
            ],
          ),
        ),
      );
}

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({Key? key}) : super(key: key);

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          // Wrapper before Scroll view!
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, top: 20, right: 0, bottom: 10),
                    child: Image.asset(
                      themedata
                          ? "images/Android-Logo-Dark.png"
                          : "images/Android-Logo-Light.png",
                      frameBuilder: (BuildContext context, Widget child,
                          int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn,
                          child: child,
                        );
                      },
                    ),
                  ),
                  AnimateIfVisibleWrapper(
                    showItemInterval: const Duration(milliseconds: 150),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 20, right: 0, bottom: 10),
                            child: Container(
                              color: themedata
                                  ? const Color.fromARGB(255, 85, 85, 85)
                                      .withOpacity(0.2)
                                  : const Color.fromARGB(255, 122, 122, 122)
                                      .withOpacity(0.2),
                              width: screenWidth,
                              height: 48.0,
                              child: const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: Text("More Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          for (int i = 0;
                              i < deviceDetailsDataListVar.length;
                              i++)
                            Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Table(
                                        border: const TableBorder(),
                                        children: [
                                          TableRow(children: [
                                            Text(
                                                deviceDetailsTitleListVar[i]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                deviceDetailsDataListVar[i]
                                                    .toString(),
                                                textAlign: TextAlign.left),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          const SizedBox(height: 30),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Device Features",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ExpandChild(
                                  hideIndicatorOnExpand: false,
                                  expandIndicatorStyle: ExpandIndicatorStyle.both,
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i < systemFeaturesList.length;
                                          i++)
                                        Text(systemFeaturesList[i].toString(),
                                            textAlign: TextAlign.left),
                                      /* Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Table(
                                                  border: const TableBorder(),
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                          systemFeaturesKeyList[
                                                                  i]
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          systemFeaturesValueList[
                                                                  i]
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ), */
                                    ],
                                  ),
                                ),
                              ]),
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
