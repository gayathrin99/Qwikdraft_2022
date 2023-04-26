<!DOCtype html>
<html>
    <head>
      <!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-T81JEY43DV"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-T81JEY43DV');
</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
  background-color: #04AA6D;
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
  <p style="font-size:30px"><strong>Instant detailed drawings!</strong></p>
  <br>
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
    <div id="youtube_video">  
    <p align="center">  
          <iframe width="560" height="315" src="https://www.youtube.com/embed/y1l-Zpfc0_k" title="Qwikdraft - Beam Details" frameborder="0" allowfullscreen></iframe>
            </p>
            <br>
          </div>
    <script>
      const div = document.getElementById("youtube_video");
  const bt = document.getElementById("submitbutton");
  bt.onclick = function show() {
    if (div.style.display === "none"){
      div.style.display = "block";
    } else {
      div.style.display = "none";
    }
    };
      </script>
    <button id="pay_button" onclick="paymentfunc()"> I want to pay </button>
    <div id="payment" style="display:none;"> Pay Rs.1000 for drawings for the software and we will return it if you aren't satissfied
    <br>
            <img src="gpayscan.jpeg" height="300" width="300" align="middle">
<br>
</div>
<script>
  const targetDiv = document.getElementById("payment");
  function paymentfunc() {
    if (targetDiv.style.display === "none"){
      targetDiv.style.display = "block";
    } else {
      targetDiv.style.display = "none";
    }
    };
    </script>
<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;
require "/home/u1ewclzlplgf/public_html/PHPMailer-master/src/PHPMailer.php";
require "/home/u1ewclzlplgf/public_html/PHPMailer-master/src/Exception.php";
require "/home/u1ewclzlplgf/public_html/PHPMailer-master/src/SMTP.php";
if (isset($_POST["upload"])){
    $email_address = $_POST["emailid"];
    echo $email_address;
    $mail = new PHPMailer(true);
    if(!empty($email_address))
{
    {
        //echo $email_address;
        //echo "<br>";
        //echo "We have recieved your mail id";
        echo "<br>";
        $host="localhost";
        $username="gayathri_n";
        $password="Varalakshmi@99";
        $database="email_addresses";
        $to = $email_address;
        $from="qwikdraft@gmail.com";
          $subject ='Qwikdraft - Footing Details';
          $message = '<!DOCTYPE html>
          <head>
          <meta http-equiv="Content-Type" content="text/html; charset="utf-8" />
          </head>
          <body>
          <div>
          <p>Hello there, </p>
          <p>Thank you for signing up with Qwikdraft.</p>
          <p>Download the program from the link on the website.</p>
          <p>Thank you.</p>
          </div>
          </body>
          </html>
          ';
          echo '<a href="/Footing details.zip" download="Footing details"> Download </a>';
          $message = stripslashes($message);
         $headers="Content-type: text/html; charset=UTF-8"."\r\n";
         $headers .= "MIME-Version: 1.0"."\r\n";
         $headers .= "From: qwikdraft@gmail.com". "\r\n" . "CC: qwikdraft@gmail.com";
    $mail->SMTPOptions = array (
      'ssl' => array(
          'verify_peer'=>false,
          'verify_peer_name'=>false,
          'allow_self_signed'=>true,
      ),
      );
    } 
    // Send email 
    $mail = @mail($to, $subject, $message, $headers);  
     
    // Email sending status 
          //echo $mail?"<h1>Email Sent Successfully!</h1>":"<h1>Email sending failed.</h1>"; 
         // echo "Sent you a mail";
          $host="localhost";
          $username="gayathri_n";
          $password="Varalakshmi@99";
          $database="email_addresses";
          $conn=mysqli_connect($host,$username,$password);
          mysqli_select_db($conn,$database);
          if (mysqli_connect_error()){
              echo "we are not connected to the database";
              die('Connect Error('.mysqli_connect_errorno().')'.mysqli_connect_error());  
          }
      else {
          
          //cho "we are connected to database";
              $SELECT = "SELECT Email_Address FROM user_email";
              $INSERT = "INSERT into user_email (Email_Address) values (?)";
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