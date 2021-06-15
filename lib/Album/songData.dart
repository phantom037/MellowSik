import 'package:http/http.dart' as http;
import 'dart:convert';

class Music {
  var url = Uri.parse('https://acrosshorizon.github.io/palpitate/');
  List _musicList = [
    {
      'title': "Test Sound",
      'singer': "Unknown Singer",
      'url':
          "https://assets.mixkit.co/sfx/preview/mixkit-cinematic-transition-swoosh-heartbeat-trailer-488.mp3",
      'coverUrl':
          "https://i.pinimg.com/564x/cf/33/d9/cf33d9624b0ed323173aec4ee1d05d40.jpg",
      'info':
          "https://www.youtube.com/watch?v=tSc8WROtNfc&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=12",
      'cover': ""
    },
    {
      'title': "Always",
      'singer': "Peder B. Helland",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/Peder%20B.%20Helland%20-%20Always.mp3?raw=true",
      'coverUrl':
          "https://i1.sndcdn.com/artworks-000303703578-zrcifi-t500x500.jpg",
      'info':
          "https://www.youtube.com/watch?v=tSc8WROtNfc&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=12",
      'cover': ""
    },
    {
      'title': "River Flows in You",
      'singer': "Yiruma",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/River%20Flows%20in%20You%20-%20Cello%20David%20Solis.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/f9/53/eb/f953eb8ec99da80bf5f9f07f3a27ec9b.jpg",
      'info':
          "https://www.youtube.com/watch?v=UVUwqxuDb9A&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=15",
      'cover': "(Cello Cover - David Solis)"
    },
    {
      'title': "Lemon",
      'singer': "Kenshi Yonezu",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/Lemon%20-%20Kenshi%20Yonezu%20Music%20Box%20Cover.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/15/93/ed/1593ed12f2315a66b9552da96c5d3cda.jpg",
      'info':
          "https://www.youtube.com/watch?v=LdYB-YoAOjc&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=4",
      'cover': ""
    },
    {
      'title': "Fox Rain",
      'singer': "Lee Sun Hee",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/Fox%20RainLee%20Sun%20Hee%20%5BMusic%20Box%5D.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/originals/d9/a7/b2/d9a7b22102edfc88bb79eb63fb1d8b38.jpg",
      'info':
          "https://www.youtube.com/watch?v=A_WHcuoxCj8&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=9",
      'cover': "(Music Box by R3 Music)"
    },
    {
      'title': "Silent Descent",
      'singer': "Eugenio Mininni",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-silent-descent-614.mp3",
      'coverUrl':
          "https://i.pinimg.com/564x/0c/df/b7/0cdfb7cd10cbea4affbc7ca289967cff.jpg",
      'info': "https://mixkit.co/free-stock-music/",
      'cover': ""
    },
    {
      'title': "GUMI",
      'singer': "Hoshi Ai",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/GUMI%20-%20Hoshi%20Ai%20Music%20Box.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/4b/00/65/4b0065c9fd27d0ee873069776a8f079c.jpg",
      'info':
          "https://www.youtube.com/watch?v=t-DEjAzPzeA&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=2",
      'cover': ""
    },
    {
      'title': "Memories",
      'singer': "Maroon 5",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/Maroon%205%20-%20Memories.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/474x/29/18/62/291862dab6db10ae7f276fefcc5537a8.jpg",
      'info':
          "https://www.youtube.com/watch?v=NRWfEu3JRcc&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=3",
      'cover': "(Music box Cover)"
    },
    {
      'title': "Uchiage Hanabi",
      'singer': "Daoko and Kenshi Yonezu",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/Uchiage%20Hanabi%20Music%20Box%20Cover.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/16/b7/11/16b711608d72dd16e1662944726ea428.jpg",
      'info':
          "https://www.youtube.com/watch?v=S8vyJMsXTXA&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=1",
      'cover': "(Cover by Flow Music)"
    },
    {
      'title': "Something Just Like This",
      'singer': "The Chainsmokers & Coldplay",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/Something%20Just%20Like%20This%20Costantino%20Carrara.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/58/f7/57/58f7574ae79bb56e617eff02a5ce0d03.jpg",
      'info':
          "https://www.youtube.com/watch?v=6wFJhmhNeeg&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=11",
      'cover': "(Cover by Costantino Carrara)"
    },
    {
      'title': "Piano Reflections",
      'singer': "Ahjay Stelino",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-piano-reflections-22.mp3",
      'coverUrl':
          "https://i.pinimg.com/564x/6d/1c/57/6d1c576c102aeacb7f2794594284174b.jpg",
      'info': "https://mixkit.co/free-stock-music/",
      'cover': ""
    },
    {
      'title': "You Dian Tian",
      'singer': "Silence Wang",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Guitar/YouDianTian.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/c5/36/be/c536be2d9619871fce706d356c16fc92.jpg",
      'info':
          "https://www.youtube.com/watch?v=kQWyZtvcrOU&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=17",
      'cover': "(Guitar Cover By ครูโก้ GTC)"
    },
    {
      'title': "A Very Happy Christmas",
      'singer': "Michael Ramir C",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-a-very-happy-christmas-897.mp3",
      'coverUrl':
          "https://i.pinimg.com/564x/08/2a/5f/082a5f93b57a4144527fcebd7c6832bc.jpg",
      'info': "https://mixkit.co/free-stock-music/",
      'cover': ""
    },
    {
      'title': "Beautiful Dream",
      'singer': "Diego Nava",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-beautiful-dream-493.mp3",
      'coverUrl':
          "https://i.pinimg.com/736x/bd/34/04/bd340424b7b3e9ce4a146131e221fd80.jpg",
      'info': "https://mixkit.co/free-stock-music/",
      'cover': ""
    },
    {
      'title': "Kiss The Rain",
      'singer': "Yiruma",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/Kiss%20the%20Rain%20-%20Yiruma.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/28/d0/88/28d088c397b218865210354825206bb1.jpg",
      'info':
          "https://www.youtube.com/watch?v=so6ExplQlaY&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=16",
      'cover': ""
    },
    {
      'title': "Snow Flower",
      'singer': "Park Hyo Shin",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/snowflower.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/52/a4/81/52a4811ef83e9dad35fc937dfa4c5d52.jpg",
      'info':
          "https://www.youtube.com/watch?v=R2BSBOvUQWk&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=10",
      'cover': "(Music Box by Flow Music)"
    },
    {
      'title': "Space Love",
      'singer': "Unknown Artist",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/Various%20Artists%20-%20Space%20Love.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/236x/10/7f/db/107fdb985df621ac74e9667ef504973e--love-from-another-star-the-star.jpg",
      'info':
          "https://www.youtube.com/watch?v=kg5cp5c58vU&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=13&t=138s",
      'cover': "(Man from the star soundtrack)"
    },
    {
      'title': "Always With Me",
      'singer': "Youmi Kimura",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Piano/Alwayswithme-SpiritedAwayOST.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/57/b7/95/57b79500c34f0229f0bc882e6507cc20.jpg",
      'info':
          "https://www.youtube.com/watch?v=oK3J0xI_KaY&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=5",
      'cover': "(Cover by ToWiMe)"
    },
    {
      'title': "My Heart Will Go On",
      'singer': "Celine Dion",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Harp/MyHeartWillGoOn-Harp%26Violin.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/e4/51/74/e45174f7b786d2debcf4139492187dee.jpg",
      'info':
          "https://www.youtube.com/watch?v=RigyRr5B_gY&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=20",
      'cover': "(Marion Le Solliec, celtic and electric harp)"
    },
    {
      'title': "Endless Love",
      'singer': "Jackie Chan, Kim Hee-sun",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Kalimba/EndlessLove-Kalimba.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/be/b9/69/beb969166c841ad88fb07a83ed7d37e5.jpg",
      'info':
          "https://www.youtube.com/watch?v=gcPAa9Eg_I8&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=6",
      'cover': "(Cover by April Yang)"
    },
    {
      'title': "Kiss The Rain",
      'singer': "Yiruma",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Kalimba/KissTheRain-kalimbacover.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/34/89/b1/3489b1302ba732ce7d39ec81b75409e7.jpg",
      'info':
          "https://www.youtube.com/watch?v=Bgo_1OtePfQ&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=8",
      'cover': "(Cover by April Yang)"
    },
    {
      'title': "River Flows In You",
      'singer': "Yiruma",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Kalimba/RiverFlowsinYou-Kalimba.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/e6/78/60/e678609d1e8a904bade6738cbcebb10c.jpg",
      'info':
          "https://www.youtube.com/watch?v=DdYi7i6t2R8&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=22",
      'cover': "(Silvita Kalimba & Vicente Guitar)"
    },
    {
      'title': "Canon In D",
      'singer': "Johann Pachelbel",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/CanonInD-MusicBox.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/a1/4c/04/a14c043a8523e5f03a21c3b9cea18f5e.jpg",
      'info':
          "https://www.youtube.com/watch?v=q_WH3miXs0M&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=21",
      'cover': "(Cover by DeepBlue5412)"
    },
    {
      'title': "Konayuki",
      'singer': "Remioromen",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/MusicBox/Konayuki.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/93/00/e4/9300e49ab2e6b947b937f335777322d0.jpg",
      'info':
          "https://www.youtube.com/watch?v=3PS_lShi7nQ&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=25",
      'cover': "(Relax α Wave - Topic)"
    },
    {
      'title': "Sad Violin",
      'singer': "Sad Violin Music Collective",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Violin/Always-violin.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/15/9d/4d/159d4d75db42c603d47ddf7b97fe0073.jpg",
      'info':
          "https://www.youtube.com/watch?v=QuNhTLVgV2Y&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=24",
      'cover': "(Cover by thaSparkaZ)"
    },
    {
      'title': "Always",
      'singer': "Yoon Mi Rae",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Violin/Always-violin.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/88/46/20/884620c469b7ee6f9ef526600f187823.jpg",
      'info':
          "https://www.youtube.com/watch?v=VIcwzjpmJNg&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=23",
      'cover': "(Cover by Jenny Yun)"
    },
    {
      'title': "O mio babbino caro",
      'singer': "Giacomo Puccini and\nGiovacchino Forzano",
      'url':
          "https://github.com/acrosshorizon/palpitate/blob/main/Violin/PucciniMioBabbinoCaro-violin.mp3?raw=true",
      'coverUrl':
          "https://i.pinimg.com/564x/9f/a0/b7/9fa0b780e8976fa32ac7782a56c4349a.jpg",
      'info':
          "https://www.youtube.com/watch?v=9uQomRL7gDc&list=PLTpeyQJ-cKQfkJ12WuqDbbYPYJkdv7Usm&index=17",
      'cover': "(Cover by Violinbow)"
    },
  ];

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      for (int i = 0; i < 10; i++) {
        var decodeTitle = jsonDecode(data)['api'][i]['title'];
        var decodeSinger = jsonDecode(data)['api'][i]['singer'];
        var decodeUrl = jsonDecode(data)['api'][i]['url'];
        var decodeCover = jsonDecode(data)['api'][i]['coverUrl'];
        _musicList.add({
          'title': decodeTitle,
          'singer': decodeSinger,
          'url': decodeUrl,
          'coverUrl': decodeCover
        });
      }
    }
  }

  List getList() {
    getData();
    return _musicList;
  }
}
