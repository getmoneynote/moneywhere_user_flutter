import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/commons/index.dart';
import '/login/index.dart';


class ApiUrlInput extends StatefulWidget {
  const ApiUrlInput({super.key});
  @override
  State<ApiUrlInput> createState() => _ApiUrlInputState();
}

class _ApiUrlInputState extends State<ApiUrlInput> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    BlocProvider.of<LoginBloc>(context).add(ApiUrlChanged(session['apiUrl']));
    controller.value = controller.value.copyWith(text: session['apiUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, NotEmptyFormz>(
      selector: (state) => state.apiUrlFormz,
      builder: (context, state) {
        return TextField(
          controller: controller,
          onChanged: (value) => context.read<LoginBloc>().add(ApiUrlChanged(value)),
          decoration: InputDecoration(
            hintText: '后台地址(http://xxx/api/v1/)',
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            errorText: (state.isPure || state.isValid) ? null : 'http://xxx:xx/api/v1/' ,
          ),
        );
      },
    );
  }
}