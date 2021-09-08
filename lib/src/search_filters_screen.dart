import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'api.dart';

class SearchFilters extends StatefulWidget {


  final Dio dio;


  SearchFilters({this.dio});

  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  List<Category> _categories;


  Future<List<Category>> getCategories() async {
    final response = await widget.dio.get('https://api.github.com/repos/docker/compose/labels');
    final data = response.data;
    return data.map<Category>((json) => Category(
      json['id'],
      json['name'])).toList();
  }

  

  @override
  void initState() {
    super.initState();
    
    getCategories().then((categories){
      setState(() {
              _categories = categories;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<GithubApi>(context);
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey,
      body: Container (
        child: ListView(
          children: [ 
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Author',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                            state.searchOptions.author = value;
                        });
                      }),
                  SizedBox(height: 30),
                  Text(
                      'Order by:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  for(int idx = 0; idx < api.order.length; idx++)  
                    RadioListTile(
                      title: Text(api.order[idx]),
                      value: api.order[idx], 
                      groupValue: state.searchOptions.order, 
                      onChanged: (selection) {
                        setState(() {
                           state.searchOptions.order = selection;                        
                        });
                      }),  
                  SizedBox(height: 30),
                  Text(
                      'Sort by:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  Wrap(
                    spacing: 20,
                    children: api.sort.map<ChoiceChip>((sort){
                      return ChoiceChip(
                        label: Text(sort),
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontWeight: FontWeight.bold),
                        selected: state.searchOptions.sort == sort,
                        onSelected: (selected) {
                          if(selected) {
                            setState(() {
                              state.searchOptions.sort = sort;                            
                            });
                          }
                        },
                      );
                    }
                    ).toList(),
                  ),  
                  SizedBox(height: 30),
                  Text(
                      'No. of results to show:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  Slider(
                    activeColor: Colors.black54,
                    inactiveColor: Colors.black26,
                    value: state.searchOptions.count ?? 5, 
                    min: 3, 
                    max: 30,
                    label: state.searchOptions.count?.round().toString(),
                    divisions: 3, 
                    onChanged: (value) {
                      setState(() {
                        state.searchOptions.count = value;
                                             
                      });
                    }
                  ),  
                  SizedBox(height: 30),     
                  Text(
                    'Labels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    _categories is List<Category> ? Wrap(
                      spacing: 10,
                      children: List<Widget>.generate(_categories.length, (index) {
                        final category = _categories[index];
                        final isSelected = state.searchOptions.categories.contains(category.id);

                        return FilterChip(
                          label: Text(category.name),
                          labelStyle: TextStyle(
                            color: isSelected 
                              ? Colors.white 
                              : Theme.of(context).textTheme.bodyText1.color,
                            fontWeight: FontWeight.bold),
                          selected: isSelected,
                          selectedColor: Colors.black54,
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            setState(() {
                                if(selected){
                                  state.searchOptions.categories.add(category.id);
                                  state.searchOptions.labels.add(category.name);
                                }else{
                                  state.searchOptions.categories.remove(category.id);
                                  state.searchOptions.labels.remove(category.name);
                                }
                            });
                          },
                            
                          );
                      })
                    ) : Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),),
                    SizedBox(height: 30),
                    
                ],
              ),
            ),
          ]
        ),),
    );
  }
}

class SearchOptions {
  String author;
  String order;
  String sort;
  double count;
  List<int> categories = [];
  List<String> labels = [];

  SearchOptions({
    this.author, 
    this.order, 
    this.sort,
    this.count,
  });

  Map<String, dynamic> toJson() => {
    'author': author,
    'order': order,
    'sort': sort,
    'count': count,
    'category': categories.join(','),
    'labels': labels.join(',')
  };
  
}

class Category {
  final int id;
  final String name;
  const Category(this.id,this.name);
  
}