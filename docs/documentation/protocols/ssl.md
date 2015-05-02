## SSL wrapping protocol

SSL (Secure Sockets Layer) is not a communication protocol on its own and it is used as a wrapping for SSL-based secure protocols, like [SODEPS](protocols/sodeps.html) and [HTTPS](protocols/https.html).

---

## SSL Use

To make use of SSL, a valid private-key certificate deposited in a Java keystore is required. On the server side the two protocol parameters `.ssl.keyStore` pointing to the keystore file and `.ssl.keyStorePassword` in presence of a password need to be set.

Clients accessing SSL servers with unsafe (including self-signed) certificates usually deny operation. A truststore, likewise a Java keystore, contains trust entries also for potentially unsafe certificates. In Jolie it is specified over the protocol parameters `.ssl.trustStore` (path) and eventually `.ssl.trustStorePassword`.

Java's keytool helps to introspect key- and truststore: `keytool -list -keystore <keystore/truststore>.jks -storepass <password>`. In a keystore, a certificate with `PrivateKeyEntry` should be contained, in a truststore the same (fingerprint) with a `trustedCertEntry`.

---

## SSL Parameters

<div class="code" src="ssl.iol"></div>
