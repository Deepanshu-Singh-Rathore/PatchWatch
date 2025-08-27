import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChampionDetailsScreen extends StatefulWidget {
  final String champId;
  final String champName;

  const ChampionDetailsScreen({super.key, required this.champId, required this.champName});

  @override
  State<ChampionDetailsScreen> createState() => _ChampionDetailsScreenState();
}

class _ChampionDetailsScreenState extends State<ChampionDetailsScreen> {
  Map<String, dynamic>? champData;

  @override
  void initState() {
    super.initState();
    fetchChampionDetails();
  }

  Future<void> fetchChampionDetails() async {
    final url = 'https://ddragon.leagueoflegends.com/cdn/14.10.1/data/en_US/champion/${widget.champId}.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        champData = data['data'][widget.champId];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (champData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lore = champData!['lore'];
    final stats = champData!['stats'];
    final spells = champData!['spells'];
    final passive = champData!['passive'];

    final splashUrl = 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${widget.champId}_0.jpg';

    return Scaffold(
      appBar: AppBar(title: Text(widget.champName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(splashUrl),
            const SizedBox(height: 12),
            Text(lore, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Text('Stats', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('HP: ${stats['hp']}, Attack: ${stats['attackdamage']}, Armor: ${stats['armor']}'),
            const SizedBox(height: 12),
            Text('Abilities', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Passive: ${passive['name']} - ${passive['description']}'),
            const SizedBox(height: 8),
            ...spells.map<Widget>((spell) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${spell['name']} - ${spell['description']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
