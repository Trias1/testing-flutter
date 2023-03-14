# sampleflutterauthapp

A sample Flutter project for Single Sing-On feature.

## Getting Started

To start this project  following things need to be configured:
- Keycloak Server [Keycloak](https://www.keycloak.org/)
- Self Signed Certificate for Keycloak Server [SSL Certificate](https://ultimatesecurity.pro/post/san-certificate/) (If required, http is fine)

For authorization purpose, [flutter_appauth](https://pub.dev/packages/flutter_appauth?msclkid=32544d2fcf7511ecabe3ad762261eb5a) has been implemented.

In thie repo I have configured only Android App. You need to provide Keycloak SSL Certificate in Android Resource folder as per network_security_config.xml

Have Fun and Happy Coding.

