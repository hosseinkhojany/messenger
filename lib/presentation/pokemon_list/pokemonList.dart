import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:telegram_flutter/common/utils/consts.dart';
import 'package:telegram_flutter/domain/controller/pokemonController.dart';
import 'package:telegram_flutter/data/models/pokemon.dart';
import 'package:telegram_flutter/common/utils/paletteUtil.dart';

class PokemonListScreen extends StatefulWidget {
  final PokemonController _controller;

  const PokemonListScreen(this._controller, {Key? key}) : super(key: key);

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset("assets/images/ic_icon.png"),
        ),
        title: const Text("Pokedex Flutter"),
      ),
      body: Obx(
        () {
          switch (widget._controller.requestStateListPokemon.value) {
            case RequestState.LOADING:
              if (widget._controller.pokemons.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: SizedBox(
                        height: 20,
                        child: Center(
                          child: Stack(
                            children: const [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Loading..."),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
                return _mainContent();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            case RequestState.ERROR:
              if (widget._controller.pokemons.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("failed to load more pokemons"),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () =>
                                    {widget._controller.loadNextPage()},
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
                return _mainContent();
              } else {
                return Center(
                  child: IconButton(
                    tooltip: "retry",
                    icon: const Icon(Icons.refresh_outlined),
                    onPressed: () => {
                      widget._controller.loadNextPage(true),
                    },
                  ),
                );
              }
            default:
              return _mainContent();
          }
        },
      ),
    );
  }

  Widget _mainContent() {
    return LazyLoadScrollView(
      onEndOfPage: widget._controller.loadNextPage,
      isLoading: widget._controller.lastPage,
      child: ResponsiveGridList(
        horizontalGridMargin: 10,
        verticalGridMargin: 10,
        minItemWidth: 150,
        children: List.generate(
          widget._controller.pokemons.length,
          (index) {
            final pokemon = widget._controller.pokemons[index];

            return FutureBuilder<PaletteGenerator>(
              future: PaletteUtil.updatePaletteGenerator(pokemon.getImage()),
              builder: (context, snapshot) {
                if (pokemon.color != Colors.black12.value) {
                  return _PokemonItem(
                      pokemon: pokemon, dominantColor: Color(pokemon.color));
                } else {
                  PokemonController controller = Get.find();
                  var dominantColor = snapshot.data?.dominantColor?.color ??
                      Color(pokemon.color);
                  controller.updatePokemonColor(
                      pokemon.page, pokemon.name, dominantColor.value);
                  return _PokemonItem(
                      pokemon: pokemon, dominantColor: dominantColor);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _PokemonItem extends StatelessWidget {
  const _PokemonItem({
    Key? key,
    required this.pokemon,
    required this.dominantColor,
  }) : super(key: key);

  final Pokemon pokemon;
  final Color dominantColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
            width: 160,
            height: 210,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(pokemon.color).withOpacity(0.6),
                blurRadius: 15,
              )
            ])),
        Card(
          color: Colors.black12,
          elevation: 5,
          shadowColor: Color(pokemon.color).withOpacity(0.6),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 150,
            height: 200,
            color: dominantColor.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: pokemon.getImage(),
                      width: 90,
                      placeholder: (context, url) {
                        return Center(
                          child: SkeletonGridLoader(
                            builder: SingleChildScrollView(
                              child: GridTile(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("assets/images/pokemon.png"),
                                  ],
                                ),
                              ),
                            ),
                            items: 1,
                            itemsPerRow: 1,
                            period: const Duration(milliseconds: 2500),
                            baseColor: Color(pokemon.color).withOpacity(0.1),
                            highlightColor: Colors.black26,
                            direction: SkeletonDirection.ltr,
                            childAspectRatio: 1,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            pokemon.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.surface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
