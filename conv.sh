#! /usr/bin/bash
echo
if [ ! -d PDFs ]; then
	mkdir PDFs
	echo -e "Output folder created.\n"
else
	echo -e "Selecting existing output folder.\n"
fi

files=$(ls -p | grep -v / | wc -l)
unread=$(ls -p PDFs/ | grep -v / | wc -l)
total=$((files-unread))
count=0

echo -e "Found $total files to convert\n"
echo -e "LaTeX engines\n------------\n"

PS3=$'\n'"Please choose a LaTeX engine: "
select option in pdflatex lualatex xelatex
do
    case $option in
        pdflatex) 
            echo "pdflatex engine selected";;
        lualatex) 
            echo "lualatex engine selected";;
        xelatex)
        	echo "xelatex";;
        *)
			echo "Please choose an option";;
	esac
	break
done
echo

echo -n "Add any latex typesetting variables you would like (e.g. --variable mainfont:\"Cabin\"): "
read variable

echo -e "\nBeginning conversion..."

find . -iname "*.mdown" | while read -r i; do
	y="$i"
	x="${y%.*}"
	z="${x##*/}"
	if [ ! -f ./PDFs/"$z".pdf ]; then
		pandoc -f markdown "$i" --latex-engine=$option --variable font-family:sans-serif $variable -o ./PDFs/"$z".pdf  
	 	((count++))
	 	echo $count/$total Complete!
	fi
done

echo All files complete!
