import 'package:flutter/material.dart';
import 'package:flutter_491/components/post_item.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Jessica's Contribution for App's Tutorial
final GlobalKey bellIconKey = GlobalKey();

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> headlines = [];
  List<String> imageUrls = []; // List to store image URLs
  List<String> descriptions = []; // List to store article descriptions
  List<String> majors = ['Technology', 'Biology', 'Mathematics', 'Physics']; // List of college majors
  String? selectedMajor; // Selected major

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    String apiKey = '29e27534a7ca4ef38be27a8bc075e376';
    String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    // Add the selected major as a query parameter if it is not null
    if (selectedMajor != null) {
      url += '&q=${Uri.encodeComponent(selectedMajor!)}';
    }
    print("Fetching news for URL: $url"); // Print the URL to the console

    final response = await http.get(Uri.parse(url));
    print("Response: ${response.body}"); // Print the response body to the console

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'] as List;
      if (articles.isEmpty) {
        print('No articles found for the selected major');
        setState(() {
          headlines = [];
          imageUrls = [];
          descriptions = [];
        });
      } else {
        setState(() {
          headlines = articles.map((article) => article['title'] as String).toList();
          imageUrls = articles.map((article) => article['urlToImage'] as String? ?? 'https://via.placeholder.com/150').toList();
          descriptions = articles.map((article) => article['description'] as String? ?? 'No description available').toList();
        });
      }
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CSULB News'),
            DropdownButton<String>(
              value: selectedMajor,
              hint: Text('Select Major'),
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMajor = newValue;
                });
                fetchNews(); // Fetch news with the new selected major
              },
              items: majors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            IconButton(
              onPressed: () {
                // Add your navigation logic here
              },
              icon: SvgPicture.asset('assets/svg/Bell.svg'),
            ),
          ],
        ),
      ),
      body: headlines.isNotEmpty
          ? ListView.separated(
        itemBuilder: (context, index) {
          return PostItem(
            heading: headlines[index],
            imageUrl: imageUrls[index],
            description: descriptions[index],
          );
        },
        itemCount: headlines.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 24,
          );
        },
      )
          : Center(
        child: Text('No articles found for the selected major'),
      ),
    );
  }
}
