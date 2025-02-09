import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raskara_boutique/screens/payment_screen.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isSelecting = false;
  final Set<int> _selectedItems = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelecting = !_isSelecting;
      if (!_isSelecting) _selectedItems.clear();
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
    });
  }

  void _removeSelectedItems(CartProvider cartProvider) {
    if (_selectedItems.isEmpty) return;

    final itemsToRemove =
        _selectedItems.map((index) => cartProvider.cartItems[index]).toList();
    for (var item in itemsToRemove) {
      cartProvider.removeItem(item);
    }

    setState(() {
      _isSelecting = false;
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0C1F7),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItems = cartProvider.cartItems;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 10),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItem(
                      name: cartItems[index].name,
                      price: cartItems[index].price,
                      isSelecting: _isSelecting,
                      isSelected: _selectedItems.contains(index),
                      onToggleSelection: () => _toggleItemSelection(index),
                    );
                  },
                ),
              ),
              CartBottomBar(
                totalPrice: cartProvider.totalPrice,
                isSelecting: _isSelecting,
                onDeletePressed: _toggleSelectionMode,
                onConfirmDelete: () => _removeSelectedItems(cartProvider),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final double price;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback onToggleSelection;

  const CartItem({
    super.key,
    required this.name,
    required this.price,
    required this.isSelecting,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSelecting)
            Checkbox(
              value: isSelected,
              onChanged: (value) => onToggleSelection(),
            ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "Rp.${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  final double totalPrice;
  final bool isSelecting;
  final VoidCallback onDeletePressed;
  final VoidCallback onConfirmDelete;

  const CartBottomBar({
    super.key,
    required this.totalPrice,
    required this.isSelecting,
    required this.onDeletePressed,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
      ),
      child: Row(
        children: [
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.check, size: 28, color: Colors.green),
              onPressed: onConfirmDelete,
            )
          else
            IconButton(
              icon: const Icon(Icons.delete, size: 28),
              onPressed: onDeletePressed,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isSelecting
                  ? null
                  : () {
                      print("Checkout button pressed!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          print("Navigating to PaymentScreen...");
                          return PaymentScreen();
                        }),
                      ).then((_) {
                        print("Returned from PaymentScreen");
                      });
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Rp.${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')}",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
