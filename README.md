# vpnrunner


[UA]

Увага! Ця програма має виключно ознайомчу мету та надається "як є", без жодної гарантії. Використовуйте її на власну відповідальність.

Цей скрипт bash використовується для автоматичного з'єднання із VPN (командна стрічка) та наступного виконання деякої програми. Кожних x хвилин (налаштовується), програма зупиняється, а VPN заново з'єднуєтся із випадковою країною (зі списку). Розробник надихався db1000_hotspotshield. Запуск відбувається легко. Ось деякі приклади:

./vpnrunner.sh --help

./vpnrunner.sh --vpn <Ваш VPN>

./vpnrunner.sh --vpn <Ваш VPN> --exe <Ваш EXE>

./vpnrunner.sh --use-proxy --exe <Ваш EXE>

./vpnrunner.sh --vpn <Ваш VPN> --use-proxy --exe <Ваш EXE>

<Ваш VPN> вказує на розширення для VPN під назвою plugin_vpn_<Ваш VPN>.sh, яке знаходиться у папці plugins. Наприклад, plugin_vpn_pia.sh - тут знаходяться команди для запуску, зупинки, перевірки VPN з'єднання для PrivateInternetAccess VPN. Той же принцип стосується <Ваш EXE> у розширеннях plugin_exe_<Ваш EXE>.sh. Зауважте, Вам зазвичай необхідно встановити відповідний клієнт від Вашого VPN-оператора, аби vpnrunner міг правильно працювати. Наразі, наступні розширення для VPN є доступними (перевірено):

 - nordvpn
 - hotspotshield
 - expressvpn
 - pia
 - purevpn
 - NetworkManager - екпериментальне розширення, яке дозволяє використовувати з'єднання налаштовані у Вашому менеджері мережі NetworkManager. Такими з'єднаннями можуть бути конфігурації для OpenVPN або WireGuard на основі імпортованих файлів від Вашого VPN-оператора. За замовчуванням розширення буде переключатися між усіма такими з'єднаннями, змінюючи таким чином Ваші доступні VPN сервери. Зауважте, підключення у NetworkManager повинні бути правильно налаштованими ще до запуску vpnrunner.

Зауважте, місця розташування для з'єднань VPN вказані у відповідних файлах розширень та можуть бути пристосованими до Ваших потреб вручну.

Перевірені програми:

 - db1000n - замовчування
 - distress
 - mhddos - необхідні застосунки для Python повинні бути встановленими наперед, інакше програма не запуститься

Програма завантажиться та встановиться автоматично, якщо не існує. Програма не запуститься (або ж зупиниться), якщо немає VPN з'єднання. VPN з'єднання перебуває під постійним наглядом.

Ви можете додати нові функції створюючи розширення для програм, VPN, менеджерів мережі. Просто зазирніть у папку plugins.


[EN]

Attention! This program has purely educational purpose and is provided "as is" without any warranty. Use it under your own responsibility.

This bash script is intended to automatically connect to your VPN (command line) and then run a certain executable. Every x minutes (configurable), the executable stops and the VPN reconnects to a random country (from a predefined list). Strongly inspired by db1000_hotspotshield. Can be executed as easy as in the following examples:

./vpnrunner.sh --help

./vpnrunner.sh --vpn < VPN >

./vpnrunner.sh --vpn < VPN > --exe < EXE >

./vpnrunner.sh --use-proxy --exe < EXE >

./vpnrunner.sh --vpn < VPN > --use-proxy --exe < EXE >

< VPN > points at the VPN-plugin named plugin_vpn_< VPN >.sh in the folder plugins. E.g., plugin_vpn_pia.sh contains commands to start, stop, check VPN connection for PrivateInternetAccess VPN. Same principles apply to < EXE > in  plugins/plugin_exe_< EXE >.sh. Note, you must usually install and activate the corresponding VPN client from your VPN provider for vpnrunner to operate properly. So far, the following VPN plugins are available (tested):

 - nordvpn
 - hotspotshield
 - expressvpn
 - pia
 - purevpn
 - NetworkManager - experimental extension allowing you to use connections in NetworkManager. Such connections could be configured for OpenVPN or WireGuard using configuration files from your VPN provider. By default, the extension will be switching between all of the available connections, thus switching your VPN servers. Note, connections in NetworkManager must be correctly configured before launching vpnrunner.

Note, connection locations for VPN are listed in the plugin files and can be tailored to your needs manually.

Tested executables:

 - db1000n - default
 - distress
 - mhddos - Python prerequisites must be installed, otherwise it will not run

The executable will be downloaded/installed automatically if not existing. The executable does not start (or terminates) if no VPN connection is established. VPN connection is permanently monitored.

You can extend the functionality by creating your own plugins for executables, VPNs, network managers. Just have a look into the plugins folder.
