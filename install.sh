#!/bin/bash

PACKAGES_FILE_DNF="pakete_dnf.txt"
PACKAGES_FILE_FLATPAK="pakete_flatpak.txt"

install_dnf_packages() {
  echo "Installiere DNF Pakete..."

  if [ ! -f "$PACKAGES_FILE_DNF" ]; then
    echo "Die Datei $PACKAGES_FILE_DNF existiert nicht."
    return
  fi

  while IFS= read -r package; do
    if [ -n "$package" ]; then
      echo "Installiere $package..."
      sudo dnf install -y "$package"
    fi
  done < "$PACKAGES_FILE_DNF"

  echo "Alle DNF Pakete wurden installiert."
}

install_flatpak_packages() {
  echo "Installiere Flatpak Pakete..."

  if [ ! -f "$PACKAGES_FILE_FLATPAK" ]; then
    echo "Die Datei $PACKAGES_FILE_FLATPAK existiert nicht."
    return
  fi

  while IFS= read -r package; do
    if [ -n "$package" ]; then
      echo "Installiere $package..."
      flatpak install -y "$package"
    fi
  done < "$PACKAGES_FILE_FLATPAK"

  echo "Alle Flatpak Pakete wurden installiert."
}

echo "Füge Microsoft hinzu"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf check-update
sudo dnf update -y

install_dnf_packages
install_flatpak_packages

npm install --global yarn