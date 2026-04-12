## 1. Introduction

Self-signed certificates are digital certificates created by a server itself, acting as its issuer, rather than having them verified and signed by a trusted third party known as the Certificate Authority (CA). These certificates enable a secure connection to an HTTPS server.

However, this ease of use comes at a cost. While self-signed certificates are free and straightforward to generate with tools like OpenSSL, they lack the crucial element of trust established by a recognized Certificate Authority (CA). This absence of trust often causes Web browsers and applications to flag the server as untrusted, resulting in security warnings.

In this tutorial, we’ll learn how to install a self-signed certificate on Alpine Linux. All commands in the tutorial were tested on Alpine 3.16.
## 2. When To Use a Self-Signed Certificate

While security warnings and lack of trust are significant drawbacks of self-signed certificates, there are scenarios where the advantages outweigh these concerns:

    For local application testing or within closed environments, self-signed certificates enable secure communication with encryption, eliminating additional costs.
    For internal tools or services accessed only within an organization’s network, self-signed certificates might be acceptable to ensure encrypted communication without the need for external validation.
    For quick demos or prototypes, self-signed certificates provide a convenient way to establish basic encrypted communication.
    Within closed, private networks where all users know and trust the self-signed certificate authority, such as within an enterprise intranet or a closed VPN network, self-signed certificates may be an unnecessary security step.

In the following sections, we set up a self-signed certificate with OpenSSL and manually set that certificate as trusted.
## 3. Generating a Self-Signed Certificate With OpenSSL

OpenSSL is an open-source toolkit that provides cryptographic functions and tools for secure communication. It includes an implementation of Transport Layer Security (TLS) and Secure Socket Layer (SSL) protocols, which are the basis for secure communication over networks.

Particularly, OpenSSL provides a tool for generating, managing, and verifying digital certificates.

### 3.1. Install OpenSSL

On Alpine 3.16, the openssl command directly launches the OpenSSL command-line interface (CLI) because OpenSSL is available by default:
```sh
$ openssl
OpenSSL>
```

However, if we encounter an error message, it might indicate that OpenSSL is missing from the system. In this case, we can often install it using the local package manager, such as apk:
```sh
$ sudo apk install openssl
```

Running this command in Alpine installs the openssl package, including its command-line interface (CLI) and all required dependencies. Similar commands can work with the respective native package manager of other Linux distributions.

### 3.2. Create a Private Key

A certificate functions as a digital identity card, containing the owner’s domain name and public key. However, to trust this information, we require that is digitally signed.

In particular, a private key generates a digital signature for the certificate. This signature verifies the certificate’s authenticity, even in the absence of a trusted Certificate Authority (CA) endorsement.

To that end, the openssl command-line tool (CLI) provides the genrsa command to generate RSA private keys:
```sh
$ openssl genrsa -out server.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
...+++++
...................................................................+++++
e is 65537 (0x010001)
```
Running the genrsa command generates a private key and saves it to the server.key file. The recommended key size for enhanced security is 4096 bits, as also used in the command

Now, let’s leverage the -check option to confirm the creation of the server.key file:
freestar
```sh
$ openssl rsa -in server.key -check
RSA key ok
writing RSA key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA0MGAptE0mINqed0uYD8NQFbzQ+tEPlp4Epr59tKuheZugZLQ
xSNGVVLPRBcdHMwR5r3nDcCUiyDyS1nr2YJmf2n1P8Wsa6Y4iyB6Cr9yYLepwMgC
3K3esJc3JBTQkFCN+xghN/hVr9N36fOskeb+Wdjw4ACZKDXKiL7edGk/BjDAwUut
...
```

Seemingly, the private key is valid.

### 3.3. Create Certificate Signing Request

Next, we create a Certificate Signing Request (CSR). The CSR contains the organization’s name, location, and domain name we want the certificate to secure. The generated CSR also contains a public key, which is later incorporated into the certificate.

Furthermore, the CSR is digitally signed using the corresponding private key. The correspondence between the private key used to generate the Certificate Signing Request (CSR) and the server that controls the private key introduces an additional security layer.

Using the private key we created in the last step, let’s create the CSR:
```sh
$ openssl req -new -key server.key -out server.csr

The interactive req subcommand shows a series of prompts that require appropriate answers:

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:RO
State or Province Name (full name) [Some-State]:Bucharest
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Baeldung
Organizational Unit Name (eg, section) []:Linux
Common Name (e.g. server FQDN or YOUR name) []:baeldung.com
Email Address []:email@baeldung.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```
Let’s view the resulting server.csr file to verify it has been generated:
```sh
$ cat server.csr
-----BEGIN CERTIFICATE REQUEST-----
MIICzjCCAbYCAQAwgYgxCzAJBgNVBAYTAk5HMRMwEQYDVQQIDApLYW5vIFN0YXRl
MQ8wDQYDVQQHDAZGYXJhd2ExCzAJBgNVBAoMAkJHMQ4wDAYDVQQLDAVMaW51eDET
MBEGA1UEAwwKb3VyLWRvbWFpbjEhMB8GCSqGSIb3DQEJARYSZW1haWxAYmFlbGR1
...
Ckw=
-----END CERTIFICATE REQUEST-----
```
Hence, we’ve created a CSR for the machine.

### 3.4. Create a Self-Signed Certificate

Finally, we can create the self-signed certificate using the existing private key (server.key) and CSR (server.csr):
```sh
$ openssl x509 -req -days 21900 -in server.csr -signkey server.key -out server.crt
Signature ok
subject=C = RO, ST = Bucharest, O = Baeldung, OU = Linux, CN = baeldung.com, emailAddress = email@baeldung.com
Getting Private key
```
The x509 command instructs openssl that we’re working with X.509 certificates and the SSL (TLS) encryption format. Further, we set the certificate validity period to 21900 days using the -days option.

Consequently, server.crt stores the generated certificate. Let’s verify its creation:
```sh
$ cat server.crt
-----BEGIN CERTIFICATE-----
MIIDgzCCAmsCFCZIsdClvYr2g7argnX20Kc51PhuMA0GCSqGSIb3DQEBCwUAMH4x
CzAJBgNVBAYTAlJPMRIwEAYDVQQIDAlCdWNoYXJlc3QxETAPBgNVBAoMCEJhZWxk
dW5nMQ4wDAYDVQQLDAVMaW51eDEVMBMGA1UEAwwMYmFlbGR1bmcuY29tMSEwHwYJ
...
xB61/V7bpIWblQzAqo75q3k3cAl2/mTn6cSabJiJ8hkABYLZkvcy
-----END CERTIFICATE-----
```
Therefore, we’ve successfully created a self-signed certificate using the generated private key and CSR.

## 4. Trusting the Self-Signed Certificate

On Alpine and other Linux distributions such as Debian, a package utility called ca-certificates includes a collection of trusted certificates from Certificate Authorities. These certificates verify the identity of websites we connect to over SSL (TLS) connections.

Of course, we have to update this collection with any newly created certificate. The collection of trusted certificates resides in the /etc/ssl/certs/ca-certificates.crt file. We can update this trust store by adding individual certificates located in the /usr/local/share/ca-certificates/ directory.

To begin, let’s update the packages and install ca-certificates:
```sh
$ sudo apk update && sudo apk add ca-certificates
```

Also, it’s recommended to clean the apk cache before updating the certificate collection:
```sh
$ sudo rm -rf /var/cache/apk/*
```

Then, we copy server.crt to the /usr/local/share/ca-certificates/:
freestar
```sh
$ sudo cp ./server.crt /usr/local/share/ca-certificates/server.crt
```
Finally, we can add the certificate to the ca-certificates collection using the update-ca-certificates command:
```sh
$ sudo update-ca-certificates
```
This command appends server.crt to the /etc/ssl/certs/ca-certificates.crt.

We can check for updates at the bottom of the file.
```sh
$ tail -25 /etc/ssl/certs/ca-certificates.crt
sBxXVsFy6K2ir40zSbofitzmdHxghm+Hl3s=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIDgzCCAmsCFCZIsdClvYr2g7argnX20Kc51PhuMA0GCSqGSIb3DQEBCwUAMH4x
CzAJBgNVBAYTAlJPMRIwEAYDVQQIDAlCdWNoYXJlc3QxETAPBgNVBAoMCEJhZWxk
dW5nMQ4wDAYDVQQLDAVMaW51eDEVMBMGA1UEAwwMYmFlbGR1bmcuY29tMSEwHwYJ
...
xB61/V7bpIWblQzAqo75q3k3cAl2/mTn6cSabJiJ8hkABYLZkvcy
-----END CERTIFICATE-----
```
Hence, we’ve successfully installed a self-signed certificate on the Linux machine.

## 5. Conclusion

In this tutorial, we learned how to install a self-signed certificate on Alpine Linux. We also covered the advantages and scenarios for using self-signed certificates.

However, this method has limitations. Self-signed certificates aren’t recognized by most Web browsers as trustworthy, leading to security warnings for users. Hence, for public-facing servers, obtaining a certificate signed by a trusted Certificate Authority (CA) is essential to avoid security warnings and ensure user trust.

Comments are open for 30 days after publishing a post. For any issues past this date, use the Contact form on the site.

----------------------------------------------------------------------------------------------------
# SSL
```sh
apk add --update python3 py3-pip acf-openssl ca-certificates
```

## Generate Key SSL(OpenSSL)
Lakukan buat konfigurasi file seperti berikut ini:
```sh
/etc/
├── nginx/
│   ├── ssl/
│   │   ├── apk.crt
│   │   ├── apk.key
│   │   └── apk.pem


# Generate Keys expired 21900 days
openssl req -new -newkey rsa:4096 -nodes -keyout apk.key -out apk.csr
openssl x509 -req -sha256 -days 21900 -in apk.csr -signkey apk.key -out apk.pem
# Generate PEM
openssl dhparam -out apk.pem 4096

openssl pkcs12 -export -out ca-apk.pfx -inkey apk.key -in apk.crt
openssl pkcs12 -nokeys -cacerts -in ca-apk.pfx  -out ca-apk.pem
openssl pkcs12 -nodes -in ca-apk.pfx -out apk-bundle.pem
chown root:root /etc/nginx/ssl/apk-bundle.pem
chmod 400 /etc/nginx/ssl/apk-bundle.pem
```
