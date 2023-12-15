class NewsQueryModel {
  late String newsHead;
  late String newsDesc;
  late String newsUrl;
  late String newsImg;
  NewsQueryModel(
      {this.newsHead = "",
      this.newsDesc = "",
      this.newsImg = "",
      this.newsUrl = ""});
  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsHead: news?["title"] ??= "",
      newsDesc: news?["description"] ??= "",
      newsImg: news?["urlToImage"] ??= "",
      newsUrl: news?["url"] ??= "",
    );
  }
}
