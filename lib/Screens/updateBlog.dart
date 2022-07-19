import 'package:blog_app/Screens/home.dart';
import 'package:blog_app/Screens/singleBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UpdateBlog extends StatefulWidget {
  final blogId;
  UpdateBlog({required this.blogId});

  @override
  _UpdateBlogState createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  final _key = GlobalKey<FormState>();
  bool isUploading = false;
  String? title;
  String? content;

  getUser() async {


    DocumentSnapshot blog = await FirebaseFirestore.instance
        .collection('blogs')
        .doc(widget.blogId)
        .get();

    setState(() {
      title = blog['title'];
      content = blog['content'];
    });
  }

  updateBlog() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isUploading = true;
      });

      await FirebaseFirestore.instance
          .collection('blogs')
          .doc(widget.blogId)
          .update({'title': title, 'content': content}).whenComplete(() {
        setState(() {
          isUploading = false;
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SingleBlog(blogId: widget.blogId)));

        final snackBar = SnackBar(content: Text('Changes saved successfully!'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  deleteBlog() async{

    await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).delete().whenComplete(() {

      FirebaseStorage.instance.ref('path_${widget.blogId}.jpg').delete().whenComplete((){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

        final snackBar = SnackBar(content: Text('Blog Deleted Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _key,
            child: Column(
              children: [
                isUploading ? LinearProgressIndicator() : Container(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('blogs')
                          .doc(widget.blogId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if(!snapshot.data!.exists){
                          return Container();
                        }
                        return Column(
                          children: [
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  title = val.trim();
                                });
                              },
                              initialValue: snapshot.data!['title'],
                              validator: (val) =>
                                  val!.isEmpty ? 'Please write title' : null,
                              decoration: InputDecoration(
                                label: Text('Title'),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  content = val.trim();
                                });
                              },
                              initialValue: snapshot.data!['content'],
                              decoration: InputDecoration(
                                  label: Text('Content ...'),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey))),
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: isUploading ? null : updateBlog,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: isUploading
                                            ? Colors.blue[200]
                                            : Colors.blue[500]),
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: isUploading ? null : deleteBlog,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: isUploading
                                            ? Colors.red[200]
                                            : Colors.red[500]),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }
}
