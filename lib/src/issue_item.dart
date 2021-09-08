import 'package:flutter/material.dart';

class IssueItem extends StatelessWidget {
  final Issue issue;

  IssueItem(this.issue);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
     child:Card(
       color: Colors.white54,
       clipBehavior: Clip.antiAlias,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(5),
     ),
      child: Row(
        children: [
          Ink(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black87,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(issue.avatar))
            ),
          ),
          Flexible(
            child: Padding(
            padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  SizedBox(height: 5),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.adjust_rounded,
                  //     ),
                  //     Flexible(child: Text(issue.name),),
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  Row(
                     children: [
                       Icon(
                         Icons.link,
                         size: 15,
                       ),
                       Flexible(
                         child: Text(issue.url),),
                     ],
                  )
                  
                ],
            ),
          ),
          ),
          
          
        ],
      ),
    ));
   
  }
}

class Issue {
  final String title;
  final String url;
  final int id;
  final String avatar;
  final String name;

  Issue._ ({
    this.title,
    this.url,
    this.id,
    this.avatar,
    this.name,
  });

  factory Issue(Map json) => Issue._(
      title : json['title'],
      url : json['url'],
      avatar: json['user']['avatar_url'],
      id : json['user']['id']);
    
}

