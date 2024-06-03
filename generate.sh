#!/bin/bash

# Check if any argument is provided
if [ "$#" -gt 1 ]; then
	# echo "Usage: $0 <arg1> [arg2] [arg3] ..."
	echo "Packing..."
	rm *.7z

	7z a molong-chs.7z molong-chs/
	7z a molong-cht.7z molong-cht/

	7z a molongkai-chs.7z molongkai-chs/
	7z a molongkai-cht.7z molongkai-cht/

	7z a molongmoqi-chs.7z molongmoqi-chs/
	7z a molongmoqi-cht.7z molongmoqi-cht/

	7z a xhloopfly-chs.7z xhloopfly-chs/
	7z a xhloopfly-cht.7z xhloopfly-cht/

	7z a xhloopkai-chs.7z xhloopkai-chs/
	7z a xhloopkai-cht.7z xhloopkai-cht/

	7z a xhloopmoqi-chs.7z xhloopmoqi-chs/
	7z a xhloopmoqi-cht.7z xhloopmoqi-cht/

	7z a xhupkai-chs.7z xhupkai-chs/
	7z a xhupkai-cht.7z xhupkai-cht/

	7z a xhupmoqi-chs.7z xhupmoqi-chs/
	7z a xhupmoqi-cht.7z xhupmoqi-cht/

	7z a xhupzrmfast-chs.7z xhupzrmfast-chs/
	7z a xhupzrmfast-cht.7z xhupzrmfast-cht/

	7z a zrloopkai-chs.7z zrloopkai-chs/
	7z a zrloopkai-cht.7z zrloopkai-cht/

	7z a zrloopmoqi-chs.7z zrloopmoqi-chs/
	7z a zrloopmoqi-cht.7z zrloopmoqi-cht/

	echo "Releasing $1..."
	gh release create "$1" --generate-notes --title "$1 - $2" *.7z
	rm *.7z
	# exit 1

else
	bash make_molong.sh 2>&1 | sed 's/^/make_molong: /'
	bash make_molongkai.sh 2>&1 | sed 's/^/make_molongkai: /'
	bash make_molongmoqi.sh 2>&1 | sed 's/^/make_molongmoqi: /'
	bash make_xhloopfly.sh 2>&1 | sed 's/^/make_xhloopfly: /'
	bash make_xhloopkai.sh 2>&1 | sed 's/^/make_xhloopkai: /'
	bash make_xhloopmoqi.sh 2>&1 | sed 's/^/make_xhloopmoqi: /'
	bash make_xhupkai.sh 2>&1 | sed 's/^/make_xhupkai: /'
	bash make_xhupmoqi.sh 2>&1 | sed 's/^/make_xhupmoqi: /'
	bash make_xhupzrmfast.sh 2>&1 | sed 's/^/make_xhupzrmfast: /'
	bash make_zrloopkai.sh 2>&1 | sed 's/^/make_zrloopkai: /'
	bash make_zrloopmoqi.sh 2>&1 | sed 's/^/make_zrloopmoqi: /'

	cd tools-additional/

	echo ""
	echo "Updating dazhu for molong-chs..."
	python3 dazhu.py --folder 'molong-chs' -f    --output 'dazhu-molong-chs.txt'

	echo ""
	echo "Updating dazhu for xhloopkai-chs..."
	python3 dazhu.py --folder 'xhloopkai-chs' -f --output 'dazhu-xhloopkai-chs.txt'

	echo ""
	echo "Updating dazhu for molongkai-chs..."
	python3 dazhu.py --folder 'molongkai-chs' -f --output 'dazhu-molongkai-chs.txt'

	cd ..
fi