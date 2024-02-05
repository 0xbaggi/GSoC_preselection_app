import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_app/entities/kml/look_at_entity.dart';
import 'package:simple_app/widget/BigButton.dart';

import '../kml_makers/kml_makers.dart';
import '../utility/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool orbiting = false;

  showSnackBar(String text, bool goSettings) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SizedBox(
            height: 60,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(text, style: Const.titleText))),
        backgroundColor: Const.lightGrey,
        duration: const Duration(seconds: 1),
        action: goSettings
            ? SnackBarAction(
                label: 'Go to settings',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              )
            : null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.grey,
      appBar: AppBar(
        backgroundColor: Const.darkGrey,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          const SizedBox(width: 45),
          Text('Simple Flutter app', style: Const.BigText),
          const Spacer(),
          Const.ssh.connected
              ? const Tooltip(
                  message: 'Online',
                  child: Icon(Icons.check_circle, color: Colors.green))
              : const Tooltip(
                  message: 'Offline',
                  child: Icon(Icons.error, color: Colors.red)),
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, '/settings');
                });
              },
              icon: const Icon(Icons.settings)),
          const SizedBox(width: 16)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BigButton(
                  onPressed: () {
                    if (Const.ssh.connected) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation',
                                style: TextStyle(fontSize: 30)),
                            content: const Text(
                                'Are you sure you want to reboot?',
                                style: TextStyle(fontSize: 20)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Const.lg.reboot();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showSnackBar("First connect to the liquid galaxy.", true);
                    }
                  },
                  icon: Icons.restart_alt,
                  text: "Reboot"),
              BigButton(
                  onPressed: () {
                    if (Const.ssh.connected) {
                      Const.lg.sendTour(45.4642, 9.1900, 4500.0, 60, 1);
                    } else {
                      showSnackBar("First connect to the liquid galaxy.", true);
                    }
                  },
                  icon: Icons.location_city,
                  text: "Go to Milan"),
              BigButton(
                  onPressed: () {
                    if (Const.ssh.connected) {
                      if (!orbiting) {
                        Const.lg.buildOrbit(LookAtEntity(
                            lat: 45.4642,
                            lng: 9.1900,
                            range: '4500',
                            tilt: 60,
                            heading: '0',
                            zoom: 4500));
                        Future.delayed(const Duration(seconds: 44), () {
                          Const.lg.stopTour();
                          orbiting = false;
                          setState(() {});
                        });
                      } else {
                        Const.lg.stopTour();
                      }
                      orbiting = !orbiting;
                      setState(() {});
                    } else {
                      showSnackBar("First connect to the liquid galaxy.", true);
                    }
                  },
                  icon: Icons.airplanemode_active,
                  text: orbiting ? "Stop Orbit" : "Start Orbit"),
              BigButton(
                  onPressed: () {
                    if (Const.ssh.connected) {
                      Const.lg.clearKml(keepLogos: false);
                      Const.lg.sendKMLToSlave(
                          Const.lg.lastScreen,
                          KMLMakers.screenOverlayImage(
                              "https://i.ibb.co/W2LDBdb/Senza-nome.png",
                              2864 / 3000));
                    } else {
                      showSnackBar("First connect to the liquid galaxy.", true);
                    }
                  },
                  icon: Icons.print,
                  text: "Show logo"),
            ],
          ),
      const Spacer(),
])

    );
  }
}
