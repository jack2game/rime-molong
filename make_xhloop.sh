#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhloop-chs
rm -rf xhloop-cht

# 生成繁體
cp -a ./rime-moran/. ./xhloop-cht

rm -rf ./xhloop-cht/.git
rm -rf ./xhloop-cht/.gitignore
rm -rf ./xhloop-cht/README.md
rm -rf ./xhloop-cht/README-en.md
rm -rf ./xhloop-cht/.github/
mv ./xhloop-cht/default.yaml ./schema
mv ./xhloop-cht/key_bindings.yaml ./schema
mv ./xhloop-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./xhloop-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhloop-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../xhloop-cht/moran.chars.dict.yaml > ../xhloop-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../xhloop-cht/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{0,1};.*\n//g" ../xhloop-cht/temp.txt
perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloop-cht/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloop-cht/temp.txt
echo "" >> ../xhloop-cht/moran.chars.dict.yaml.bak
cat ../xhloop-cht/temp.txt >> ../xhloop-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloop-cht/moran.base.dict.yaml > ../xhloop-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloop-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -t -i ../xhloop-cht/snow_pinyin.base.dict.yaml -o ../xhloop-cht/temp.txt
# echo "" >> ../xhloop-cht/moran.base.dict.yaml.bak
cat ../xhloop-cht/temp.txt >> ../xhloop-cht/moran.base.dict.yaml.bak
rm ../xhloop-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-cht/moran.tencent.dict.yaml > ../../xhloop-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-cht/moran.moe.dict.yaml > ../../xhloop-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-cht/moran.computer.dict.yaml > ../../xhloop-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-cht/moran.hanyu.dict.yaml > ../../xhloop-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-cht/moran.words.dict.yaml > ../../xhloop-cht/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../xhloop-cht/zrlf.dict.yaml -o ../../xhloop-cht/zrlf.dict.yaml.bak

sed '/\.\.\./q' ../xhloop-cht/moran_fixed.dict.yaml > ../xhloop-cht/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../xhloop-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-cht/zrlong.dict.yaml
opencc -i ../xhloop-cht/zrlong.dict.yaml -o ../xhloop-cht/temp.txt -c s2t
echo "" >> ../xhloop-cht/moran_fixed.dict.yaml.bak
cat ../xhloop-cht/temp.txt >> ../xhloop-cht/moran_fixed.dict.yaml.bak
rm ../xhloop-cht/zrlong.dict.yaml

sed '/\.\.\./q' ../xhloop-cht/moran_fixed_simp.dict.yaml > ../xhloop-cht/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../xhloop-cht/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-cht/zrlong.dict.yaml
cp ../xhloop-cht/zrlong.dict.yaml ../xhloop-cht/temp.txt
echo "" >> ../xhloop-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhloop-cht/temp.txt >> ../xhloop-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhloop-cht/zrlong.dict.yaml

mv ../xhloop-cht/moran.chars.dict.yaml{.bak,}
mv ../xhloop-cht/moran.base.dict.yaml{.bak,}
# mv ../xhloop-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhloop-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhloop-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhloop-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloop-cht/moran.words.dict.yaml{.bak,}
mv ../xhloop-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhloop-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../xhloop-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../xhloop-chs/moran.chars.dict.yaml > ../xhloop-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../xhloop-chs/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{0,1};.*\n//g" ../xhloop-chs/temp.txt
perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloop-chs/temp.txt
perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloop-chs/temp.txt
echo "" >> ../xhloop-chs/moran.chars.dict.yaml.bak
cat ../xhloop-chs/temp.txt >> ../xhloop-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloop-chs/moran.base.dict.yaml > ../xhloop-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloop-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -s -i ../xhloop-chs/snow_pinyin.base.dict.yaml -o ../xhloop-chs/temp.txt
# echo "" >> ../xhloop-chs/moran.base.dict.yaml.bak
cat ../xhloop-chs/temp.txt >> ../xhloop-chs/moran.base.dict.yaml.bak
rm ../xhloop-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-chs/moran.tencent.dict.yaml > ../../xhloop-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-chs/moran.moe.dict.yaml > ../../xhloop-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-chs/moran.computer.dict.yaml > ../../xhloop-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-chs/moran.hanyu.dict.yaml > ../../xhloop-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloop-chs/moran.words.dict.yaml > ../../xhloop-chs/moran.words.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../xhloop-chs/zrlf.dict.yaml -o ../../xhloop-chs/zrlf.dict.yaml.bak

sed '/\.\.\./q' ../xhloop-chs/moran_fixed.dict.yaml > ../xhloop-chs/moran_fixed.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../xhloop-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-chs/zrlong.dict.yaml
opencc -i ../xhloop-chs/zrlong.dict.yaml -o ../xhloop-chs/temp.txt -c s2t
echo "" >> ../xhloop-chs/moran_fixed.dict.yaml.bak
cat ../xhloop-chs/temp.txt >> ../xhloop-chs/moran_fixed.dict.yaml.bak
rm ../xhloop-chs/zrlong.dict.yaml

sed '/\.\.\./q' ../xhloop-chs/moran_fixed_simp.dict.yaml > ../xhloop-chs/moran_fixed_simp.dict.yaml.bak
cp ../rime-zrlong/zrlong.dict.yaml ../xhloop-chs/zrlong.dict.yaml
sed -i '0,/\.\.\./d' ../xhloop-chs/zrlong.dict.yaml
cp ../xhloop-chs/zrlong.dict.yaml ../xhloop-chs/temp.txt
echo "" >> ../xhloop-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhloop-chs/temp.txt >> ../xhloop-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhloop-chs/zrlong.dict.yaml

mv ../xhloop-chs/moran.chars.dict.yaml{.bak,}
mv ../xhloop-chs/moran.base.dict.yaml{.bak,}
# mv ../xhloop-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhloop-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhloop-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhloop-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloop-chs/moran.words.dict.yaml{.bak,}
mv ../xhloop-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhloop-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../xhloop-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhloop-cht/tools
rm -rf ./xhloop-cht/make_simp_dist.sh
mkdir -p ./xhloop-cht/snow-dicts/
mkdir -p ./xhloop-chs/snow-dicts/
cp -a ./xhloop-cht/moran_fixed.dict.yaml ./schema/
cp -a ./xhloop-cht/moran_fixed_simp.dict.yaml ./schema/
cp -a ./schema/default.custom.yaml ./xhloop-cht
cp -a ./schema/default.custom.yaml ./xhloop-chs

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
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloop-cht/snow-dicts/xhloop_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../xhloop-cht/snow-dicts/flypy_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p xhloop -x zrmdb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloop-chs/snow-dicts/xhloop_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -o ../xhloop-chs/snow-dicts/flypy_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./schema/radical.schema.yaml ./xhloop-chs
cp ./schema/radical.schema.yaml ./xhloop-cht
cp ./schema/radical_flypy.dict.yaml ./xhloop-cht
sed '/\.\.\./q' ./xhloop-cht/radical_flypy.dict.yaml > ./xhloop-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhloop-cht/moran.chars.dict.yaml
echo "" >> ./xhloop-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./xhloop-cht/radical_flypy.dict.yaml.bak
mv ./xhloop-cht/radical_flypy.dict.yaml{.bak,}
cp ./xhloop-cht/radical_flypy.dict.yaml ./xhloop-chs

rm temp.txt
rm ./xhloop-cht/temp.txt
rm ./xhloop-chs/temp.txt

echo xhloop繁體設定檔...
cd xhloop-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloop_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloop.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloop/g" ./xhloop.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloop/g" ./xhloop.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloop = moran + xhloop + snow/g" ./xhloop.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloop_fixed/g" ./xhloop.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloop_sentence/g" ./xhloop.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloop.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloop.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloop.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloop.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloop.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloop.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloop.schema.yaml

cp moran_aux.schema.yaml xhloop_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloop_aux/g" ./xhloop_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloop輔篩/g" ./xhloop_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloop」方案不同。/g" ./xhloop_aux.schema.yaml

cp moran_bj.schema.yaml xhloop_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloop_bj/g" ./xhloop_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloop並擊/g" ./xhloop_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloop = moran + xhloop + snow/g" ./xhloop_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloop_fixed/g" ./xhloop_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloop_sentence/g" ./xhloop_bj.schema.yaml

cp moran_fixed.schema.yaml xhloop_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloop_fixed/g" ./xhloop_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloop字詞/g" ./xhloop_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloop_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloop_sentence/g" ./xhloop_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloop整句/g" ./xhloop_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_sentence.schema.yaml
cd ..

echo xhloop简体設定檔...
cd xhloop-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloop_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloop.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloop/g" ./xhloop.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloop/g" ./xhloop.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloop = moran + xhloop + snow/g" ./xhloop.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloop_fixed/g" ./xhloop.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloop_sentence/g" ./xhloop.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloop.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloop.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloop.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloop.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloop.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloop.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloop.schema.yaml

cp moran_aux.schema.yaml xhloop_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloop_aux/g" ./xhloop_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloop輔篩/g" ./xhloop_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloop」方案不同。/g" ./xhloop_aux.schema.yaml

cp moran_bj.schema.yaml xhloop_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloop_bj/g" ./xhloop_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloop並擊/g" ./xhloop_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloop = moran + xhloop + snow/g" ./xhloop_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloop_fixed/g" ./xhloop_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloop_sentence/g" ./xhloop_bj.schema.yaml

cp moran_fixed.schema.yaml xhloop_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloop_fixed/g" ./xhloop_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloop字詞/g" ./xhloop_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloop_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloop_sentence/g" ./xhloop_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloop整句/g" ./xhloop_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloop_sentence.schema.yaml
cd ..
