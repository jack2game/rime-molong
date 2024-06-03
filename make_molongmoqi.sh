#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf molongmoqi-chs
rm -rf molongmoqi-cht

# 生成繁體
cp -a ./rime-moran/. ./molongmoqi-cht

rm -rf ./molongmoqi-cht/.git
rm -rf ./molongmoqi-cht/.gitignore
rm -rf ./molongmoqi-cht/README.md
rm -rf ./molongmoqi-cht/README-en.md
rm -rf ./molongmoqi-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./molongmoqi-cht/moran.yaml
# mv ./molongmoqi-cht/key_bindings.yaml ./schema
# mv ./molongmoqi-cht/punctuation.yaml ./schema
cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./molongmoqi-cht/opencc/moran_chaifen.txt
sed -i -E 's/^(\S+)\t(\S+)\t(.+)$/\1\t〔\3\2〕/' ./molongmoqi-cht/opencc/moran_chaifen.txt
cp ./rime-shuangpin-fuzhuma/reverse_moqima.dict.yaml ./tools-additional/moqidb.txt && sed -i '0,/\.\.\./d' ./tools-additional/moqidb.txt
perl -CSAD -i -pe 's/(.\t[a-z]{2})\t.*/$1/' ./tools-additional/moqidb.txt

# 生成簡體
cd ./molongmoqi-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/molongmoqi-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../molongmoqi-cht/moran.chars.dict.yaml > ../molongmoqi-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../molongmoqi-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../molongmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molongmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molongmoqi-cht/temp.txt
echo "" >> ../molongmoqi-cht/moran.chars.dict.yaml.bak
cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molongmoqi-cht/moran.base.dict.yaml > ../molongmoqi-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molongmoqi-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molongmoqi-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -t -i ../molongmoqi-cht/snow_pinyin.base.dict.yaml -o ../molongmoqi-cht/temp.txt
# echo "" >> ../molongmoqi-cht/moran.base.dict.yaml.bak
cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran.base.dict.yaml.bak
rm ../molongmoqi-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-cht/moran.tencent.dict.yaml > ../../molongmoqi-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-cht/moran.moe.dict.yaml > ../../molongmoqi-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-cht/moran.computer.dict.yaml > ../../molongmoqi-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-cht/moran.hanyu.dict.yaml > ../../molongmoqi-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-cht/moran.words.dict.yaml > ../../molongmoqi-cht/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../molongmoqi-cht/zrlf.dict.yaml -o ../molongmoqi-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../molongmoqi-cht/moran_fixed.dict.yaml > ../molongmoqi-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongmoqi.simpchars.txt ../molongmoqi-cht/molongmoqi.simpchars.txt && opencc -i ../molongmoqi-cht/molongmoqi.simpchars.txt -o ../molongmoqi-cht/temp.txt -c s2t
echo "" >> ../molongmoqi-cht/moran_fixed.dict.yaml.bak
cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/molong.simpwords.txt -o ../molongmoqi-cht/temp.txt -c s2t
echo "" >> ../molongmoqi-cht/moran_fixed.dict.yaml.bak && cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongmoqi-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../molongmoqi-cht/moran_fixed.dict.yaml >> ../molongmoqi-cht/moran_fixed.dict.yaml.bak
rm ../molongmoqi-cht/molongmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../molongmoqi-cht/moran_fixed_simp.dict.yaml > ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongmoqi.simpchars.txt ../molongmoqi-cht/molongmoqi.simpchars.txt && cp ../molongmoqi-cht/molongmoqi.simpchars.txt ../molongmoqi-cht/temp.txt
echo "" >> ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak
cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molong.simpwords.txt ../molongmoqi-cht/temp.txt
echo "" >> ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak && cat ../molongmoqi-cht/temp.txt >> ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongmoqi-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../molongmoqi-cht/moran_fixed_simp.dict.yaml >> ../molongmoqi-cht/moran_fixed_simp.dict.yaml.bak
rm ../molongmoqi-cht/molongmoqi.simpchars.txt

mv ../molongmoqi-cht/moran.chars.dict.yaml{.bak,}
mv ../molongmoqi-cht/moran.base.dict.yaml{.bak,}
# mv ../molongmoqi-cht/moran.tencent.dict.yaml{.bak,}
# mv ../molongmoqi-cht/moran.moe.dict.yaml{.bak,}
# mv ../molongmoqi-cht/moran.computer.dict.yaml{.bak,}
# mv ../molongmoqi-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../molongmoqi-cht/moran.words.dict.yaml{.bak,}
mv ../molongmoqi-cht/moran_fixed.dict.yaml{.bak,}
mv ../molongmoqi-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molongmoqi-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../molongmoqi-chs/moran.chars.dict.yaml > ../molongmoqi-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../molongmoqi-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../molongmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molongmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molongmoqi-chs/temp.txt
echo "" >> ../molongmoqi-chs/moran.chars.dict.yaml.bak
cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molongmoqi-chs/moran.base.dict.yaml > ../molongmoqi-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molongmoqi-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molongmoqi-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -s -i ../molongmoqi-chs/snow_pinyin.base.dict.yaml -o ../molongmoqi-chs/temp.txt
# echo "" >> ../molongmoqi-chs/moran.base.dict.yaml.bak
cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran.base.dict.yaml.bak
rm ../molongmoqi-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-chs/moran.tencent.dict.yaml > ../../molongmoqi-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-chs/moran.moe.dict.yaml > ../../molongmoqi-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-chs/moran.computer.dict.yaml > ../../molongmoqi-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-chs/moran.hanyu.dict.yaml > ../../molongmoqi-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongmoqi-chs/moran.words.dict.yaml > ../../molongmoqi-chs/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../molongmoqi-chs/zrlf.dict.yaml -o ../molongmoqi-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../molongmoqi-chs/moran_fixed.dict.yaml > ../molongmoqi-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongmoqi.simpchars.txt ../molongmoqi-chs/molongmoqi.simpchars.txt && opencc -i ../molongmoqi-chs/molongmoqi.simpchars.txt -o ../molongmoqi-chs/temp.txt -c s2t
echo "" >> ../molongmoqi-chs/moran_fixed.dict.yaml.bak
cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/molong.simpwords.txt -o ../molongmoqi-chs/temp.txt -c s2t
echo "" >> ../molongmoqi-chs/moran_fixed.dict.yaml.bak && cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongmoqi-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../molongmoqi-chs/moran_fixed.dict.yaml >> ../molongmoqi-chs/moran_fixed.dict.yaml.bak
rm ../molongmoqi-chs/molongmoqi.simpchars.txt

sed '/#----------词库----------#/q' ../molongmoqi-chs/moran_fixed_simp.dict.yaml > ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongmoqi.simpchars.txt ../molongmoqi-chs/molongmoqi.simpchars.txt && cp ../molongmoqi-chs/molongmoqi.simpchars.txt ../molongmoqi-chs/temp.txt
echo "" >> ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak
cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molong.simpwords.txt ../molongmoqi-chs/temp.txt
echo "" >> ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak && cat ../molongmoqi-chs/temp.txt >> ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongmoqi-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../molongmoqi-chs/moran_fixed_simp.dict.yaml >> ../molongmoqi-chs/moran_fixed_simp.dict.yaml.bak
rm ../molongmoqi-chs/molongmoqi.simpchars.txt

mv ../molongmoqi-chs/moran.chars.dict.yaml{.bak,}
mv ../molongmoqi-chs/moran.base.dict.yaml{.bak,}
# mv ../molongmoqi-chs/moran.tencent.dict.yaml{.bak,}
# mv ../molongmoqi-chs/moran.moe.dict.yaml{.bak,}
# mv ../molongmoqi-chs/moran.computer.dict.yaml{.bak,}
# mv ../molongmoqi-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../molongmoqi-chs/moran.words.dict.yaml{.bak,}
mv ../molongmoqi-chs/moran_fixed.dict.yaml{.bak,}
mv ../molongmoqi-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molongmoqi-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./molongmoqi-cht/tools
rm -rf ./molongmoqi-cht/make_simp_dist.sh
mkdir -p ./molongmoqi-cht/snow-dicts/
mkdir -p ./molongmoqi-chs/snow-dicts/
# cp -a ./molongmoqi-cht/moran_fixed.dict.yaml ./schema/molongmoqi_fixed.dict.yaml
# cp -a ./molongmoqi-cht/moran_fixed_simp.dict.yaml ./schema/molongmoqi_fixed_simp.dict.yaml
cp -a ./schema/default.custom.molongmoqi.yaml ./molongmoqi-cht/default.custom.yaml
cp -a ./schema/default.custom.molongmoqi.yaml ./molongmoqi-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molongmoqi-cht/snow-dicts/molongmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -t -o ../molongmoqi-cht/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -t -o ../molongmoqi-cht/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -t -o ../molongmoqi-cht/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -t -o ../molongmoqi-cht/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -t -o ../molongmoqi-cht/snow-dicts/flypy_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -t -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../molongmoqi-cht/snow-dicts/molongmoqi_moqidb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molongmoqi-chs/snow-dicts/molongmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -o ../molongmoqi-chs/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -o ../molongmoqi-chs/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -o ../molongmoqi-chs/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -o ../molongmoqi-chs/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -o ../molongmoqi-chs/snow-dicts/flypy_moqidb_others.dict.yaml
python3 gen_dict_with_shape.py -p molongmoqi -x moqidb -s -i ../rime-snow-pinyin/snow_pinyin.tencent.dict.yaml -o ../molongmoqi-chs/snow-dicts/molongmoqi_moqidb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./molongmoqi-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./molongmoqi-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./molongmoqi-cht
sed '/\.\.\./q' ./molongmoqi-cht/radical_flypy.dict.yaml > ./molongmoqi-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./molongmoqi-cht/moran.chars.dict.yaml
echo "" >> ./molongmoqi-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./molongmoqi-cht/radical_flypy.dict.yaml.bak
mv ./molongmoqi-cht/radical_flypy.dict.yaml{.bak,}
cp ./molongmoqi-cht/radical_flypy.dict.yaml ./molongmoqi-chs

rm -f temp.txt
rm -f ./molongmoqi-cht/temp.txt
rm -f ./molongmoqi-chs/temp.txt

echo molongmoqi繁體設定檔...
cd molongmoqi-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongmoqi_moqidb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molongmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molongmoqi/g" ./molongmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: molongmoqi/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongmoqi = moran + zrlong + moqi + snow/g" ./molongmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongmoqi_fixed/g" ./molongmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongmoqi_sentence/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molongmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molongmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molongmoqi.schema.yaml

cp moran_aux.schema.yaml molongmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molongmoqi_aux/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molongmoqi輔篩/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molongmoqi」方案不同。/g" ./molongmoqi_aux.schema.yaml

cp moran_bj.schema.yaml molongmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molongmoqi_bj/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molongmoqi並擊/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongmoqi = moran + zrlong + moqi + snow/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongmoqi_fixed/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongmoqi_sentence/g" ./molongmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml molongmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molongmoqi_fixed/g" ./molongmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molongmoqi字詞/g" ./molongmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml molongmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molongmoqi_sentence/g" ./molongmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molongmoqi整句/g" ./molongmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_sentence.schema.yaml
cd ..

echo molongmoqi简体設定檔...
cd molongmoqi-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongmoqi_moqidb_tencent      # 腾讯词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml


rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molongmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molongmoqi/g" ./molongmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: molongmoqi/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongmoqi = moran + zrlong + moqi + snow/g" ./molongmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongmoqi_fixed/g" ./molongmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongmoqi_sentence/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molongmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molongmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molongmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molongmoqi.schema.yaml

cp moran_aux.schema.yaml molongmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molongmoqi_aux/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molongmoqi輔篩/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molongmoqi」方案不同。/g" ./molongmoqi_aux.schema.yaml

cp moran_bj.schema.yaml molongmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molongmoqi_bj/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molongmoqi並擊/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongmoqi = moran + zrlong + moqi + snow/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongmoqi_fixed/g" ./molongmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongmoqi_sentence/g" ./molongmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml molongmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molongmoqi_fixed/g" ./molongmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molongmoqi字詞/g" ./molongmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml molongmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molongmoqi_sentence/g" ./molongmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molongmoqi整句/g" ./molongmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongmoqi_sentence.schema.yaml
cd ..
