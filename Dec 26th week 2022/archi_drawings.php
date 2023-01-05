<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Architectural drawings</title>
    <style>
      *{
              margin:0;
              padding:0;
              text-decoration: none;
              box-sizing: border-box;
              list-style: none;
            }
      body{
         font-family: 'Roboto',sans-serif;
         background: #B6D0E2;
         color: black;
         text-align: center;
      }
      br{
        display: block;
        margin: 100px;
      }
      #submitbutton
{
  width:100px;
  height: 50px;
  background-color: Orange;
  color:black;
}
#submitbutton:hover
{
background-color: Grey;
color: white;
}
.topnav{
  background-color: #333;
  overflow: hidden;
}
.topnav a{
  float: right;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}
.topnav a:hover{
  background-color: #ddd;
  color: black;
}
.topnav a.active{
  background-color: #24bdd1;
  color: white;
}
a{
  text-decoration:none;
  display:inline-block;
  padding: 8px 16px;
}
a:hover{
  background-color: #ddd;
  color:black;
}
.previous{
  background-color: #f1f1f1;
  color: black;
}
.next{
  background-color: #3D75EE;
  color: white;
}
      </style>
</head>
<body>
<div class="topnav">
  <img src="logo.png" width="200px" height="50px" align="left"></img>
  <u1>
  <li> <a href="support.php">Support</a></li>
  <li> <a class="active" href="index.php">Home</a></li>
  </ul>
</div>
<br>
<br>
  <p style="font-size:30px"><strong>Instant architectural drawings!</strong></p>
  <form method="post">
        <input type="email" name="emailid" id="emailid" required />
        <br>
        <br>
        <p font-size="100px">Enter your mail address to access the software </p>
        <br>
        <input type="submit" name="upload" value="Submit" id="submitbutton" style="height:50px; width: 100px;background-color:Orange;font-size:20px; border:none" onclick="show()"/>
        <br>
    </form>
    <br>
    <div id="dim">
    <p> What is the dimensions of your site? </p>
      <br>
  <form>
    <input type="number" id="length" name="length">Length (in feet)</input>
    <br>
    <br>
    <input type="number" id="breadth" name="breadth">Breadth (in feet)</input>
    <br>
    <br>
    <input type="submit" value="OK" id="dimensions">
    <br>
  </form>
</div>
  <script>
    const div = document.getElementById("dim");
    document.getElementById("submitbutton").onclick = function show() {
      if (div.style.display === "none"){
      div.style.display = "block";
    } else {
      div.style.display = "none";
    }
    };
    </script>
  <?php
  ini_set('display_errors',1);
  ini_set('display_startup_errors',1);
  error_reporting(E_ALL);
  if (isset($_POST["upload"])){
    $email_address = $_POST["emailid"];
if(!empty($email_address))
{
    echo $email_address;
    echo "<br>";
    echo "We have recieved your mail id";
    echo "<br>";
    $host="localhost";
    $username="gayathri_qwikdraft";
    $password=",rO=nhK[8";
    $database="email_addresses";
    $conn=mysqli_connect($host,$username,$password);
      mysqli_select_db($conn,$database);
      if (mysqli_connect_error()){
          echo "we are not connected to the database";
          die('Connect Error('.mysqli_connect_errorno().')'.mysqli_connect_error());  
      }
  else {
      
      //cho "we are connected to database";
          $SELECT = "SELECT Email FROM user_email";
          $INSERT = "INSERT into user_email (Email) values (?)";
          $stmt=$conn->prepare($INSERT);
          $stmt->bind_param("s",$email_address);
          $stmt->execute();
          $stmt->store_result();
          $rnum = $stmt->num_rows;
          $stmt->close();
          $conn->close();       
}
}
  }

  ?>
</body>
</html>
