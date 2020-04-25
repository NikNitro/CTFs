function deleteProduct(id) {
	document.getElementById("productId").value = id;
	document.forms["viewProducts"].action = "delete_product.php";
	document.forms["viewProducts"].submit();
}
function updateProduct(id) {
	document.getElementById("productId").value = id;
	document.forms["viewProducts"].action = "update_product.php";
	document.forms["viewProducts"].submit();
}
function viewProduct(id) {
	document.getElementById("productId").value = id;
	document.forms["viewProducts"].action = "view_product.php";
	document.forms["viewProducts"].submit();
}
function deleteCategory(id) {
	document.getElementById("categoryId").value = id;
	document.forms["categoryOptions"].action = "delete_category.php";
	document.forms["categoryOptions"].submit();
}
function updateCategory(id) {
	document.getElementById("categoryId").value = id;
	document.forms["categoryOptions"].action = "update_category.php";
	document.forms["categoryOptions"].submit();
}