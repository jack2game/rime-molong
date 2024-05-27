#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhloopkai-chs
rm -rf xhloopkai-cht

# 生成繁體
cp -a ./rime-moran/. ./xhloopkai-cht

rm -rf ./xhloopkai-cht/.git
rm -rf ./xhloopkai-cht/.gitignore
rm -rf ./xhloopkai-cht/README.md
rm -rf ./xhloopkai-cht/README-en.md
rm -rf ./xhloopkai-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./xhloopkai-cht/moran.yaml
# mv ./xhloopkai-cht/key_bindings.yaml ./schema
# mv ./xhloopkai-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./xhloopkai-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhloopkai-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../xhloopkai-cht/moran.chars.dict.yaml > ../xhloopkai-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -m -i ../data/zdicdbtonesorted.yaml -o ../xhloopkai-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhloopkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopkai-cht/temp.txt
echo "" >> ../xhloopkai-cht/moran.chars.dict.yaml.bak
cat ../xhloopkai-cht/temp.txt >> ../xhloopkai-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopkai-cht/moran.base.dict.yaml > ../xhloopkai-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopkai-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopkai-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -t -i ../xhloopkai-cht/snow_pinyin.base.dict.yaml -o ../xhloopkai-cht/temp.txt
# echo "" >> ../xhloopkai-cht/moran.base.dict.yaml.bak
cat ../xhloopkai-cht/temp.txt >> ../xhloopkai-cht/moran.base.dict.yaml.bak
rm ../xhloopkai-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-cht/moran.tencent.dict.yaml > ../../xhloopkai-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-cht/moran.moe.dict.yaml > ../../xhloopkai-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-cht/moran.computer.dict.yaml > ../../xhloopkai-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-cht/moran.hanyu.dict.yaml > ../../xhloopkai-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-cht/moran.words.dict.yaml > ../../xhloopkai-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopkai-cht/zrlf.dict.yaml -o ../xhloopkai-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopkai-cht/moran_fixed.dict.yaml > ../xhloopkai-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopkai.simpchars.4123.txt ../xhloopkai-cht/xhloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopkai-cht/xhloopkai.simpchars.4123.txt
opencc -i ../xhloopkai-cht/xhloopkai.simpchars.4123.txt -o ../xhloopkai-cht/temp.txt -c s2t
echo "" >> ../xhloopkai-cht/moran_fixed.dict.yaml.bak
cat ../xhloopkai-cht/temp.txt >> ../xhloopkai-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopkai-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopkai-cht/moran_fixed.dict.yaml >> ../xhloopkai-cht/moran_fixed.dict.yaml.bak
rm ../xhloopkai-cht/xhloopkai.simpchars.4123.txt

sed '/#----------词库----------#/q' ../xhloopkai-cht/moran_fixed_simp.dict.yaml > ../xhloopkai-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopkai.simpchars.4123.txt ../xhloopkai-cht/xhloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopkai-cht/xhloopkai.simpchars.4123.txt
cp ../xhloopkai-cht/xhloopkai.simpchars.4123.txt ../xhloopkai-cht/temp.txt
echo "" >> ../xhloopkai-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhloopkai-cht/temp.txt >> ../xhloopkai-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopkai-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopkai-cht/moran_fixed_simp.dict.yaml >> ../xhloopkai-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhloopkai-cht/xhloopkai.simpchars.4123.txt

mv ../xhloopkai-cht/moran.chars.dict.yaml{.bak,}
mv ../xhloopkai-cht/moran.base.dict.yaml{.bak,}
# mv ../xhloopkai-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopkai-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhloopkai-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhloopkai-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopkai-cht/moran.words.dict.yaml{.bak,}
mv ../xhloopkai-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhloopkai-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopkai-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../xhloopkai-chs/moran.chars.dict.yaml > ../xhloopkai-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -m -i ../data/zdicdbtonesorted.yaml -o ../xhloopkai-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhloopkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopkai-chs/temp.txt
echo "" >> ../xhloopkai-chs/moran.chars.dict.yaml.bak
cat ../xhloopkai-chs/temp.txt >> ../xhloopkai-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopkai-chs/moran.base.dict.yaml > ../xhloopkai-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopkai-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloopkai-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -s -i ../xhloopkai-chs/snow_pinyin.base.dict.yaml -o ../xhloopkai-chs/temp.txt
# echo "" >> ../xhloopkai-chs/moran.base.dict.yaml.bak
cat ../xhloopkai-chs/temp.txt >> ../xhloopkai-chs/moran.base.dict.yaml.bak
rm ../xhloopkai-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-chs/moran.tencent.dict.yaml > ../../xhloopkai-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-chs/moran.moe.dict.yaml > ../../xhloopkai-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-chs/moran.computer.dict.yaml > ../../xhloopkai-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-chs/moran.hanyu.dict.yaml > ../../xhloopkai-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopkai-chs/moran.words.dict.yaml > ../../xhloopkai-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopkai-chs/zrlf.dict.yaml -o ../xhloopkai-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhloopkai-chs/moran_fixed.dict.yaml > ../xhloopkai-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopkai.simpchars.4123.txt ../xhloopkai-chs/xhloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopkai-chs/xhloopkai.simpchars.4123.txt
opencc -i ../xhloopkai-chs/xhloopkai.simpchars.4123.txt -o ../xhloopkai-chs/temp.txt -c s2t
echo "" >> ../xhloopkai-chs/moran_fixed.dict.yaml.bak
cat ../xhloopkai-chs/temp.txt >> ../xhloopkai-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopkai-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhloopkai-chs/moran_fixed.dict.yaml >> ../xhloopkai-chs/moran_fixed.dict.yaml.bak
rm ../xhloopkai-chs/xhloopkai.simpchars.4123.txt

sed '/#----------词库----------#/q' ../xhloopkai-chs/moran_fixed_simp.dict.yaml > ../xhloopkai-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopkai.simpchars.4123.txt ../xhloopkai-chs/xhloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopkai-chs/xhloopkai.simpchars.4123.txt
cp ../xhloopkai-chs/xhloopkai.simpchars.4123.txt ../xhloopkai-chs/temp.txt
echo "" >> ../xhloopkai-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhloopkai-chs/temp.txt >> ../xhloopkai-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopkai-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhloopkai-chs/moran_fixed_simp.dict.yaml >> ../xhloopkai-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhloopkai-chs/xhloopkai.simpchars.4123.txt

mv ../xhloopkai-chs/moran.chars.dict.yaml{.bak,}
mv ../xhloopkai-chs/moran.base.dict.yaml{.bak,}
# mv ../xhloopkai-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopkai-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhloopkai-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhloopkai-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopkai-chs/moran.words.dict.yaml{.bak,}
mv ../xhloopkai-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhloopkai-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopkai-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhloopkai-cht/tools
rm -rf ./xhloopkai-cht/make_simp_dist.sh
mkdir -p ./xhloopkai-cht/snow-dicts/
mkdir -p ./xhloopkai-chs/snow-dicts/
# cp -a ./xhloopkai-cht/moran_fixed.dict.yaml ./schema/xhloopkai_fixed.dict.yaml
# cp -a ./xhloopkai-cht/moran_fixed_simp.dict.yaml ./schema/xhloopkai_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhloopkai.yaml ./xhloopkai-cht/default.custom.yaml
cp -a ./schema/default.custom.xhloopkai.yaml ./xhloopkai-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopkai-cht/snow-dicts/xhloopkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../xhloopkai-cht/snow-dicts/flypy_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p xhloopkai -x zrmdb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopkai-chs/snow-dicts/xhloopkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -o ../xhloopkai-chs/snow-dicts/flypy_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopkai-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./xhloopkai-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhloopkai-cht
sed '/\.\.\./q' ./xhloopkai-cht/radical_flypy.dict.yaml > ./xhloopkai-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhloopkai-cht/moran.chars.dict.yaml
echo "" >> ./xhloopkai-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./xhloopkai-cht/radical_flypy.dict.yaml.bak
mv ./xhloopkai-cht/radical_flypy.dict.yaml{.bak,}
cp ./xhloopkai-cht/radical_flypy.dict.yaml ./xhloopkai-chs

rm -f temp.txt
rm -f ./xhloopkai-cht/temp.txt
rm -f ./xhloopkai-chs/temp.txt

echo xhloopkai繁體設定檔...
cd xhloopkai-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml



rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopkai/g" ./xhloopkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopkai/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopkai = moran + xhloop + moranshape + snow/g" ./xhloopkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopkai_fixed/g" ./xhloopkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopkai_sentence/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopkai.schema.yaml

cp moran_aux.schema.yaml xhloopkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopkai_aux/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopkai輔篩/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopkai」方案不同。/g" ./xhloopkai_aux.schema.yaml

cp moran_bj.schema.yaml xhloopkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopkai_bj/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopkai並擊/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopkai = moran + xhloop + moranshape + snow/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopkai_fixed/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopkai_sentence/g" ./xhloopkai_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopkai_fixed/g" ./xhloopkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopkai字詞/g" ./xhloopkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopkai_sentence/g" ./xhloopkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopkai整句/g" ./xhloopkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_sentence.schema.yaml
cd ..

echo xhloopkai简体設定檔...
cd xhloopkai-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml



rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopkai/g" ./xhloopkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopkai/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopkai = moran + xhloop + moranshape + snow/g" ./xhloopkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopkai_fixed/g" ./xhloopkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopkai_sentence/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopkai.schema.yaml

cp moran_aux.schema.yaml xhloopkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopkai_aux/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopkai輔篩/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopkai」方案不同。/g" ./xhloopkai_aux.schema.yaml

cp moran_bj.schema.yaml xhloopkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopkai_bj/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopkai並擊/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopkai = moran + xhloop + moranshape + snow/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopkai_fixed/g" ./xhloopkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopkai_sentence/g" ./xhloopkai_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopkai_fixed/g" ./xhloopkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopkai字詞/g" ./xhloopkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopkai_sentence/g" ./xhloopkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopkai整句/g" ./xhloopkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopkai_sentence.schema.yaml
cd ..
