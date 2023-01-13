RU ### Здесь скрипты, которые позволят упростить жизнь в работе с Linux машинами. Пока что здесь следующие скрипты:
EN ### There's some bash scripts, that i'm using to simplify my work with Linux servers. Btw there's common scripts:

### gen_root_ca.sh
#RU Скрипт, использующий openssl для генерации сертификатов ЦС (Центра Сертификации). На выходе получаем файлы myCA.pem и myCA.key
#EN Script, that using openssl to generate CA (Certification Authority) certificates. On the output we've got 2 files: myCA.pem and myCA.key

### gen_web_cert.sh
#RU Скрипт, который генерирует самоподписанный сертификат для web-сайта. Во время исполнения в той же папке должнен находиться сертификат ЦС с названием myCA.key и myCA.pem. Принимает один аргумент - доменное имя веб-сайта, его же записывает в поле alt names.
#EN Script, that generates self-signed certificate for website. You need to have CA certificates with names myCA.pem and myCA.key in the same folder while executing. You need to specify an argument - domain name for web-site, that name would be written in alt names field.
# USAGE # Использование # ./gen_web_cert.sh domain.name

### wg_gen_conf.sh
#RU Скрипт, который генерирует конфиг, публичный  и приватные ключи для WireGuard, перед работой удаляет интерфейс wg0, во время исполнений добавляет публичный ключ нового клиента в /etc/wireguard/wg0.conf и снова включает интерфейс. По стандарту выдает адреса из подсети 10.255.255.0/24. Перед запуском необходимо создать файл address с содержимым - первым адресом для выдачи клиенту. 
#EN Script, that generates config, public and private keys for WireGuard. It disables wg0 interface, adds peer's public key to /etc/wireguard/wg0.conf and after work enables wg0. By default gives address from 10.255.255.0/24 subnet. Before execution you have to specify first peer's address in 'address' file
# USAGE # Использование #
# echo 10 > address
# sudo su 
# ./wg_gen_conf.sh peers_name
