const Product = require('../models/ProductModel.js');

exports.getAllProducts = (req, res) => {
  Product.getAll((err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json(results);
  });
};

exports.createProduct = (req, res) => {
  const { name, price, imagePath } = req.body;

  if (!name || !price || !imagePath) {
    return res.status(400).json({ error: 'Semua field harus diisi' });
  }

  Product.create({ name, price, imagePath }, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ id: result.insertId, name, price, imagePath });
  });
};

exports.deleteProduct = (req, res) => {
  const { id } = req.params;

  Product.delete(id, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json({ message: `Produk dengan ID ${id} berhasil dihapus` });
  });
};
