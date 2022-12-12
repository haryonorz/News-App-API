import 'dart:async';

import '../data/api/api_service.dart';
import '../data/model/article.dart';
import 'package:flutter/material.dart';

// Enum ResultState bertugas untuk mengatur setiap proses yang akan dijalankan
// di dalam fungsi _fetchAllArticle(). Sehingga, kita dapat dengan mudah untuk
// menampilkan widget apa saja ketika state sedang dalam keadaan loading,
// noData, hasData, ataupun error.
enum ResultState { loading, noData, hasData, error }

class NewsProvider extends ChangeNotifier {
  final ApiService apiService;

  // fungsi _fetchAllArticle() juga merupakan sebuah fungsi yang bersifat private.
  // Artinya, fungsi ini hanya dapat diakses di dalam kelas NewsProvider saja.
  // Lantas bagaimana jika kita ingin menggunakan kelas ini beserta fungsinya
  // karena kebutuhan untuk mengakses data tersebut? Jawabannya, Anda bisa
  // memanggil fungsi tersebut di dalam constructor dari kelas NewsProvider.
  NewsProvider({required this.apiService}) {
    _fetchAllArticle();
  }

  // Kemudian karena semua inisiasi variabel pada kelas ini bersifat private
  // dengan adanya tanda _ (underscore) pada setiap awalan nama variabel, di sini
  // kita menggunakan getter untuk dapat mengakses variabel private tersebut
  // ketika akan digunakan di luar kelas NewsProvider.
  late ArticlesResult _articlesResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ArticlesResult get result => _articlesResult;

  ResultState get state => _state;

  // fungsi _fetchAllArticle() mengembalikan nilai dynamic. Artinya, data
  // yang akan dikeluarkan oleh fungsi tersebut bersifat dinamis, bisa objek,
  // tipe data, atau yang lainnya.
  // Mengapa harus dynamic? Kita bisa lihat di dalam fungsi tersebut
  // mengembalikan dua jenis data, yang pertama adalah String yang diwakilkan
  // oleh variabel _message, dan yang kedua adalah model hasil dari proses
  // apiService.topHeadlines() yang diwakilkan oleh variabel _articlesResult.
  Future<dynamic> _fetchAllArticle() async {
    // Kemudian di dalam fungsi ini juga kita melihat terdapat fungsi notifyListeners()
    // dipanggil sebanyak empat kali didalam try, if, else, dan catch.
    // notifyListeners() dapat kita gunakan karena kelas NewsProvider merupakan
    // turunan dari kelas ChangeNotifier. Kemudian fungsi notifyListeners()
    // bertugas layaknya seperti setState() pada kelas yang turunan dari
    // kelas StatefulWidget. Hal ini karena fungsi tersebut bertugas untuk
    // melakukan perubahan state secara real time di dalam fungsi _fetchAllArticle(),
    // sehingga kelas enum dapat berubah-ubah state-nya dari loading, noData,
    // hasData, atau error tergantung dari response API-nya seperti apa.
    try {
      _state = ResultState.loading;
      notifyListeners();
      final article = await apiService.topHeadlines();
      if (article.articles.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _articlesResult = article;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
