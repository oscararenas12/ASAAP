import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';

//THIS PAGE IS FOR STYLING THE NEWSFEED

enum NewsMenu {
  option,
  report,
}

class PostItem extends StatelessWidget {
  final String heading;
  final String imageUrl;
  final String description;
  final GlobalKey? bookmarkIconKey;
  final GlobalKey? shareIconKey;
  final GlobalKey? optionsMenuKey;

  const PostItem({super.key, required this.heading, required this.imageUrl, required this.description, this.bookmarkIconKey, this.shareIconKey, this.optionsMenuKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              // User icon
              Image.asset(
                'assets/temp/User Icon.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  heading,
                  style: AppText.header1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            description,
            style: AppText.subtitle1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                key: bookmarkIconKey,
                Icons.bookmark,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              Icon(
                key: shareIconKey,
                Icons.share,
                size: 22,
                color: Colors.white,
              ),
              PopupMenuButton<NewsMenu>(
                onSelected: (value) {
                  switch (value) {
                    case NewsMenu.option:
                    //Navigator.of(context).pushNamed(AppRoutes.'edit_profile');
                      break;
                    case NewsMenu.report:
                      print('report');
                      break;
                    default:
                  }
                },
                key: optionsMenuKey,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: NewsMenu.option,
                      child: Text('options'),
                    ),
                    const PopupMenuItem(
                      value: NewsMenu.report,
                      child: Text('report'),
                    ),
                  ];
                },
              ),
            ],
          ),
          const Divider(
            color: AppColors.darkblue,
            thickness: 1,
            height: 10,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }
}
