<?php echo '<p>Hello World</p>'; ?> 
<?php echo '<script>alert("XSS");</script>'; ?> 
<?php echo 'scandir($path);'; ?> 
<?php scandir($path); ?> 
