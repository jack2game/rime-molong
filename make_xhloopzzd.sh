#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhloopzzd-chs
rm -rf xhloopzzd-cht

# 生成繁體
cp -a ./rime-moran/. ./xhloopzzd-cht

rm -rf ./xhloopzzd-cht/.git
rm -rf ./xhloopzzd-cht/.gitignore
rm -rf ./xhloopzzd-cht/README.md
rm -rf ./xhloopzzd-cht/README-en.md
rm -rf ./xhloopzzd-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./xhloopzzd-cht/moran.yaml
perl -0777 -i -pe 's/(  user_sentence_top:)\n(    __append:)\n(      __patch:)/$1\n# $2\n# $3/' ./xhloopzzd-cht/moran.yaml
# mv ./xhloopzzd-cht/punctuation.yaml ./schema
# cp ./rime-shuangpin-fuzhuma/opencc/zzd_chaifen.txt ./xhloopzzd-cht/opencc/moran_chaifen.txt
# sed -i -E 's/^(\S+)\t(\S+)\t(.+)$/\1\t〔\3\2〕/' ./xhloopzzd-cht/opencc/moran_chaifen.txt
# cp ./rime-shuangpin-fuzhuma/opencc/zzd_chaifen.txt ./tools-additional/zzddb.txt # && sed -i '0,/\.\.\./d' ./tools-additional/zzddb.txt
# perl -CSAD -i -pe 's/(.*\t[a-z]{2})\t.*/$1/' ./tools-additional/zzddb.txt

# 生成簡體
cd ./xhloopzzd-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhloopzzd-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../xhloopzzd-cht/moran.chars.dict.yaml > ../xhloopzzd-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -i ../data/zdicdbtonesorted.yaml -o ../xhloopzzd-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhloopzzd-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopzzd-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopzzd-cht/temp.txt
echo "" >> ../xhloopzzd-cht/moran.chars.dict.yaml.bak
cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopzzd-cht/moran.base.dict.yaml > ../xhloopzzd-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopzzd-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopzzd-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -t -i ../xhloopzzd-cht/snow_pinyin.base.dict.yaml -o ../xhloopzzd-cht/temp.txt
# echo "" >> ../xhloopzzd-cht/moran.base.dict.yaml.bak
cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran.base.dict.yaml.bak
rm ../xhloopzzd-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-cht/moran.tencent.dict.yaml > ../../xhloopzzd-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-cht/moran.moe.dict.yaml > ../../xhloopzzd-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-cht/moran.computer.dict.yaml > ../../xhloopzzd-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-cht/moran.hanyu.dict.yaml > ../../xhloopzzd-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-cht/moran.words.dict.yaml > ../../xhloopzzd-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopzzd-cht/zrlf.dict.yaml -o ../xhloopzzd-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopzzd-cht/moran_fixed.dict.yaml > ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopzzd.simpchars.txt ../xhloopzzd-cht/xhloopzzd.simpchars.txt && opencc -i ../xhloopzzd-cht/xhloopzzd.simpchars.txt -o ../xhloopzzd-cht/temp.txt -c s2t
echo "" >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhloop.simpwords.txt -o ../xhloopzzd-cht/temp.txt -c s2t
echo "" >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak && cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhloopzzd-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopzzd-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopzzd-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopzzd-cht/moran_fixed.dict.yaml >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../xhloopzzd-cht/temp.txt -c s2t
echo "" >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak && cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../xhloopzzd-cht/moran_fixed.dict.yaml.bak
rm ../xhloopzzd-cht/xhloopzzd.simpchars.txt

sed '/#----------词库----------#/q' ../xhloopzzd-cht/moran_fixed_simp.dict.yaml > ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopzzd.simpchars.txt ../xhloopzzd-cht/xhloopzzd.simpchars.txt && cp ../xhloopzzd-cht/xhloopzzd.simpchars.txt ../xhloopzzd-cht/temp.txt
echo "" >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloop.simpwords.txt ../xhloopzzd-cht/temp.txt
echo "" >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak && cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhloopzzd-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopzzd-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopzzd-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopzzd-cht/moran_fixed_simp.dict.yaml >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../xhloopzzd-cht/temp.txt
echo "" >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak && cat ../xhloopzzd-cht/temp.txt >> ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../xhloopzzd-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhloopzzd-cht/xhloopzzd.simpchars.txt

mv ../xhloopzzd-cht/moran.chars.dict.yaml{.bak,}
mv ../xhloopzzd-cht/moran.base.dict.yaml{.bak,}
# mv ../xhloopzzd-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopzzd-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhloopzzd-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhloopzzd-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopzzd-cht/moran.words.dict.yaml{.bak,}
mv ../xhloopzzd-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhloopzzd-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopzzd-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../xhloopzzd-chs/moran.chars.dict.yaml > ../xhloopzzd-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -i ../data/zdicdbtonesorted.yaml -o ../xhloopzzd-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhloopzzd-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopzzd-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopzzd-chs/temp.txt
echo "" >> ../xhloopzzd-chs/moran.chars.dict.yaml.bak
cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopzzd-chs/moran.base.dict.yaml > ../xhloopzzd-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopzzd-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopzzd-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -s -i ../xhloopzzd-chs/snow_pinyin.base.dict.yaml -o ../xhloopzzd-chs/temp.txt
# echo "" >> ../xhloopzzd-chs/moran.base.dict.yaml.bak
cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran.base.dict.yaml.bak
rm ../xhloopzzd-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-chs/moran.tencent.dict.yaml > ../../xhloopzzd-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-chs/moran.moe.dict.yaml > ../../xhloopzzd-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-chs/moran.computer.dict.yaml > ../../xhloopzzd-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-chs/moran.hanyu.dict.yaml > ../../xhloopzzd-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopzzd-chs/moran.words.dict.yaml > ../../xhloopzzd-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopzzd-chs/zrlf.dict.yaml -o ../xhloopzzd-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopzzd-chs/moran_fixed.dict.yaml > ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopzzd.simpchars.txt ../xhloopzzd-chs/xhloopzzd.simpchars.txt && opencc -i ../xhloopzzd-chs/xhloopzzd.simpchars.txt -o ../xhloopzzd-chs/temp.txt -c s2t
echo "" >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhloop.simpwords.txt -o ../xhloopzzd-chs/temp.txt -c s2t
echo "" >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak && cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhloopzzd-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopzzd-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopzzd-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopzzd-chs/moran_fixed.dict.yaml >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/common.simp.words.txt -o ../xhloopzzd-chs/temp.txt -c s2t
echo "" >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak && cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../xhloopzzd-chs/moran_fixed.dict.yaml.bak
rm ../xhloopzzd-chs/xhloopzzd.simpchars.txt

sed '/#----------词库----------#/q' ../xhloopzzd-chs/moran_fixed_simp.dict.yaml > ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopzzd.simpchars.txt ../xhloopzzd-chs/xhloopzzd.simpchars.txt && cp ../xhloopzzd-chs/xhloopzzd.simpchars.txt ../xhloopzzd-chs/temp.txt
echo "" >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloop.simpwords.txt ../xhloopzzd-chs/temp.txt
echo "" >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak && cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{1}\t[A-Za-z]+.*\n//g" ../xhloopzzd-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopzzd-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fff}\x{3007}\x{3400}-\x{4dbf}\x{20000}-\x{2a6df}\x{2a700}-\x{2b73f}\x{2b740}-\x{2b81f}\x{2b820}-\x{2ceaf}\x{2ceb0}-\x{2ebe0}\x{30000}-\x{3134a}\x{31350}-\x{323af}\x{2ebf0}-\x{2ee5f}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopzzd-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopzzd-chs/moran_fixed_simp.dict.yaml >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/common.simp.words.txt ../xhloopzzd-chs/temp.txt
echo "" >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak && cat ../xhloopzzd-chs/temp.txt >> ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak && perl -i -ne 'print if !$seen{$_}++' ../xhloopzzd-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhloopzzd-chs/xhloopzzd.simpchars.txt

mv ../xhloopzzd-chs/moran.chars.dict.yaml{.bak,}
mv ../xhloopzzd-chs/moran.base.dict.yaml{.bak,}
# mv ../xhloopzzd-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopzzd-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhloopzzd-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhloopzzd-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopzzd-chs/moran.words.dict.yaml{.bak,}
mv ../xhloopzzd-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhloopzzd-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopzzd-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhloopzzd-cht/tools
rm -rf ./xhloopzzd-cht/make_simp_dist.sh
mkdir -p ./xhloopzzd-cht/snow-dicts/
mkdir -p ./xhloopzzd-chs/snow-dicts/
# cp -a ./xhloopzzd-cht/moran_fixed.dict.yaml ./schema/xhloopzzd_fixed.dict.yaml
# cp -a ./xhloopzzd-cht/moran_fixed_simp.dict.yaml ./schema/xhloopzzd_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhloopzzd.yaml ./xhloopzzd-cht/default.custom.yaml
cp -a ./schema/default.custom.xhloopzzd.yaml ./xhloopzzd-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopzzd-cht/snow-dicts/xhloopzzd_zzddb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zzddb -t -o ../xhloopzzd-cht/snow-dicts/flypy_zzddb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zzddb -t -o ../xhloopzzd-cht/snow-dicts/flypy_zzddb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zzddb -t -o ../xhloopzzd-cht/snow-dicts/flypy_zzddb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zzddb -t -o ../xhloopzzd-cht/snow-dicts/flypy_zzddb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zzddb -t -o ../xhloopzzd-cht/snow-dicts/flypy_zzddb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -t -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../xhloopzzd-cht/snow-dicts/xhloopzzd_zzddb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopzzd-chs/snow-dicts/xhloopzzd_zzddb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zzddb -o ../xhloopzzd-chs/snow-dicts/flypy_zzddb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zzddb -o ../xhloopzzd-chs/snow-dicts/flypy_zzddb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zzddb -o ../xhloopzzd-chs/snow-dicts/flypy_zzddb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zzddb -o ../xhloopzzd-chs/snow-dicts/flypy_zzddb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zzddb -o ../xhloopzzd-chs/snow-dicts/flypy_zzddb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhloopzzd -x zzddb -s -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../xhloopzzd-chs/snow-dicts/xhloopzzd_zzddb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopzzd-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopzzd-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhloopzzd-cht
sed '/\.\.\./q' ./xhloopzzd-cht/radical_flypy.dict.yaml > ./xhloopzzd-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhloopzzd-cht/moran.chars.dict.yaml
echo "" >> ./xhloopzzd-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./xhloopzzd-cht/radical_flypy.dict.yaml.bak
mv ./xhloopzzd-cht/radical_flypy.dict.yaml{.bak,}
cp ./xhloopzzd-cht/radical_flypy.dict.yaml ./xhloopzzd-chs

rm -f temp.txt
rm -f ./xhloopzzd-cht/temp.txt
rm -f ./xhloopzzd-chs/temp.txt

echo xhloopzzd繁體設定檔...
cd xhloopzzd-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopzzd_zzddb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopzzd_zzddb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopzzd.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopzzd/g" ./xhloopzzd.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopzzd/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopzzd = moran + xhloop + zzd + snow/g" ./xhloopzzd.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopzzd_fixed/g" ./xhloopzzd.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopzzd_sentence/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopzzd.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopzzd.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopzzd.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./xhloopzzd.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./xhloopzzd.schema.yaml

cp moran_aux.schema.yaml xhloopzzd_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopzzd_aux/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopzzd輔篩/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopzzd」方案不同。/g" ./xhloopzzd_aux.schema.yaml

cp moran_bj.schema.yaml xhloopzzd_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopzzd_bj/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopzzd並擊/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopzzd = moran + xhloop + zzd + snow/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopzzd_fixed/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopzzd_sentence/g" ./xhloopzzd_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopzzd_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopzzd_fixed/g" ./xhloopzzd_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopzzd字詞/g" ./xhloopzzd_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopzzd_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopzzd_sentence/g" ./xhloopzzd_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopzzd整句/g" ./xhloopzzd_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_sentence.schema.yaml
cd ..

echo xhloopzzd简体設定檔...
cd xhloopzzd-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopzzd_zzddb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopzzd_zzddb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopzzd.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopzzd/g" ./xhloopzzd.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopzzd/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopzzd = moran + xhloop + zzd + snow/g" ./xhloopzzd.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopzzd_fixed/g" ./xhloopzzd.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopzzd_sentence/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopzzd.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopzzd.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopzzd.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopzzd.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./xhloopzzd.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./xhloopzzd.schema.yaml

cp moran_aux.schema.yaml xhloopzzd_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopzzd_aux/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopzzd輔篩/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopzzd」方案不同。/g" ./xhloopzzd_aux.schema.yaml

cp moran_bj.schema.yaml xhloopzzd_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopzzd_bj/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopzzd並擊/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopzzd = moran + xhloop + zzd + snow/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopzzd_fixed/g" ./xhloopzzd_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopzzd_sentence/g" ./xhloopzzd_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopzzd_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopzzd_fixed/g" ./xhloopzzd_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopzzd字詞/g" ./xhloopzzd_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopzzd_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopzzd_sentence/g" ./xhloopzzd_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopzzd整句/g" ./xhloopzzd_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopzzd_sentence.schema.yaml
cd ..
