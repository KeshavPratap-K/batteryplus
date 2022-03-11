import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
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

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        var androidInfoVar = await DeviceInfo.deviceInfoPlugin.androidInfo;
        //formatSystemFeature(androidInfoVar.systemFeatures);
        deviceData = _readAndroidBuildData(androidInfoVar);
        deviceDetailsDataListVar = deviceData.keys
            .map((String property) => deviceData[property])
            .toList();
        deviceDetailsTitleListVar =
            deviceData.keys.map((String property) => property).toList();
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {});
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Manufacturer': build.manufacturer,
      'Product': build.product,
      'Make': build.brand,
      'Model': build.model,
      'SecurityPatch': build.version.securityPatch,
      'Android SDK': build.version.sdkInt,
      'Android Version': build.version.release,
      'Incremental Version': build.version.incremental,
      'Version Codename': build.version.codename,
      'Device Board': build.board,
      'bootloader': build.bootloader,
      'Display Info': build.display,
      'Fingerprint': build.fingerprint,
      'Hardware': build.hardware,
      'Host': build.host,
      'ID': build.id,
      'Supported32BitAbis': build.supported32BitAbis,
      'Supported64BitAbis': build.supported64BitAbis,
      'SupportedAbis': build.supportedAbis,
      'Tags': build.tags,
      'Type': build.type,
      'isPhysical Device': build.isPhysicalDevice,
      'Android ID': build.androidId,
    };
  }

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
                          /* Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Table(
                                      border: const TableBorder(),
                                      children: [
                                        TableRow(children: [
                                          const Text("System Features",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Table(
                                            border: const TableBorder(),
                                            children: [
                                              for (int i = 0;
                                                  i < systemFeaturesList.length;
                                                  i++)
                                                TableRow(children: [
                                                  Flexible(
                                                    child: Text(
                                                      systemFeaturesList[i]
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ])
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ]),
                          ), */
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
