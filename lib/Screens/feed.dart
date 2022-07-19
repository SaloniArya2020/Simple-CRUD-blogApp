import 'package:blog_app/Screens/sign_in.dart';
import 'package:blog_app/Screens/singleBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('blogs')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                    children: snapshot.data!.docs.map((doc) {
                  print(doc);

                  if (!doc.exists) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'No Blogs Yet!',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleBlog(blogId: doc['blogId'])));
                    },
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          doc['mediaUrl'],
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '15 feb 2020,  15min ago',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(doc['ownerId'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('');
                                    }

                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                snapshot.data!['profilePhoto']),
                                            radius: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snapshot.data!['username'],
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      doc['title'],
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      doc['content'].toString().length <= 150
                                          ? '${doc['content']}...'
                                          : '${doc['content'].toString().substring(0, 150)} ...',
                                      style: TextStyle(fontSize: 15),
                                    )),
                              )
                            ],
                          )),
                    ),
                  );
                }).toList());
              })),
    );
  }
}
