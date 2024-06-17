#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhupmoqi-chs
rm -rf xhupmoqi-cht

# 生成繁體
cp -a ./rime-moran/. ./xhupmoqi-cht

rm -rf ./xhupmoqi-cht/.git
rm -rf ./xhupmoqi-cht/.gitignore
rm -rf ./xhupmoqi-cht/README.md
rm -rf ./xhupmoqi-cht/README-en.md
rm -rf ./xhupmoqi-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./xhupmoqi-cht/moran.yaml
perl -0777 -i -pe 's/(  user_sentence_top:)\n(    __append:)\n(      __patch:)/$1\n# $2\n# $3/' ./xhupmoqi-cht/moran.yaml
# mv ./xhupmoqi-cht/punctuation.yaml ./schema
cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./xhupmoqi-cht/opencc/moran_chaifen.txt
sed -i -E 's/^(\S+)\t(\S+)\t(.+)$/\1\t〔\3\2〕/' ./xhupmoqi-cht/opencc/moran_chaifen.txt
cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./tools-additional/moqidb.txt # && sed -i '0,/\.\.\./d' ./tools-additional/moqidb.txt
perl -CSAD -i -pe 's/(.*\t[a-z]{2})\t.*/$1/' ./tools-additional/moqidb.txt

# 生成簡體
cd ./xhupmoqi-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhupmoqi-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupmoqi-cht/moran.chars.dict.yaml > ../xhupmoqi-cht/moran.chars.dict.yaml.bak
mv ../xhupmoqi-cht/moran.chars.dict.yaml{.bak,} && perl -CSAD -i -pe "s/([a-z]{2});[a-z]{2}/\1/g" ../xhupmoqi-cht/moran.chars.dict.yaml
sed '/\.\.\./q' ../xhupmoqi-cht/moran.chars.dict.yaml > ../xhupmoqi-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p static -x moqidb -i ../xhupmoqi-cht/moran.chars.dict.yaml -o ../xhupmoqi-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhupmoqi-cht/temp.txt && sed -i '0,/\.\.\./d' ../xhupmoqi-cht/temp.txt
awk 'NF >= 2 && /^[^\s]+\t[a-z;]+/ && !seen[$1 FS $2]++ {print $0}' ../xhupmoqi-cht/temp.txt > temp && mv temp ../xhupmoqi-cht/temp.txt
echo "" >> ../xhupmoqi-cht/moran.chars.dict.yaml.bak && cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhupmoqi-cht/moran.base.dict.yaml > ../xhupmoqi-cht/moran.base.dict.yaml.bak
cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupmoqi-cht/ice.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhupmoqi-cht/ice.base.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../xhupmoqi-cht/ice.base.dict.yaml -o ../xhupmoqi-cht/temp.txt
# echo "" >> ../xhupmoqi-cht/moran.base.dict.yaml.bak
cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran.base.dict.yaml.bak
rm ../xhupmoqi-cht/ice.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-cht/moran.tencent.dict.yaml > ../../xhupmoqi-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-cht/moran.moe.dict.yaml > ../../xhupmoqi-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-cht/moran.computer.dict.yaml > ../../xhupmoqi-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-cht/moran.hanyu.dict.yaml > ../../xhupmoqi-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-cht/moran.words.dict.yaml > ../../xhupmoqi-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupmoqi-cht/zrlf.dict.yaml -o ../xhupmoqi-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupmoqi-cht/moran_fixed.dict.yaml > ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupmoqi.simpchars.txt ../xhupmoqi-cht/xhupmoqi.simpchars.txt && opencc -i ../xhupmoqi-cht/xhupmoqi.simpchars.txt -o ../xhupmoqi-cht/temp.txt -c s2t
echo "" >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhup.simpwords.txt -o ../xhupmoqi-cht/temp.txt -c s2t
echo "" >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak && cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhupmoqi-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhupmoqi-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupmoqi-cht/moran_fixed.dict.yaml
# sed '0,/#----------詞庫----------#/d' ../xhupmoqi-cht/moran_fixed.dict.yaml >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../xhupmoqi-cht/temp.txt -c s2t
echo "" >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak && cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed.dict.yaml.bak
rm ../xhupmoqi-cht/xhupmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../xhupmoqi-cht/moran_fixed_simp.dict.yaml > ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupmoqi.simpchars.txt ../xhupmoqi-cht/xhupmoqi.simpchars.txt && cp ../xhupmoqi-cht/xhupmoqi.simpchars.txt ../xhupmoqi-cht/temp.txt
echo "" >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhup.simpwords.txt ../xhupmoqi-cht/temp.txt
echo "" >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak && cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhupmoqi-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhupmoqi-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupmoqi-cht/moran_fixed_simp.dict.yaml
# sed '0,/#----------词库----------#/d' ../xhupmoqi-cht/moran_fixed_simp.dict.yaml >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../xhupmoqi-cht/temp.txt
echo "" >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak && cat ../xhupmoqi-cht/temp.txt >> ../xhupmoqi-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhupmoqi-cht/xhupmoqi.simpchars.txt

mv ../xhupmoqi-cht/moran.chars.dict.yaml{.bak,}
mv ../xhupmoqi-cht/moran.base.dict.yaml{.bak,}
# mv ../xhupmoqi-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhupmoqi-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhupmoqi-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhupmoqi-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhupmoqi-cht/moran.words.dict.yaml{.bak,}
mv ../xhupmoqi-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhupmoqi-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupmoqi-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupmoqi-chs/moran.chars.dict.yaml > ../xhupmoqi-chs/moran.chars.dict.yaml.bak
mv ../xhupmoqi-chs/moran.chars.dict.yaml{.bak,} && perl -CSAD -i -pe "s/([a-z]{2});[a-z]{2}/\1/g" ../xhupmoqi-chs/moran.chars.dict.yaml
sed '/\.\.\./q' ../xhupmoqi-chs/moran.chars.dict.yaml > ../xhupmoqi-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p static -x moqidb -i ../xhupmoqi-chs/moran.chars.dict.yaml -o ../xhupmoqi-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhupmoqi-chs/temp.txt && sed -i '0,/\.\.\./d' ../xhupmoqi-chs/temp.txt
awk 'NF >= 2 && /^[^\s]+\t[a-z;]+/ && !seen[$1 FS $2]++ {print $0}' ../xhupmoqi-chs/temp.txt > temp && mv temp ../xhupmoqi-chs/temp.txt
echo "" >> ../xhupmoqi-chs/moran.chars.dict.yaml.bak && cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhupmoqi-chs/moran.base.dict.yaml > ../xhupmoqi-chs/moran.base.dict.yaml.bak
cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupmoqi-chs/ice.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhupmoqi-chs/ice.base.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../xhupmoqi-chs/ice.base.dict.yaml -o ../xhupmoqi-chs/temp.txt
# echo "" >> ../xhupmoqi-chs/moran.base.dict.yaml.bak
cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran.base.dict.yaml.bak
rm ../xhupmoqi-chs/ice.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-chs/moran.tencent.dict.yaml > ../../xhupmoqi-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-chs/moran.moe.dict.yaml > ../../xhupmoqi-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-chs/moran.computer.dict.yaml > ../../xhupmoqi-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-chs/moran.hanyu.dict.yaml > ../../xhupmoqi-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupmoqi-chs/moran.words.dict.yaml > ../../xhupmoqi-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupmoqi-chs/zrlf.dict.yaml -o ../xhupmoqi-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupmoqi-chs/moran_fixed.dict.yaml > ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupmoqi.simpchars.txt ../xhupmoqi-chs/xhupmoqi.simpchars.txt && opencc -i ../xhupmoqi-chs/xhupmoqi.simpchars.txt -o ../xhupmoqi-chs/temp.txt -c s2t
echo "" >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhup.simpwords.txt -o ../xhupmoqi-chs/temp.txt -c s2t
echo "" >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak && cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhupmoqi-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhupmoqi-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupmoqi-chs/moran_fixed.dict.yaml
# sed '0,/#----------詞庫----------#/d' ../xhupmoqi-chs/moran_fixed.dict.yaml >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../xhupmoqi-chs/temp.txt -c s2t
echo "" >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak && cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed.dict.yaml.bak
rm ../xhupmoqi-chs/xhupmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../xhupmoqi-chs/moran_fixed_simp.dict.yaml > ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupmoqi.simpchars.txt ../xhupmoqi-chs/xhupmoqi.simpchars.txt && cp ../xhupmoqi-chs/xhupmoqi.simpchars.txt ../xhupmoqi-chs/temp.txt
echo "" >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhup.simpwords.txt ../xhupmoqi-chs/temp.txt
echo "" >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak && cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhupmoqi-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhupmoqi-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupmoqi-chs/moran_fixed_simp.dict.yaml
# sed '0,/#----------词库----------#/d' ../xhupmoqi-chs/moran_fixed_simp.dict.yaml >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../xhupmoqi-chs/temp.txt
echo "" >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak && cat ../xhupmoqi-chs/temp.txt >> ../xhupmoqi-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhupmoqi-chs/xhupmoqi.simpchars.txt

mv ../xhupmoqi-chs/moran.chars.dict.yaml{.bak,}
mv ../xhupmoqi-chs/moran.base.dict.yaml{.bak,}
# mv ../xhupmoqi-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhupmoqi-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhupmoqi-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhupmoqi-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhupmoqi-chs/moran.words.dict.yaml{.bak,}
mv ../xhupmoqi-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhupmoqi-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupmoqi-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhupmoqi-cht/tools
rm -rf ./xhupmoqi-cht/make_simp_dist.sh
mkdir -p ./xhupmoqi-cht/ice-dicts/
mkdir -p ./xhupmoqi-chs/ice-dicts/
# cp -a ./xhupmoqi-cht/moran_fixed.dict.yaml ./schema/xhupmoqi_fixed.dict.yaml
# cp -a ./xhupmoqi-cht/moran_fixed_simp.dict.yaml ./schema/xhupmoqi_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhupmoqi.yaml ./xhupmoqi-cht/default.custom.yaml
cp -a ./schema/default.custom.xhupmoqi.yaml ./xhupmoqi-chs/default.custom.yaml

# 刪去詞語簡碼
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\n//g" ./schema/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\t.*\n//g" ./schema/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\n//g" ./schema/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff01}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\t.*\n//g" ./schema/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\n//g" ./schema/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\t.*\n//g" ./schema/moran_fixed.dict.yaml

# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\n//g" ./schema/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\n//g" ./schema/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\n//g" ./schema/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml

cd ./tools-additional
# 生成繁體霧凇
# python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/others.dict.yaml  -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -t -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupmoqi-cht/ice-dicts/xhupmoqi_moqidb_tencent.dict.yaml
# 生成簡體霧凇
# python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/others.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupmoqi -x moqidb -s -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupmoqi-chs/ice-dicts/xhupmoqi_moqidb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupmoqi-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupmoqi-cht
# cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupmoqi-cht
# sed '/\.\.\./q' ./xhupmoqi-cht/radical_flypy.dict.yaml > ./xhupmoqi-cht/radical_flypy.dict.yaml.bak
# python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhupmoqi-cht/moran.chars.dict.yaml
# echo "" >> ./xhupmoqi-cht/radical_flypy.dict.yaml.bak
# cat temp.txt >> ./xhupmoqi-cht/radical_flypy.dict.yaml.bak
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupmoqi-chs
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupmoqi-chs

rm -f temp.txt
rm -f ./xhupmoqi-cht/temp.txt
rm -f ./xhupmoqi-chs/temp.txt

echo xhupmoqi繁體設定檔...
cd xhupmoqi-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml && sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupmoqi_moqidb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupmoqi_moqidb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupmoqi/g" ./xhupmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupmoqi/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupmoqi = moran + xhup + moqi + ice/g" ./xhupmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupmoqi_fixed/g" ./xhupmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupmoqi_sentence/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupmoqi.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./xhupmoqi.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./xhupmoqi.schema.yaml

cp moran_aux.schema.yaml xhupmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupmoqi_aux/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupmoqi輔篩/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupmoqi」方案不同。/g" ./xhupmoqi_aux.schema.yaml

cp moran_bj.schema.yaml xhupmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupmoqi_bj/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupmoqi並擊/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupmoqi = moran + xhup + moqi + ice/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupmoqi_fixed/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupmoqi_sentence/g" ./xhupmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml xhupmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupmoqi_fixed/g" ./xhupmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupmoqi字詞/g" ./xhupmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupmoqi_sentence/g" ./xhupmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupmoqi整句/g" ./xhupmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_sentence.schema.yaml
cd ..

echo xhupmoqi简体設定檔...
cd xhupmoqi-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml && sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupmoqi_moqidb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupmoqi_moqidb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupmoqi/g" ./xhupmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupmoqi/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupmoqi = moran + xhup + moqi + ice/g" ./xhupmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupmoqi_fixed/g" ./xhupmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupmoqi_sentence/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupmoqi.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./xhupmoqi.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./xhupmoqi.schema.yaml

cp moran_aux.schema.yaml xhupmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupmoqi_aux/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupmoqi輔篩/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupmoqi」方案不同。/g" ./xhupmoqi_aux.schema.yaml

cp moran_bj.schema.yaml xhupmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupmoqi_bj/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupmoqi並擊/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupmoqi = moran + xhup + moqi + ice/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupmoqi_fixed/g" ./xhupmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupmoqi_sentence/g" ./xhupmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml xhupmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupmoqi_fixed/g" ./xhupmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupmoqi字詞/g" ./xhupmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupmoqi_sentence/g" ./xhupmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupmoqi整句/g" ./xhupmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupmoqi_sentence.schema.yaml
cd ..
