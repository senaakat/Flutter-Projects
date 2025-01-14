import 'package:flutter/material.dart';
import 'package:flutter_project/Duyurular/home.dart';
import 'package:flutter_project/Duyurular/models/liste_model.dart';
import 'package:flutter_project/Duyurular/models/liste.dart';

class SecondHomePage extends StatefulWidget {
  final News shpage;

  SecondHomePage({required this.shpage});

  @override
  State<SecondHomePage> createState() => _SecondHomePageState();
}

class _SecondHomePageState extends State<SecondHomePage> {
  late News currentNews; // Burada tılanılan haber tutulacak.News türünde bir nesne.
//late dart dilinde başlangıç değeri belli bir süre sonra atanacak değişkenler için kullanılır.
  List<News> listeNews = listem.newsList;
  @override
  void initState() {
    super.initState();
    currentNews = widget.shpage; // Başlangıçta widget'ın aldığı haberle başlatılır.
  }

  void updateNews(News news) {
    setState(() {
      currentNews = news; // Yeni bir haber geldiğinde güncellenir.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Duyurular()));
              },
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                currentNews.image,
                fit: BoxFit.cover,
              ),
              title: Align(
                alignment: Alignment.bottomLeft, // Container'ı alt sol köşeye hizala
                child: Container(
                  child: Text(
                    currentNews.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Tıklama olunca haber güncellenir.
                    updateNews(listeNews[index]);
                  },
                  child: Container(),
                );
              },
              childCount: listeNews.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  height: 600,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentNews.text,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
