#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf molongkai-chs
rm -rf molongkai-cht

# 生成繁體
cp -a ./rime-moran/. ./molongkai-cht

rm -rf ./molongkai-cht/.git
rm -rf ./molongkai-cht/.gitignore
rm -rf ./molongkai-cht/README.md
rm -rf ./molongkai-cht/README-en.md
rm -rf ./molongkai-cht/.github/
# mv ./molongkai-cht/default.yaml ./schema
# mv ./molongkai-cht/key_bindings.yaml ./schema
# mv ./molongkai-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./molongkai-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/molongkai-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../molongkai-cht/moran.chars.dict.yaml > ../molongkai-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../molongkai-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../molongkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molongkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molongkai-cht/temp.txt
echo "" >> ../molongkai-cht/moran.chars.dict.yaml.bak
cat ../molongkai-cht/temp.txt >> ../molongkai-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molongkai-cht/moran.base.dict.yaml > ../molongkai-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molongkai-cht/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molongkai-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -t -i ../molongkai-cht/snow_pinyin.base.dict.yaml -o ../molongkai-cht/temp.txt
# echo "" >> ../molongkai-cht/moran.base.dict.yaml.bak
cat ../molongkai-cht/temp.txt >> ../molongkai-cht/moran.base.dict.yaml.bak
rm ../molongkai-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-cht/moran.tencent.dict.yaml > ../../molongkai-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-cht/moran.moe.dict.yaml > ../../molongkai-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-cht/moran.computer.dict.yaml > ../../molongkai-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-cht/moran.hanyu.dict.yaml > ../../molongkai-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-cht/moran.words.dict.yaml > ../../molongkai-cht/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../molongkai-cht/zrlf.dict.yaml -o ../molongkai-cht/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongkai-cht/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../molongkai-cht/moran_fixed.dict.yaml > ../molongkai-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongkai.simpchars.txt ../molongkai-cht/molongkai.simpchars.txt
# sed -i '0,/\.\.\./d' ../molongkai-cht/molongkai.simpchars.txt
opencc -i ../molongkai-cht/molongkai.simpchars.txt -o ../molongkai-cht/temp.txt -c s2t
echo "" >> ../molongkai-cht/moran_fixed.dict.yaml.bak
cat ../molongkai-cht/temp.txt >> ../molongkai-cht/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../molongkai-cht/moran_fixed.dict.yaml >> ../molongkai-cht/moran_fixed.dict.yaml.bak
rm ../molongkai-cht/molongkai.simpchars.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongkai-cht/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../molongkai-cht/moran_fixed_simp.dict.yaml > ../molongkai-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongkai.simpchars.txt ../molongkai-cht/molongkai.simpchars.txt
# sed -i '0,/\.\.\./d' ../molongkai-cht/molongkai.simpchars.txt
cp ../molongkai-cht/molongkai.simpchars.txt ../molongkai-cht/temp.txt
echo "" >> ../molongkai-cht/moran_fixed_simp.dict.yaml.bak
cat ../molongkai-cht/temp.txt >> ../molongkai-cht/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../molongkai-cht/moran_fixed_simp.dict.yaml >> ../molongkai-cht/moran_fixed_simp.dict.yaml.bak
rm ../molongkai-cht/molongkai.simpchars.txt

mv ../molongkai-cht/moran.chars.dict.yaml{.bak,}
mv ../molongkai-cht/moran.base.dict.yaml{.bak,}
# mv ../molongkai-cht/moran.tencent.dict.yaml{.bak,}
# mv ../molongkai-cht/moran.moe.dict.yaml{.bak,}
# mv ../molongkai-cht/moran.computer.dict.yaml{.bak,}
# mv ../molongkai-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../molongkai-cht/moran.words.dict.yaml{.bak,}
mv ../molongkai-cht/moran_fixed.dict.yaml{.bak,}
mv ../molongkai-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molongkai-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../molongkai-chs/moran.chars.dict.yaml > ../molongkai-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../molongkai-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../molongkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../molongkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../molongkai-chs/temp.txt
echo "" >> ../molongkai-chs/moran.chars.dict.yaml.bak
cat ../molongkai-chs/temp.txt >> ../molongkai-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../molongkai-chs/moran.base.dict.yaml > ../molongkai-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../molongkai-chs/snow_pinyin.base.dict.yaml
sed -i '0,/\.\.\./d' ../molongkai-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -s -i ../molongkai-chs/snow_pinyin.base.dict.yaml -o ../molongkai-chs/temp.txt
# echo "" >> ../molongkai-chs/moran.base.dict.yaml.bak
cat ../molongkai-chs/temp.txt >> ../molongkai-chs/moran.base.dict.yaml.bak
rm ../molongkai-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-chs/moran.tencent.dict.yaml > ../../molongkai-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-chs/moran.moe.dict.yaml > ../../molongkai-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-chs/moran.computer.dict.yaml > ../../molongkai-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-chs/moran.hanyu.dict.yaml > ../../molongkai-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molongkai-chs/moran.words.dict.yaml > ../../molongkai-chs/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../molongkai-chs/zrlf.dict.yaml -o ../molongkai-chs/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongkai-chs/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../molongkai-chs/moran_fixed.dict.yaml > ../molongkai-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongkai.simpchars.txt ../molongkai-chs/molongkai.simpchars.txt
# sed -i '0,/\.\.\./d' ../molongkai-chs/molongkai.simpchars.txt
opencc -i ../molongkai-chs/molongkai.simpchars.txt -o ../molongkai-chs/temp.txt -c s2t
echo "" >> ../molongkai-chs/moran_fixed.dict.yaml.bak
cat ../molongkai-chs/temp.txt >> ../molongkai-chs/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../molongkai-chs/moran_fixed.dict.yaml >> ../molongkai-chs/moran_fixed.dict.yaml.bak
rm ../molongkai-chs/molongkai.simpchars.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../molongkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../molongkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../molongkai-chs/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../molongkai-chs/moran_fixed_simp.dict.yaml > ../molongkai-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/molongkai.simpchars.txt ../molongkai-chs/molongkai.simpchars.txt
# sed -i '0,/\.\.\./d' ../molongkai-chs/molongkai.simpchars.txt
cp ../molongkai-chs/molongkai.simpchars.txt ../molongkai-chs/temp.txt
echo "" >> ../molongkai-chs/moran_fixed_simp.dict.yaml.bak
cat ../molongkai-chs/temp.txt >> ../molongkai-chs/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../molongkai-chs/moran_fixed_simp.dict.yaml >> ../molongkai-chs/moran_fixed_simp.dict.yaml.bak
rm ../molongkai-chs/molongkai.simpchars.txt

mv ../molongkai-chs/moran.chars.dict.yaml{.bak,}
mv ../molongkai-chs/moran.base.dict.yaml{.bak,}
# mv ../molongkai-chs/moran.tencent.dict.yaml{.bak,}
# mv ../molongkai-chs/moran.moe.dict.yaml{.bak,}
# mv ../molongkai-chs/moran.computer.dict.yaml{.bak,}
# mv ../molongkai-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../molongkai-chs/moran.words.dict.yaml{.bak,}
mv ../molongkai-chs/moran_fixed.dict.yaml{.bak,}
mv ../molongkai-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../molongkai-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./molongkai-cht/tools
rm -rf ./molongkai-cht/make_simp_dist.sh
mkdir -p ./molongkai-cht/snow-dicts/
mkdir -p ./molongkai-chs/snow-dicts/
cp -a ./molongkai-cht/moran_fixed.dict.yaml ./schema/molongkai_fixed.dict.yaml
cp -a ./molongkai-cht/moran_fixed_simp.dict.yaml ./schema/molongkai_fixed_simp.dict.yaml
cp -a ./schema/default.custom.molongkai.yaml ./molongkai-cht/default.custom.yaml
cp -a ./schema/default.custom.molongkai.yaml ./molongkai-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molongkai-cht/snow-dicts/molongkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../molongkai-cht/snow-dicts/flypy_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p molongkai -x zrmdb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../molongkai-chs/snow-dicts/molongkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -o ../molongkai-chs/snow-dicts/flypy_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./schema/radical.schema.yaml ./molongkai-chs
cp ./schema/radical.schema.yaml ./molongkai-cht
cp ./schema/radical_flypy.dict.yaml ./molongkai-cht
sed '/\.\.\./q' ./molongkai-cht/radical_flypy.dict.yaml > ./molongkai-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./molongkai-cht/moran.chars.dict.yaml
echo "" >> ./molongkai-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./molongkai-cht/radical_flypy.dict.yaml.bak
mv ./molongkai-cht/radical_flypy.dict.yaml{.bak,}
cp ./molongkai-cht/radical_flypy.dict.yaml ./molongkai-chs

rm temp.txt
rm ./molongkai-cht/temp.txt
rm ./molongkai-chs/temp.txt

echo molongkai繁體設定檔...
cd molongkai-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molongkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molongkai/g" ./molongkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: molongkai/g" ./molongkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongkai = moran + molongkai + snow/g" ./molongkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongkai_fixed/g" ./molongkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongkai_sentence/g" ./molongkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molongkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molongkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molongkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molongkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molongkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molongkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molongkai.schema.yaml

cp moran_aux.schema.yaml molongkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molongkai_aux/g" ./molongkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molongkai輔篩/g" ./molongkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molongkai」方案不同。/g" ./molongkai_aux.schema.yaml

cp moran_bj.schema.yaml molongkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molongkai_bj/g" ./molongkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molongkai並擊/g" ./molongkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongkai = moran + molongkai + snow/g" ./molongkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongkai_fixed/g" ./molongkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongkai_sentence/g" ./molongkai_bj.schema.yaml

cp moran_fixed.schema.yaml molongkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molongkai_fixed/g" ./molongkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molongkai字詞/g" ./molongkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_fixed.schema.yaml

cp moran_sentence.schema.yaml molongkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molongkai_sentence/g" ./molongkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molongkai整句/g" ./molongkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_sentence.schema.yaml
cd ..

echo molongkai简体設定檔...
cd molongkai-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/molongkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml molongkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: molongkai/g" ./molongkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: molongkai/g" ./molongkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongkai = moran + molongkai + snow/g" ./molongkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongkai_fixed/g" ./molongkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongkai_sentence/g" ./molongkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molongkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molongkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molongkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molongkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molongkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molongkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molongkai.schema.yaml

cp moran_aux.schema.yaml molongkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: molongkai_aux/g" ./molongkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: molongkai輔篩/g" ./molongkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molongkai」方案不同。/g" ./molongkai_aux.schema.yaml

cp moran_bj.schema.yaml molongkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: molongkai_bj/g" ./molongkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: molongkai並擊/g" ./molongkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molongkai = moran + molongkai + snow/g" ./molongkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - molongkai_fixed/g" ./molongkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - molongkai_sentence/g" ./molongkai_bj.schema.yaml

cp moran_fixed.schema.yaml molongkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: molongkai_fixed/g" ./molongkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: molongkai字詞/g" ./molongkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_fixed.schema.yaml

cp moran_sentence.schema.yaml molongkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: molongkai_sentence/g" ./molongkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: molongkai整句/g" ./molongkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molongkai_sentence.schema.yaml
cd ..
