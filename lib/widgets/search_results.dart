import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/FoodItem.dart';
import 'package:orderingsystem/Screens/s_edit.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SearchResults extends StatelessWidget {

  List<FoodItem> searchedResults;

  SearchResults(this.searchedResults);

  Widget buildText(String title, Size mediaQuery) {
    return CText(
      text: title,
      textColor: Colors.white,
      fontSize: mediaQuery.width * 0.045,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    print(searchedResults.isNotEmpty);

    return Consumer<FoodItem>(
      builder: (context, foodItem, _) {

        return searchedResults != null
            ? Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(right: 20),
            itemCount: searchedResults.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: boxShadow,
              ),
              width: mediaQuery.width * 0.9,
              height: mediaQuery.width * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    child: searchedResults[index].imageUrl != null
                        ? Image(
                      image: CachedNetworkImageProvider(
                        searchedResults[index].imageUrl[0],
                      ),
                      height: mediaQuery.height,
                      width: mediaQuery.width * 0.26,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      child: Center(child: Text("No Image")),
                      height: mediaQuery.height,
                      width: mediaQuery.width * 0.26,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CText(
                                  text: searchedResults[index].foodName,
                                  fontSize: mediaQuery.width * 0.05,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                    height: mediaQuery.height * 0.005),
                                CText(
                                  text:
                                  searchedResults[index].description,
                                  fontSize: mediaQuery.width * 0.03,
                                  textColor: Colors.grey[600],
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: mediaQuery.width * 0.22,
                    alignment: Alignment.center,
                    child: !isEditScreen
                        ? buildText("${searchedResults[index].price} ₹",
                        mediaQuery)
                        : GestureDetector(
                      child: buildText('Edit', mediaQuery),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            SEditItems.routeName,
                            arguments:
                            searchedResults[index].foodId);
                      },
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 4,
                        ),
                      ],
                      color: Color(0xff1c2843),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
            : Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: CContainer(
            borderRadius: BorderRadius.circular(15),
            child: Center(child: CText(text: 'No items.')),
          ),
        );
      },
    );
  }
}
