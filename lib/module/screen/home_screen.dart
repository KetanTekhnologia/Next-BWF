import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? email;
  final String? name;
  final int doctor_id;

  const HomeScreen(
      {super.key,
        required this.email,
        required this.name,
        required this.doctor_id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.name ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ), // Use 'Unknown' if name is null
              accountEmail: Text(
                widget.email ?? 'Unknown',
                style:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              ), //Use 'No Email' if email is null
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/doctorimage.jpg'),
              ),
              decoration: BoxDecoration(
                color: Color(0xffBFF6F7), // Customize header color if needed
              ),
            ),
            // ListTile(
            //   // leading: Icon(Icons.person),
            //   title: Text('My Profile'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigator.pushNamed(context, '');
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //       builder: (context) => DoctorProfileScreen()),
            //     // );
            //   },
            // ),
            // ListTile(
            //   // leading: Icon(Icons.notification_add),
            //   title: Text('Manage Time'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //       builder: (context) => AllFamilyProfileMainScreen()),
            //     // );
            //     //Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   // leading: Icon(Icons.star),
            //   title: Text('Reviews'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '');
            //     //Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   // leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '');
            //     //Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.person_2_outlined),
            //   title: Text('My Profile'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) =>MyProfileDoctor()),
            //     );
            //     //Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.login_outlined),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //*****************************************************************************************************************//
            //************************Useable**********************************************************************************//
            // MaterialButton(
            //   minWidth: double.infinity,
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PatientRegistration(
            //             name: widget.name,
            //           )),
            //     );
            //   },
            //   child: Text(
            //     'New Patient Registration',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontSize: 20,
            //     ),
            //   ),
            //   color: Color(0xffBFF6F7),
            //   textColor: Colors.black,
            //   height: 100,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   elevation: 10,
            // ),
            //*****************************************************************************************************************//

            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),

            //************************************************************Usable*********************************************//
            // MaterialButton(
            //   minWidth: double.infinity,
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => PatientList(
            //               doctor_id: widget.doctor_id,
            //               name: widget.name,
            //             )));
            //   },
            //   child: Text(
            //     'Patient List',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontSize: 20,
            //     ),
            //   ),
            //   color: Color(0xffBFF6F7),
            //   textColor: Colors.black,
            //   height: 100,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   elevation: 10,
            // ),
            //************************************************************Usable*********************************************//

          ],
        ),
      ),
    );
  }
}
