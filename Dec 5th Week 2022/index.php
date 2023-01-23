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
  <li> <a href="support.php">Contact us</a></li>
  <li> <a class="active" href="index.php">Home</a></li>
  </ul>
</div>
<br>
<br>
  <p style="font-size:60px"><strong>Click the below links for the software!</strong></p>
  <br>
  <p style="font-size:30px">To generate automated Civil design according to Indian standards!</p>
  <br>
  <a href="/Design.php"> Design </a>
<br>
  <br>
  <p style="font-size:30px">To generate automated Civil Structural drawings</p>
  <br>
<a href="/Column Details.php"> Column Details </a>
<br>
<a href ="/Beam Details.php"> Beam Details </a>
<br>
<a href ="/Footing Details.php"> Footing Details </a>
<br>
<a href ="/Slab Details.php"> Slab Details </a>
<br>
<a href ="/Grid Lines.php"> Grid Lines </a>
<br>
<a href ="/Architectural drawings.php"> Architectural drawings </a>
<br>
<?php
// import dependencies (using composer's autoload)
// if not using Composer, you'll want to require the
require "/home/g6bau7mbk3r2/mixpanel-php-master/lib/Mixpanel.php";
// get the Mixpanel class instance with your project token
$mp = Mixpanel::getInstance("4eee140182cfa0f760f4527869bfcc6a", array("host" => "api-eu.mixpanel.com"));

// get the Mixpanel class instance, replace with your
// project token
$mp = Mixpanel::getInstance("MIXPANEL_PROJECT_TOKEN");

// track an event
$mp->track("button clicked", array("label" => "sign-up"));
$mp = Mixpanel::getInstance("MIXPANEL_PROJECT_TOKEN");

// create or update a profile with First Name, Last Name,
// E-Mail Address, Phone Number, and Favorite Color
// without updating geolocation data or $last_seen
?>

</body>
</html>