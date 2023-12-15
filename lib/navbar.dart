import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:trialapk/model.dart';
import 'package:http/http.dart' as http;
import 'package:trialapk/NewsView.dart';
class navi extends StatefulWidget {
  String Query;
  navi({required this.Query}) {}
  @override
  State<navi> createState() => _naviState();
}

class _naviState extends State<navi> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String Url = "";
    if (query == "Top News" || query == "India") {
      Url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=e88d692a64f942e8a720b84e6ee7a9e6";
    } else if(query=="Health"){
      Url =
          "https://newsapi.org/v2/top-headlines?country=in&category=$query&apiKey=e88d692a64f942e8a720b84e6ee7a9e6";
    }
    else{
    Url="https://newsapi.org/v2/everything?q=$query&from=2023-11-11&sortBy=publishedAt&apiKey=e88d692a64f942e8a720b84e6ee7a9e6";
    }
    var Response = await http.get(Uri.parse(Url));
    Map data = jsonDecode(Response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
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
    getNewsByQuery(widget.Query);
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.Query,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child:isLoading
                      ? Container(
                    height: MediaQuery.of(context).size.height - 450,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ): ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => webop(
                                            newsModelList[index].newsUrl)));
                              },
                              child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    newsModelList[index].newsImg,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 230,
                                  ),
                                ),
                                Positioned(
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                      ),
                                      child: Text(
                                        (newsModelList[index]
                                                    .newsHead
                                                    .toString()
                                                    .length >
                                                50)
                                            ? (newsModelList[index]
                                                    .newsHead
                                                    .toString())
                                                .substring(0, 50)
                                            : newsModelList[index]
                                                .newsHead
                                                .toString(),
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ],
                          ),
                        ),
                            ));
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
