#!/usr/bin/env bash

print_help()
{
  echo "Script fixed offset for the azure image gallery"
  echo "See https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic"
  echo "Usage: fix_vdh_allignment.sh *.vhd"
}


if [ $# -eq 0 ]; then
    print_help
    exit 1
fi

vhddisk="$1"
rawdisk="${vhddisk%.*}.raw"
MB=$((1024*1024))
qemu-img convert -f vpc -O raw "$vhddisk" "$rawdisk"
size=$(qemu-img info -f raw --output json "$rawdisk" | gawk 'match($0, /"virtual-size": ([0-9]+),/, val) {print val[1]}')
rounded_size=$(((($size+$MB-1)/$MB)*$MB))
echo "Rounded Size = $rounded_size"
qemu-img resize "$rawdisk" $rounded_size
rm -rf "$vhddisk"
qemu-img convert -f raw -o subformat=fixed,force_size -O vpc "$rawdisk" "$vhddisk"
