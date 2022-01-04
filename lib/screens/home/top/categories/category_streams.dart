import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/screens/home/stores/list_store.dart';
import 'package:frosty/screens/settings/stores/settings_store.dart';
import 'package:frosty/widgets/stream_card.dart';
import 'package:provider/provider.dart';

class CategoryStreams extends StatelessWidget {
  final ListStore store;

  const CategoryStreams({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: store.refreshStreams,
        child: Observer(
          builder: (context) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  stretch: true,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height / 3,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      store.categoryInfo!.name,
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: CachedNetworkImage(
                      imageUrl: store.categoryInfo!.boxArtUrl.replaceRange(store.categoryInfo!.boxArtUrl.lastIndexOf('-') + 1, null, '300x400.jpg'),
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index > store.streams.length / 2 && store.hasMore) {
                        store.getStreams();
                      }
                      return Observer(
                        builder: (context) => StreamCard(
                          streamInfo: store.streams[index],
                          showUptime: context.read<SettingsStore>().showThumbnailUptime,
                        ),
                      );
                    },
                    childCount: store.streams.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
