import 'package:flutter/material.dart';
import 'package:newsapp/models/newsinfo.dart';
import 'package:newsapp/services/api_manager.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<NewsModel> _newsModel;
  @override
  void initState() {
    _newsModel = API_MANAGER().getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<NewsModel>(
            future: _newsModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data!.articles.length,
                    itemBuilder: (context, index) {
                      var article = data.articles[index];
                      return GestureDetector(
                        onTap: () {
                          print("tapped: " + index.toString());
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(article.title),
                                            Text(article.description),
                                          ])),
                                );
                              });
                        },
                        child: Container(
                          height: 100,
                          child: ListTile(
                            // ignore: unnecessary_null_comparison
                            leading: article.urlToImage == null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blue,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(
                                          article.urlToImage,
                                          fit: BoxFit.cover,
                                        ))),
                            title: Text(
                              article.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(article.author == null
                                ? " " + article.source.name
                                : article.author + " " + article.source.name),
                          ),
                        ),
                      );
                    });
              } else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
