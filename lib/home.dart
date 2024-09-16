import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final apikey = 'JC5548g3cq4z043hwqq1WDj2lLgEPfXO8kXS0Kqk';
  Future<String> fetchImagesUrl() async {
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$apikey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to load APOD');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa APOD'),
      ),
      body: FutureBuilder<String>(
        future: fetchImagesUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // Once data is available, display the image
            return Center(
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          } else {
            // In case of no data or unexpected conditions
            return const Center(child: Text('No image available'));
          }
        },
      ),
    );
  }
}
