import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var player = AudioCache(); //يقوم بتشغيل الصوت
  Map<String, bool> score = {};
  Map<String, Color> choices = {
    '🍎': Colors.red,
    '🥒': Colors.green,
    '🔵': Colors.blue,
    '🍋': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;
  int indexx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your scors $indexx'),
      ),
      body: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // مساحات متساوية قبل وبعد كل عمود
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((element) {
              return Expanded(
                  //حتى لا يحصل مشاكل في الارتفاع
                  child: Draggable<String>(
                //حتى يتم السحب والافلات
                data: element, //هو الذي يسحب
                child: Movabel(score[element] == true
                    ? '✔️'
                    : element), //هو الذي يكون ظاهر على الشاشة
                feedback: Movabel(element), // شكل العنصر عند السحب
                childWhenDragging:
                    Movabel('🐰'), //لما يتم السحب ماذا يظهر مكان العنصر المسحوب
              ));
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((element) {
              return buildTarget(element);
            }).toList()
              ..shuffle(Random(
                  index)), //..تعود على اري نفسها random ::: to order randomly and optional para to start
            //shuffle للترتيب
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            index++;
            indexx = 0;
          });
        },
      ),
    );
  }

  Widget buildTarget(element) {
    return DragTarget<String>(
      builder: (context, incoming, rejected) {
        if (score[element] == true) {
          return Container(
            color: Colors.white,
            height: 80,
            width: 200,
            child: Text('Congratulation!'),
            alignment: Alignment.center,
          );
        } else {
          return Container(
            color: choices[element],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == element,
      onAccept: (data) {
        setState(() {
          score[element] = true;
          player.play('clap.mp3');
          indexx++;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Movabel extends StatelessWidget {
  final String emoji;
  Movabel(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, //شفاف
      child: Container(
          alignment: Alignment.center,
          height: 50,
          padding: EdgeInsets.all(15),
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 60,
              color: Colors.black,
            ),
          )),
    );
  }
}
