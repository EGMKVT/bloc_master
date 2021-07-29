import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:async/async.dart';
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
  TextEditingController cText = new TextEditingController();


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

  // Future getImageCamera() async{
  //   var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  //
  //   final tempDir =await getTemporaryDirectory();
  //   final path = tempDir.path;
  //
  //   int rand= new Math.Random().nextInt(100000);
  //
  //   Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image,width: 500, height: 500);
  //
  //   var compressImg= new File("$path/image_$rand.jpg")
  //     ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
  //
  //
  //   setState(() {
  //     _image = compressImg;
  //   });
  // }

  Future upload(File imageFile) async {
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Token b93b4cd7480a6b2313700a547f73f4eedd7fef01",};
    var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length= await imageFile.length();
    var uri = Uri.parse('http://10.0.10.49:8000/account/api/NFT/',);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
    ///add headers
    request.headers.addAll(headers);
    request.fields['title'] = cTitle.text;
    request.fields['title'] = cText.text;
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
              controller: cText,
              decoration:new InputDecoration(
                hintText: "Title",
              ),
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
                // RaisedButton(
                //   child: Icon(Icons.camera_alt),
                //   onPressed: getImageCamera,
                // ),
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
