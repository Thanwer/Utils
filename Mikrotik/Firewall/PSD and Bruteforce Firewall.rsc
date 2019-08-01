/ip firewall raw
add action=drop chain=prerouting comment=DNS dst-port=53 in-interface-list= wan.interfaces protocol=udp
add action=drop chain=prerouting comment="Port Scan" in-interface-list= wan.interfaces src-address-list="Black List (Port Scanner WAN)"
add action=drop chain=prerouting comment=SSH dst-port=22 in-interface-list= wan.interfaces protocol=tcp src-address-list="Black List (SSH)"
add action=drop chain=prerouting comment=Winbox dst-port=8291  in-interface-list=wan.interfaces protocol=tcp

/ip firewall filter
add action=add-src-to-address-list address-list= "Black List (Port Scanner WAN)" address-list-timeout=4w2d chain=input  comment="PORT SCAN" in-interface-list=wan.interfaces log=yes log-prefix= "Add_Black List (Port Scanner WAN)" protocol=tcp psd=21,3s,3,1
add action=jump chain=input comment="SSH BRUTEFORCE" dst-port=22  in-interface-list=wan.interfaces jump-target="Black List (SSH) Chain"  log-prefix="jump " protocol=tcp
add action=add-src-to-address-list address-list="Black List (SSH)"  address-list-timeout=4w2d chain="Black List (SSH) Chain"  connection-state=new log=yes log-prefix="Add_Black List (SSH)"  src-address-list="Black List (SSH) Stage 3"
add action=add-src-to-address-list address-list="Black List (SSH) Stage 3"  address-list-timeout=1m chain="Black List (SSH) Chain" connection-state= new log-prefix="Add_Black List (SSH) S3" src-address-list= "Black List (SSH) Stage 2"
add action=add-src-to-address-list address-list="Black List (SSH) Stage 2"  address-list-timeout=1m chain="Black List (SSH) Chain" connection-state= new log-prefix="Add_Black List (SSH) S2" src-address-list= "Black List (SSH) Stage 1"
add action=add-src-to-address-list address-list="Black List (SSH) Stage 1"  address-list-timeout=1m chain="Black List (SSH) Chain" connection-state= new log-prefix="Add_Black List (SSH) S1"
add action=return chain="Black List (SSH) Chain"
add action=accept chain=input dst-port=22 log=yes log-prefix= "SSH ALLOWED -->" protocol=tcp
