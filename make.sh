#!/bin/bash

if [[ "$1" == "" ]]; then
	# Build all `md` files
	for f in *.md; do
		echo "Building: $f"
		bn="$(basename "$f" .md)"
		"$0" "$bn"
	done
	echo "Built all documents. Calculating hashes..."
	sha256sum ./* > sha256sum.txt
	b2sum ./* > b2sum.txt
	echo "Calculated hashes. Signing generated files..."
	for f in *; do
		echo "Signing: $f"
		# verify with `minisign -Vm <file> -P RWQ0WYJ07DUokK8V/6LNJ9bf/O/QM9k4FSlDmzgEeXm7lEpw3ecYjXDM`
#		gpg --armor --sign "$f"
		yes '' | minisign -S -s /home/user/.minisign/minisign.key -m "$f"
	done
	echo "Signed all files. Done."
	exit
fi

bn="$1"

echo "Generating PDF..."
pandoc --self-contained "$bn".md -o "$bn".pdf -t ms --metadata title="The Hitchhiker's Guide to Online Anonymity"
echo "Generating HTML..."
pandoc --self-contained "$bn".md -o "$bn".html --metadata title="The Hitchhiker's Guide to Online Anonymity"
echo "Generating ODT..."
pandoc --self-contained "$bn".md -o "$bn".odt --metadata title="The Hitchhiker's Guide to Online Anonymity"
#pandoc --self-contained -t slidy guide.md -o guide.pdf
#markdown guide.md > guide.html
