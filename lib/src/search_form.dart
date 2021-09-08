import 'package:flutter/material.dart';

class Searchform extends StatefulWidget {
  Searchform({ this.onSearch });

  final void Function(String search) onSearch;

  @override
  _SearchformState createState() => _SearchformState();
}

class _SearchformState extends State<Searchform> {
  final _formKey = GlobalKey<FormState>();

  var _autovalidate = false;
  var _search;

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(15),
            child:Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Enter Search',
                        border: OutlineInputBorder(),
                        filled: true,
                        errorStyle: TextStyle(fontSize: 15),
                      ),
                      onChanged: (value){
                          _search = value;
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Please enter a search term';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                          onPressed: () {
                            final isValid = _formKey.currentState.validate();
                            if(isValid){
                              widget.onSearch(_search);
                              FocusManager.instance.primaryFocus.unfocus();
                            }else{
                              setState(() {
                                _autovalidate = true;
                              });
                            }
                          },
                          fillColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
            )));
  }
}

