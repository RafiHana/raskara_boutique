const db = require('../config/db');

class Product {
  static getAll(callback) {
    db.query('SELECT id, name, price, imagePath FROM products ORDER BY id DESC', callback);
  }  

  static create({ name, price, imagePath }, callback) {
    db.query(
      'INSERT INTO products (name, price, imagePath) VALUES (?, ?, ?)',
      [name, price, imagePath],
      callback
    );
  }

  static delete(id, callback) {
    db.query('DELETE FROM products WHERE id = ?', [id], callback);
  }
}

module.exports = Product;
