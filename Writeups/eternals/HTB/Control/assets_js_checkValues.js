//assets/js/checkValues.js

function checkValues(form) {
   if (form == "updateProduct") {
      var name = document.forms["updateProduct"]["name"].value;
      var quantity = document.forms["updateProduct"]["quantity"].value;
      var price = document.forms["updateProduct"]["price"].value;
      if (name.length <= 0) {
         alert("Name cannot be empty!");
         return false;
      }
      if (quantity < 0 || quantity == "") {
         alert("Quantity cannot be less than 0!");
         return false;
      }
      if (price == 0 || price.includes("-")) {
         alert("Price must be greater than 0");
         return false;
      }
   } else if (form == "createProduct") {
      var name = document.forms["createProduct"]["name"].value;
      var quantity = document.forms["createProduct"]["quantity"].value;
      var price = document.forms["createProduct"]["price"].value;
      if (name.length <= 0) {
         alert("Name cannot be empty!");
         return false;
      }
      if (quantity < 0 || quantity == "") {
         alert("Quantity cannot be less than 0!");
         return false;
      }
      if (price == 0 || price.includes("-")) {
         alert("Price must be greater than 0");
         return false;
      }
   } else if (form == "createCategory") {
      var name = document.forms["createCategory"]["name"].value;
      if (name.length <= 0) {
         alert("Name cannot be empty!");
         return false;
      }
   } else if (form == "updateCategory") {
      var name = document.forms["updateCategory"]["name"].value;
      if (name.length <= 0) {
         alert("Name cannot be empty!");
         return false;
      }
   }
   return true;
}