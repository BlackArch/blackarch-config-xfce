#!/bin/bash

[[ "${HTTP_USER_AGENT:0:2}" != 'pa' ]] && exit 2

while read -r package; do
	packages=("$package" "${packages[@]}")
done

get_groups()
{
  pkginfo=$1
  groups=$(echo "$pkginfo" | grep Groups | cut -d':' -f 2)
  category=""
  for group in $groups; do
    case "$group" in
      blackarch-anti-forensic)
        category="${category} X-Blackarch-Anti-Forensic;"
        ;;
      blackarch-automation)
        category="${category} X-Blackarch-Automation;"
        ;;
      blackarch-automobile)
        category="${category} X-Blackarch-Automobile;"
        ;;
      blackarch-backdoor)
        category="${category} X-Blackarch-Backdoor;"
        ;;
      blackarch-binary)
        category="${category} X-Blackarch-Binary;"
        ;;
      blackarch-bluetooth)
        category="${category} X-Blackarch-Bluetooth;"
        ;;
      blackarch-Code-audit)
        category="${category} X-Blackarch-Code-Audit;"
        ;;
      blackarch-cracker)
        category="${category} X-Blackarch-Cracker;"
        ;;
      blackarch-crypto)
        category="${category} X-Blackarch-Crypto;"
        ;;
      blackarch-database)
        category="${category} X-Blackarch-Database;"
        ;;
      blackarch-debugger)
        category="${category} X-Blackarch-Debugger;"
        ;;
      blackarch-decompiler)
        category="${category} X-Blackarch-Decompiler;"
        ;;
      blackarch-defensive)
        category="${category} X-Blackarch-Defensive;"
        ;;
      blackarch-disassembler)
        category="${category} X-Blackarch-Disassembler;"
        ;;
      blackarch-dos)
        category="${category} X-Blackarch-Dos;"
        ;;
      blackarch-drone)
        category="${category} X-Blackarch-Drone;"
        ;;
      blackarch-exploitation)
        category="${category} X-Blackarch-Exploitation;"
        ;;
      blackarch-fingerprint)
        category="${category} X-Blackarch-Fingerprint;"
        ;;
      blackarch-firmware)
        category="${category} X-Blackarch-Firmware;"
        ;;
      blackarch-fuzzer)
        category="${category} X-Blackarch-Fuzzer;"
        ;;
      blackarch-forensic)
        category="${category} X-Blackarch-Forensic;"
        ;;
      blackarch-gpu)
        category="${category} X-Blackarch-Gpu;"
        ;;
      blackarch-hardware)
        category="${category} X-Blackarch-Hardware;"
        ;;
      blackarch-honeypot)
        category="${category} X-Blackarch-Honeypot;"
        ;;
      blackarch-ids)
        category="${category} X-Blackarch-Ids;"
        ;;
      blackarch-keylogger)
        category="${category} X-Blackarch-Keylogger;"
        ;;
      blackarch-malware)
        category="${category} X-Blackarch-Malware;"
        ;;
      blackarch-misc)
        category="${category} X-Blackarch-Misc;"
        ;;
      blackarch-mobile)
        category="${category} X-Blackarch-Mobile;"
        ;;
      blackarch-mobile-reversing)
        category="${category} X-Blackarch-Mobile-Reversing;"
        ;;
      blackarch-networking)
        category="${category} X-Blackarch-Networking;"
        ;;
      blackarch-nfc)
        category="${category} X-Blackarch-Nfc;"
        ;;
      blackarch-packer)
        category="${category} X-Blackarch-Packer;"
        ;;
      blackarch-proxy)
        category="${category} X-Blackarch-Proxy;"
        ;;
      blackarch-radio)
        category="${category} X-Blackarch-Radio;"
        ;;
      blackarch-recon)
        category="${category} X-Blackarch-Recon;"
        ;;
      blackarch-reversing)
        category="${category} X-Blackarch-Reversing;"
        ;;
      blackarch-scan)
        category="${category} X-Blackarch-Scan;"
        ;;
      blackarch-scanner)
        category="${category} X-Blackarch-Scanner;"
        ;;
      blackarch-sniffer)
        category="${category} X-Blackarch-Sniffer;"
        ;;
      blackarch-social)
        category="${category} X-Blackarch-Social;"
        ;;
      blackarch-spoof)
        category="${category} X-Blackarch-Spoof;"
        ;;
      blackarch-stego)
        category="${category} X-Blackarch-Stego;"
        ;;
      blackarch-tunnel)
        category="${category} X-Blackarch-Tunnel;"
        ;;
      blackarch-unpacker)
        category="${category} X-Blackarch-Unpacker;"
        ;;
      blackarch-voip)
        category="${category} X-Blackarch-Voip;"
        ;;
      blackarch-webapp)
        category="${category} X-Blackarch-Webapp;"
        ;;
      blackarch-windows)
        category="${category} X-Blackarch-Windows;"
        ;;
      blackarch-wireless)
        category="${category} X-Blackarch-Wireless;"
        ;;
    esac
  done
  echo "$category"
}

get_desc()
{
  pkginfo="$1"
  desc=$(echo $pkginfo | grep Description)
  echo "$desc"
}

gen()
{
  for package in "${packages[@]}"; do
    pkginfo=$(pacman -Qi "${package}")
    package=$(echo "$pkginfo" | grep Name | cut -d':' -f 2 | sed 's/^ //g')
    desc=$(echo "$pkginfo" | grep Description | cut -d':' -f 2 | sed 's/^ //g')
    groups=$(get_groups "$pkginfo")

    if [ -z $groups ]; then
      continue
    fi

    cat > "/usr/share/applications/ba-${package}.desktop" << EOF
[Desktop Entry]
Name="$package"
Icon="utilities-terminal"
Comment="$desc"
TryExec=/usr/bin/$package
Exec=sh -c '/usr/bin/$package;\$SHELL'
StartupNotify=true
Terminal=true
Type=Application
Categories="$groups"
EOF

  done
}

rm(){
  for package in "${packages[@]}"; do
    if [[ -f "/usr/share/applications/ba-${package}" ]]; then
      rm -f "/usr/share/applications/ba-${package}"
    fi
  done
}

case $1 in
gen) gen ;;
rm) rm ;;
*)
    exit 2
    ;;
esac
