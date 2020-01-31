import 'package:flutter/material.dart';


class UserDetailWidget extends StatefulWidget {
  final String userId;

  UserDetailWidget({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  double widgetExtent = 0.0;
  Widget currentWidget;

  var miniWidget = Container(
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
  );

  var maxiWidget = SizedBox.expand(
    child: Container(
      
    )
  );

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
        widgetExtent = notification.extent;
      },
      child: DraggableScrollableSheet(
        initialChildSize: minHeight,
        minChildSize: minHeight,
        maxChildSize: maxHeight,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: currentWidget
                  ),
                ]
              )
            )
          );
        }
      )
    );
  }
}
