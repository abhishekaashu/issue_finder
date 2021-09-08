import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
      baseUrl: 'https://api.github.com/repos/docker/compose/issues',
      //headers: {
        //'user-key': DotEnv().env['GITHUB_API_KEY']
      //}
  ));