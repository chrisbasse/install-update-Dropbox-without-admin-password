#!/bin/bash

# Décompresse et installe DropboxHelperInstaller
# Évite la demande du mot de passe administrateur après l'installation ou la mise à jour de Dropbox
# Christophe BASSETTE

set -euo pipefail

APP="/Applications/Dropbox.app"
TGZ="$APP/Contents/Resources/DropboxHelperInstaller.tgz"
TARGET="/Library/DropboxHelperTools"
INSTALLER="$TARGET/DropboxHelperInstaller"

echo "Début du correctif DropboxHelperInstaller"

[[ -d $APP ]] || { echo "ERROR: Dropbox.app introuvable"; exit 1; }
[[ -f $TGZ ]] || { echo "ERROR: Archive DropboxHelperInstaller.tgz manquante"; exit 1; }
tar -tzf "$TGZ" &>/dev/null || { echo "ERROR: Archive tgz corrompue"; exit 1; }

echo "Dropbox valide"

mkdir -p "$TARGET"
[[ -f $INSTALLER ]] && rm -f "$INSTALLER" && echo "Ancien installeur supprimé"

tar -zxf "$TGZ" -C "$TARGET"
[[ -f $INSTALLER ]] || { echo "ERROR: Extraction échouée"; exit 1; }

echo "Extraction réussie"

chown root:wheel "$TARGET" "$INSTALLER"
chmod 04511 "$INSTALLER"
echo "Permissions root:wheel et SUID appliquées"

[[ -x $INSTALLER ]] || { echo "ERROR: Installeur non exécutable"; exit 1; }
[[ -u $INSTALLER ]] || { echo "ERROR: Bit SUID manquant"; exit 1; }
[[ "$(stat -f "%u:%g" "$INSTALLER")" == "0:0" ]] || { echo "ERROR: Propriétaire incorrect"; exit 1; }

echo "Installation réussie"
echo "Fin du script"
