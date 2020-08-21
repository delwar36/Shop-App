
import 'package:flutter/material.dart';
import '../screens/category_details_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String thumbnailLink;

  CategoryItem(
    this.id,
    this.title,
    this.thumbnailLink,
  );

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryDetailsScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
        'thumbnailLink': thumbnailLink,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        child: Card(
          elevation: 10,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: thumbnailLink == null
                      ? Container(
                          color: Colors.blue,
                        )
                      : Image.network(
                          thumbnailLink,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  color: Colors.black54,
                  child: SizedBox(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
