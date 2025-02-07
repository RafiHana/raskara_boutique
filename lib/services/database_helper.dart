// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/product.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('products.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE products (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         price TEXT,
//         imagePath TEXT
//       )
//     ''');
//   }

//   Future<int> insertProduct(Product product) async {
//     final db = await instance.database;
//     return await db.insert('products', product.toMap());
//   }

//   Future<List<Product>> getAllProducts() async {
//     final db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query('products');
//     return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
//   }

//   Future<void> deleteProduct(int id) async {
//     final db = await instance.database;
//     await db.delete(
//       'products',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }