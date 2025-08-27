import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/champion_provider.dart';
import '../screens/champ_detail.dart';

class ChampionGridItem extends StatelessWidget {
  final dynamic champ;

  const ChampionGridItem({super.key, required this.champ});

  @override
  Widget build(BuildContext context) {
    final champId = champ['id'];
    final champName = champ['name'];
    final imageUrl = 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/$champId.png';

    final winrate = 'N/A';
    final tier = 'Unknown';

    final provider = Provider.of<ChampionProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChampionDetailsScreen(champId: champId, champName: champName),
          ),
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 2),
              Text(champName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Winrate: $winrate%", style: const TextStyle(fontSize: 10)),
              Text("Tier: $tier", style: const TextStyle(fontSize: 10)),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(
                provider.isFavorite(champId) ? Icons.favorite : Icons.favorite_border,
                color: provider.isFavorite(champId) ? Colors.red : Colors.grey,
                size: 20,
              ),
              onPressed: () {
                provider.toggleFavorite(champId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
