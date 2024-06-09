#!/bin/bash

score=0
nyawa=3

animals=("anjing" "bunglon" "cicak" "domba" "elang" "flamingo" "gajah" "harimau" "iguana" "kanguru" "landak" "merpati" "nyamuk" "pinguin" "rusa" "singa" "tupai" "ular" "zebra" "alpaka" "bebek" "cendrawasih" "hamster" "ikan" "jaguar" "kucing" "lumba-lumba" "orangutan" "panda" "rajawali" "siamang" "jerapah")

while [ $nyawa -gt 0 ]; do
  word=${animals[RANDOM % ${#animals[@]}]}
  hint="${word:0:1}" 

  for ((i=1; i<${#word}; i++)); do
    hint+=" -"
  done
  hints_left=2

  while [ $nyawa -gt 0 ]; do
    user_input=$(zenity --entry --title="Tebak Kata" --text=" Sisa nyawa Anda: $nyawa\n\nKata yang harus ditebak:\n$hint\n\nJumlah huruf: ${#word}\n\nHint tersisa: $hints_left\n\nSkor Anda: $score\n\nGunakan 'hint' untuk mendapatkan petunjuk." --entry-text "")
    guess=$(echo "$user_input" | tr '[:upper:]' '[:lower:]') 

    if [ "$guess" == "$word" ]; then
      ((score++))
      zenity --info --title="Selamat!" --text="Anda benar. Anda menang!\nSkor Anda: $score"
      break
    elif [ "$guess" == "hint" ] && [ $hints_left -gt 0 ]; then
      random_index=$(( RANDOM % (${#word}-1) + 1 ))
      hint="${hint:0:2*random_index}${word:$random_index:1}${hint:2*random_index+1}"
      hints_left=$((hints_left - 1))
    else
      zenity --error --title="Maaf!" --text="Tebakan Anda salah. Nyawa berkurang."
      ((nyawa--))
    fi
  done

  if [ $nyawa -eq 0 ]; then
    zenity --info --title="Game Over" --text="Maaf, Anda kalah. Kata yang benar adalah \"$word\".\nSkor Akhir Anda: $score"
  fi

  play_again=$(zenity --list --title="Main Lagi?" --text="Ingin bermain lagi?" --radiolist --column="Pilih" --column="Pilihan" TRUE "Ya" FALSE "Tidak")

  if [ "$play_again" == "Ya" ]; then
    nyawa=3
    hints_left=2
  else
    zenity --info --title="Terima Kasih!" --text="Terima kasih telah bermain!\nSkor Akhir Anda: $score"
    break
  fi
done