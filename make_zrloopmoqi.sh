#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf zrloopmoqi-chs
rm -rf zrloopmoqi-cht

# 生成繁體
cp -a ./rime-moran/. ./zrloopmoqi-cht

rm -rf ./zrloopmoqi-cht/.git
rm -rf ./zrloopmoqi-cht/.gitignore
rm -rf ./zrloopmoqi-cht/README.md
rm -rf ./zrloopmoqi-cht/README-en.md
rm -rf ./zrloopmoqi-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./zrloopmoqi-cht/moran.yaml
perl -0777 -i -pe 's/(  user_sentence_top:)\n(    __append:)\n(      __patch:)/$1\n# $2\n# $3/' ./zrloopmoqi-cht/moran.yaml
# mv ./zrloopmoqi-cht/punctuation.yaml ./schema
cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./zrloopmoqi-cht/opencc/moran_chaifen.txt
sed -i -E 's/^(\S+)\t(\S+)\t(.+)$/\1\t〔\3\2〕/' ./zrloopmoqi-cht/opencc/moran_chaifen.txt
cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./tools-additional/moqidb.txt # && sed -i '0,/\.\.\./d' ./tools-additional/moqidb.txt
perl -CSAD -i -pe 's/(.*\t[a-z]{2})\t.*/$1/' ./tools-additional/moqidb.txt

# 生成簡體
cd ./zrloopmoqi-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/zrloopmoqi-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../zrloopmoqi-cht/moran.chars.dict.yaml > ../zrloopmoqi-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../zrloopmoqi-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../zrloopmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloopmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloopmoqi-cht/temp.txt
echo "" >> ../zrloopmoqi-cht/moran.chars.dict.yaml.bak
cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloopmoqi-cht/moran.base.dict.yaml > ../zrloopmoqi-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloopmoqi-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../zrloopmoqi-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -t -i ../zrloopmoqi-cht/snow_pinyin.base.dict.yaml -o ../zrloopmoqi-cht/temp.txt
# echo "" >> ../zrloopmoqi-cht/moran.base.dict.yaml.bak
cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran.base.dict.yaml.bak
rm ../zrloopmoqi-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-cht/moran.tencent.dict.yaml > ../../zrloopmoqi-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-cht/moran.moe.dict.yaml > ../../zrloopmoqi-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-cht/moran.computer.dict.yaml > ../../zrloopmoqi-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-cht/moran.hanyu.dict.yaml > ../../zrloopmoqi-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-cht/moran.words.dict.yaml > ../../zrloopmoqi-cht/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../zrloopmoqi-cht/zrlf.dict.yaml -o ../zrloopmoqi-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../zrloopmoqi-cht/moran_fixed.dict.yaml > ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopmoqi.simpchars.txt ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt && opencc -i ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt -o ../zrloopmoqi-cht/temp.txt -c s2t
echo "" >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/zrloop.simpwords.txt -o ../zrloopmoqi-cht/temp.txt -c s2t
echo "" >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak && cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../zrloopmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopmoqi-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../zrloopmoqi-cht/moran_fixed.dict.yaml >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../zrloopmoqi-cht/temp.txt -c s2t
echo "" >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak && cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../zrloopmoqi-cht/moran_fixed.dict.yaml.bak
rm ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml > ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopmoqi.simpchars.txt ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt && cp ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt ../zrloopmoqi-cht/temp.txt
echo "" >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloop.simpwords.txt ../zrloopmoqi-cht/temp.txt
echo "" >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak && cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../zrloopmoqi-cht/temp.txt
echo "" >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak && cat ../zrloopmoqi-cht/temp.txt >> ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
rm ../zrloopmoqi-cht/zrloopmoqi.simpchars.txt

mv ../zrloopmoqi-cht/moran.chars.dict.yaml{.bak,}
mv ../zrloopmoqi-cht/moran.base.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/moran.tencent.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/moran.moe.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/moran.computer.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/moran.words.dict.yaml{.bak,}
mv ../zrloopmoqi-cht/moran_fixed.dict.yaml{.bak,}
mv ../zrloopmoqi-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloopmoqi-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../zrloopmoqi-chs/moran.chars.dict.yaml > ../zrloopmoqi-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../zrloopmoqi-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../zrloopmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloopmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloopmoqi-chs/temp.txt
echo "" >> ../zrloopmoqi-chs/moran.chars.dict.yaml.bak
cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloopmoqi-chs/moran.base.dict.yaml > ../zrloopmoqi-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloopmoqi-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../zrloopmoqi-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -s -i ../zrloopmoqi-chs/snow_pinyin.base.dict.yaml -o ../zrloopmoqi-chs/temp.txt
# echo "" >> ../zrloopmoqi-chs/moran.base.dict.yaml.bak
cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran.base.dict.yaml.bak
rm ../zrloopmoqi-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-chs/moran.tencent.dict.yaml > ../../zrloopmoqi-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-chs/moran.moe.dict.yaml > ../../zrloopmoqi-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-chs/moran.computer.dict.yaml > ../../zrloopmoqi-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-chs/moran.hanyu.dict.yaml > ../../zrloopmoqi-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopmoqi-chs/moran.words.dict.yaml > ../../zrloopmoqi-chs/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../zrloopmoqi-chs/zrlf.dict.yaml -o ../zrloopmoqi-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../zrloopmoqi-chs/moran_fixed.dict.yaml > ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopmoqi.simpchars.txt ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt && opencc -i ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt -o ../zrloopmoqi-chs/temp.txt -c s2t
echo "" >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/zrloop.simpwords.txt -o ../zrloopmoqi-chs/temp.txt -c s2t
echo "" >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak && cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../zrloopmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopmoqi-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../zrloopmoqi-chs/moran_fixed.dict.yaml >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../zrloopmoqi-chs/temp.txt -c s2t
echo "" >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak && cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../zrloopmoqi-chs/moran_fixed.dict.yaml.bak
rm ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml > ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopmoqi.simpchars.txt ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt && cp ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt ../zrloopmoqi-chs/temp.txt
echo "" >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloop.simpwords.txt ../zrloopmoqi-chs/temp.txt
echo "" >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak && cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../zrloopmoqi-chs/temp.txt
echo "" >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak && cat ../zrloopmoqi-chs/temp.txt >> ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
rm ../zrloopmoqi-chs/zrloopmoqi.simpchars.txt

mv ../zrloopmoqi-chs/moran.chars.dict.yaml{.bak,}
mv ../zrloopmoqi-chs/moran.base.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/moran.tencent.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/moran.moe.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/moran.computer.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/moran.words.dict.yaml{.bak,}
mv ../zrloopmoqi-chs/moran_fixed.dict.yaml{.bak,}
mv ../zrloopmoqi-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloopmoqi-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./zrloopmoqi-cht/tools
rm -rf ./zrloopmoqi-cht/make_simp_dist.sh
mkdir -p ./zrloopmoqi-cht/snow-dicts/
mkdir -p ./zrloopmoqi-chs/snow-dicts/
# cp -a ./zrloopmoqi-cht/moran_fixed.dict.yaml ./schema/zrloopmoqi_fixed.dict.yaml
# cp -a ./zrloopmoqi-cht/moran_fixed_simp.dict.yaml ./schema/zrloopmoqi_fixed_simp.dict.yaml
cp -a ./schema/default.custom.zrloopmoqi.yaml ./zrloopmoqi-cht/default.custom.yaml
cp -a ./schema/default.custom.zrloopmoqi.yaml ./zrloopmoqi-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloopmoqi-cht/snow-dicts/zrloopmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -t -o ../zrloopmoqi-cht/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -t -o ../zrloopmoqi-cht/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -t -o ../zrloopmoqi-cht/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -t -o ../zrloopmoqi-cht/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -t -o ../zrloopmoqi-cht/snow-dicts/flypy_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -t -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../zrloopmoqi-cht/snow-dicts/zrloopmoqi_moqidb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloopmoqi-chs/snow-dicts/zrloopmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -o ../zrloopmoqi-chs/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -o ../zrloopmoqi-chs/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -o ../zrloopmoqi-chs/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -o ../zrloopmoqi-chs/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -o ../zrloopmoqi-chs/snow-dicts/flypy_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p zrloopmoqi -x moqidb -s -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../zrloopmoqi-chs/snow-dicts/zrloopmoqi_moqidb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./zrloopmoqi-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./zrloopmoqi-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./zrloopmoqi-cht
sed '/\.\.\./q' ./zrloopmoqi-cht/radical_flypy.dict.yaml > ./zrloopmoqi-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./zrloopmoqi-cht/moran.chars.dict.yaml
echo "" >> ./zrloopmoqi-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./zrloopmoqi-cht/radical_flypy.dict.yaml.bak
mv ./zrloopmoqi-cht/radical_flypy.dict.yaml{.bak,}
cp ./zrloopmoqi-cht/radical_flypy.dict.yaml ./zrloopmoqi-chs

rm -f temp.txt
rm -f ./zrloopmoqi-cht/temp.txt
rm -f ./zrloopmoqi-chs/temp.txt

echo zrloopmoqi繁體設定檔...
cd zrloopmoqi-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopmoqi_moqidb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloopmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloopmoqi/g" ./zrloopmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloopmoqi/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopmoqi = moran + zrloop + moqi + snow/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopmoqi_fixed/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopmoqi_sentence/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloopmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloopmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloopmoqi.schema.yaml
# sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./zrloopmoqi.schema.yaml
# sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./zrloopmoqi.schema.yaml

cp moran_aux.schema.yaml zrloopmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloopmoqi_aux/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloopmoqi輔篩/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloopmoqi」方案不同。/g" ./zrloopmoqi_aux.schema.yaml

# cp moran_bj.schema.yaml zrloopmoqi_bj.schema.yaml
# sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloopmoqi_bj/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^  name: 魔然·並擊G$/  name: zrloopmoqi並擊/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopmoqi = moran + zrloop + moqi + snow/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    - moran_fixed$/    - zrloopmoqi_fixed/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    - moran_sentence$/    - zrloopmoqi_sentence/g" ./zrloopmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml zrloopmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloopmoqi_fixed/g" ./zrloopmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloopmoqi字詞/g" ./zrloopmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloopmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloopmoqi_sentence/g" ./zrloopmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloopmoqi整句/g" ./zrloopmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_sentence.schema.yaml
cd ..

echo zrloopmoqi简体設定檔...
cd zrloopmoqi-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopmoqi_moqidb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloopmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloopmoqi/g" ./zrloopmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloopmoqi/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopmoqi = moran + zrloop + moqi + snow/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopmoqi_fixed/g" ./zrloopmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopmoqi_sentence/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloopmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloopmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloopmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloopmoqi.schema.yaml
# sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./zrloopmoqi.schema.yaml
# sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./zrloopmoqi.schema.yaml

cp moran_aux.schema.yaml zrloopmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloopmoqi_aux/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloopmoqi輔篩/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloopmoqi」方案不同。/g" ./zrloopmoqi_aux.schema.yaml

# cp moran_bj.schema.yaml zrloopmoqi_bj.schema.yaml
# sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloopmoqi_bj/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^  name: 魔然·並擊G$/  name: zrloopmoqi並擊/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopmoqi = moran + zrloop + moqi + snow/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    - moran_fixed$/    - zrloopmoqi_fixed/g" ./zrloopmoqi_bj.schema.yaml
# sed -i "s/^    - moran_sentence$/    - zrloopmoqi_sentence/g" ./zrloopmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml zrloopmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloopmoqi_fixed/g" ./zrloopmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloopmoqi字詞/g" ./zrloopmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloopmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloopmoqi_sentence/g" ./zrloopmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloopmoqi整句/g" ./zrloopmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopmoqi_sentence.schema.yaml
cd ..
