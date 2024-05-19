#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf zrloopkai-chs
rm -rf zrloopkai-cht

# 生成繁體
cp -a ./rime-moran/. ./zrloopkai-cht

rm -rf ./zrloopkai-cht/.git
rm -rf ./zrloopkai-cht/.gitignore
rm -rf ./zrloopkai-cht/README.md
rm -rf ./zrloopkai-cht/README-en.md
rm -rf ./zrloopkai-cht/.github/
# mv ./zrloopkai-cht/default.yaml ./schema
# mv ./zrloopkai-cht/key_bindings.yaml ./schema
# mv ./zrloopkai-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./zrloopkai-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/zrloopkai-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../zrloopkai-cht/moran.chars.dict.yaml > ../zrloopkai-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../zrloopkai-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../zrloopkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloopkai-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloopkai-cht/temp.txt
echo "" >> ../zrloopkai-cht/moran.chars.dict.yaml.bak
cat ../zrloopkai-cht/temp.txt >> ../zrloopkai-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloopkai-cht/moran.base.dict.yaml > ../zrloopkai-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloopkai-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -t -i ../zrloopkai-cht/snow_pinyin.base.dict.yaml -o ../zrloopkai-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../zrloopkai-cht/temp.txt && sed -i '0,/\.\.\./d' ../zrloopkai-cht/temp.txt
# echo "" >> ../zrloopkai-cht/moran.base.dict.yaml.bak
cat ../zrloopkai-cht/temp.txt >> ../zrloopkai-cht/moran.base.dict.yaml.bak
rm ../zrloopkai-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-cht/moran.tencent.dict.yaml > ../../zrloopkai-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-cht/moran.moe.dict.yaml > ../../zrloopkai-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-cht/moran.computer.dict.yaml > ../../zrloopkai-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-cht/moran.hanyu.dict.yaml > ../../zrloopkai-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-cht/moran.words.dict.yaml > ../../zrloopkai-cht/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../zrloopkai-cht/zrlf.dict.yaml -o ../zrloopkai-cht/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../zrloopkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopkai-cht/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../zrloopkai-cht/moran_fixed.dict.yaml > ../zrloopkai-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopkai.simpchars.4123.txt ../zrloopkai-cht/zrloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../zrloopkai-cht/zrloopkai.simpchars.4123.txt
opencc -i ../zrloopkai-cht/zrloopkai.simpchars.4123.txt -o ../zrloopkai-cht/temp.txt -c s2t
echo "" >> ../zrloopkai-cht/moran_fixed.dict.yaml.bak
cat ../zrloopkai-cht/temp.txt >> ../zrloopkai-cht/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../zrloopkai-cht/moran_fixed.dict.yaml >> ../zrloopkai-cht/moran_fixed.dict.yaml.bak
rm ../zrloopkai-cht/zrloopkai.simpchars.4123.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../zrloopkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopkai-cht/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../zrloopkai-cht/moran_fixed_simp.dict.yaml > ../zrloopkai-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopkai.simpchars.4123.txt ../zrloopkai-cht/zrloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../zrloopkai-cht/zrloopkai.simpchars.4123.txt
cp ../zrloopkai-cht/zrloopkai.simpchars.4123.txt ../zrloopkai-cht/temp.txt
echo "" >> ../zrloopkai-cht/moran_fixed_simp.dict.yaml.bak
cat ../zrloopkai-cht/temp.txt >> ../zrloopkai-cht/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../zrloopkai-cht/moran_fixed_simp.dict.yaml >> ../zrloopkai-cht/moran_fixed_simp.dict.yaml.bak
rm ../zrloopkai-cht/zrloopkai.simpchars.4123.txt

mv ../zrloopkai-cht/moran.chars.dict.yaml{.bak,}
mv ../zrloopkai-cht/moran.base.dict.yaml{.bak,}
# mv ../zrloopkai-cht/moran.tencent.dict.yaml{.bak,}
# mv ../zrloopkai-cht/moran.moe.dict.yaml{.bak,}
# mv ../zrloopkai-cht/moran.computer.dict.yaml{.bak,}
# mv ../zrloopkai-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloopkai-cht/moran.words.dict.yaml{.bak,}
mv ../zrloopkai-cht/moran_fixed.dict.yaml{.bak,}
mv ../zrloopkai-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloopkai-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../zrloopkai-chs/moran.chars.dict.yaml > ../zrloopkai-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -i ../data/zdicdbtonesorted.yaml -o ../zrloopkai-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../zrloopkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../zrloopkai-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../zrloopkai-chs/temp.txt
echo "" >> ../zrloopkai-chs/moran.chars.dict.yaml.bak
cat ../zrloopkai-chs/temp.txt >> ../zrloopkai-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../zrloopkai-chs/moran.base.dict.yaml > ../zrloopkai-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../zrloopkai-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -s -i ../zrloopkai-chs/snow_pinyin.base.dict.yaml -o ../zrloopkai-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../zrloopkai-chs/temp.txt && sed -i '0,/\.\.\./d' ../zrloopkai-chs/temp.txt
# echo "" >> ../zrloopkai-chs/moran.base.dict.yaml.bak
cat ../zrloopkai-chs/temp.txt >> ../zrloopkai-chs/moran.base.dict.yaml.bak
rm ../zrloopkai-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-chs/moran.tencent.dict.yaml > ../../zrloopkai-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-chs/moran.moe.dict.yaml > ../../zrloopkai-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-chs/moran.computer.dict.yaml > ../../zrloopkai-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-chs/moran.hanyu.dict.yaml > ../../zrloopkai-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../zrloopkai-chs/moran.words.dict.yaml > ../../zrloopkai-chs/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../zrloopkai-chs/zrlf.dict.yaml -o ../zrloopkai-chs/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../zrloopkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopkai-chs/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../zrloopkai-chs/moran_fixed.dict.yaml > ../zrloopkai-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopkai.simpchars.4123.txt ../zrloopkai-chs/zrloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../zrloopkai-chs/zrloopkai.simpchars.4123.txt
opencc -i ../zrloopkai-chs/zrloopkai.simpchars.4123.txt -o ../zrloopkai-chs/temp.txt -c s2t
echo "" >> ../zrloopkai-chs/moran_fixed.dict.yaml.bak
cat ../zrloopkai-chs/temp.txt >> ../zrloopkai-chs/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../zrloopkai-chs/moran_fixed.dict.yaml >> ../zrloopkai-chs/moran_fixed.dict.yaml.bak
rm ../zrloopkai-chs/zrloopkai.simpchars.4123.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../zrloopkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../zrloopkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../zrloopkai-chs/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../zrloopkai-chs/moran_fixed_simp.dict.yaml > ../zrloopkai-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/zrloopkai.simpchars.4123.txt ../zrloopkai-chs/zrloopkai.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../zrloopkai-chs/zrloopkai.simpchars.4123.txt
cp ../zrloopkai-chs/zrloopkai.simpchars.4123.txt ../zrloopkai-chs/temp.txt
echo "" >> ../zrloopkai-chs/moran_fixed_simp.dict.yaml.bak
cat ../zrloopkai-chs/temp.txt >> ../zrloopkai-chs/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../zrloopkai-chs/moran_fixed_simp.dict.yaml >> ../zrloopkai-chs/moran_fixed_simp.dict.yaml.bak
rm ../zrloopkai-chs/zrloopkai.simpchars.4123.txt

mv ../zrloopkai-chs/moran.chars.dict.yaml{.bak,}
mv ../zrloopkai-chs/moran.base.dict.yaml{.bak,}
# mv ../zrloopkai-chs/moran.tencent.dict.yaml{.bak,}
# mv ../zrloopkai-chs/moran.moe.dict.yaml{.bak,}
# mv ../zrloopkai-chs/moran.computer.dict.yaml{.bak,}
# mv ../zrloopkai-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../zrloopkai-chs/moran.words.dict.yaml{.bak,}
mv ../zrloopkai-chs/moran_fixed.dict.yaml{.bak,}
mv ../zrloopkai-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../zrloopkai-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./zrloopkai-cht/tools
rm -rf ./zrloopkai-cht/make_simp_dist.sh
mkdir -p ./zrloopkai-cht/snow-dicts/
mkdir -p ./zrloopkai-chs/snow-dicts/
cp -a ./zrloopkai-cht/moran_fixed.dict.yaml ./schema/zrloopkai_fixed.dict.yaml
cp -a ./zrloopkai-cht/moran_fixed_simp.dict.yaml ./schema/zrloopkai_fixed_simp.dict.yaml
cp -a ./schema/default.custom.zrloopkai.yaml ./zrloopkai-cht/default.custom.yaml
cp -a ./schema/default.custom.zrloopkai.yaml ./zrloopkai-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloopkai-cht/snow-dicts/zrloopkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../zrloopkai-cht/snow-dicts/flypy_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p zrloopkai -x zrmdb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../zrloopkai-chs/snow-dicts/zrloopkai_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x zrmdb -o ../zrloopkai-chs/snow-dicts/flypy_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./schema/radical.schema.yaml ./zrloopkai-chs
cp ./schema/radical.schema.yaml ./zrloopkai-cht
cp ./schema/radical_flypy.dict.yaml ./zrloopkai-cht
sed '/\.\.\./q' ./zrloopkai-cht/radical_flypy.dict.yaml > ./zrloopkai-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./zrloopkai-cht/moran.chars.dict.yaml
echo "" >> ./zrloopkai-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./zrloopkai-cht/radical_flypy.dict.yaml.bak
mv ./zrloopkai-cht/radical_flypy.dict.yaml{.bak,}
cp ./zrloopkai-cht/radical_flypy.dict.yaml ./zrloopkai-chs

rm temp.txt
rm ./zrloopkai-cht/temp.txt
rm ./zrloopkai-chs/temp.txt

echo zrloopkai繁體設定檔...
cd zrloopkai-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloopkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloopkai/g" ./zrloopkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloopkai/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopkai = moran + zrloopkai + snow/g" ./zrloopkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopkai_fixed/g" ./zrloopkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopkai_sentence/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloopkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloopkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloopkai.schema.yaml

cp moran_aux.schema.yaml zrloopkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloopkai_aux/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloopkai輔篩/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloopkai」方案不同。/g" ./zrloopkai_aux.schema.yaml

cp moran_bj.schema.yaml zrloopkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloopkai_bj/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: zrloopkai並擊/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopkai = moran + zrloopkai + snow/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopkai_fixed/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopkai_sentence/g" ./zrloopkai_bj.schema.yaml

cp moran_fixed.schema.yaml zrloopkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloopkai_fixed/g" ./zrloopkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloopkai字詞/g" ./zrloopkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloopkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloopkai_sentence/g" ./zrloopkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloopkai整句/g" ./zrloopkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_sentence.schema.yaml
cd ..

echo zrloopkai简体設定檔...
cd zrloopkai-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/zrloopkai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml zrloopkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: zrloopkai/g" ./zrloopkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: zrloopkai/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopkai = moran + zrloopkai + snow/g" ./zrloopkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopkai_fixed/g" ./zrloopkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopkai_sentence/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./zrloopkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./zrloopkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./zrloopkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./zrloopkai.schema.yaml

cp moran_aux.schema.yaml zrloopkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: zrloopkai_aux/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: zrloopkai輔篩/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「zrloopkai」方案不同。/g" ./zrloopkai_aux.schema.yaml

cp moran_bj.schema.yaml zrloopkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: zrloopkai_bj/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: zrloopkai並擊/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    zrloopkai = moran + zrloopkai + snow/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - zrloopkai_fixed/g" ./zrloopkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - zrloopkai_sentence/g" ./zrloopkai_bj.schema.yaml

cp moran_fixed.schema.yaml zrloopkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: zrloopkai_fixed/g" ./zrloopkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: zrloopkai字詞/g" ./zrloopkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_fixed.schema.yaml

cp moran_sentence.schema.yaml zrloopkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: zrloopkai_sentence/g" ./zrloopkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: zrloopkai整句/g" ./zrloopkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./zrloopkai_sentence.schema.yaml
cd ..
