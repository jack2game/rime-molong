#!/bin/bash

# Check if any argument is provided
if [ "$#" -gt 1 ]; then
	# echo "Usage: $0 <arg1> [arg2] [arg3] ..."
	echo "Packing..."
	rm *.7z
	7z a molong-chs.7z molong-chs/
	7z a molong-cht.7z molong-cht/

	7z a xhloopfly-chs.7z xhloopfly-chs/
	7z a xhloopfly-cht.7z xhloopfly-cht/

	7z a xhloopkai-chs.7z xhloopkai-chs/
	7z a xhloopkai-cht.7z xhloopkai-cht/

	7z a zrloopkai-chs.7z zrloopkai-chs/
	7z a zrloopkai-cht.7z zrloopkai-cht/

	7z a molongkai-chs.7z molongkai-chs/
	7z a molongkai-cht.7z molongkai-cht/

	7z a xhloopmoqi-chs.7z xhloopmoqi-chs/
	7z a xhloopmoqi-cht.7z xhloopmoqi-cht/

	7z a xhupmoqi-chs.7z xhupmoqi-chs/
	7z a xhupmoqi-cht.7z xhupmoqi-cht/

	7z a xhupkai-chs.7z xhupkai-chs/
	7z a xhupkai-cht.7z xhupkai-cht/

	7z a xhupzrmfast-chs.7z xhupzrmfast-chs/
	7z a xhupzrmfast-cht.7z xhupzrmfast-cht/

	echo "Releasing $1..."
	gh release create "$1" --generate-notes --title "$1 - $2" *.7z
	rm *.7z
	# exit 1

else
	bash make_molong.sh
	bash make_xhloopfly.sh
	bash make_xhloopkai.sh
	bash make_zrloopkai.sh
	bash make_molongkai.sh
	bash make_xhloopmoqi.sh
	bash make_xhupmoqi.sh
	bash make_xhupkai.sh
	bash make_xhupzrmfast.sh
	cd tools-additional/

	echo ""
	echo "Updating dazhu for molong-chs..."
	python3 dazhu.py --folder 'molong-chs' -f    --output 'dazhu-molong-chs.txt'
	# python3 dazhu.py --folder 'molong-chs'       --output 'dazhu-molong-chs-single.txt'

	echo ""
	echo "Updating dazhu for xhloopkai-chs..."
	python3 dazhu.py --folder 'xhloopkai-chs' -f --output 'dazhu-xhloopkai-chs.txt'
	# python3 dazhu.py --folder 'xhloopkai-chs'    --output 'dazhu-xhloopkai-chs-single.txt'

	# echo ""
	# echo "Updating dazhu for zrloopkai-chs..."
	# python3 dazhu.py --folder 'zrloopkai-chs' -f --output 'dazhu-zrloopkai-chs.txt'
	# python3 dazhu.py --folder 'zrloopkai-chs'    --output 'dazhu-zrloopkai-chs-single.txt'

	cd ..
fi