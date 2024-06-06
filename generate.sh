#!/bin/bash

set -x

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

	7z a morankai-chs.7z morankai-chs/
	7z a morankai-cht.7z morankai-cht/

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
	bash make_morankai.sh 2>&1 | sed 's/^/make_morankai: /'
	# bash make_xhloopfly.sh 2>&1 | sed 's/^/make_xhloopfly: /'
	bash make_xhloopkai.sh 2>&1 | sed 's/^/make_xhloopkai: /'
	bash make_xhloopmoqi.sh 2>&1 | sed 's/^/make_xhloopmoqi: /'
	bash make_xhupkai.sh 2>&1 | sed 's/^/make_xhupkai: /'
	bash make_xhupmoqi.sh 2>&1 | sed 's/^/make_xhupmoqi: /'
	# bash make_xhupzrmfast.sh 2>&1 | sed 's/^/make_xhupzrmfast: /'
	bash make_zrloopkai.sh 2>&1 | sed 's/^/make_zrloopkai: /'
	bash make_zrloopmoqi.sh 2>&1 | sed 's/^/make_zrloopmoqi: /'

	cp ./molong-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/molong.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/molong.chars.dict.txt
	cp ./molongkai-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/molongkai.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/molongkai.chars.dict.txt
	cp ./molongmoqi-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/molongmoqi.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/molongmoqi.chars.dict.txt
	cp ./morankai-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/morankai.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/morankai.chars.dict.txt
	cp ./xhloopfly-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/xhloopfly.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhloopfly.chars.dict.txt
	cp ./xhloopkai-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/xhloopkai.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhloopkai.chars.dict.txt
	cp ./xhloopmoqi-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/xhloopmoqi.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhloopmoqi.chars.dict.txt
	cp ./xhupkai-cht/moran.chars.dict.yaml   ./data/assess.tiger-code.com/chardicts/xhupkai.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhupkai.chars.dict.txt
	cp ./xhupmoqi-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/xhupmoqi.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhupmoqi.chars.dict.txt
	cp ./xhupzrmfast-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/xhupzrmfast.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/xhupzrmfast.chars.dict.txt
	cp ./zrloopkai-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/zrloopkai.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/zrloopkai.chars.dict.txt
	cp ./zrloopmoqi-cht/moran.chars.dict.yaml ./data/assess.tiger-code.com/chardicts/zrloopmoqi.chars.dict.txt  && sed -i '0,/\.\.\./d' ./data/assess.tiger-code.com/chardicts/zrloopmoqi.chars.dict.txt

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/xhloopkai.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/xhloopkai.chars.dict.txt >> ./xhupkai-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/xhloopkai.chars.dict.txt >> ./xhupkai-chs/moran.chars.dict.yaml

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/xhupkai.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/xhupkai.chars.dict.txt   >> ./xhloopkai-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/xhupkai.chars.dict.txt   >> ./xhloopkai-chs/moran.chars.dict.yaml

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/xhloopmoqi.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/xhloopmoqi.chars.dict.txt >> ./xhupmoqi-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/xhloopmoqi.chars.dict.txt >> ./xhupmoqi-chs/moran.chars.dict.yaml

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/xhupmoqi.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/xhupmoqi.chars.dict.txt >> ./xhloopmoqi-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/xhupmoqi.chars.dict.txt >> ./xhloopmoqi-chs/moran.chars.dict.yaml

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/morankai.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/morankai.chars.dict.txt >> ./zrloopkai-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/morankai.chars.dict.txt >> ./zrloopkai-chs/moran.chars.dict.yaml

	sed -i -E 's/([^\t]*\t)(.)(.)/\1\2\u\3/' ./data/assess.tiger-code.com/chardicts/zrloopkai.chars.dict.txt
	cat ./data/assess.tiger-code.com/chardicts/zrloopkai.chars.dict.txt >> ./morankai-cht/moran.chars.dict.yaml
	cat ./data/assess.tiger-code.com/chardicts/zrloopkai.chars.dict.txt >> ./morankai-chs/moran.chars.dict.yaml

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

	python3 gen_dict_with_shape.py -p tonenum2tonesymbol -x emptydb -i ../data/zdicdbtonesorted.yaml -o ./pinyinwithtone.txt

	cd ..
fi
