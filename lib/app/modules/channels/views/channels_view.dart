import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_reader/app/data/models/sources_model.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/channels_controller.dart';
import 'details_screen_channel.dart';
import 'news_list_channel.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (controller.soucesListSport.isEmpty &&
                  controller.soucesListBusiness.isEmpty &&
                  controller.soucesListGeneral.isEmpty &&
                  controller.soucesListTechnology.isEmpty &&
                  controller.soucesListScience.isEmpty &&
                  controller.soucesListEntertainment.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '🚫 API limit reached! Please try again later.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Visibility(
                      visible: controller.soucesListSport.isNotEmpty,
                      child: _buildChannelSection(
                          'Sports Channels', controller.soucesListSport),
                    ),
                    Visibility(
                      visible: controller.soucesListBusiness.isNotEmpty,
                      child: _buildChannelSection(
                          'Business Channels', controller.soucesListBusiness),
                    ),
                    Visibility(
                      visible: controller.soucesListGeneral.isNotEmpty,
                      child: _buildChannelSection(
                          'General Channels', controller.soucesListGeneral),
                    ),
                    Visibility(
                      visible: controller.soucesListTechnology.isNotEmpty,
                      child: _buildChannelSection('Technology Channels',
                          controller.soucesListTechnology),
                    ),
                    Visibility(
                      visible: controller.soucesListScience.isNotEmpty,
                      child: _buildChannelSection(
                          'Science Channels', controller.soucesListScience),
                    ),
                    Visibility(
                      visible: controller.soucesListEntertainment.isNotEmpty,
                      child: _buildChannelSection('Entertainment Channels',
                          controller.soucesListEntertainment),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 270.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'News Channels',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black45,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Animation
                Lottie.asset(
                  'assets/1735148202050.json', // Replace with your Lottie file path
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                  repeat: true,
                  animate: true,
                ),

                Text(
                  'Discover Your News Sources',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelCard(BuildContext context, SourceModel? source,
      {bool isLoading = false}) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 150, // Reduced width
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }

    if (source == null) {
      return Container();
    }

    return GestureDetector(
      onLongPress: () {
        Get.to(() => SourceDetailsScreen(
              source: source,
            ));
      },
      onTap: () {
        Get.to(() => NewsListDomain(
              domain: source.id!,
            ));
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 6,
          shadowColor: Colors.blue.shade200.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.blue.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.blue.shade100,
                          Colors.blue.shade200,
                        ],
                        center: Alignment.center,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade300.withOpacity(0.4),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        source.name![0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue.shade900,
                          shadows: [
                            Shadow(
                              blurRadius: 6.0,
                              color: Colors.blue.shade200,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    source.name!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelSection(String title, List<SourceModel> sources) {
    final isLoading = controller.isLoading.value;
    final hasSources = sources.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20, // Slightly smaller title
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 140, // Reduced height to match smaller card
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 6 : sources.length,
              itemBuilder: (context, index) {
                if (isLoading || !hasSources) {
                  return _buildChannelCard(context, null, isLoading: true);
                }
                final source = sources[index];
                return _buildChannelCard(context, source);
              },
            ),
          ),
        ],
      ),
    );
  }
}
