import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/models/categories_model.dart';
import 'package:wallpaper_hub/models/wallpaper_model.dart';
import 'package:wallpaper_hub/screens/image_view.dart';
import 'package:wallpaper_hub/screens/search.dart';
import 'package:wallpaper_hub/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'categories.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoriesModel> categories = new List();

  List<WallpaperModel> wallpapers = new List();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    await http.get( Uri.parse('https://api.pexels.com/v1/curated?per_page=20&page=1'),
        headers: {"Authorization": apiKey}).then((value) {
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
  } //getTrendingWallpapers

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
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
                          hintText: "Search wallpapers",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Search(searchQuery: searchController.text,)
                        )
                        );
                      },
                      child: Container(
                          child: Icon(Icons.search)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                height: 75,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                        title: categories[index].categoryName,
                        imgUrl: categories[index].imgUrl,
                      );
                    }),
              ),
              SizedBox(height: 16,),
              wallpapersList(wallpapers, context)
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;

  CategoriesTile({@required this.imgUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Category(
              categoryName: title.toLowerCase(),
            )
        )
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 6),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imgUrl,
                  height: 50, width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black26,
              ),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(title,
                style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 16,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
