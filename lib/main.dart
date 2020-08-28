import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'login.dart';
import 'package:dio/dio.dart';


void main() {
  runApp(Login());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
Future<void> getpermi() async{
  var status= await Permission.storage.status;
  if(status.isUndetermined){
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }
  else{
    print('granted');
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FlutterInsta flutterInsta =
  FlutterInsta(); // create instance of FlutterInsta class
  TextEditingController usernameController = TextEditingController();
  TextEditingController reelController = TextEditingController();
  TabController tabController;
  var count=0;
  String username, followers = " ", following, bio, website, profileimage;
  bool pressed = false;
  bool downloading = false;


final url="https://www.instagram.com/p/CAKgXN6gu6o/?utm_source=ig_web_copy_link";

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, initialIndex: 1, length: 2);
    getpermi();
    FlutterDownloader.initialize();
  }



//Future<void> downloadfile() async{
//    Dio dio=new Dio();
//
//    try{
//
//     // var dir= await getExternal;
//      //await dio.download(url, "${dir.path}/img1.jpg",
////          onProgress: (received, total) {
////            if (total != -1) {
////              print((received / total * 100).toStringAsFixed(0) + "%");
////            }
////          }
//     // );
//    }
//    catch(e){
//      print(e);
//    }
//}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: GradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.red, Colors.orange, Colors.yellow]
        ),


        title: const Text('InstaDown'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.person_outline),
            ),
            Tab(
              icon: Icon(Icons.slow_motion_video),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          homePage(), // home screen
          ReelPage()
        ],
      ),
    );
  }

//get data from api
  Future printDetails(String username) async {
    await flutterInsta.getProfileData(username);
    setState(() {
      this.username = usernameController.text; //username
      this.followers = flutterInsta.followers; //number of followers
      this.following = flutterInsta.following; // number of following
      this.website = flutterInsta.website; // bio link
      this.bio = flutterInsta.bio; // Bio
      this.profileimage = flutterInsta.imgurl; // Profile picture URL
      print(followers);
    });
  }

  Widget homePage() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),

        ),
        hintText: 'Enter Username Here',

            ),
              controller: usernameController,
            ),
          ),
          RaisedButton(
            color: Colors.indigo,
            child: Text("Print Details",
            style: TextStyle(
              color: Colors.white
            ),),
            onPressed: () async {
              setState(() {
                pressed = true;
              });
              printDetails(usernameController.text); //get Data
            },
          ),
          pressed
              ? Expanded(
                child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "${profileimage}",
                            width: 120,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          "${username}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${followers}\nFollowers",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "${following}\nFollowing",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          "${bio}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "${website}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ),
          ),
              )
              : Container(),
        ],
      ),
    );
  }

//Reel Downloader page
  Widget ReelPage() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),

                ),
                hintText: 'Enter URL link Here',

              ),
              controller: reelController,
            ),
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              download();
              setState(() {
                downloading = true;
              });
//             final file= download();
//              print(file);
            },
            child: Text("Download",
            style: TextStyle(
              color: Colors.white
            ),),
          ),
//          Padding(
//            padding: const EdgeInsets.all(10.0),
//            child: Container(
//              child: Text(
//                'Video is stored at INTERNAL_STORAGE/ANDROID/DATA/COM.EXAMPLE.INSTADOWN/FILES'
//              ),
//            ),
//          ),


            downloading
                ? Center(
              child:
              CircularProgressIndicator(), //if downloading is true show Progress Indicator
            )
                : Container()


          ],
        ),
      ),
    );
  }

//Download reel video on button clickl
   download() async {

    final file= await getExternalStorageDirectory();
    var myvideourl = await flutterInsta.downloadReels(reelController.text);
   // var myvideourl="https://www.youtube.com/watch?v=LJj77zWMoL0";
    final taskId = await FlutterDownloader.enqueue(
      url: myvideourl,
      savedDir: file.path,
      showNotification: true,
      fileName: "$count.mp4",
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    ).whenComplete(() {
      setState(() {
        //print(file);
        count=count+1;
        downloading = false; // set to false to stop Progress indicator
      });
    });
    //return file;
  }
}

