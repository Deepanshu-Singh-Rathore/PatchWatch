import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/champion_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/champion_grid_item.dart';
import 'patch_screen.dart';

class ChampionOverviewScreen extends StatefulWidget {
  const ChampionOverviewScreen({super.key});

  @override
  State<ChampionOverviewScreen> createState() => _ChampionOverviewScreenState();
}

class _ChampionOverviewScreenState extends State<ChampionOverviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> roles = ['All', 'Favorites', 'Fighter', 'Tank', 'Mage', 'Assassin', 'Marksman', 'Support'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChampionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PatchWatch - Champions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PatchNotesScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search champions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                Provider.of<ChampionProvider>(context, listen: false).searchChampions(value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: roles.map((role) {
                final isSelected = provider.selectedRole == role;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(role),
                    selected: isSelected,
                    onSelected: (_) {
                      Provider.of<ChampionProvider>(context, listen: false).filterByRole(role);
                      Provider.of<ChampionProvider>(context, listen: false).searchChampions(_searchController.text);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: provider.champions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: provider.filteredChampions.length,
                    itemBuilder: (context, index) {
                      final champ = provider.filteredChampions[index];
                      return ChampionGridItem(champ: champ);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
