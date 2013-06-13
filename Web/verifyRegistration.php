 <?
if(empty($_POST['nameContact']))
{
	die('{"status":"0","txt":"Введите имя."}');
}

 

if(empty($_POST['emailContact']) || empty($_POST['emailContact']))
{
	die('{"status":"0","txt":"Введите адрес электронной почты."}');
}

// is the email valid?

if(!(preg_match("/^[\.A-z0-9_\-\+]+[@][A-z0-9_\-]+([.][A-z0-9_\-]+)+[A-z]{1,4}$/", $_POST['emailContact'])))
	die('{"status":"0","txt":"Адрес электронной почты указан неверно."}');

 if((strtotime($_POST['datefrom'])-strtotime($_POST['dateto'])) > 0)
{
	die('{"status":"0","txt":"Дата начала больше даты конца периода."}');
}
	
	
require_once('recaptchalib.php');
$privatekey = "6LclSMsSAAAAAN63Sq-QtsR3owjnoJO6OSuNrlFs";



$resp = recaptcha_check_answer ($privatekey,
							$_SERVER["REMOTE_ADDR"],
							$_POST["recaptcha_challenge_field"],
							$_POST["recaptcha_response_field"]);

if (!$resp->is_valid) {
// What happens when the CAPTCHA was entered incorrectly
		die('{"status":"0","txt":"Неправильно введен код с картинки. Попробуйте обновить его и ввести еще раз."}');
} else {
// Your code here to handle a successful verification
}
	
	
echo '{"status":"1","txt":"/Home/MessageSent"}';

  ?>
  
