import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets_owner/generated/i18n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';
import 'package:http/http.dart' as http;

class ProductItemWidget extends StatefulWidget {
   String heroTag;
   Product product;


  ProductItemWidget({Key key, this.product, this.heroTag}) : super(key: key);


  @override
  ProductItemWidgetState createState() => ProductItemWidgetState();

}
  class ProductItemWidgetState extends StateMVC<ProductItemWidget> {
    bool isSwitched=false ;

  @override
  Widget build(BuildContext context) {


    return InkWell(

      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
     //   Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: widget.product.id, heroTag: t));
      },
      child: Container(

          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.heroTag + widget.product.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        imageUrl: widget.product.image.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Row(
                                children: Helper.getStarsList(widget.product.getRate()),
                              ),
                              Text(
                                widget.product.options.map((e) => e.name).toList().join(', '),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Helper.getPrice(
                              widget.product.price,
                              context,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            widget.product.discountPrice > 0
                                ? Helper.getPrice(widget.product.discountPrice, context,
                                style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(decoration: TextDecoration.lineThrough)))
                                : SizedBox(height: 0),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Switch(
                value:widget.product.status ,
                onChanged: (value) {
                  setState(() {
                    widget.product.status = !widget.product.status;
                     if (value) {
                       updateStatus("1",widget.product.id.toString());
                       debugPrint("data 1");
                     } else {
                       updateStatus("0",widget.product.id.toString());
                       debugPrint("data 2");
                     }
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          )
      ),
    );
  }

    Future<String> updateStatus(String status,String prouctID) async {
      debugPrint("data $status");
      var response = await http.get(
          Uri.encodeFull("http://65.0.152.250/public/update_product/$prouctID/$status"),
          headers: {"Accept": "application/json"});

      debugPrint("data"+response.body);



      return "Success!";
    }
}
