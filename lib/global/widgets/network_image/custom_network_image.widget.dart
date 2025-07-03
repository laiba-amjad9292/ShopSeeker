import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// category_default_icon.png

class NetworkImageCustom extends StatefulWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;
  final String? defaultImage;

  const NetworkImageCustom(
      {Key? key,
      this.height,
      this.width,
      this.image,
      this.defaultImage,
      this.radius = 5,
      this.fit})
      : super(key: key);

  @override
  State<NetworkImageCustom> createState() => _NetworkImageCustomState();
}

class _NetworkImageCustomState extends State<NetworkImageCustom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: widget.image == '' ||
              widget.image?.contains('http') == false ||
              widget.image?.contains('.mp4') == true ||
              widget.image?.contains('.mp3') == true
          ? Image.asset(
              height: widget.height,
              width: widget.width,
              widget.defaultImage ?? "assets/images/img_placeholder.png",
              fit: widget.fit != null ? widget.fit! : BoxFit.cover)
          : CachedNetworkImage(
              placeholder: ((context, url) => Image.asset(
                  height: widget.height,
                  width: widget.width,
                  widget.defaultImage ?? "assets/images/img_placeholder.png",
                  fit: widget.fit != null ? widget.fit! : BoxFit.cover)),
              imageUrl: widget.image ?? "",
              height: widget.height,
              width: widget.width,
              errorWidget: ((context, url, error) => Image.asset(
                  height: widget.height,
                  width: widget.width,
                  widget.defaultImage ?? "assets/images/img_placeholder.png",
                  fit: widget.fit != null ? widget.fit! : BoxFit.cover)),
              fit: widget.fit != null ? widget.fit! : BoxFit.cover),
    );
  }
}
