const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController'); 
const paymentController = require('../controllers/paymentController');

router.get('/products', productController.getAllProducts);
router.post('/products', productController.createProduct);
router.delete('/products/:id', productController.deleteProduct); 

router.post('/create-payment', paymentController.createTransaction);

module.exports = router;
