import 'package:flutter/material.dart';


DraggableScrollableSheet openUserDetail(context, userId) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.blue[100],
          child: ListView.builder(
            controller: scrollController,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Item $index'));
            },
          )
        );
      }
    );
  }
  