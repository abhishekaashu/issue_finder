import 'package:flutter/material.dart';
import './search_filters_screen.dart';
import 'app_state.dart';

import 'package:provider/provider.dart';
import './search_form.dart';
import './issue_item.dart';
import 'package:dio/dio.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title, this.dio}) : super(key: key);


  final String title;
  final Dio dio;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  String query;

  Future<List> searchIssues(String query, SearchOptions options) async{
    String labelQuery = "";
    for (String label in options.labels) {
      labelQuery = labelQuery + ' label:"$label"';
    }
    String searchQuery = query + ' is:issue is:open repo:docker/compose' + labelQuery + (options.author != "" ? ' author:' + options.author : '');
    final response = await widget.dio.get('https://api.github.com/search/issues', queryParameters: {
      'q' : searchQuery,
      'per_page' : options.count.toInt().toString(),
      ...(options != null ? options.toJson() : {}),
      }
    );
    //final response = await widget.dio.get('https://api.github.com/search/issues?q=frontend is:issuerepo:docker/compose');
    return response.data['items'];
    
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title:
          Text(
            widget.title, 
            style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true, 
        backgroundColor: Colors.black87,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchFilters(
                  dio: widget.dio,
                )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                Icons.tune,
              ),
            ),
          )
        ],
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Searchform(
              onSearch: (q){
                setState(() {
                  query = q;
                });
              }
            ),
            //SizedBox(height: 10),
            query ==  null
             ? Expanded(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black12,
                    size: 110,
                  ),
                  Text(
                    'No results to display',
                    style: TextStyle(
                      color: Colors.black12,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
             ))
             : FutureBuilder(
               future: searchIssues(query,state.searchOptions),
               builder: (context, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return Center(
                     child: CircularProgressIndicator(),
                   );
                 }
                 if(snapshot.hasData){
                   return Expanded(
                     child:ListView(
                        children: snapshot.data
                            .map<Widget>(
                              (json) => IssueItem(Issue(json))
                          
                        ).toList(),
                      ),
                    );
                 }
                 return Text(
                   'Error retrieving results: ${snapshot.error}'
                 );
               },
             )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
