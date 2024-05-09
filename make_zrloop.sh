#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf zrloop-chs
rm -rf zrloop-cht

# 生成繁體
cp -a ./rime-moran/. ./zrloop-cht

rm -rf ./zrloop-cht/.git
rm -rf ./zrloop-cht/.gitignore
rm -rf ./zrloop-cht/README.md
rm -rf ./zrloop-cht/README-en.md
rm -rf ./zrloop-cht/.github/
mv ./zrloop-cht/default.yaml ./schema
mv ./zrloop-cht/key_bindings.yaml ./schema
mv ./zrloop-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./zrloop-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/zrloop-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../zrloop-cht/moran.chars.dict.yaml > ../zrloop-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../zrloop-cht/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{0,1};.*\n//g" ../zrloop-cht/temp.txt
perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloop-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloop-cht/temp.txt
echo "" >> ../zrloop-cht/moran.chars.dict.yaml.bak
cat ../zrloop-cht/temp.txt >> ../zrloop-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloop-cht/moran.base.dict.yaml > ../zrloop-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloop-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -t -i ../zrloop-cht/snow_pinyin.base.dict.yaml -o ../zrloop-cht/temp.txt
# echo "" >> ../zrloop-cht/moran.base.dict.yaml.bak
cat ../zrloop-cht/temp.txt >> ../zrloop-cht/moran.base.dict.yaml.bak
rm ../zrloop-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-cht/moran.tencent.dict.yaml > ../../zrloop-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-cht/moran.moe.dict.yaml > ../../zrloop-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-cht/moran.computer.dict.yaml > ../../zrloop-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-cht/moran.hanyu.dict.yaml > ../../zrloop-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-cht/moran.words.dict.yaml > ../../zrloop-cht/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../zrloop-cht/zrlf.dict.yaml -o ../../zrloop-cht/zrlf.dict.yaml.bak

sed '/\.\.\./q' ../zrloop-cht/moran_fixed.dict.yaml > ../zrloop-cht/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../zrloop-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-cht/zrlong.dict.yaml
opencc -i ../zrloop-cht/zrlong.dict.yaml -o ../zrloop-cht/temp.txt -c s2t
echo "" >> ../zrloop-cht/moran_fixed.dict.yaml.bak
cat ../zrloop-cht/temp.txt >> ../zrloop-cht/moran_fixed.dict.yaml.bak
rm ../zrloop-cht/zrlong.dict.yaml

sed '/\.\.\./q' ../zrloop-cht/moran_fixed_simp.dict.yaml > ../zrloop-cht/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../zrloop-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-cht/zrlong.dict.yaml
cp ../zrloop-cht/zrlong.dict.yaml ../zrloop-cht/temp.txt
echo "" >> ../zrloop-cht/moran_fixed_simp.dict.yaml.bak
cat ../zrloop-cht/temp.txt >> ../zrloop-cht/moran_fixed_simp.dict.yaml.bak
rm ../zrloop-cht/zrlong.dict.yaml

mv ../zrloop-cht/moran.chars.dict.yaml{.bak,}
mv ../zrloop-cht/moran.base.dict.yaml{.bak,}
# mv ../zrloop-cht/moran.tencent.dict.yaml{.bak,}
# mv ../zrloop-cht/moran.moe.dict.yaml{.bak,}
# mv ../zrloop-cht/moran.computer.dict.yaml{.bak,}
# mv ../zrloop-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloop-cht/moran.words.dict.yaml{.bak,}
mv ../zrloop-cht/moran_fixed.dict.yaml{.bak,}
mv ../zrloop-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloop-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../zrloop-chs/moran.chars.dict.yaml > ../zrloop-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../zrloop-chs/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{0,1};.*\n//g" ../zrloop-chs/temp.txt
perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloop-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloop-chs/temp.txt
echo "" >> ../zrloop-chs/moran.chars.dict.yaml.bak
cat ../zrloop-chs/temp.txt >> ../zrloop-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloop-chs/moran.base.dict.yaml > ../zrloop-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloop-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -s -i ../zrloop-chs/snow_pinyin.base.dict.yaml -o ../zrloop-chs/temp.txt
# echo "" >> ../zrloop-chs/moran.base.dict.yaml.bak
cat ../zrloop-chs/temp.txt >> ../zrloop-chs/moran.base.dict.yaml.bak
rm ../zrloop-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-chs/moran.tencent.dict.yaml > ../../zrloop-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-chs/moran.moe.dict.yaml > ../../zrloop-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-chs/moran.computer.dict.yaml > ../../zrloop-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-chs/moran.hanyu.dict.yaml > ../../zrloop-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloop-chs/moran.words.dict.yaml > ../../zrloop-chs/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../zrloop-chs/zrlf.dict.yaml -o ../../zrloop-chs/zrlf.dict.yaml.bak

sed '/\.\.\./q' ../zrloop-chs/moran_fixed.dict.yaml > ../zrloop-chs/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../zrloop-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-chs/zrlong.dict.yaml
opencc -i ../zrloop-chs/zrlong.dict.yaml -o ../zrloop-chs/temp.txt -c s2t
echo "" >> ../zrloop-chs/moran_fixed.dict.yaml.bak
cat ../zrloop-chs/temp.txt >> ../zrloop-chs/moran_fixed.dict.yaml.bak
rm ../zrloop-chs/zrlong.dict.yaml

sed '/\.\.\./q' ../zrloop-chs/moran_fixed_simp.dict.yaml > ../zrloop-chs/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../zrloop-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../zrloop-chs/zrlong.dict.yaml
cp ../zrloop-chs/zrlong.dict.yaml ../zrloop-chs/temp.txt
echo "" >> ../zrloop-chs/moran_fixed_simp.dict.yaml.bak
cat ../zrloop-chs/temp.txt >> ../zrloop-chs/moran_fixed_simp.dict.yaml.bak
rm ../zrloop-chs/zrlong.dict.yaml

mv ../zrloop-chs/moran.chars.dict.yaml{.bak,}
mv ../zrloop-chs/moran.base.dict.yaml{.bak,}
# mv ../zrloop-chs/moran.tencent.dict.yaml{.bak,}
# mv ../zrloop-chs/moran.moe.dict.yaml{.bak,}
# mv ../zrloop-chs/moran.computer.dict.yaml{.bak,}
# mv ../zrloop-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloop-chs/moran.words.dict.yaml{.bak,}
mv ../zrloop-chs/moran_fixed.dict.yaml{.bak,}
mv ../zrloop-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloop-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./zrloop-cht/tools
rm -rf ./zrloop-cht/make_simp_dist.sh
mkdir -p ./zrloop-cht/snow-dicts/
mkdir -p ./zrloop-chs/snow-dicts/
cp -a ./zrloop-cht/moran_fixed.dict.yaml ./schema/
cp -a ./zrloop-cht/moran_fixed_simp.dict.yaml ./schema/
cp -a ./schema/default.custom.yaml ./zrloop-cht
cp -a ./schema/default.custom.yaml ./zrloop-chs

# 刪去詞語簡碼
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\n//g" ./schema/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\t.*\n//g" ./schema/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\n//g" ./schema/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff01}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\t.*\n//g" ./schema/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\n//g" ./schema/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\t.*\n//g" ./schema/moran_fixed.dict.yaml

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\n//g" ./schema/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{2,100}\t[A-Za-z0-9]{1,3}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\n//g" ./schema/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{3,100}\t[A-Za-z0-9]{4}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\n//g" ./schema/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}A-Za-z0-9\x{3007}\x{ff0c}-\x{ffee}]{1,100}\t[A-Za-z0-9]{5,100}\t.*\n//g" ./schema/moran_fixed_simp.dict.yaml

cd ./tools-additional
# 生成繁體霧凇
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloop-cht/snow-dicts/zrloop_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../zrloop-cht/snow-dicts/flypy_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p zrloop -x zrmdb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloop-chs/snow-dicts/zrloop_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -o ../zrloop-chs/snow-dicts/flypy_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./schema/radical.schema.yaml ./zrloop-chs
cp ./schema/radical.schema.yaml ./zrloop-cht
cp ./schema/radical_flypy.dict.yaml ./zrloop-cht
sed '/\.\.\./q' ./zrloop-cht/radical_flypy.dict.yaml > ./zrloop-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./zrloop-cht/moran.chars.dict.yaml
echo "" >> ./zrloop-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./zrloop-cht/radical_flypy.dict.yaml.bak
mv ./zrloop-cht/radical_flypy.dict.yaml{.bak,}
cp ./zrloop-cht/radical_flypy.dict.yaml ./zrloop-chs

rm temp.txt
rm ./zrloop-cht/temp.txt
rm ./zrloop-chs/temp.txt

echo zrloop繁體設定檔...
cd zrloop-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloop_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloop.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloop/g" ./zrloop.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloop/g" ./zrloop.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloop = moran + zrloop + snow/g" ./zrloop.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloop_fixed/g" ./zrloop.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloop_sentence/g" ./zrloop.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloop.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloop.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloop.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloop.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloop.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloop.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloop.schema.yaml

cp moran_aux.schema.yaml zrloop_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloop_aux/g" ./zrloop_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloop輔篩/g" ./zrloop_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloop」方案不同。/g" ./zrloop_aux.schema.yaml

cp moran_bj.schema.yaml zrloop_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloop_bj/g" ./zrloop_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: zrloop並擊/g" ./zrloop_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloop = moran + zrloop + snow/g" ./zrloop_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloop_fixed/g" ./zrloop_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloop_sentence/g" ./zrloop_bj.schema.yaml

cp moran_fixed.schema.yaml zrloop_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloop_fixed/g" ./zrloop_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloop字詞/g" ./zrloop_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloop_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloop_sentence/g" ./zrloop_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloop整句/g" ./zrloop_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_sentence.schema.yaml
cd ..

echo zrloop简体設定檔...
cd zrloop-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloop_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloop.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloop/g" ./zrloop.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloop/g" ./zrloop.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloop = moran + zrloop + snow/g" ./zrloop.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloop_fixed/g" ./zrloop.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloop_sentence/g" ./zrloop.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloop.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloop.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloop.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloop.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloop.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloop.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloop.schema.yaml

cp moran_aux.schema.yaml zrloop_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloop_aux/g" ./zrloop_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloop輔篩/g" ./zrloop_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloop」方案不同。/g" ./zrloop_aux.schema.yaml

cp moran_bj.schema.yaml zrloop_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloop_bj/g" ./zrloop_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: zrloop並擊/g" ./zrloop_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloop = moran + zrloop + snow/g" ./zrloop_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloop_fixed/g" ./zrloop_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloop_sentence/g" ./zrloop_bj.schema.yaml

cp moran_fixed.schema.yaml zrloop_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloop_fixed/g" ./zrloop_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloop字詞/g" ./zrloop_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloop_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloop_sentence/g" ./zrloop_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloop整句/g" ./zrloop_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloop_sentence.schema.yaml
cd ..
