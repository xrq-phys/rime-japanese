#!/bin/bash

echo "Warning: This conversion could take a VERY LONG TIME."

# Don't use the slow variant.
if (( 0 == 1 )); then
if [ -e tools/mozc_ut.dict_contents.txt ]; then
	rm tools/mozc_ut.dict_contents.txt
fi

while read term; do
	S=$(echo $term | awk '{ print $1 }')
	K=$(echo $term | awk '{ print $5 }')
	while read rule; do
		S=$(echo $S | sed -e "s/$(echo $rule | awk '{ print $1 }')/$(echo $rule | awk '{ print $2 }')/g")
	done < tools/kana2latin.txt;
	echo "$K	$S" >> tools/mozc_ut.dict_contents.txt
done < tools/mozc_ut.txt
fi

cat tools/mozc_ut.txt | awk '{ print $1 }' > tools/mozc_ut.kana.txt
cat tools/mozc_ut.txt | awk '{ print $5 }' > tools/mozc_ut.kanji.txt
S=$(cat tools/mozc_ut.kana.txt);
while read rule; do
	S=$(echo $S | sed -e "s/$(echo $rule | awk '{ print $1 }')/$(echo $rule | awk '{ print $2 }')/g")
done < tools/kana2latin.txt;
echo "$S" | sed -e 's/ /\n/g' > tools/mozc_ut.latin.txt
paste -d"\t" tools/mozc_ut.kanji.txt tools/mozc_ut.latin.txt > tools/mozc_ut.dict_contents.txt

