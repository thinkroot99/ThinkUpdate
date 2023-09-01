#!/bin/bash

# Se verifică dacă utilizatorul are privilegii de super-utilizator
if [[ $EUID -ne 0 ]]; then
   echo "Acest script trebuie să fie rulat cu privilegii de super-utilizator." 
   exit 1
fi

# Funcție pentru instalarea paru
install_paru() {
    if ! command -v paru &> /dev/null; then
        echo "Instalare paru..."
        pacman -S --noconfirm paru
    fi
}

# Se verifică dacă paru este instalat
if command -v paru &> /dev/null; then
    PACKAGE_MANAGER="paru"
else
    echo "Paru nu este instalat. Se va instala automat."
    install_package_manager
    
    # Se verifică din nou și setează corespunzător
    if command -v paru &> /dev/null; then
        PACKAGE_MANAGER="paru"
    else
        echo "Instalarea paru a eșuat. Scriptul nu poate continua."
        exit 1
    fi
fi

# Se actualizează lista de pachete
echo "Actualizare lista de pachete..."
$PACKAGE_MANAGER -Sy

# Se actualizează pachetele instalate din depozitele oficiale
echo "Actualizare pachete oficiale..."
$PACKAGE_MANAGER -Su --noconfirm

# Se actualizează pachetele AUR
echo "Actualizare pachete AUR..."
$PACKAGE_MANAGER -Syu --aur --noconfirm

# SecCurăță cache-ul pachetelor vechi
echo "Curățare cache pachete..."
$PACKAGE_MANAGER -Sc --noconfirm

echo "Actualizare completă."

