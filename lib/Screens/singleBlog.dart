import 'package:blog_app/Screens/home.dart';
import 'package:blog_app/Screens/sign_in.dart';
import 'package:blog_app/Screens/updateBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleBlog extends StatefulWidget {
  final blogId;

  SingleBlog({required this.blogId});

  @override
  _SingleBlogState createState() => _SingleBlogState();
}

class _SingleBlogState extends State<SingleBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        backgroundColor: Colors.green[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(widget.blogId)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    String title = snapshot.data!.get('title');
                    String mediaUrl = snapshot.data!.get('mediaUrl');
                    String content = snapshot.data!.get('content');
                    String blogUsername = snapshot.data!.get('username');
                    String blogOwnerId = snapshot.data!.get('ownerId');

                    return Column(
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(mediaUrl),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800]),
                              ),
                            ),

                            // Edit Button
                            currentUser!.uid == blogOwnerId
                                ? GestureDetector(
                                    onTap: () {},
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateBlog(
                                                      blogId: widget.blogId,
                                                    )));
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(blogOwnerId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('');
                              }
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
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
                                      blogUsername,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      '15 min ago',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 18),
                          decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(content,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800])),
                        )
                      ],
                    );
                  })),
        ),
      ),
    );
  }
}
