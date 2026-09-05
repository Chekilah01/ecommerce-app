import 'package:final_project/features/order/presentation/widgets/order_card.dart';
import 'package:final_project/features/order/presentation/bloc/order_bloc.dart';
import 'package:final_project/features/order/presentation/bloc/order_event.dart';
import 'package:final_project/features/order/presentation/bloc/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();

    context.read<OrderBloc>().add(const LoadOrders());
  }

  Future<void> _selectDateRange() async {
    final selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (selectedRange == null) {
      return;
    }

    setState(() {
      _selectedDateRange = selectedRange;
    });

    context.read<OrderBloc>().add(
      LoadOrders(
        startDate: selectedRange.start,
        endDate: selectedRange.end.add(const Duration(days: 1)),
      ),
    );
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });

    context.read<OrderBloc>().add(const LoadOrders());
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }

  Future<void> _refreshOrders() async {
    final range = _selectedDateRange;

    context.read<OrderBloc>().add(
      LoadOrders(
        startDate: range?.start,
        endDate: range?.end.add(const Duration(days: 1)),
      ),
    );

    await context.read<OrderBloc>().stream.firstWhere(
      (state) =>
          state.status == OrderStatusState.success ||
          state.status == OrderStatusState.failure,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDateFilter = _selectedDateRange != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrderStatusState.failure) {
            return Column(
              children: [
                _buildDateFilter(),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 50),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Something went wrong.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshOrders,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.orders.isEmpty) {
            return Column(
              children: [
                _buildDateFilter(),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshOrders,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/no_products.svg',
                                height: 150,
                                width: 150,
                              ),
                              const SizedBox(height: 32),
                              Text(
                                hasDateFilter
                                    ? 'No orders found for this period'
                                    : 'You have no orders yet',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (hasDateFilter) ...[
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: _clearDateFilter,
                                  child: const Text('Clear date filter'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _buildDateFilter(),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    itemCount: state.orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];

                      return OrderCard(
                        orderId: order.id,
                        date: order.createdAt,
                        itemCount: order.items.length,
                        total: order.total,
                        status: order.status,
                        onTap: () {
                          context.push('/customer/orders/${order.id}');
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateFilter() {
    final range = _selectedDateRange;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _selectDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(
                range == null
                    ? 'Filter by date'
                    : '${_formatDate(range.start)} - '
                          '${_formatDate(range.end)}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          if (range != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: _clearDateFilter,
              tooltip: 'Clear filter',
              icon: const Icon(Icons.clear),
            ),
          ],
        ],
      ),
    );
  }
}
