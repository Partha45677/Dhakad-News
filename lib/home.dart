import 'dart:convert';
import 'package:trialapk/NewsView.dart';
import 'package:trialapk/navbar.dart';
import 'package:trialapk/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Top News",
    "India",
    "World",
    "Finacnce",
    "Health"
  ];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2023-11-11&sortBy=publishedAt&apiKey=e88d692a64f942e8a720b84e6ee7a9e6";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;

          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });

          if (i == 5) {
            break;
          }
        } catch (e) {
          print(e);
        }
        ;
      }
    });
  }

  getNewsofIndia(String provide) async {
    String url =
        "https://newsapi.org/v2/everything?q=$provide&from=2023-11-11&sortBy=publishedAt&apiKey=e88d692a64f942e8a720b84e6ee7a9e6";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("india");
    getNewsofIndia("ipl 2024");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DHAKAD NEWS",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.black26, borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    navi(Query: searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value == "") {
                          print("BLANK SEARCH");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => navi(Query: value)));
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search Health"),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      navi(Query: navBarItem[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    })),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: isLoading
                  ? Container(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()))
                  : CarouselSlider(
                      options: CarouselOptions(
                          height: 200, autoPlay: true, enlargeCenterPage: true),
                      items: newsModelListCarousel.map((instance) {
                        return Builder(builder: (BuildContext context) {
                          try {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            webop(instance.newsUrl)));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          instance.newsImg,
                                          fit: BoxFit.fitHeight,
                                          width: double.infinity,
                                        )),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    instance.newsHead,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                        )),
                                  ])),
                            ));
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        });
                      }).toList(),
                    ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "LATEST NEWS: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Container(
                          height: MediaQuery.of(context).size.height - 450,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsModelList.length,
                          itemBuilder: (context, index) {
                            try {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => webop(
                                                newsModelList[index].newsUrl)));
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 1.0,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                newsModelList[index].newsImg,
                                                fit: BoxFit.fitHeight,
                                                height: 230,
                                                width: double.infinity,
                                              )),
                                          Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black12
                                                                .withOpacity(0),
                                                            Colors.black
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter)),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 15, 10, 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        newsModelList[index]
                                                            .newsHead,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        newsModelList[index]
                                                                    .newsDesc
                                                                    .length >
                                                                50
                                                            ? "${newsModelList[index].newsDesc.substring(0, 55)}...."
                                                            : newsModelList[
                                                                    index]
                                                                .newsDesc,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      )),
                                ),
                              );
                            } catch (e) {
                              print(e);
                              return Container();
                            }
                          }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Set the background color
                              onPrimary: Colors.white, // Set the text color
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          navi(Query: "Technology")));
                            },
                            child: Text("SHOW MORE")),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}