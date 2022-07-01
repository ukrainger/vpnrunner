# vpnrunner


[UA]

Цей скрипт bash використовуєтьсся для автоматичного з'єднання із VPN (командна стрічка) та наступного виконання деякої програми. Кожних x хвилин (налаштовується), програма зупиняється, а VPN заново з'єднуєтся із випадковою країною (зі списку). Розробник надихався db1000_hotspotshield. Запуск відбувається легко:

./vpnrunner.sh --vpn <Ваш VPN>

або

./vpnrunner.sh --vpn <Ваш VPN> --exe <Ваш EXE>

Наразі, наступні розширення для VPN є доступними (перевірено):

 - nordvpn
 - hotspotshield
 - expressvpn
 - pia
 - purevpn

Перевірені програми:

 - db1000n - замовчування
 - distress

Програма завантажиться та встановиться автоматично, якщо не існує. Програма не запуститься (або ж зупиниться), якщо немає VPN з'єднання. VPN з'єднання перебуває під постійним наглядом.

Ви можете додати нові функції створюючи розширення для програм, VPN, менеджерів мережі. Просто зазирніть у папку plugins.


[EN]

This bash script is intended to automatically connect to your VPN (command line) and then run a certain executable. Every x minutes (configurable), the executable stops and the VPN reconnects to a random country (from a predefined list). Strongly inspired by db1000_hotspotshield. Can be executed as easy as:

./vpnrunner.sh --vpn <your VPN>

or

./vpnrunner.sh --vpn <your VPN> --exe <your EXE>

So far, the following VPN plugins are available (tested):

 - nordvpn
 - hotspotshield
 - expressvpn
 - pia
 - purevpn

Tested executables:

 - db1000n - default
 - distress

The executable will be downloaded/installed automatically if not existing. The executable does not start (or terminates) if no VPN connection is established. VPN connection is permanently monitored.

You can extend the functionality by creating your own plugins for executables, VPNs, network managers. Just have a look into the plugins folder.
