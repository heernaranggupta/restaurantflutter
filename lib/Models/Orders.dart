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

  Future<void> updateOrder(String docId, isApprove) async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('Orders').doc(docId).update(
        {'isApprove': isApprove}).then((value) => print('Successsssss!!!'));
  }

  Future<void> deleteOrder(String docId) async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('Orders').doc(docId).delete();
  }

  Future<void> deleteParticularOrder(String docId, String orderId, List<dynamic> order, int index) async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final order = await firestoreInstance
        .collection('Orders')
        .get()
        .then((querySnapshot) => querySnapshot.docs
          .where((element) => element.id == docId).toList());

    print(order.first.data()['order'].length);


    var newOrder = [];
    for(var i=0; i<order.first.data()['order'].length; i++) {
      if(i!=index){
        newOrder.add(order.first.data()['order'][index]);
      }
    }

    // print(newOrder.length);
    // order.first.data().update(
    //     'order', (value) => value[index].delete()
    // );

    if(newOrder.length == 0) {
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection('Orders').doc(docId).delete();
    } else {
      await firestoreInstance.collection('Orders').doc(docId).update(
          {'order': newOrder}).then((value) => print('Successsssss!!!'));
    }
    // order.first.data()['order'] = newOrder;
  }
}
