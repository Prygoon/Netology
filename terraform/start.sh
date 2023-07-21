#!/bin/bash

# Запускаем terraform apply и проверяем exit code
if ! terraform apply; then
    echo "Terraform apply failed. Script execution stopped."
    exit 1
fi

# Читаем username из meta.yaml
username=$(grep -oP '(?<=name: )\S+' meta.yaml)

# Запускаем terraform output и сохраняем вывод в массив
mapfile -t ip_addresses < <(terraform output -json | jq -r '.external_ip_address_vm_1.value, .external_ip_address_vm_2.value')


# Файл инвентаря Ansible
inventory_file="inventory.ini"

# Группа в файле инвентаря
group_name="yandex_cloud"

# Добавляем группу в файл инвентаря, если она еще не существует
if ! grep -qF "[$group_name]" "$inventory_file"; then
    echo -e "\n[$group_name]" >> "$inventory_file"
fi

base_hostname="host"
index=1

# Добавляем IP-адреса в файл инвентаря Ansible в указанную группу
for ip_address in "${ip_addresses[@]}"; do
    hostname="${base_hostname}${index}"
    # Проверяем, не содержится ли уже IP-адрес в файле
    if ! grep -qF "$ip_address" "$inventory_file"; then
        # Добавляем IP-адрес в файл и группу
        echo "$hostname ansible_host=$ip_address ansible_connection=ssh ansible_user=$username" >> "$inventory_file"
    fi
    ((index++))
done
