#!/bin/bash

# Uncomment the next line if running the script directly!
# chmod +x backup.sh

# =================================================================
# This script is used to automate the backup of most important
# files on my computer. These files are saved to my USB Stick or 
# External HD. The directory will be zipped and sent to external
# drive.
#
# - The script will go to each directory that has been defined;
# - Each directory that has been defined will be compressed, 
#   inserting a date: folder_-_YYYY-MM-DD.zip; 
#   Example: Pictures_-_2020-07-03.zip
# - Before, it will be checked in the directory if there is the 
#   same file with the date of a previous backup. If it exists, 
#   it will be deleted before copying the new file.
# - Some directories will be compressed with password.
# - Some directories will be listed in a text file. These are files 
#   that are not that important and can be saved just for 
#   information to save space and know what to download next, 
#   such as: Music, Videos, Softwares...;
#
# $ backup --all
# $ backup --docs
# =================================================================

TODAY_DATE="$(date +%y-%m-%d)"
PATH_THIS_LOCAL="$(pwd)"
PATH_BACKUP_DEVICE="/run/media/$USER/BKP-X0N4D0"

# ============================================
function backup() {
  local backupOption="$1"
  local pathDest=""

  if cd $PATH_BACKUP_DEVICE; then
    pathDest=$PATH_BACKUP_DEVICE
    cd $PATH_THIS_LOCAL
  
    clear; print-script-title
    
    case $backupOption in 

      "-h" | "help" | '')
        clear; print-help-user-guide
      ;; 
      
      "--all")

      ;;

      "--list")

      ;;
      
      "--docs")

      ;;

      *)  
        print-msg -red "[!] Command not found!"; sleep 2  
        print-help-user-guide
      ;;
    esac
  else
    print-msg -red "[*] Device not found!"; sleep 2
  fi

}
# ============================================

function print-msg() {
  local colorName="$1"
  local colorID="$2"
  local msgToPrint="$3"

  case $colorName in
    "-red") colorID=31 ;;
    "-blue") colorID=34 ;;
    "-green") colorID=32 ;;
    "-white") colorID=37 ;;
    *) colorID=37 ;;
  esac

  echo -e '\033['$colorID'm'$msgToPrint'\033[m'
}

function print-script-title() {
  print-msg -white "-----------------------------------------"
  print-msg -blue "|\t* | Minimal Backup | *\t\t|"
  print-msg -green "|\t[...] >>>>> <<<<<< [.]\t\t|"
  print-msg -white "-----------------------------------------"
}

function check-dir-exists {
  local pathToDir="$1"
  if [[ ! -d $pathToDir ]]; then
    echo false
  else
    echo true
  fi
}

function print-help-user-guide() {
  print-script-title
  print-msg -green "backup [flags]"
  print-msg -blue "\t-all"
  print-msg -blue "\t-list"
}

function zip-file-directory() {
  local pathOrFileToZip="$1"
  local pathToSendZippedFile="$2"
  local newZipFileName="$3"
  zip -qrs 2g "$newZipFileName" "$pathOrFileToZip"
}

function zip-partitioned-file() {
  local fileOrDirectoryName="$1"
  local nameOfZipFile="$2"
  zip -s 2g -r $nameOfZipFile $fileOrDirectoryName
}

function movefile() {
  local fileName="$1"
  local pathToDest="$2"
  mv "$fileName" "$pathToDest"
}

function create-new-backup-path() {
  local pathName="$1"
  mkdir $pathName
}

function list-files-txt() {
  local pathToBeListed="$1"
  local pathToSendFile="$2"
  local fileTxtName="$3"
  ls $pathToBeListed >> "$pathToSendFile/$fileTxtName" 
}

# ============================================

backup $1

unset THIS_LOCAL_PATH
unset TODAY_DATE
unset BACKUP_DEVICE