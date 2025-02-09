import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';
import '../providers/cart_provider.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Product> products = [];
  List<int> selectedItems = [];
  bool isDeleteMode = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _showAddProductDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    File? selectedImage;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Harga Produk'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      selectedImage = File(image.path);
                    }
                  },
                  child: Text('Pilih Gambar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    selectedImage != null) {
                  try {
                    final newProduct = Product(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      imagePath: '',
                    );

                    await ApiService.addProduct(newProduct, selectedImage!);

                    await _loadProducts();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menambahkan produk: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap isi semua field!')),
                  );
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadProducts() async {
    try {
      final loadedProducts = await ApiService.getProducts();
      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  void _startDeleteMode() {
    setState(() {
      isDeleteMode = true;
      selectedItems.clear();
    });
  }

  void _cancelDeleteMode() {
    setState(() {
      isDeleteMode = false;
      selectedItems.clear();
    });
  }

  Future<void> _deleteSelectedProducts() async {
    for (int index in selectedItems) {
      await ApiService.deleteProduct(products[index].id!);
    }
    await _loadProducts();
    _cancelDeleteMode();
  }

  void _addToCart(int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(products[index]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${products[index].name} ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0C1FF),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 55, left: 16, right: 16, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 81, 6, 243),
                    ),
                  ),
                  Row(
                    children: [
                      if (isDeleteMode) ...[
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: _cancelDeleteMode,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: selectedItems.isEmpty
                              ? null
                              : _deleteSelectedProducts,
                        ),
                      ] else
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/minus.svg',
                            width: 10,
                            height: 10,
                            color: Color.fromARGB(255, 81, 6, 243),
                          ),
                          onPressed: _startDeleteMode,
                        ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/plus.svg',
                          width: 24,
                          height: 24,
                          color: Color.fromARGB(255, 81, 6, 243),
                        ),
                        onPressed: _showAddProductDialog,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/cart.svg',
                          width: 24,
                          height: 24,
                          color: Color.fromARGB(255, 81, 6, 243),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isSelected = selectedItems.contains(index);

                  return GestureDetector(
                    onTap: isDeleteMode ? () => _toggleSelection(index) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(color: Colors.red, width: 3)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.network(
                                product.imagePath ?? '',
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(),
                            child: Text(
                              product.name,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(),
                            child: Text(
                              "Rp.${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                          ),
                          if (!isDeleteMode)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () => _addToCart(index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    '+ Add to cart',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
