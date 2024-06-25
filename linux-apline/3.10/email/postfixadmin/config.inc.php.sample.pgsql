$CONF['configured'] = true;
$CONF['setup_password'] = "";  << Don't change this yet
$CONF['database_type'] = 'pgsql';
$CONF['database_host'] = 'localhost';
$CONF['database_user'] = 'postfix';
$CONF['database_password'] = '*****';   << The password you chose above
$CONF['database_name'] = 'postfix';
$CONF['database_prefix'] = "";
$CONF['admin_email'] = 'you@some.email.com';  << Your email address 
$CONF['encrypt'] = 'dovecot:SHA512-CRYPT';
$CONF['authlib_default_flavor'] = 'SHA';
$CONF['dovecotpw'] = "/usr/bin/doveadm pw";
$CONF['domain_path'] = 'YES';
$CONF['domain_in_mailbox'] = 'NO';
$CONF['aliases'] = '10';                       
$CONF['mailboxes'] = '10';
$CONF['maxquota'] = '10';
$CONF['quota'] = 'YES';
$CONF['quota_multiplier'] = '1024000';
$CONF['vacation'] = 'NO'; 
$CONF['vacation_control'] ='NO';
$CONF['vacation_control_admin'] = 'NO';
$CONF['alias_control'] = 'YES';
$CONF['alias_control_admin'] = 'YES';
$CONF['special_alias_control'] = 'YES';
$CONF['fetchmail'] = 'NO';
$CONF['user_footer_link'] = "http://host.example.com/postfixadmin";
$CONF['footer_link'] = 'http://host.example.com/postfixadmin/main.php';
$CONF['create_mailbox_subdirs_prefix']="";  
$CONF['used_quotas'] = 'YES';   
$CONF['new_quota_table'] = 'YES';