#!/bin/bash

# Defaults
DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)"
IMAGE_RE="([0-9]+)x([0-9]+)"
FOLDER="$(dirname "$(readlink -f "$0")")"
LOCK="$FOLDER/src/lock.png"
PARAMS=""
OUTPUT_IMAGE="/tmp/i3lock.png"
PIXELATE=false
BLURTYPE="1x1"

font=$(convert -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{family}\n")/ { print a[NR-1]; exit }")
text="Type password to unlock"
case "${LANG:-}" in
    af_* ) text="Tik wagwoord om te ontsluit" ;; # Afrikaans
    de_* ) text="Bitte Passwort eingeben" ;; # Deutsch
    da_* ) text="Indtast adgangskode" ;; # Danish
    en_* ) text="Type password to unlock" ;; # English
    es_* ) text="Ingrese su contraseña" ;; # Española
    fr_* ) text="Entrez votre mot de passe" ;; # Français
    he_* ) text="הליענה לטבל המסיס דלקה" ;; # Hebrew עברית (convert doesn't play bidi well)
    hi_* ) text="अनलॉक करने के लिए पासवर्ड टाईप करें" ;; #Hindi
    id_* ) text="Masukkan kata sandi Anda" ;; # Bahasa Indonesia
    it_* ) text="Inserisci la password" ;; # Italian
    ja_* ) text="パスワードを入力してください" ;; # Japanese
    lv_* ) text="Ievadi paroli" ;; # Latvian
    nb_* ) text="Skriv inn passord" ;; # Norwegian
    pl_* ) text="Podaj hasło" ;; # Polish
    pt_* ) text="Digite a senha para desbloquear" ;; # Português
    tr_* ) text="Giriş yapmak için şifrenizi girin" ;; # Turkish
    ru_* ) text="Введите пароль" ;; # Russian
    * ) text="Type password to unlock" ;; # Default to English
esac

# Read user input
POSITIONAL=()
for i in "$@"
do
  case $i in
  -h|--help)
    echo "lock: Syntax: lock [-n|--no-text] [-p|--pixelate] [-b=VAL|--blur=VAL]"
    echo "for correct blur values, read: http://www.imagemagick.org/Usage/blur/#blur_args"
    exit
    shift
    ;;
  -b=*|--blur=*)
    VAL="${i#*=}"
    BLURTYPE=(${VAL//=/ }) 
    shift
    ;;
  -p|--pixelate)
    PIXELATE=true
    shift # past argument
    ;;
  *)    # unknown option
    echo "unknown option: $i"
    exit
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#Take screenshot:
scrot -z $OUTPUT_IMAGE

#Get dimensions of the lock image:
LOCK_IMAGE_INFO=`identify $LOCK`
[[ $LOCK_IMAGE_INFO =~ $IMAGE_RE ]]
IMAGE_WIDTH=${BASH_REMATCH[1]}
IMAGE_HEIGHT=${BASH_REMATCH[2]}

#Execute xrandr to get information about the monitors:
while read LINE
do
  #If we are reading the line that contains the position information:
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    #Extract information and append some parameters to the ones that will be given to ImageMagick:
    WIDTH=${BASH_REMATCH[1]}
    HEIGHT=${BASH_REMATCH[2]}
    X=${BASH_REMATCH[3]}
    Y=${BASH_REMATCH[4]}
    POS_X=$(($X+$WIDTH/2-$IMAGE_WIDTH/2))
    POS_Y=$(($Y+$HEIGHT/2-$IMAGE_HEIGHT/2))

    #TEXT_X=$(($POS_X - 50))
    #TEXT_Y=$(($POS_Y + 160))
    #PARAMS="$PARAMS '$LOCK' '-geometry' '+$POS_X+$POS_Y' '-annotate' '+$TEXT_X+$TEXT_Y' '$text' '$LOCK' '-composite'"
    PARAMS="$PARAMS '$LOCK' '-geometry' '+$POS_X+$POS_Y' '-composite'"
  fi
done <<<"`xrandr`"

#Execute ImageMagick:
if $PIXELATE ; then
  PARAMS="'$OUTPUT_IMAGE' '-scale' '10%' '-scale' '1000%' -font "$font" -pointsize 26 $PARAMS '$OUTPUT_IMAGE'"
else
  PARAMS="'$OUTPUT_IMAGE' '-level' '0%,100%,0.6' '-blur' '$BLURTYPE' -font "$font" -pointsize 26 $PARAMS '$OUTPUT_IMAGE'"
fi

value="60" #brightness value to compare to
color=$(convert "$OUTPUT_IMAGE" -gravity center -crop 100x100+0+0 +repage -colorspace hsb \
    -resize 1x1 txt:- | awk -F '[%$]' 'NR==2{gsub(",",""); printf "%.0f\n", $(NF-1)}');

eval convert $PARAMS

if [[ $color -gt $value ]]; then #white background image and black text
    #Lock the screen:
    i3lock -i $OUTPUT_IMAGE --insidecolor=0000001c --ringcolor=0000003e \
        --linecolor=00000000 --keyhlcolor=ffffff80 --ringvercolor=ffffff00 \
        --separatorcolor=22222260 --insidevercolor=ffffff1c \
        --ringwrongcolor=ffffff55 --insidewrongcolor=ffffff1c \
        --verifcolor=ffffff00 --wrongcolor=ff000000 --timecolor=ffffff00 \
        --datecolor=ffffff00 --layoutcolor=ffffff00 -t
else #black
    #Lock the screen:
    i3lock -i $OUTPUT_IMAGE --insidecolor=ffffff1c --ringcolor=ffffff3e \
        --linecolor=ffffff00 --keyhlcolor=00000080 --ringvercolor=00000000 \
        --separatorcolor=22222260 --insidevercolor=0000001c \
        --ringwrongcolor=00000055 --insidewrongcolor=0000001c \
        --verifcolor=00000000 --wrongcolor=ff000000 --timecolor=00000000 \
        --datecolor=00000000 --layoutcolor=00000000 -t
fi

#Remove the generated image:
rm $OUTPUT_IMAGE
