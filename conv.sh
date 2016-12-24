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
            echo -e "\npdflatex engine selected";;
        lualatex) 
            echo -e "\nlualatex engine selected";;
        xelatex)
        	echo -e "\nxelatex";;
        *)
			echo "Please choose an option";;
	esac
	break
done
echo

echo -n "Would you like to add any latex typesetting variables(e.g. --variable mainfont:\"Gill Sans\")?: "
read variable

echo -e "\nBeginning conversion...\n"

find . -iname "*.mdown" | while read -r i; do
	y="$i"
	x="${y%.*}"
	z="${x##*/}"
	if [ ! -f ./PDFs/"$z".pdf ]; then
		pandoc -f markdown "$i" --latex-engine=$option --variable font-family:sans-serif $variable -o ./PDFs/"$z".pdf  
	 	((count++))
	 	echo $count/$total compiled.
	fi
done

echo -e "\nAll files complete!"
