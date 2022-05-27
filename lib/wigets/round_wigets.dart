

//이건 프로필이랑,
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkCircleImg({ String imgurl,  double imgsize,  IconData replaceicon}) {
  return imgurl.isEmpty? CircleAvatar(
      backgroundColor: Colors.white,
      radius: imgsize*0.5,
      child: Icon(replaceicon, size: imgsize,
        color: Colors.black54,
      )):ClipOval(
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      width: imgsize,
      height: imgsize,
      imageUrl: imgurl,
      placeholder: (context, url) =>  CircularProgressIndicator(),
      errorWidget: (context, url, error) =>  CircleAvatar(
          backgroundColor: Colors.white,
          radius: imgsize*0.5,
          child: Icon(replaceicon, size: imgsize,
            color: Colors.black54,
          )),
    ),
  );
}

CircleAvatar iconAvata(double size, {double sizefactor=1.25}) {
  return CircleAvatar(
    radius: size,
    backgroundColor: Colors.white,
    child: Image.asset('assets/images/icon1.png', width: size*sizefactor, height:size*sizefactor,),
  );
}