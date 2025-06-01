import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../../providers/CategoryProvider.dart';
import '../../providers/AuthProvider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/search.dart';
import 'CategoryDetail.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<void> _fetchFuture;

  @override
  void initState() {
    super.initState();
    _fetchFuture = Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final userPhoto = authProvider.userData?['photo'];

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              foregroundImage: (userPhoto != null && userPhoto.isNotEmpty && userPhoto.startsWith('http'))
                  ? NetworkImage(userPhoto)
                  : const AssetImage('assets/Profile.png') as ImageProvider,
              child: (userPhoto == null || userPhoto.isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            AppConstants.Width(width / 50),
            Text(
              "Categorías",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 20,
                fontFamily: "Ariom-Bold",
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              "assets/notification.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 50),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Search(),
                ),
              );
            },
            child: Image.asset(
              "assets/Search.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 50),
        ],
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: notifier.buttonColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar categorías",
                style: TextStyle(color: notifier.textColor),
              ),
            );
          }

          final categories = categoryProvider.categories;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width / 20,
              vertical: height / 40,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetail(
                          categoryId: category['id'],
                          categoryTitle: category['title'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: notifier.buttonColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: category['svgContent'] != null &&
                              category['svgContent'].toString().trim().isNotEmpty
                              ? SvgPicture.network(
                            category['svgContent'],
                            height: 40,
                            width: 40,
                            color: notifier.svgColor,
                            placeholderBuilder: (context) =>
                                Icon(Icons.image, color: notifier.textColor),
                          )
                              : Icon(Icons.image_not_supported, color: notifier.textColor),
                        )
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Ariom-Bold",
                          color: notifier.textColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
