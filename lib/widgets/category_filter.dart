import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Category.dart';
import 'package:orderingsystem/constants.dart';

class CategoryFilter extends StatelessWidget {
  final String filterId;
  final Function onFilterChange;
  final List<Categories> _categories;

  CategoryFilter(this._categories, this.onFilterChange, this.filterId);
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return CContainer(
      borderRadius: BorderRadius.circular(10),
      height: mediaQuery.height * 0.14,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(15, 8, 0, 0),
        physics: BouncingScrollPhysics(),
        itemCount: _categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                onFilterChange(_categories[index].categoryId);
              },
              child: Column(
                children: [
                  CContainer(
                    width: mediaQuery.width * 0.14,
                    padding: EdgeInsets.all(3),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _categories[index].categoryId == filterId
                          ? fontColor
                          : appColor,
                      width: 2,
                    ),
                    child: Image(
                      fit: BoxFit.fill,
                      image:
                          CachedNetworkImageProvider(_categories[index].imgUrl),
                    ),
                  ),
                  SizedBox(height: 10),
                  CText(
                    text: _categories[index].categoryName,
                    fontSize: mediaQuery.width * 0.035,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
