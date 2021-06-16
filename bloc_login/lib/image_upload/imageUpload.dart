import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:progress_dialog/progress_dialog.dart';




import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

import 'dart:math' as Math;
class UserInfoEdit extends StatefulWidget {
  @override
  _UserInfoEditState createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {

  File _image;
  TextEditingController cTitle = new TextEditingController();

  Future getImageGallery() async{
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;

    int rand= new Math.Random().nextInt(100000);

    Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image,width: 500, height: 500);

    var compressImg= new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


    setState(() {
      _image = compressImg;
    });
  }

  Future getImageCamera() async{
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;

    int rand= new Math.Random().nextInt(100000);

    Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image,width: 500, height: 500);

    var compressImg= new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


    setState(() {
      _image = compressImg;
    });
  }

  Future upload(File imageFile) async{
    var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length= await imageFile.length();
    var uri = Uri.parse("http://10.0.30.157:8000/account/api/NFT/");
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
    request.fields['title'] = cTitle.text;
    request.files.add(multipartFile);

    var responseJson = await request.send();

    if(responseJson.statusCode==200){
      print("Image Uploaded");
    }else{
      print("Upload Failed");
    }
    responseJson.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image"),),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: _image==null
                  ? new Text("No image selected!")
                  : new Image.file(_image),
            ),

            TextField(
              controller: cTitle,
              decoration:new InputDecoration(
                hintText: "Title",
              ),
            ),

            Row(
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.image),
                  onPressed: getImageGallery,
                ),
                RaisedButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: getImageCamera,
                ),
                Expanded(child: Container(),),
                RaisedButton(
                  child: Text("UPLOAD"),
                  onPressed:(){
                    upload(_image);
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
// class UserInfoEdit extends StatefulWidget {
//
//   @override
//   _UserInfoEditState createState() => _UserInfoEditState();
// }
//
// class _UserInfoEditState extends State<UserInfoEdit> {
//   ProgressDialog pr;
//
//   String _Title;
//   String _Price;
//   String _Tags;
//   File _Image;
//
//   var Title = TextEditingController();
//   var Price = TextEditingController();
//   var Tags = TextEditingController();
//   String img =
//       'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png';
//
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     //============================================= loading dialoge
//     pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
//
//     //Optional
//     pr.style(
//       message: 'Please wait...',
//       borderRadius: 10.0,
//       backgroundColor: Colors.white,
//       progressWidget: CircularProgressIndicator(),
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//       progressTextStyle: TextStyle(
//           color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//       messageTextStyle: TextStyle(
//           color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         // leading: IconButton(
//         //   icon: Icon(Icons.arrow_back_ios),
//         //   onPressed: () {
//         //     Navigator.pop(context);
//         //   },
//         // ),
//         title: Text('Edit Personal Info'),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Colors.white,
//           child: Padding(
//             padding: EdgeInsets.only(
//               right: 10,
//               left: 10,
//               top: 10,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     'Add Profile Picture and your Personal Details',
//                     style: Theme.of(context).textTheme.title,
//                   ),
//                   //======================================================================================== Circle Avatar
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     alignment: Alignment.center,
//                     child: Column(
//                       children: <Widget>[
//                         Stack(
//                           children: <Widget>[
//                             CircleAvatar(
//                               backgroundImage: _Image == null
//                                   ? NetworkImage(
//                                       'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
//                                   : FileImage(_Image),
//                               radius: 50.0,
//                             ),
//                             InkWell(
//                               onTap: _onAlertPress,
//                               child: Container(
//                                   padding: EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(40.0),
//                                       color: Colors.black),
//                                   margin: EdgeInsets.only(left: 70, top: 70),
//                                   child: Icon(
//                                     Icons.photo_camera,
//                                     size: 25,
//                                     color: Colors.white,
//                                   )),
//                             ),
//                           ],
//                         ),
//                         Text('Half Body',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
// //=========================================================================================== Form
//                   Container(
//                     margin: EdgeInsets.only(top: 20, bottom: 100),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           TextFormField(
//                             controller: Title,
//                             onChanged: ((String Title) {
//                               setState(() {
//                                 _Title = Title;
//                                 print(_Title);
//                               });
//                             }),
//                             decoration: InputDecoration(
//                               labelText: "Title",
//                               labelStyle: TextStyle(
//                                 color: Colors.black87,
//                               ),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                             ),
//                             textAlign: TextAlign.center,
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return 'Please enter full name';
//                               }
//                               return null;
//                             },
//                           ),
//
//                           //========================================== Email Address
//                           Container(
//                             margin: EdgeInsets.only(top: 25),
//                             child: TextFormField(
//                               controller: Tags,
//                               onChanged: ((String Tags) {
//                                 setState(() {
//                                   _Tags = Tags;
//                                   print(_Tags);
//                                 });
//                               }),
//                               decoration: InputDecoration(
//                                 labelText: "Tags",
//                                 labelStyle: TextStyle(
//                                   color: Colors.black87,
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                               textAlign: TextAlign.center,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Please enter email address';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//
//                           //===================================================== Emergency Contact
//
//                           Container(
//                             margin: EdgeInsets.only(top: 25),
//                             child: TextFormField(
//                               controller: Price,
//                               onChanged: ((String Price) {
//                                 setState(() {
//                                   _Price = Price;
//                                   print(_Price);
//                                 });
//                               }),
//                               decoration: InputDecoration(
//                                 labelText: "Price",
//                                 labelStyle: TextStyle(
//                                   color: Colors.black87,
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.phone,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Please enter emergency contact number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           //========================================================Button
//
//                           Center(
//                             child: Container(
//                               width: 300,
//                               margin: EdgeInsets.only(top: 50),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(25),
//                                   color: Colors.blue),
//                               child: FlatButton(
//                                 child: FittedBox(
//                                     child: Text(
//                                   'Save',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16),
//                                   textAlign: TextAlign.center,
//                                 )),
//                                 onPressed: () {
//                                   if (_formKey.currentState.validate()) {
//                                     _startUploading();
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
// //============================================================================================================= Form Finished
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   //========================================================================== Funcions Area
//
//   //========================= Gellary / Camera AlerBox
//   void _onAlertPress() async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return new CupertinoAlertDialog(
//             actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: Column(
//                   children: <Widget>[
//                     // Image.asset(
//                     //   'assets/images/gallery.png',
//                     //   width: 50,
//                     // ),
//                     Text('Gallery'),
//                   ],
//                 ),
//                 onPressed: getGalleryImage,
//               ),
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: Column(
//                   children: <Widget>[
//                     // Image.asset(
//                     //   'assets/images/take_picture.png',
//                     //   width: 50,
//                     // ),
//                     Text('Take Photo'),
//                   ],
//                 ),
//                 onPressed: getCameraImage,
//               ),
//             ],
//           );
//         });
//   }
//
//   // ================================= Image from camera
//   Future getCameraImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//     setState(() {
//       _Image = image;
//       Navigator.pop(context);
//     });
//   }
//
//   //============================== Image from gallery
//   Future getGalleryImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       _Image = image;
//       Navigator.pop(context);
//     });
//   }
//
//   //============================================================= API Area to upload image
//   Uri apiUrl = Uri.parse(
//       'http://10.0.30.157:8000/account/api/NFT/');
//
//   Future<Map<String, dynamic>> _uploadImage(File image) async {
//     setState(() {
//       pr.show();
//     });
//
//     final mimeTypeData =
//     lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
//
//     // Intilize the multipart request
//     final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
//
//     // Attach the file in the request
//     final file = await http.MultipartFile.fromPath(
//         'half_body_image', image.path,
//         contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
//     // Explicitly pass the extension of the image with request body
//     // Since image_picker has some bugs due which it mixes up
//     // image extension with file name like this filenamejpge
//     // Which creates some problem at the server side to manage
//     // or verify the file extension
//
// //    imageUploadRequest.fields['ext'] = mimeTypeData[1];
//
//     imageUploadRequest.files.add(file);
//     imageUploadRequest.fields['Title'] = _Title;
//     imageUploadRequest.fields['Tags'] = _Tags;
//     imageUploadRequest.fields['Price'] = _Price;
//
//     try {
//       final streamedResponse = await imageUploadRequest.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       if (response.statusCode != 200) {
//         return null;
//       }
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       _resetState();
//       return responseData;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   void _startUploading() async {
//     if (_Image != null ||
//         _Title != '' ||
//         _Tags != '' ||
//         _Price != '') {
//       final Map<String, dynamic> response = await _uploadImage(_Image);
//
//       // Check if any error occured
//       if (response == null) {
//         pr.hide();
//         messageAllert('User details updated successfully', 'Success');
//       }
//     } else {
//       messageAllert('Please Select a profile photo', 'Profile Photo');
//     }
//   }
//
//   void _resetState() {
//     setState(() {
//       pr.hide();
//       _Title = null;
//       _Tags = null;
//       _Price = null;
//       _Image = null;
//     });
//   }
//
//   messageAllert(String msg, String ttl) {
//     Navigator.pop(context);
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return new CupertinoAlertDialog(
//             title: Text(ttl),
//             content: Text(msg),
//             actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: Column(
//                   children: <Widget>[
//                     Text('Okay'),
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }
