import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/search/presentation/widgets/search_main_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ic.sl<PostCubit>(),
      child: SearchMainWidget(),
    );
  }
}
