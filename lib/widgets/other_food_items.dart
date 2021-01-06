// import 'package:flutter/material.dart';
// import '../models/FoodItem.dart';

// import '../constants.dart';

// class OtherFoodItems extends StatefulWidget {
//   @override
//   _OtherFoodItemsState createState() => _OtherFoodItemsState();
// }

// class _OtherFoodItemsState extends State<OtherFoodItems> {
//   @override
//   void initState() {
//     vegFood();
//     nonVegFood();
//     super.initState();
//   }

//   void vegFood() {
//     foodItems.forEach((item) {
//       if (item.isVeg) {
//         setState(() {
//           vegFoodItems.add(item);
//         });
//       }
//     });
//   }

//   void nonVegFood() {
//     foodItems.forEach((item) {
//       if (!item.isVeg) {
//         setState(() {
//           nonVegFoodItems.add(item);
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<FoodItem> foodItemsDisplay = [];

//     print("actual lenth  - ${foodItemsDisplay.length}");
//     final mediaQuery = MediaQuery.of(context).size;
//     if (isVeg) {
//       foodItemsDisplay = vegFoodItems;
//     } else if (isNonVeg) {
//       foodItemsDisplay = nonVegFoodItems;
//     } else {
//       foodItemsDisplay = foodItems;
//     }
//     print("actual lenth  - ${foodItemsDisplay.length}");

//     return Container(
//       height: foodItemsDisplay.length * 125.0,
//       child: ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.only(right: 20),
//         itemCount: foodItemsDisplay.length,
//         itemBuilder: (ctx, index) => Container(
//           margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
//           decoration: BoxDecoration(
//             color: Color(0xfff5f5f5),
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             boxShadow: boxShadow,
//           ),
//           width: mediaQuery.width * 0.9,
//           height: 104,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ClipRRect(
//                 child: foodItemsDisplay[index].imageUrl != null
//                     ? Image.network(
//                         foodItemsDisplay[index].imageUrl,
//                         fit: BoxFit.cover,
//                         height: mediaQuery.height * 0.3,
//                         width: mediaQuery.width * 0.275,
//                       )
//                     : Container(
//                         child: Center(child: Text("No Image")),
//                         height: mediaQuery.height * 0.3,
//                         width: mediaQuery.width * 0.275,
//                       ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10.0),
//                   bottomLeft: Radius.circular(10.0),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xfff5f5f5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white,
//                         offset: Offset(-3, -3),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               foodItemsDisplay[index].foodName,
//                               style: TextStyle(fontSize: 20),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               foodItemsDisplay[index].description,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10),
//               Container(
//                 width: 90,
//                 alignment: Alignment.center,
//                 height: 120,
//                 child: Text(
//                   !isEditScreen ? "${foodItemsDisplay[index].price} ₹" : 'Edit',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white,
//                       offset: Offset(-3, -3),
//                       blurRadius: 4,
//                     ),
//                   ],
//                   color: Color(0xff1c2843),
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
