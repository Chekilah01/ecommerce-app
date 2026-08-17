import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('admin/products/add');
        },
        child: const Icon(Icons.add),
        ),
    );
  }
}