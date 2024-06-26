```sh
                                                                                
                                                                                
               //,                                                              
      ##/ ### ////////          @@@/@@#                    @@#/@@ &@ #@@@@@/    
        ,### /   ***** ,**     *@    @@ @@./@%,@, @* @@ @@  @@@@. &@ #@   @@    
      ##( #,        .***,       @@   @@ @@  @@@@     @, @@ @@  ,@.&@ #@   @@    
       %##%,  ...   */ *.         *#,   @@.#    /(   ,  ,,   /#,  ., .,,,       
     ##% ##*  ###   */ ./                                                       
          ####### ///  //         @ @( @@%%@ &#@%, *   @@%&&&  @ & &#%% @@      
             /##                                                                
                                                                                

```sh
cat > /etc/lighttpd/check.conf << EOF
$HTTP["url"] =~ "^/check($|/)" {
  server.document-root = "/var/www/localhost"
  server.errorlog = "/var/log/lighttpd/error-check.log"
  accesslog.filename = "/var/log/lighttpd/access-check.log"
}
EOF

itawxrc="";itawxrc=$(grep 'include "check.conf' /etc/lighttpd/lighttpd.conf);[[ "$itawxrc" != "" ]] && echo listo || \
sed -i -r 's#.*include "mod_ssl.conf".*#include "mod_ssl.conf"\ninclude "check.conf"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart