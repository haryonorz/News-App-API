import 'package:provider/provider.dart';

import '../provider/news_provider.dart';
import '../widgets/card_article.dart';
import '../widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  Widget _buildList() {
    // widget Consumer yang merupakan bagian dari package provider.
    // Artinya, setiap ada perubahan di dalam kelas NewsProvider berupa state
    // dari kelas enum ResultState atau bahkan data yang akan dikeluarkan akan
    // ditampung oleh variabel state.
    return Consumer<NewsProvider>(
      builder: (context, state, _) {
        // Kemudian kita juga menggunakan if statement untuk mengecek state dari
        // kelas enum yang didapatkan berada di posisi apa. Apakah loading, noData,
        // hasData, error, atau bahkan tidak masuk state sama sekali.
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          // menggunakan widget ListView.builder karena data yang didapatkan
          // bersifat dinamis. Kemudian di dalam widget tersebut kita melakukan
          // looping untuk menampilkan masing-masing item data kedalam sebuah
          // widget yang sudah kita buat sebelumnya yaitu widget CardArticle.
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.articles.length,
            itemBuilder: (context, index) {
              var article = state.result.articles[index];
              return CardArticle(article: article);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('News App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
