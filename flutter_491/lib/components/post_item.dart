import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';

enum NewsMenu {
  option,
  report,
}

class PostItem extends StatelessWidget {
  final String heading;
  final String imageUrl;
  final String description;
  final String articleLink;  // URL to the article
  final GlobalKey? bookmarkIconKey;
  final GlobalKey? shareIconKey;
  final GlobalKey? optionsMenuKey;

  const PostItem({
    super.key,
    required this.heading,
    required this.imageUrl,
    required this.description,
    required this.articleLink, // Pass the article link
    this.bookmarkIconKey,
    this.shareIconKey,
    this.optionsMenuKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
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
              IconButton(
                icon: Icon(Icons.bookmark),
                color: AppColors.darkblue,
                onPressed: () {
                  // Bookmark logic here
                },
                key: bookmarkIconKey,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.share),
                color: AppColors.darkblue,
                onPressed: () {
                  // Share logic here
                },
                key: shareIconKey,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.link),
                color: AppColors.darkblue,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: articleLink)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link copied to clipboard'))
                    );
                  });
                },
              ),
              const SizedBox(width: 12),
              PopupMenuButton<NewsMenu>(
                onSelected: (value) {
                  switch (value) {
                    case NewsMenu.option:
                    // Add options logic here
                      break;
                    case NewsMenu.report:
                    // Add report logic here
                      print('Report clicked');
                      break;
                  }
                },
                key: optionsMenuKey,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: NewsMenu.option,
                      child: Text('Options'),
                    ),
                    const PopupMenuItem(
                      value: NewsMenu.report,
                      child: Text('Report'),
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
