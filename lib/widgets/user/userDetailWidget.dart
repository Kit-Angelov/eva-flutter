import 'package:flutter/material.dart';


class UserDetailWidget extends StatefulWidget {
  final String userId;

  UserDetailWidget({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  var currentWidget;

  Widget miniWidget (BuildContext context, ScrollController scrollController)  {
    return ListView(
      padding: const EdgeInsets.all(0),
      physics: BouncingScrollPhysics(),
      controller: scrollController,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade500,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "asdf",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ]
    );
  }

  Widget maxiWidget (BuildContext context, ScrollController scrollController) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      controller: scrollController,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
                        fit: BoxFit.cover,
                      )
                    )
                  ],
                ),
              ),
            ]
          )
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentWidget = miniWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    var minHeight = 60 / MediaQuery.of(context).size.height;
    var maxHeight = 0.7;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent > minHeight && currentWidget != maxiWidget) {
          currentWidget = maxiWidget;
          setState(() {});
        } else if((notification.extent == minHeight && currentWidget != miniWidget)){
          currentWidget = miniWidget;
          setState(() {});
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: minHeight,
        minChildSize: minHeight,
        maxChildSize: maxHeight,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.white,
            child: currentWidget(context, scrollController)
          );
        }
      )
    );
  }
}
