import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChampionProvider extends ChangeNotifier {
  List<dynamic> champions = [];
  List<dynamic> filteredChampions = [];
  String selectedRole = 'All';
  Set<String> favoriteChampIds = {};

  ChampionProvider() {
    fetchChampions();
    loadFavorites();
  }

  Future<void> fetchChampions() async {
    const url = 'https://ddragon.leagueoflegends.com/cdn/14.10.1/data/en_US/champion.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      champions = data['data'].values.toList();
      champions.removeWhere((champ) => champ['id'] == 'Caitlyn');
      filteredChampions = List.from(champions);
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favorites') ?? [];
    favoriteChampIds = savedIds.toSet();
    notifyListeners();
  }

  void filterByRole(String role) {
    if (role == 'Favorites') {
      filteredChampions = champions.where((champ) => favoriteChampIds.contains(champ['id'])).toList();
    } else if (role == 'All') {
      filteredChampions = List.from(champions);
    } else {
      filteredChampions = champions.where((champ) => champ['tags'].contains(role)).toList();
    }
    selectedRole = role;
    notifyListeners();
  }

  void toggleFavorite(String champId) async {
    if (favoriteChampIds.contains(champId)) {
      favoriteChampIds.remove(champId);
    } else {
      favoriteChampIds.add(champId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', favoriteChampIds.toList());
  }

  bool isFavorite(String champId) {
    return favoriteChampIds.contains(champId);
  }

  void searchChampions(String query) {
    List<dynamic> baseList;

    if (selectedRole == 'Favorites') {
      baseList = champions.where((champ) => favoriteChampIds.contains(champ['id'])).toList();
    } else if (selectedRole == 'All') {
      baseList = List.from(champions);
    } else {
      baseList = champions.where((champ) => champ['tags'].contains(selectedRole)).toList();
    }

    if (query.isEmpty) {
      filteredChampions = baseList;
    } else {
      filteredChampions = baseList.where((champ) => champ['name'].toLowerCase().contains(query.toLowerCase())).toList();
    }

    notifyListeners();
  }
}
