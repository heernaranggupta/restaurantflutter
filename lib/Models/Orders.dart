import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  Orders({
    this.date,
    this.time,
    this.total,
    this.isApprove,
    this.order,
    this.orderId,
    this.docId,
    this.specialNote,
    this.table,
  });

  String date;
  int orderId;
  String time;
  int total;
  bool isApprove;
  String docId;
  List<dynamic> order;
  String specialNote;
  String table;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        date: json["Date"],
        docId: json["DocId"],
        time: json["Time"],
        total: json["Total"],
        isApprove: json["isApprove"],
        order: json["order"],
        orderId: json["orderId"],
        specialNote: json['specialNote'],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "DocId": docId,
        "Time": time,
        "Total": total,
        "isApprove": isApprove,
        "order": order,
        "orderId": orderId,
        "specialNote": specialNote,
        "table": table,
      };
  Future<dynamic> getOrders() async {
    List<Orders> _ordersList = [];
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection('Orders')
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              _ordersList.add(Orders.fromJson(result.data()));
            }));
    return _ordersList;
  }

  Future<dynamic> updateOrder(String orderId, isApprove) async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('Orders').doc(orderId).update(
        {'isApprove': isApprove}).then((value) => print('Successsssss!!!'));
  }
}
