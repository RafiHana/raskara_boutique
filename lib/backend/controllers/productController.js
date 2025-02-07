const multer = require('multer');
const path = require('path');
const Product = require('../models/ProductModel.js');

exports.getAllProducts = (req, res) => {
  Product.getAll((err, results) => {
    if (err) {
      console.error('Error fetching products:', err);
      return res.status(500).json({ error: err.message });
    }

    const formattedResults = results.map(product => ({
      ...product,
      imagePath: product.imagePath.startsWith('http')
        ? product.imagePath
        : `http://10.0.2.2:4000/uploads/${product.imagePath}`,  
    }));

    res.status(200).json(formattedResults);
  });
};


const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/uploads/');  
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); 
  },
});
const upload = multer({ storage: storage });

exports.createProduct = (req, res) => {
  upload.single('image')(req, res, function (err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    const { name, price } = req.body;
    if (!name || !price || !req.file) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    const imagePath = `http://10.0.2.2:4000/uploads/${req.file.filename}`; 
    Product.create({ name, price, imagePath }, (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ id: result.insertId, name, price, imagePath });
    });
  });
};

exports.deleteProduct = (req, res) => {
  const { id } = req.params;

  Product.delete(id, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json({ message: `Produk dengan ID ${id} berhasil dihapus` });
  });
};
