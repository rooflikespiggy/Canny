import 'package:Canny/Database/all_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Models/notification.dart';
import 'package:Canny/Services/Notification/default_notification.dart';

class NotificationDatabaseService {
  final String uid;

  NotificationDatabaseService({ this.uid });

  final CollectionReference notificationCollection = Database().notificationDatabase();

  Future initStartNotif() async {
    await addDefaultNotif(defaultNotif);
    return true;
  }

  Future addDefaultNotif(Notification notif) async {
    await notificationCollection
        .doc('NotifStatus')
        .set(notif.toMap());
    return true;
  }

  Future updateNotifStatus(bool newStatus) async {
    await notificationCollection
        .doc('NotifStatus')
        .update({
      'notificationStatus': newStatus
    });
    return true;
  }

  Future<Notification> getNotifStatus() async {
    List<DocumentSnapshot> snapshots = await notificationCollection
        .get()
        .then((value) => value.docs);
    return snapshots.map((doc) => Notification.fromMap(doc)).first;
  }

}