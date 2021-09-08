import './search_filters_screen.dart';
import 'api.dart';

class AppState{
  final SearchOptions searchOptions = SearchOptions(
   author: zAuthors,
   sort: zSort.first,
   order: zOrder.first,
   count: zMaxCount,
  );
}