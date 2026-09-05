import 'package:final_project/features/order/domain/entities/order_status.dart';
import 'package:final_project/features/order/presentation/bloc/order_bloc.dart';
import 'package:final_project/features/order/presentation/bloc/order_event.dart';
import 'package:final_project/features/order/presentation/bloc/order_state.dart';
import 'package:final_project/features/order/presentation/widgets/order_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  State<AdminOrderDetailsPage> createState() =>
      _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState
    extends State<AdminOrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<OrderBloc>().add(
      LoadOrderById(widget.orderId),
    );
  }

  Future<void> _confirmOrder() async {
    final confirmed = await _showConfirmationDialog(
      title: 'Confirm Order',
      message:
          'Are you sure you want to confirm this order? '
          'The product stock will be reduced.',
      confirmText: 'Confirm',
    );

    if (!mounted || confirmed != true) {
      return;
    }

    context.read<OrderBloc>().add(
      ConfirmOrder(widget.orderId),
    );
  }

  Future<void> _cancelOrder() async {
    final confirmed = await _showConfirmationDialog(
      title: 'Cancel Order',
      message: 'Are you sure you want to cancel this order?',
      confirmText: 'Cancel Order',
      isDestructive: true,
    );

    if (!mounted || confirmed != true) {
      return;
    }

    context.read<OrderBloc>().add(
      CancelOrder(widget.orderId),
    );
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: isDestructive
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    )
                  : ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
              child: Text(confirmText),
            ),
          ],
        );
      },
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
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatusState.actionSuccess &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
              ),
            );
          }

          if (state.status == OrderStatusState.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == OrderStatusState.loading &&
              state.selectedOrder == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == OrderStatusState.failure &&
              state.selectedOrder == null) {
            return _buildErrorState(state);
          }

          final order = state.selectedOrder;

          if (order == null) {
            return const Center(
              child: Text('Order not found.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: OrderDetailsContent(
                  order: order,
                ),
              ),

              if (order.status == OrderStatus.pending)
                _buildActionButtons(
                  isLoading:
                      state.status == OrderStatusState.loading,
                ),

              if (order.status != OrderStatus.pending)
                _buildStatusMessage(order.status),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(OrderState state) {
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
              state.errorMessage ??
                  'Something went wrong.',
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

  Widget _buildActionButtons({
    required bool isLoading,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, -3),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : _cancelOrder,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  disabledForegroundColor:
                      Colors.grey.shade400,
                  side: BorderSide(
                    color: isLoading
                        ? Colors.grey.shade400
                        : Colors.red,
                  ),
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      Colors.grey.shade400,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm Order',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(OrderStatus status) {
    final isConfirmed =
        status == OrderStatus.confirmed;

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, -3),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConfirmed
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: isConfirmed
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              isConfirmed
                  ? 'This order has been confirmed.'
                  : 'This order has been cancelled.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isConfirmed
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}