import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/models/wallpaper_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_hub/screens/search.dart';
import 'package:wallpaper_hub/widgets/widget.dart';


class Category extends StatefulWidget {

  final String categoryName;

  Category({@required this.categoryName});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  getCategoryWallpapers(String searchQuery) async {

    var url = Uri.parse("https://api.pexels.com/v1/search?query=$searchQuery&per_page=30&page=1");

    await http.get(url,
        headers: {
          "Authorization": apiKey
        }).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        WallpaperModel wallpaperModel = new WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });

      setState(() {});
    });
  }


  @override
  void initState() {
    getCategoryWallpapers(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(right: 52.0),
          child: brandName(),
        ),
        elevation: 0.0,
        centerTitle: false,
        //leadingWidth: 0.0, //to get the name in center
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(32),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "search wallpapers",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Search(searchQuery: searchController.text,)
                        )
                        );
                      },
                      child: Container(child: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              wallpapersList(wallpapers, context),
            ],
          ),
        ),
      ),
    );
  }
}
