import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_reader/app/widgets/dateformat_util.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/news_model.dart';
import '../../../theme/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  final Articles newsItem;

  const NewsDetailView({super.key, required this.newsItem});

  Future<void> _launchInAppBrowser() async {
    final Uri uri = Uri.parse(newsItem.url!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView, // Ensure in-app browser mode
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } else {
      Get.snackbar(
        'Error',
        'Could not launch URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to share the news link
  void _shareNews() {
    Share.share(
      'Check out this news article: ${newsItem.title}\n\nRead more: ${newsItem.url}',
      subject: newsItem.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("${newsItem.content!}");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                newsItem.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
                overflow: TextOverflow.visible,
              ),
              background: GestureDetector(
                onTap: (){
                  showImageViewer(
                    context,
                    Image.network(newsItem.urlToImage!).image,
                    useSafeArea: true,
                    swipeDismissible: true,
                    doubleTapZoomable: true,
                  );

                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'news_image_${newsItem.title}',
                      child: newsItem.urlToImage == null ||
                              newsItem.urlToImage!.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 50,
                              ),
                            )
                          : CachedNetworkImage(
                            imageUrl: newsItem.urlToImage!,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.background,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding:
              const EdgeInsets.only(left: 50, bottom: 16, right: 16),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article Metadata with Enhanced Design
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Author Chip with Icon
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: AppColors.accent, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                newsItem.author!.split(',').first,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Formatted Date
                        Text(
                          '${DateFormatUtil.formatNewsDate(newsItem.publishedAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      newsItem.description!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      newsItem.content!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Action Buttons with Modern Design
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Read in App Button with Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent,
                                AppColors.accent.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _launchInAppBrowser,
                            icon: const Icon(Icons.open_in_browser, color: Colors.white,),
                            label:  Text('Read in App', style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.accent,
                            size: 28,
                          ),
                          onPressed: () => _shareNews(),
                        )
                            .animate(
                                onPlay: (controller) => controller.repeat())
                            .shake(duration: 2000.ms),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
