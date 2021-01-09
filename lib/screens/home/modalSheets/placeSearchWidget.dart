import 'package:flutter/material.dart';
import 'package:eva/widgets/widgets.dart';

void openPlaceSearch(context, searchPlaceCallback) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SizedBox(
                    height: 10,
                  )),
              Expanded(
                child:
                    SearchPlaceWidget(geocodingCallback: searchPlaceCallback),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height - 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )),
        );
      });
}
