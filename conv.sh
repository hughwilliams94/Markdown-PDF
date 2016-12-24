# Checks for the presence of markdown files
echo
md=$(ls -1 *.md 2>/dev/null | wc -l)
mdown=$(ls -1 *.mdown 2>/dev/null | wc -l)
mark=$(ls -1 *.markdown 2>/dev/null | wc -l)
present=$(($md+$mdown+$mark))
if [ "$present" -eq 0 ]; then
	echo -e "No markdown files detected!\n"
	exit
fi

# Checks for output directory and creates one if missing
if [ ! -d PDFs ]; then
	mkdir PDFs
	echo -e "Output folder created.\n"
else
	echo -e "Selecting existing output folder.\n"
fi

# Finds and prints the total number of files to be compiled
files=$(ls -p | grep -v / | wc -l)
unread=$(ls -p PDFs/ | grep -v / | wc -l)
total=$((files-unread))
count=0
echo -e "Found $total files to convert\n"

# Asks user for the LaTeX engine to be used
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

# Allows user to add custom LaTeX variables 
echo -n "Would you like to add any LaTeX details(e.g. --variable mainfont:\"Gill Sans\")?: "
read variable

# Compiles documents
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
