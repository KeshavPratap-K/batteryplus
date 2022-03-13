import 'dart:async';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:batteryplus/device_details.dart';
import 'package:batteryplus/globals/global_var.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:batteryplus/components/z_animated_toggle.dart';
import 'package:batteryplus/theme_providers/theme_provider.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer timer;
  BatteryState batteryState = BatteryState.full;
  Color textButtonColor = Colors.black;

  late StreamSubscription streamSubscription;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    super.initState();

    getBatteryPercentage();
    getBatteryState();
    getThemeData();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getBatteryPercentage();
      getBatteryState();
      getThemeData();
    });
  }

  void getBatteryPercentage() async {
    final level = await battery.batteryLevel;
    percentage = level;
    batteryHealth = "${(await BatteryInfoPlugin().androidBatteryInfo)?.health}";
    batteryCapacity =
        "${((await BatteryInfoPlugin().androidBatteryInfo)!.batteryCapacity! / 1000).toString()}  mAh";
    currentNow =
        "${((await BatteryInfoPlugin().androidBatteryInfo)!.currentNow! / 1000).toString()} mA";
    currentAverage =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.currentAverage.toString()}";
    String pluggedStatusVar =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.pluggedStatus}";
    temperature =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.temperature.toString()} °C 🔥";
    voltage =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.voltage.toString()} mV⚡";
    technology =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.technology} ";
    remainingEnergy =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.remainingEnergy.toString()}";
    scale =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.scale.toString()}";
    chargingStatus =
        "${(await BatteryInfoPlugin().androidBatteryInfo)?.chargingStatus.toString()}";

    if (pluggedStatusVar == "AC") {
      pluggedStatus = pluggedStatusVar;
    } else {
      pluggedStatus = "Not plugged";
    }
    if (chargingStatus == "ChargingStatus.Charging") {
      chargeTimeRemaining = (await BatteryInfoPlugin().androidBatteryInfo)!
                  .chargeTimeRemaining! ==
              -1
          ? "Calculating charge time remaining ..."
          : "Charge time remaining: ${((await BatteryInfoPlugin().androidBatteryInfo)!.chargeTimeRemaining! / 1000 / 60).truncate()} minutes";
    } else if (chargingStatus == "ChargingStatus.Full") {
      chargeTimeRemaining = "Battery is full";
    } else {
      chargeTimeRemaining = "Battery not connected to a power source";
    }

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
      //'System Features': systemFeaturesList
    };
  }

  void getBatteryState() async {
    var deviceData = <String, dynamic>{};

    if (deviceData.isEmpty) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var deviceInfo = await deviceInfoPlugin.androidInfo;
      formatSystemFeature(deviceInfo.systemFeatures);
      //var androidInfoVar = await DeviceInfo.deviceInfoPlugin.androidInfo;
      //formatSystemFeature(androidInfoVar.systemFeatures);
      deviceData = _readAndroidBuildData(deviceInfo);
      deviceDetailsDataListVar = deviceData.keys
          .map((String property) => deviceData[property])
          .toList();
      deviceDetailsTitleListVar =
          deviceData.keys.map((String property) => property).toList();
      //systemDetailsGot = false;
      //continue;
    }

    streamSubscription = battery.onBatteryStateChanged.listen((state) {
      batteryState = state;
      switch (batteryState) {
        case BatteryState.full:
          batteryStatus = "Battery Full";
          batterycolor = const Color.fromARGB(255, 2, 241, 14);
          break;
        case BatteryState.charging:
          batteryStatus = "charging";
          batterycolor = const Color.fromARGB(255, 255, 115, 0);
          break;
        case BatteryState.discharging:
          batteryStatus = "discharging";
          batterycolor = const Color.fromARGB(255, 2, 241, 14);
          break;
        case BatteryState.unknown:
          batteryStatus = "unknown";
          batterycolor = const Color.fromARGB(255, 97, 97, 97);
          break;
        default:
          batteryStatus = "something broke";
          batterycolor = const Color.fromARGB(255, 170, 170, 170);
      }

      setState(() {});
    });
  }

  // function to toggle circle animation
  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
      //textButtonColor = Colors.white;
    } else {
      _animationController.reverse(from: 1.0);
      //textButtonColor = Colors.black;
    }
  }

  setTextButtonColor(bool theme) {
    if (!theme) {
      textButtonColor = Colors.white;
    } else {
      textButtonColor = Colors.black;
    }
  }

  Future<bool> getThemeData() async {
    WidgetsFlutterBinding.ensureInitialized();
    //final appDocumentDirectory = await getApplicationDocumentsDirectory();

    //Hive.init(appDocumentDirectory.path);

    final settings = await Hive.openBox('settings');
    themedata = settings.get('isLightTheme') ?? false;

    return themedata;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // Now we have access to the theme properties
    final themeProvider = Provider.of<ThemeProvider>(context);
    setTextButtonColor(themeProvider.isLightTheme);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: screenHeight * 0.1),
            child: Column(
              children: [
                ZAnimatedToggle(
                  values: const ['Light', 'Dark'],
                  onToggleCallback: (v) async {
                    await themeProvider.toggleThemeData();
                    setState(() {});
                    changeThemeMode(themeProvider.isLightTheme);
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 90),
                  child: SingleChildScrollView(
                    child: Hero(
                      tag: "DemoTag",
                      flightShuttleBuilder: (
                        BuildContext flightContext,
                        Animation<double> animation,
                        HeroFlightDirection flightDirection,
                        BuildContext fromHeroContext,
                        BuildContext toHeroContext,
                      ) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) => Container(
                            color: const Color(0xFFFDFDFD).withOpacity(0),
                          ),
                        );
                      },
                      child: CircularPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        radius: screenWidth * 0.35,
                        lineWidth: screenWidth * 0.05,
                        percent: percentage.toDouble() / 100,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0),
                            ),
                            Text(
                              batteryStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        progressColor: batterycolor,
                        backgroundColor: const Color.fromARGB(255, 97, 97, 97),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: textButtonColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const DeviceDetails()));
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Text("More Details ", style: TextStyle(fontSize: 20)),
                        Icon(Icons.arrow_forward_rounded, size: 25),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// #time for finishing touches! I
