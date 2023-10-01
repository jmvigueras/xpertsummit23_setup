<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
    <title>Portal de acceso Cloud workshop – Fortinet </title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>  
	function redirect(){
                tokenid=document.getElementById('tokenid').value
                window.location = "http://${lab_fqdn}/"+tokenid
        };	
  </script> 
  </head>
  <body>
    <h1><span style="color:Red">Fortinet</span> - Cloud workshop</h1>
    <p></p>
    <hr/>
    <h3>Introduce codigo del laboratorio:</h3>
        <input type="text" id="tokenid" name="tokenid"> 
        <button id="btn1" type="button" onclick=redirect()>Go</button>
  </body>
</html>

