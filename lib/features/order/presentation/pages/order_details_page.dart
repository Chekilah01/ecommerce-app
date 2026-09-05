import 'package:final_project/features/order/presentation/bloc/order_bloc.dart';
import 'package:final_project/features/order/presentation/bloc/order_event.dart';
import 'package:final_project/features/order/presentation/bloc/order_state.dart';
import 'package:final_project/features/order/presentation/widgets/order_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<OrderBloc>().add(
      LoadOrderById(widget.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == OrderStatusState.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(
                          LoadOrderById(widget.orderId),
                        );
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final order = state.selectedOrder;

          if (order == null) {
            return const Center(
              child: Text('Order not found.'),
            );
          }

          return OrderDetailsContent(order: order);
        },
      ),
    );
  }
}

