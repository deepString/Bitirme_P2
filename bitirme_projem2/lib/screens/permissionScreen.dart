import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  String camResult = "";
  String locationResult = "";
  String locationAlwaysResult = "";

  controlCameraPermission() async {
    var statusCamera = await Permission.camera.status;

    switch (statusCamera) {
      case (PermissionStatus.granted):
        setState(() {
          camResult = "Yetki alindi";
        });
        break;
      case (PermissionStatus.denied):
        setState(() {
          camResult = "Henüz bir yetki verilmedi";
        });
        break;
      case (PermissionStatus.restricted):
        setState(() {
          camResult = "Kisitlanmis yetki, yetkiyi alamazsiniz";
        });
        break;
      case (PermissionStatus.limited):
        setState(() {
          camResult =
              "Kisitlanmis yetki, kullanici tarafindan kisitli yetki seçildi";
        });
        break;
      case (PermissionStatus.permanentlyDenied):
        setState(() {
          camResult = "Yetkiyi reddettiniz";
        });
        break;
      case (PermissionStatus.provisional):
        setState(() {
          camResult = "Provisional";
        });
        break;
    }
  }

  controlLocationPermission() async {
    await Permission.location.onDeniedCallback(() {
      setState(() {
        locationResult = "Konum izni reddedildi";
      });
    }).onGrantedCallback(() async {
      setState(() {
        locationResult = "Konum iznine erişim sağlandi";
      });

      await Permission.locationAlways.onDeniedCallback(() {
        setState(() {
          locationAlwaysResult = "Her zaman için konum yetkisini reddettiniz";
        });
      }).onGrantedCallback(() {
        setState(() {
          locationAlwaysResult = "Her zaman için konum yetkisi verildi";
        });
      }).onPermanentlyDeniedCallback(() {
        setState(() {
          locationAlwaysResult =
              "Her zaman için konum yetkisi kalici olarak reddedildi";
        });
      }).onRestrictedCallback(() {
        setState(() {
          locationAlwaysResult = "Her zaman için konum yetkisi kisitlandi";
        });
      }).onLimitedCallback(() {
        setState(() {
          locationAlwaysResult =
              "Her zaman için konum yetkisine sinirli erişim verildi";
        });
      }).onProvisionalCallback(() {
        setState(() {
          locationAlwaysResult =
              "Her zaman için konum yetkisine geçici erişim verildi";
        });
      }).request();
    }).onPermanentlyDeniedCallback(() {
      setState(() {
        locationResult = "Her zaman için konum yetkisi kalici engellendi";
      });
    }).onRestrictedCallback(() {
      setState(() {
        locationResult = "Konum yetkisi kisitlanmiş, yetki alinamaz";
      });
    }).onLimitedCallback(() {
      setState(() {
        locationResult = "Konum yetkisine sinirli erişim verildi";
      });
    }).onProvisionalCallback(() {
      setState(() {
        locationResult = "Konum yetkisi geçici olarak sağlandi";
      });
    }).request();
  }

  @override
  void initState() {
    super.initState();
    controlCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 248, 248),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          title: Text(
            "Permissions",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            ExpansionTilePermItem(Icons.camera_alt, "Camera", camResult, "",
                () async {
              await Permission.camera.request();
            }),
            ExpansionTilePermItem(Icons.location_on, "Location", locationResult,
                locationAlwaysResult, () {
              controlLocationPermission();
            }),
          ],
        ),
      ),
    );
  }

  Widget ExpansionTilePermItem(IconData icon, String title, String description,
      String description2, Function()? onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ExpansionTile(
        leading: Icon(icon, size: 20, color: Colors.black87),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        collapsedBackgroundColor: Colors.white,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Color.fromARGB(30, 158, 158, 158),
          ),
        ),
        collapsedIconColor: Colors.black87,
        iconColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Color.fromARGB(30, 158, 158, 158),
          ),
        ),
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.only(bottom: 10),
        children: [
          Row(
            children: [
              Gap(25),
              Expanded(
                child: Divider(
                  color: Color.fromARGB(255, 240, 240, 240),
                ),
              ),
              Gap(25),
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                if (description2 != "")
                  Text(
                    description2,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 238, 238),
                  border: Border.all(
                    color: const Color.fromARGB(176, 158, 158, 158),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Text("Yetki Ver", style: TextStyle(
                color: Colors.black87,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
