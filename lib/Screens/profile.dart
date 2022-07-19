import 'package:blog_app/Screens/sign_in.dart';
import 'package:blog_app/Screens/singleBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String content =
      'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with:\“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn\'t distract from the layout. A practice not without controversy, laying out pages with meaningless filler text can be very useful when the focus is meant to be on design, not content.The passage experienced a surge in popularity during the 1960s when Letraset used it on their dry-transfer sheets, and again during the 90s as desktop publishers bundled the text with their software. Today it seen all around the web; on templates, websites, and stock designs. Use our generator to get your own, or read on for the authoritative history of lorem ipsum.';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    currentUser!.profilePhoto
                  ),
                  radius: 45,

                  //Edit profile pic
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green[800],
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    currentUser!.username,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    currentUser!.email,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(),
          ),

          // Blogs

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('blogs')
                .where('ownerId', isEqualTo: currentUser!.uid)
                .snapshots(),
            builder: (context, snapshots) {

              if(!snapshots.hasData){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }


              return Column(
                children: snapshots.data!.docs.map((doc) {

                  if(!doc.exists){
                    return Container();
                  }else{
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleBlog(blogId: doc['blogId'])));
                      },
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              doc['mediaUrl']
                                          ),
                                          fit: BoxFit.fill
                                      )
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.topLeft,
                                  child: Text('15 feb 2020,  15min ago', style: TextStyle(color: Colors.grey[600]),),
                                ),


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
                                        doc['content'].toString().length <= 150 ?
                                        doc['content']: '${doc['content'].substring(0, 150)} ...',
                                        style: TextStyle(fontSize: 15),
                                      )),
                                )
                              ],
                            )),
                      ),
                    );
                  }



                }).toList(),
              );
            },
          )

          // Column(

          // children: [

          // GestureDetector(
          //   onTap: (){},
          //   child: Card(
          //     child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           children: [
          //             Container(
          //               height: 250,
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(20),
          //                   image: DecorationImage(
          //                       image: NetworkImage(
          //                         'https://cdn.dribbble.com/users/915817/screenshots/5834160/mobile-blog-app_4x.jpg?compress=1&resize=1000x750&vertical=top',
          //                       ),
          //                       fit: BoxFit.fill
          //                   )
          //               ),
          //             ),
          //
          //             SizedBox(
          //               height: 10,
          //             ),
          //
          //             Container(
          //               padding: EdgeInsets.symmetric(horizontal: 8),
          //               alignment: Alignment.topLeft,
          //               child: Text('15 feb 2020,  15min ago', style: TextStyle(color: Colors.grey[600]),),
          //             ),
          //
          //
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Container(
          //                   alignment: Alignment.topLeft,
          //                   child: Text(
          //                     'Title',
          //                     style: TextStyle(
          //                         fontSize: 22,
          //                         fontWeight: FontWeight.bold),
          //                   )),
          //             ),
          //             Padding(
          //               padding:
          //               const EdgeInsets.symmetric(horizontal: 8),
          //               child: Container(
          //                   alignment: Alignment.topLeft,
          //                   child: Text(
          //                     content.toString().length <= 150 ?
          //                     content : '${content.substring(0, 150)} ...',
          //                     style: TextStyle(fontSize: 15),
          //                   )),
          //             )
          //           ],
          //         )),
          //   ),
          // )
          // ],
          // )
        ],
      ),
    );
  }
}
