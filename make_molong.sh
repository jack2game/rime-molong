#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf molong-chs
rm -rf molong-cht

# 生成繁體
cp -a ./rime-moran/. ./molong-cht

rm -rf ./molong-cht/.git
rm -rf ./molong-cht/.gitignore
rm -rf ./molong-cht/README.md
rm -rf ./molong-cht/README-en.md
rm -rf ./molong-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./molong-cht/moran.yaml
# mv ./molong-cht/key_bindings.yaml ./schema
# mv ./molong-cht/punctuation.yaml ./schema


# cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb_zrlong.txt

# 生成簡體
cd ./molong-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/molong-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../molong-cht/moran.chars.dict.yaml > ../molong-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -i ../data/zdicdbtonesorted.yaml -o ../molong-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../molong-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molong-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molong-cht/temp.txt
echo "" >> ../molong-cht/moran.chars.dict.yaml.bak
cat ../molong-cht/temp.txt >> ../molong-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molong-cht/moran.base.dict.yaml > ../molong-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molong-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molong-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -t -i ../molong-cht/snow_pinyin.base.dict.yaml -o ../molong-cht/temp.txt
# echo "" >> ../molong-cht/moran.base.dict.yaml.bak
cat ../molong-cht/temp.txt >> ../molong-cht/moran.base.dict.yaml.bak
rm ../molong-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.tencent.dict.yaml > ../../molong-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.moe.dict.yaml > ../../molong-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.computer.dict.yaml > ../../molong-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.hanyu.dict.yaml > ../../molong-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.words.dict.yaml > ../../molong-cht/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../molong-cht/zrlf.dict.yaml -o ../../molong-cht/zrlf.dict.yaml.bak

# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+\n//g" ../molong-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molong-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molong-cht/moran_fixed.dict.yaml
sed '/\.\.\./q' ../molong-cht/moran_fixed.dict.yaml > ../molong-cht/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../molong-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../molong-cht/zrlong.dict.yaml
opencc -i ../molong-cht/zrlong.dict.yaml -o ../molong-cht/temp.txt -c s2t
echo "" >> ../molong-cht/moran_fixed.dict.yaml.bak
cat ../molong-cht/temp.txt >> ../molong-cht/moran_fixed.dict.yaml.bak
# sed '0,/#----------词库----------#/d' ../molong-cht/moran_fixed.dict.yaml >> ../molong-cht/moran_fixed.dict.yaml.bak
rm ../molong-cht/zrlong.dict.yaml

# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+\n//g" ../molong-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molong-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molong-cht/moran_fixed_simp.dict.yaml
sed '/\.\.\./q' ../molong-cht/moran_fixed_simp.dict.yaml > ../molong-cht/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../molong-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../molong-cht/zrlong.dict.yaml
cp ../molong-cht/zrlong.dict.yaml ../molong-cht/temp.txt
echo "" >> ../molong-cht/moran_fixed_simp.dict.yaml.bak
cat ../molong-cht/temp.txt >> ../molong-cht/moran_fixed_simp.dict.yaml.bak
# sed '0,/#----------词库----------#/d' ../molong-cht/moran_fixed_simp.dict.yaml >> ../molong-cht/moran_fixed_simp.dict.yaml.bak
rm ../molong-cht/zrlong.dict.yaml

mv ../molong-cht/moran.chars.dict.yaml{.bak,}
mv ../molong-cht/moran.base.dict.yaml{.bak,}
# mv ../molong-cht/moran.tencent.dict.yaml{.bak,}
# mv ../molong-cht/moran.moe.dict.yaml{.bak,}
# mv ../molong-cht/moran.computer.dict.yaml{.bak,}
# mv ../molong-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../molong-cht/moran.words.dict.yaml{.bak,}
mv ../molong-cht/moran_fixed.dict.yaml{.bak,}
mv ../molong-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molong-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../molong-chs/moran.chars.dict.yaml > ../molong-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -i ../data/zdicdbtonesorted.yaml -o ../molong-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../molong-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molong-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molong-chs/temp.txt
echo "" >> ../molong-chs/moran.chars.dict.yaml.bak
cat ../molong-chs/temp.txt >> ../molong-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molong-chs/moran.base.dict.yaml > ../molong-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molong-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molong-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -s -i ../molong-chs/snow_pinyin.base.dict.yaml -o ../molong-chs/temp.txt
# echo "" >> ../molong-chs/moran.base.dict.yaml.bak
cat ../molong-chs/temp.txt >> ../molong-chs/moran.base.dict.yaml.bak
rm ../molong-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.tencent.dict.yaml > ../../molong-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.moe.dict.yaml > ../../molong-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.computer.dict.yaml > ../../molong-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.hanyu.dict.yaml > ../../molong-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.words.dict.yaml > ../../molong-chs/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../molong-chs/zrlf.dict.yaml -o ../../molong-chs/zrlf.dict.yaml.bak

# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+\n//g" ../molong-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molong-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molong-chs/moran_fixed.dict.yaml
sed '/\.\.\./q' ../molong-chs/moran_fixed.dict.yaml > ../molong-chs/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../molong-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../molong-chs/zrlong.dict.yaml
opencc -i ../molong-chs/zrlong.dict.yaml -o ../molong-chs/temp.txt -c s2t
echo "" >> ../molong-chs/moran_fixed.dict.yaml.bak
cat ../molong-chs/temp.txt >> ../molong-chs/moran_fixed.dict.yaml.bak
# sed '0,/#----------词库----------#/d' ../molong-chs/moran_fixed.dict.yaml >> ../molong-chs/moran_fixed.dict.yaml.bak
rm ../molong-chs/zrlong.dict.yaml

# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+\n//g" ../molong-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molong-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molong-chs/moran_fixed_simp.dict.yaml
sed '/\.\.\./q' ../molong-chs/moran_fixed_simp.dict.yaml > ../molong-chs/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../molong-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../molong-chs/zrlong.dict.yaml
cp ../molong-chs/zrlong.dict.yaml ../molong-chs/temp.txt
echo "" >> ../molong-chs/moran_fixed_simp.dict.yaml.bak
cat ../molong-chs/temp.txt >> ../molong-chs/moran_fixed_simp.dict.yaml.bak
# sed '0,/#----------词库----------#/d' ../molong-chs/moran_fixed_simp.dict.yaml >> ../molong-chs/moran_fixed_simp.dict.yaml.bak
rm ../molong-chs/zrlong.dict.yaml

mv ../molong-chs/moran.chars.dict.yaml{.bak,}
mv ../molong-chs/moran.base.dict.yaml{.bak,}
# mv ../molong-chs/moran.tencent.dict.yaml{.bak,}
# mv ../molong-chs/moran.moe.dict.yaml{.bak,}
# mv ../molong-chs/moran.computer.dict.yaml{.bak,}
# mv ../molong-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../molong-chs/moran.words.dict.yaml{.bak,}
mv ../molong-chs/moran_fixed.dict.yaml{.bak,}
mv ../molong-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molong-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./molong-cht/tools
rm -rf ./molong-cht/make_simp_dist.sh
mkdir -p ./molong-cht/snow-dicts/
mkdir -p ./molong-chs/snow-dicts/
# cp -a ./molong-cht/moran_fixed.dict.yaml ./schema/molong_fixed.dict.yaml
# cp -a ./molong-cht/moran_fixed_simp.dict.yaml ./schema/molong_fixed_simp.dict.yaml
cp -a ./schema/default.custom.molong.yaml ./molong-cht/default.custom.yaml
cp -a ./schema/default.custom.molong.yaml ./molong-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molong-cht/snow-dicts/zrlong_zrmdb_zrlong_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb_zrlong -t -o ../molong-cht/snow-dicts/flypy_zrmdb_zrlong_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p zrlong -x zrmdb_zrlong -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molong-chs/snow-dicts/zrlong_zrmdb_zrlong_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb_zrlong -o ../molong-chs/snow-dicts/flypy_zrmdb_zrlong_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./molong-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./molong-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./molong-cht
sed '/\.\.\./q' ./molong-cht/radical_flypy.dict.yaml > ./molong-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./molong-cht/moran.chars.dict.yaml
echo "" >> ./molong-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./molong-cht/radical_flypy.dict.yaml.bak
mv ./molong-cht/radical_flypy.dict.yaml{.bak,}
cp ./molong-cht/radical_flypy.dict.yaml ./molong-chs

rm -f temp.txt
rm -f ./molong-cht/temp.txt
rm -f ./molong-chs/temp.txt

echo molong繁體設定檔...
cd molong-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrlong_zrmdb_zrlong_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml



rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molong.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molong/g" ./molong.schema.yaml
sed -i "s/^  name: 魔然$/  name: molong/g" ./molong.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = moran + zrlong + snow/g" ./molong.schema.yaml
sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong.schema.yaml
sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molong.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molong.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molong.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molong.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molong.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molong.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molong.schema.yaml

cp moran_aux.schema.yaml molong_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molong_aux/g" ./molong_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molong輔篩/g" ./molong_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molong」方案不同。/g" ./molong_aux.schema.yaml

cp moran_bj.schema.yaml molong_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molong_bj/g" ./molong_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molong並擊/g" ./molong_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = moran + zrlong + snow/g" ./molong_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong_bj.schema.yaml

cp moran_fixed.schema.yaml molong_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molong_fixed/g" ./molong_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molong字詞/g" ./molong_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_fixed.schema.yaml

cp moran_sentence.schema.yaml molong_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molong_sentence/g" ./molong_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molong整句/g" ./molong_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_sentence.schema.yaml
cd ..

echo molong简体設定檔...
cd molong-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrlong_zrmdb_zrlong_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml



rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molong.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molong/g" ./molong.schema.yaml
sed -i "s/^  name: 魔然$/  name: molong/g" ./molong.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = moran + zrlong + snow/g" ./molong.schema.yaml
sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong.schema.yaml
sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molong.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molong.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molong.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molong.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molong.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molong.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molong.schema.yaml

cp moran_aux.schema.yaml molong_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molong_aux/g" ./molong_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molong輔篩/g" ./molong_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molong」方案不同。/g" ./molong_aux.schema.yaml

cp moran_bj.schema.yaml molong_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molong_bj/g" ./molong_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molong並擊/g" ./molong_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = moran + zrlong + snow/g" ./molong_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong_bj.schema.yaml

cp moran_fixed.schema.yaml molong_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molong_fixed/g" ./molong_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molong字詞/g" ./molong_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_fixed.schema.yaml

cp moran_sentence.schema.yaml molong_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molong_sentence/g" ./molong_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molong整句/g" ./molong_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - 自然龍作者：Elflare\n    - Integrator：jack2game/g" ./molong_sentence.schema.yaml
cd ..
