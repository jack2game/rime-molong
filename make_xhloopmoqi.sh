#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhloopmoqi-chs
rm -rf xhloopmoqi-cht

# 生成繁體
cp -a ./rime-moran/. ./xhloopmoqi-cht

rm -rf ./xhloopmoqi-cht/.git
rm -rf ./xhloopmoqi-cht/.gitignore
rm -rf ./xhloopmoqi-cht/README.md
rm -rf ./xhloopmoqi-cht/README-en.md
rm -rf ./xhloopmoqi-cht/.github/
# mv ./xhloopmoqi-cht/default.yaml ./schema
# mv ./xhloopmoqi-cht/key_bindings.yaml ./schema
# mv ./xhloopmoqi-cht/punctuation.yaml ./schema

cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./xhloopmoqi-cht/opencc/moran_chaifen.txt
cp ./rime-shuangpin-fuzhuma/moqima8105.txt ./tools-additional/moqidb.txt
perl -CSAD -i -pe 's/(.\t[a-z]{2})\t.*/$1/' ./tools-additional/moqidb.txt

# 生成簡體
cd ./xhloopmoqi-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhloopmoqi-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../xhloopmoqi-cht/moran.chars.dict.yaml > ../xhloopmoqi-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../xhloopmoqi-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopmoqi-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopmoqi-cht/temp.txt
echo "" >> ../xhloopmoqi-cht/moran.chars.dict.yaml.bak
cat ../xhloopmoqi-cht/temp.txt >> ../xhloopmoqi-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopmoqi-cht/moran.base.dict.yaml > ../xhloopmoqi-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopmoqi-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopmoqi-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -t -i ../xhloopmoqi-cht/snow_pinyin.base.dict.yaml -o ../xhloopmoqi-cht/temp.txt
# echo "" >> ../xhloopmoqi-cht/moran.base.dict.yaml.bak
cat ../xhloopmoqi-cht/temp.txt >> ../xhloopmoqi-cht/moran.base.dict.yaml.bak
rm ../xhloopmoqi-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-cht/moran.tencent.dict.yaml > ../../xhloopmoqi-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-cht/moran.moe.dict.yaml > ../../xhloopmoqi-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-cht/moran.computer.dict.yaml > ../../xhloopmoqi-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-cht/moran.hanyu.dict.yaml > ../../xhloopmoqi-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-cht/moran.words.dict.yaml > ../../xhloopmoqi-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopmoqi-cht/zrlf.dict.yaml -o ../xhloopmoqi-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopmoqi-cht/moran_fixed.dict.yaml > ../xhloopmoqi-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt
opencc -i ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt -o ../xhloopmoqi-cht/temp.txt -c s2t
echo "" >> ../xhloopmoqi-cht/moran_fixed.dict.yaml.bak
cat ../xhloopmoqi-cht/temp.txt >> ../xhloopmoqi-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopmoqi-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopmoqi-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopmoqi-cht/moran_fixed.dict.yaml >> ../xhloopmoqi-cht/moran_fixed.dict.yaml.bak
rm ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt

sed '/#----------词库----------#/q' ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml > ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt
cp ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-cht/temp.txt
echo "" >> ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhloopmoqi-cht/temp.txt >> ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml >> ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhloopmoqi-cht/xhloopmoqi.simpchars.4123.txt

mv ../xhloopmoqi-cht/moran.chars.dict.yaml{.bak,}
mv ../xhloopmoqi-cht/moran.base.dict.yaml{.bak,}
# mv ../xhloopmoqi-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopmoqi-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhloopmoqi-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhloopmoqi-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopmoqi-cht/moran.words.dict.yaml{.bak,}
mv ../xhloopmoqi-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhloopmoqi-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopmoqi-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../xhloopmoqi-chs/moran.chars.dict.yaml > ../xhloopmoqi-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -i ../data/zdicdbtonesorted.yaml -o ../xhloopmoqi-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopmoqi-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopmoqi-chs/temp.txt
echo "" >> ../xhloopmoqi-chs/moran.chars.dict.yaml.bak
cat ../xhloopmoqi-chs/temp.txt >> ../xhloopmoqi-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopmoqi-chs/moran.base.dict.yaml > ../xhloopmoqi-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopmoqi-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopmoqi-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -s -i ../xhloopmoqi-chs/snow_pinyin.base.dict.yaml -o ../xhloopmoqi-chs/temp.txt
# echo "" >> ../xhloopmoqi-chs/moran.base.dict.yaml.bak
cat ../xhloopmoqi-chs/temp.txt >> ../xhloopmoqi-chs/moran.base.dict.yaml.bak
rm ../xhloopmoqi-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-chs/moran.tencent.dict.yaml > ../../xhloopmoqi-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-chs/moran.moe.dict.yaml > ../../xhloopmoqi-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-chs/moran.computer.dict.yaml > ../../xhloopmoqi-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-chs/moran.hanyu.dict.yaml > ../../xhloopmoqi-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopmoqi-chs/moran.words.dict.yaml > ../../xhloopmoqi-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopmoqi-chs/zrlf.dict.yaml -o ../xhloopmoqi-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopmoqi-chs/moran_fixed.dict.yaml > ../xhloopmoqi-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt
opencc -i ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt -o ../xhloopmoqi-chs/temp.txt -c s2t
echo "" >> ../xhloopmoqi-chs/moran_fixed.dict.yaml.bak
cat ../xhloopmoqi-chs/temp.txt >> ../xhloopmoqi-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopmoqi-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopmoqi-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopmoqi-chs/moran_fixed.dict.yaml >> ../xhloopmoqi-chs/moran_fixed.dict.yaml.bak
rm ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt

sed '/#----------词库----------#/q' ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml > ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt
cp ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt ../xhloopmoqi-chs/temp.txt
echo "" >> ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhloopmoqi-chs/temp.txt >> ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml >> ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhloopmoqi-chs/xhloopmoqi.simpchars.4123.txt

mv ../xhloopmoqi-chs/moran.chars.dict.yaml{.bak,}
mv ../xhloopmoqi-chs/moran.base.dict.yaml{.bak,}
# mv ../xhloopmoqi-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopmoqi-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhloopmoqi-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhloopmoqi-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopmoqi-chs/moran.words.dict.yaml{.bak,}
mv ../xhloopmoqi-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhloopmoqi-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopmoqi-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhloopmoqi-cht/tools
rm -rf ./xhloopmoqi-cht/make_simp_dist.sh
mkdir -p ./xhloopmoqi-cht/snow-dicts/
mkdir -p ./xhloopmoqi-chs/snow-dicts/
# cp -a ./xhloopmoqi-cht/moran_fixed.dict.yaml ./schema/xhloopmoqi_fixed.dict.yaml
# cp -a ./xhloopmoqi-cht/moran_fixed_simp.dict.yaml ./schema/xhloopmoqi_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhloopmoqi.yaml ./xhloopmoqi-cht/default.custom.yaml
cp -a ./schema/default.custom.xhloopmoqi.yaml ./xhloopmoqi-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopmoqi-cht/snow-dicts/xhloopmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x moqidb -t -o ../xhloopmoqi-cht/snow-dicts/flypy_moqidb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p xhloopmoqi -x moqidb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopmoqi-chs/snow-dicts/xhloopmoqi_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x moqidb -o ../xhloopmoqi-chs/snow-dicts/flypy_moqidb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopmoqi-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopmoqi-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhloopmoqi-cht
sed '/\.\.\./q' ./xhloopmoqi-cht/radical_flypy.dict.yaml > ./xhloopmoqi-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhloopmoqi-cht/moran.chars.dict.yaml
echo "" >> ./xhloopmoqi-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./xhloopmoqi-cht/radical_flypy.dict.yaml.bak
mv ./xhloopmoqi-cht/radical_flypy.dict.yaml{.bak,}
cp ./xhloopmoqi-cht/radical_flypy.dict.yaml ./xhloopmoqi-chs

rm -f temp.txt
rm -f ./xhloopmoqi-cht/temp.txt
rm -f ./xhloopmoqi-chs/temp.txt

echo xhloopmoqi繁體設定檔...
cd xhloopmoqi-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopmoqi/g" ./xhloopmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopmoqi/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopmoqi = moran + xhloop + moqi + snow/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopmoqi_fixed/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopmoqi_sentence/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopmoqi.schema.yaml

cp moran_aux.schema.yaml xhloopmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopmoqi_aux/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopmoqi輔篩/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopmoqi」方案不同。/g" ./xhloopmoqi_aux.schema.yaml

cp moran_bj.schema.yaml xhloopmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopmoqi_bj/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopmoqi並擊/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopmoqi = moran + xhloop + moqi + snow/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopmoqi_fixed/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopmoqi_sentence/g" ./xhloopmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopmoqi_fixed/g" ./xhloopmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopmoqi字詞/g" ./xhloopmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopmoqi_sentence/g" ./xhloopmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopmoqi整句/g" ./xhloopmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_sentence.schema.yaml
cd ..

echo xhloopmoqi简体設定檔...
cd xhloopmoqi-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopmoqi_moqidb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopmoqi.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopmoqi/g" ./xhloopmoqi.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopmoqi/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopmoqi = moran + xhloop + moqi + snow/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopmoqi_fixed/g" ./xhloopmoqi.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopmoqi_sentence/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopmoqi.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopmoqi.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopmoqi.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopmoqi.schema.yaml

cp moran_aux.schema.yaml xhloopmoqi_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopmoqi_aux/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopmoqi輔篩/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopmoqi」方案不同。/g" ./xhloopmoqi_aux.schema.yaml

cp moran_bj.schema.yaml xhloopmoqi_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopmoqi_bj/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopmoqi並擊/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopmoqi = moran + xhloop + moqi + snow/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopmoqi_fixed/g" ./xhloopmoqi_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopmoqi_sentence/g" ./xhloopmoqi_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopmoqi_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopmoqi_fixed/g" ./xhloopmoqi_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopmoqi字詞/g" ./xhloopmoqi_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopmoqi_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopmoqi_sentence/g" ./xhloopmoqi_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopmoqi整句/g" ./xhloopmoqi_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopmoqi_sentence.schema.yaml
cd ..
