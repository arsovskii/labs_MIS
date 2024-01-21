import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/home/kol_grid.dart';
import 'package:lab3/screens/modals/kol_add.dart';

import '../../services/auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AuthService.getEmailOfCurrentUser().toString()),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return kol_modal();
                },
              )
            },
          )
        ],
      ),
      body: Container(
        child: kol_grid(),
      ),
    );
  }
}
