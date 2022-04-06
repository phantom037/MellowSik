import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Song.dart';

class SongApi {
  static Future<List<Song>> getSongs(String query) async {
    final url = Uri.parse('https://dlmocha.com/app/mellowsik.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List songs = json.decode(response.body);

      return songs.map((json) => Song.fromJson(json)).where((element) {
        final titleLower = element.title.toLowerCase();
        final singerLower = element.singer.toLowerCase();
        final coverLower = element.cover.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            singerLower.contains(searchLower) ||
            coverLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception('Failed to load song');
    }
  }
}
