import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_reader/app/modules/home/views/news_detail_view.dart';
import 'package:shimmer/shimmer.dart';
import '../data/models/news_model.dart';
import 'dateformat_util.dart';

class StylishNewsCard extends StatelessWidget {
  final Articles newsItem;
  final bool isCarousel;

  const StylishNewsCard(
      {super.key, required this.newsItem, required this.isCarousel});

  @override
  Widget build(BuildContext context) {
    final double imageAspectRatio = isCarousel ? 13 / 6 : 16 / 4;
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: theme.cardColor,
          child: InkWell(
            splashColor: theme.colorScheme.secondary.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondary.withOpacity(0.1),
            onTap: () {
              Get.to(() => NewsDetailView(newsItem: newsItem));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: imageAspectRatio,
                      child: newsItem.urlToImage == null ||
                              newsItem.urlToImage!.isEmpty
                          ? _buildPlaceholderImage()
                          : _buildNetworkImage(),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              theme.colorScheme.surface.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        newsItem.title ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !isCarousel,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsItem.description ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSourceChip(theme),
                              _buildDatePill(theme),
                            ],
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
      ),
    ).animate(
      delay: 100.ms,
      effects: [
        FadeEffect(duration: 400.ms),
        ScaleEffect(begin: const Offset(0.95, 0.95)),
        SlideEffect(begin: const Offset(0, 0.05)),
      ],
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: newsItem.urlToImage!,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildImagePlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholderImage(),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: CircularProgressIndicator(
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              color: Colors.grey[400],
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              'Image Not Available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.source_outlined,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 6),
          Text(
            "${newsItem.source?.name!.split(',').first}" ?? 'Unknown',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePill(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 6),
          Text(
            DateFormatUtil.formatNewsDate(newsItem.publishedAt),
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
