#!/bin/bash
set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.
# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# Aéré et identé
# Ecrit en utilisant des fonctions
# Nom d'utilisateurs dans le cartouche du fichier
# Commenté et documenté
# Pas d'erreur identifié par le schellcheck

# La liste des commandes est editer, supprimer, lister, construire

 function main {
    parameter=$(echo "$parameter" | tr "[A-Z]" "[a-z]")
 }
function do_build {
 if [ -e web ]
then
    echo Ok.
    for file in web/*.html
    do
        if [ -e file ]
        then
                rm web/*.html
        fi
        done
else
    mkdir web 2> /dev/null
fi

echo "All html documents" > markdown/index.md
echo "======================" >> markdown/index.md

for f in markdown/*.md
do  
    nom=$(echo "$f" | cut -d'/' -f2 | cut -d'.' -f1)

    echo "Le fichier $nom" >> markdown/index.md
    echo "[$nom]($nom.html)"  >> markdown/index.md

    echo "<!DOCTYPE html>" > web/"$nom".html
    echo "<html lang=\"en\">" >> web/"$nom".html
    echo "<head>" >> web/"$nom".html
    echo "<meta charset=\"UTF-8\">" >> web/"$nom".html
    echo "<title>$nom</title>" >> web/"$nom".html
    echo "</head>" >> web/"$nom".html
    echo "<body>" >> web/"$nom".html
    (pandoc --from markdown --to html5 < "$f" ) >> web/"$nom".html
    echo "</body>" >> web/"$nom".html
    echo "</html>" >> web/"$nom".html
    pandoc -s web/"$nom".html -o pdf"$nom".pdf
done
convert *.pdf web/blog.pdf
rm *.pdf
}
function do_edit {
 nomP=$1
    if [ $# -ne 0 ] #It controls if there is a parameter
    then
    if [ "$nomP" != index ] # It controls if the file isn't the index
    then
    if [ -e "$EDITOR" ] #It controls if $EDITOR exists
    then
        $EDITOR markdown/"$nomP".md
    elif [ -e /usr/bin/editor ] #If $EDITOR doesn't existe it controls if editor exists
    then 
        /usr/bin/editor markdown/"$nomP".md
    else #If $EDITOR and editor don't exist it search the editor by default
        editDef=$(update-alternatives --list editor | head -n 1)
        $editDef markdown/"$nomP".md
    fi
    else
    echo "Index can't be edited"
    fi
    fi
}
function do_delete {
    Page=$1
if [ -e "$Page" ] #It controls if the file in parameter exists
then
    echo "Do you really want to remove $Page ?"
    read -r Reponse
    Rep=$(echo "$Reponse" | tr '[A-Z]' '[a-z]') # It converts uppercase characters to lowercase
    if [ "$Rep" == "y" ] || [ "$Rep" == "yes" ];
    then
        rm -r "$Page"
        echo "$Page has been removed"
    else
        echo "$Page hasn't been removed"
    fi
else
    echo "$Page doesn't exist"
fi
}
function do_list {
 nbfichier=$(ls markdown | wc -l)
    #Show numbers of files that data contain.
    function nbline {
        if [ $nbfichier -eq 1 ]
            then
            echo "You have $nbfichier file."
        else
            echo "You have $nbfichier files."
        fi
    }
    # if there is files in the data folder, it will show their name.
    function list {
        if [ $nbfichier -gt 0 ]
        then
            ls markdown |  sed ':a;N;$!ba;s/\n/   /g'
        fi        
    }

    nbline
    list
}
function do_show {
    if [ $# -eq 1 ]
    then
        PDF=$1
        pdf=$(echo "$PDF" | tr '[A-Z]' '[a-z]') #It converts uppercased characters to lowercase
    fi
    if [ $# -eq 0 ] #It controls if there is a parameter and if there isn't a parameter it opens the file in html format
    then
        xdg-open ./web/index.html 2> /dev/null
        if [ ! -e ./web/index.html ] 
        then
            echo "index.html hasn't been created"
        fi
    elif [ "$pdf" = "pdf" ]; # If there the parameter "pdf" it open the file in pdf format
    then
        xdg-open web/blog.pdf 2> /dev/null
        if [ ! -e web/blog.pdf ] #If the file doesn't exits it show an error message
        then
            echo "blog.pdf hasn't been created"
        fi
    else 
        echo "I don't understand your parameter"
    fi
}
function do_fail {
 echo "[ERROR] : Wrong/Absent parameter."
 echo "[USAGE] : ./blogue.sh build"
 echo "[USAGE] : ./blogue.sh edit"
 echo "[USAGE] : ./blogue.sh delete"
 echo "[USAGE] : ./blogue.sh list"
 echo "[USAGE] : ./blogue.sh show"
}

if [ $# -eq 0 ]
then
    do_fail
else

parameter=$1
main
case "$parameter" in

    build)
        if [ -e markdown ]
        then
        echo "Currently building..."
        else
            mkdir markdown
            touch markdown/changeMe.md
        fi
            do_build
        ;;
    edit)
    if [ $# -eq 2 ] && [ -e markdown ]
        then
        do_edit "$2"
    else
        echo "[ERROR] : Enter your file in parameter of the function or be sure to done a ./blogue.sh build firstly. "
    fi
        ;;
    delete)
        if [ $# -eq 2 ] && [ -e markdown ]
        then
            do_delete "$2"
        else
        echo "[ERROR] : There is no parameter or be sure to done a ./blogue.sh build firstly."
        fi
        ;;
    list)
        if [ -e markdown ]
        then
            do_list
        else
        echo "[ERROR] : You better make a ./blogue.sh build first."
        fi
        
        ;;
    show)
    if [ $# -eq 2 ]
    then
       do_show "$2" 
    elif [ $# -eq 1 ] 
    then
       do_show 
    fi
        ;;
    
    *)
        do_fail
        ;;
    esac

fi
###########################################################
#   CopyRight : TISSOT Priscilla and QUATTROCHI Anthony   #
###########################################################