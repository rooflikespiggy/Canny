import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Screens/Sidebar/Quick%20Input/customise_quickinput.dart';
import 'package:Canny/Services/Dashboard/dashboard_database.dart';
import 'package:Canny/Services/Notifications/notification_database.dart';
import 'package:Canny/Services/Users/auth.dart';
import 'package:Canny/Shared/custom_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Screens/wrapper.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({Key key}) : super(key: key);

  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> with AutomaticKeepAliveClientMixin {
  final AuthService _auth = AuthService();
  final String email = FirebaseAuth.instance.currentUser.email;
  final CollectionReference dashboardCollection = Database().dashboardDatabase();
  final DashboardDatabaseService _authDashboard = DashboardDatabaseService();
  final CollectionReference notifCollection = Database().notificationDatabase();
  final NotificationDatabaseService _authNotification = NotificationDatabaseService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Drawer(
        child: Container(
          color: kLightBlue,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
              decoration: BoxDecoration(
                color: kDarkBlue,
                image: DecorationImage(
                  image: AssetImage('styles/images/logo-8.png'),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Container(
                  child: Text(email,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.bottomCenter,
                  height: 40.0,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate_outlined),
              trailing: Icon(Icons.arrow_right),
              title: Text(
                  'Customise Quick Input',
                  style: TextStyle(fontFamily: 'Lato',
                    fontSize: 16,
                  )
              ),
              onTap: () => {
                Navigator.push(context,
                    NoAnimationMaterialPageRoute(builder: (context) => CustomiseQI()))
              },
            ),
            Divider(thickness: 1.0),
            StreamBuilder(
              stream: dashboardCollection.doc('Switch').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                        'Customise Dashboard',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                        )
                      ),
                      children: <Widget>[
                        SwitchListTile(
                          value: snapshot.data['balance'],
                          onChanged: (value) => _authDashboard.updateBudget(value),
                          title: Text('Balance'),
                          activeTrackColor: kLightBlueDark,
                          activeColor: kDarkBlue,
                          inactiveThumbColor: Colors.white,
                        ),
                        SwitchListTile(
                          value: snapshot.data['expenseBreakdown'],
                          onChanged: (value) => _authDashboard.updateExpenseBreakdown(value),
                          title: Text('Expenses Breakdown'),
                          activeTrackColor: kLightBlueDark,
                          activeColor: kDarkBlue,
                          inactiveThumbColor: Colors.white,
                        ),
                        SwitchListTile(
                          value: snapshot.data['expenseSummary'],
                          onChanged: (value) => _authDashboard.updateExpenseSummary(value),
                          title: Text('Expenses Summary'),
                          activeTrackColor: kLightBlueDark,
                          activeColor: kDarkBlue,
                          inactiveThumbColor: Colors.white,
                        ),
                        SwitchListTile(
                          value: snapshot.data['recentReceipts'],
                          onChanged: (value) => _authDashboard.updateRecentReceipts(value),
                          title: Text('Recent Receipts'),
                          activeTrackColor: kLightBlueDark,
                          activeColor: kDarkBlue,
                          inactiveThumbColor: Colors.white,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }
            ),
            Divider(thickness: 1.0),
            StreamBuilder(
                stream: notifCollection.doc('NotifStatus').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        leading: Icon(Icons.notifications_active),
                        title: Text(
                            'Turn on Reminder Notifications',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                            )
                        ),
                        trailing: Switch(
                            value:snapshot.data['notificationStatus'],
                            onChanged: (value) async {
                              await _authNotification.updateNotifStatus(value);
                            },
                              activeTrackColor: kLightBlueDark,
                              activeColor: kDarkBlue,
                              inactiveThumbColor: Colors.white,
                            ),

                      ),
                    );
                  }
                  return Container();
                }
            ),
            Divider(thickness: 1.0),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                style: TextStyle(fontFamily: 'Lato',
                  fontSize: 16,
                )
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

