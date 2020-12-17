import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets_owner/src/controllers/market_controller.dart';
import 'package:markets_owner/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/market.dart';
import 'package:http/http.dart' as http;

class CardWidget extends StatefulWidget {
  final Market market;
  final String heroTag;

  CardWidget({Key key, this.market, this.heroTag}) : super(key: key);

  @override
  CardWidgettState createState() => CardWidgettState();

}



  class CardWidgettState extends StateMVC<CardWidget> {
  bool isSwitched=false ;
  MarketController _con;


  CardWidgettState() : super(MarketController()) {
    _con = controller;
  }




  @override
  Widget build(BuildContext context) {

    return Container(

      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[

              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/Details',
                      arguments: RouteArgument(
                        id: widget.market.id,
                        heroTag: 'my_markets',
                      ));
                }, // handle your image tap here
                child: ClipRRect(

                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),

                  child: CachedNetworkImage(

                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                ),
              ),
             /* Hero(
                tag: this.widget.heroTag + widget.market.id,
                child: ClipRRect(

                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),

                  child: CachedNetworkImage(

                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                ),
              ),*/

              Row(

                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(color: widget.market.closed ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(24)),
                    child: widget.market.closed
                        ? Text(
                      S.of(context).closed,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    )
                        : Text(
                      S.of(context).open,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(color: widget.market.availableForDelivery ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(24)),
                    child: widget.market.availableForDelivery
                        ? Text(
                      S.of(context).delivery,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    )
                        : Text(
                      S.of(context).pickup,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.market.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(widget.market.description),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: Helper.getStarsList(double.parse(widget.market.rate)),
                          ),
                          Switch(
                            value: !widget.market.closed ,
                            onChanged: (value) {
                              setState(() {
                                widget.market.closed =!widget.market.closed;
                                if (value) {
                                  updateStatus("0",widget.market.id.toString());
                                  debugPrint("data 1");
                                } else {
                                  updateStatus("1",widget.market.id.toString());
                                  debugPrint("data 2");
                                }
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String> updateStatus(String value,String id) async {
    var response = await http.get(
        Uri.encodeFull("http://65.0.152.250/public/update_status/$id/$value"),
        headers: {"Accept": "application/json"});

    /* var parsedJson = json.decode(response.body);*/

    debugPrint("data " +response.body);
    return "Success!";
  }

}
