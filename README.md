# RU | Здесь скрипты, которые позволят упростить жизнь в работе с Linux машинами. Пока что здесь следующие скрипты:
> EN | There's some bash scripts, that i'm using to simplify my work with Linux servers. Btw there's common scripts:
<br /><br />

### gen_root_ca.sh
Скрипт, использующий openssl для генерации сертификатов ЦС (Центра Сертификации). На выходе получаем файлы myCA.pem и myCA.key.
>Script, that using openssl to generate CA (Certification Authority) certificates. On the output we've got 2 files: myCA.pem and myCA.key.
```sh
sudo su
sh gen_root_ca.sh
```
<br />

### gen_web_cert.sh
Скрипт, который генерирует самоподписанный сертификат для web-сайта. Во время исполнения в той же папке должнен находиться сертификат ЦС с названием myCA.key и myCA.pem. Принимает один аргумент - доменное имя веб-сайта, его же записывает в поле alt names. <br />
>Script, that generates self-signed certificate for website. You need to have CA certificates with names myCA.pem and myCA.key in the same folder while executing. You need to specify an argument - domain name for web-site, that name would be written in alt names field.
```sh
sudo su
wg_gen_conf.sh
```
<br />

Скрипт, который генерирует конфиг, публичный и приватные ключи для WireGuard, перед работой удаляет интерфейс wg0, во время исполнений добавляет публичный ключ нового клиента в /etc/wireguard/wg0.conf и снова включает интерфейс. По стандарту выдает адреса из подсети 10.255.255.0/24.  <br />
>Script, that generates config, public and private keys for WireGuard. It disables wg0 interface, adds peer's public key to /etc/wireguard/wg0.conf and after work enables wg0. By default gives address from 10.255.255.0/24 subnet. 
```sh
sudo su
./wg_gen_conf.sh peers_name
```
