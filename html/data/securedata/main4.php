<html>
	<meta http-equiv="refresh" content="1" />
</html>
<?php
	$output = shell_exec("cat unique/*");
	echo "<pre>$output</pre>";
?>