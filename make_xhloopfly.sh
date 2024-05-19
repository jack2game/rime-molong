#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhloopfly-chs
rm -rf xhloopfly-cht

# 生成繁體
cp -a ./rime-moran/. ./xhloopfly-cht

rm -rf ./xhloopfly-cht/.git
rm -rf ./xhloopfly-cht/.gitignore
rm -rf ./xhloopfly-cht/README.md
rm -rf ./xhloopfly-cht/README-en.md
rm -rf ./xhloopfly-cht/.github/
# mv ./xhloopfly-cht/default.yaml ./schema
# mv ./xhloopfly-cht/key_bindings.yaml ./schema
# mv ./xhloopfly-cht/punctuation.yaml ./schema


# cp ./rime-moran/tools/data/flypydb.txt ./tools-additional
# sed -i 's/ /\t/g' ./tools-additional/flypydb.txt

# 生成簡體
cd ./xhloopfly-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhloopfly-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
sed '/\.\.\./q' ../xhloopfly-cht/moran.chars.dict.yaml > ../xhloopfly-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -i ../data/zdicdbtonesorted.yaml -o ../xhloopfly-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopfly-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopfly-cht/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopfly-cht/temp.txt
echo "" >> ../xhloopfly-cht/moran.chars.dict.yaml.bak
cat ../xhloopfly-cht/temp.txt >> ../xhloopfly-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopfly-cht/moran.base.dict.yaml > ../xhloopfly-cht/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopfly-cht/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -t -i ../xhloopfly-cht/snow_pinyin.base.dict.yaml -o ../xhloopfly-cht/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopfly-cht/temp.txt && sed -i '0,/\.\.\./d' ../xhloopfly-cht/temp.txt
# echo "" >> ../xhloopfly-cht/moran.base.dict.yaml.bak
cat ../xhloopfly-cht/temp.txt >> ../xhloopfly-cht/moran.base.dict.yaml.bak
rm ../xhloopfly-cht/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-cht/moran.tencent.dict.yaml > ../../xhloopfly-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-cht/moran.moe.dict.yaml > ../../xhloopfly-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-cht/moran.computer.dict.yaml > ../../xhloopfly-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-cht/moran.hanyu.dict.yaml > ../../xhloopfly-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-cht/moran.words.dict.yaml > ../../xhloopfly-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopfly-cht/zrlf.dict.yaml -o ../xhloopfly-cht/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopfly-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopfly-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopfly-cht/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../xhloopfly-cht/moran_fixed.dict.yaml > ../xhloopfly-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopfly.simpchars.4123.txt ../xhloopfly-cht/xhloopfly.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopfly-cht/xhloopfly.simpchars.4123.txt
opencc -i ../xhloopfly-cht/xhloopfly.simpchars.4123.txt -o ../xhloopfly-cht/temp.txt -c s2t
echo "" >> ../xhloopfly-cht/moran_fixed.dict.yaml.bak
cat ../xhloopfly-cht/temp.txt >> ../xhloopfly-cht/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../xhloopfly-cht/moran_fixed.dict.yaml >> ../xhloopfly-cht/moran_fixed.dict.yaml.bak
rm ../xhloopfly-cht/xhloopfly.simpchars.4123.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopfly-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopfly-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopfly-cht/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../xhloopfly-cht/moran_fixed_simp.dict.yaml > ../xhloopfly-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopfly.simpchars.4123.txt ../xhloopfly-cht/xhloopfly.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopfly-cht/xhloopfly.simpchars.4123.txt
cp ../xhloopfly-cht/xhloopfly.simpchars.4123.txt ../xhloopfly-cht/temp.txt
echo "" >> ../xhloopfly-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhloopfly-cht/temp.txt >> ../xhloopfly-cht/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../xhloopfly-cht/moran_fixed_simp.dict.yaml >> ../xhloopfly-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhloopfly-cht/xhloopfly.simpchars.4123.txt

mv ../xhloopfly-cht/moran.chars.dict.yaml{.bak,}
mv ../xhloopfly-cht/moran.base.dict.yaml{.bak,}
# mv ../xhloopfly-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopfly-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhloopfly-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhloopfly-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopfly-cht/moran.words.dict.yaml{.bak,}
mv ../xhloopfly-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhloopfly-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopfly-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
sed '/\.\.\./q' ../xhloopfly-chs/moran.chars.dict.yaml > ../xhloopfly-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -i ../data/zdicdbtonesorted.yaml -o ../xhloopfly-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopfly-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t.*;[a-z]{0,1}\n//g" ../xhloopfly-chs/temp.txt
# perl -CSAD -i -pe "s/.*\t[a-z]{2};;.*\n//g" ../xhloopfly-chs/temp.txt
echo "" >> ../xhloopfly-chs/moran.chars.dict.yaml.bak
cat ../xhloopfly-chs/temp.txt >> ../xhloopfly-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhloopfly-chs/moran.base.dict.yaml > ../xhloopfly-chs/moran.base.dict.yaml.bak
cp ../rime-snow-pinyin/snow_pinyin.base.dict.yaml ../xhloopfly-chs/snow_pinyin.base.dict.yaml
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -s -i ../xhloopfly-chs/snow_pinyin.base.dict.yaml -o ../xhloopfly-chs/temp.txt
perl -CSAD -i -pe "s/.\t[a-z]{2};;\t0\n//g" ../xhloopfly-chs/temp.txt && sed -i '0,/\.\.\./d' ../xhloopfly-chs/temp.txt
# echo "" >> ../xhloopfly-chs/moran.base.dict.yaml.bak
cat ../xhloopfly-chs/temp.txt >> ../xhloopfly-chs/moran.base.dict.yaml.bak
rm ../xhloopfly-chs/snow_pinyin.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-chs/moran.tencent.dict.yaml > ../../xhloopfly-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-chs/moran.moe.dict.yaml > ../../xhloopfly-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-chs/moran.computer.dict.yaml > ../../xhloopfly-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-chs/moran.hanyu.dict.yaml > ../../xhloopfly-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhloopfly-chs/moran.words.dict.yaml > ../../xhloopfly-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhloopfly-chs/zrlf.dict.yaml -o ../xhloopfly-chs/zrlf.dict.yaml.bak

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopfly-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopfly-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopfly-chs/moran_fixed.dict.yaml
sed '/#----------詞庫----------#/q' ../xhloopfly-chs/moran_fixed.dict.yaml > ../xhloopfly-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopfly.simpchars.4123.txt ../xhloopfly-chs/xhloopfly.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopfly-chs/xhloopfly.simpchars.4123.txt
opencc -i ../xhloopfly-chs/xhloopfly.simpchars.4123.txt -o ../xhloopfly-chs/temp.txt -c s2t
echo "" >> ../xhloopfly-chs/moran_fixed.dict.yaml.bak
cat ../xhloopfly-chs/temp.txt >> ../xhloopfly-chs/moran_fixed.dict.yaml.bak
sed '0,/#----------詞庫----------#/d' ../xhloopfly-chs/moran_fixed.dict.yaml >> ../xhloopfly-chs/moran_fixed.dict.yaml.bak
rm ../xhloopfly-chs/xhloopfly.simpchars.4123.txt

perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhloopfly-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhloopfly-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhloopfly-chs/moran_fixed_simp.dict.yaml
sed '/#----------词库----------#/q' ../xhloopfly-chs/moran_fixed_simp.dict.yaml > ../xhloopfly-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhloopfly.simpchars.4123.txt ../xhloopfly-chs/xhloopfly.simpchars.4123.txt
# sed -i '0,/\.\.\./d' ../xhloopfly-chs/xhloopfly.simpchars.4123.txt
cp ../xhloopfly-chs/xhloopfly.simpchars.4123.txt ../xhloopfly-chs/temp.txt
echo "" >> ../xhloopfly-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhloopfly-chs/temp.txt >> ../xhloopfly-chs/moran_fixed_simp.dict.yaml.bak
sed '0,/#----------词库----------#/d' ../xhloopfly-chs/moran_fixed_simp.dict.yaml >> ../xhloopfly-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhloopfly-chs/xhloopfly.simpchars.4123.txt

mv ../xhloopfly-chs/moran.chars.dict.yaml{.bak,}
mv ../xhloopfly-chs/moran.base.dict.yaml{.bak,}
# mv ../xhloopfly-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhloopfly-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhloopfly-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhloopfly-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhloopfly-chs/moran.words.dict.yaml{.bak,}
mv ../xhloopfly-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhloopfly-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhloopfly-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhloopfly-cht/tools
rm -rf ./xhloopfly-cht/make_simp_dist.sh
mkdir -p ./xhloopfly-cht/snow-dicts/
mkdir -p ./xhloopfly-chs/snow-dicts/
cp -a ./xhloopfly-cht/moran_fixed.dict.yaml ./schema/xhloopfly_fixed.dict.yaml
cp -a ./xhloopfly-cht/moran_fixed_simp.dict.yaml ./schema/xhloopfly_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhloopfly.yaml ./xhloopfly-cht/default.custom.yaml
cp -a ./schema/default.custom.xhloopfly.yaml ./xhloopfly-chs/default.custom.yaml

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
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -t -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopfly-cht/snow-dicts/xhloopfly_flypydb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x flypydb -t -o ../xhloopfly-cht/snow-dicts/flypy_flypydb_tencent.dict.yaml
# 生成簡體霧凇
python3 gen_dict_with_shape.py -p xhloopfly -x flypydb -s -i ../rime-snow-pinyin/snow_pinyin.ext.dict.yaml -o ../xhloopfly-chs/snow-dicts/xhloopfly_flypydb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/8105.dict.yaml    -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/41448.dict.yaml   -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/base.dict.yaml    -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/ext.dict.yaml     -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/others.dict.yaml  -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-snow/cn_dicts/tencent.dict.yaml -x flypydb -o ../xhloopfly-chs/snow-dicts/flypy_flypydb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./schema/radical.schema.yaml ./xhloopfly-chs
cp ./schema/radical.schema.yaml ./xhloopfly-cht
cp ./schema/radical_flypy.dict.yaml ./xhloopfly-cht
sed '/\.\.\./q' ./xhloopfly-cht/radical_flypy.dict.yaml > ./xhloopfly-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhloopfly-cht/moran.chars.dict.yaml
echo "" >> ./xhloopfly-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./xhloopfly-cht/radical_flypy.dict.yaml.bak
mv ./xhloopfly-cht/radical_flypy.dict.yaml{.bak,}
cp ./xhloopfly-cht/radical_flypy.dict.yaml ./xhloopfly-chs

rm temp.txt
rm ./xhloopfly-cht/temp.txt
rm ./xhloopfly-chs/temp.txt

echo xhloopfly繁體設定檔...
cd xhloopfly-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopfly_flypydb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopfly.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopfly/g" ./xhloopfly.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopfly/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopfly = moran + xhloopfly + snow/g" ./xhloopfly.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopfly_fixed/g" ./xhloopfly.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopfly_sentence/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopfly.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopfly.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopfly.schema.yaml

cp moran_aux.schema.yaml xhloopfly_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopfly_aux/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopfly輔篩/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopfly」方案不同。/g" ./xhloopfly_aux.schema.yaml

cp moran_bj.schema.yaml xhloopfly_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopfly_bj/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopfly並擊/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopfly = moran + xhloopfly + snow/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopfly_fixed/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopfly_sentence/g" ./xhloopfly_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopfly_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopfly_fixed/g" ./xhloopfly_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopfly字詞/g" ./xhloopfly_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopfly_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopfly_sentence/g" ./xhloopfly_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopfly整句/g" ./xhloopfly_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_sentence.schema.yaml
cd ..

echo xhloopfly简体設定檔...
cd xhloopfly-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - snow-dicts\/xhloopfly_flypydb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhloopfly.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhloopfly/g" ./xhloopfly.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhloopfly/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopfly = moran + xhloopfly + snow/g" ./xhloopfly.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopfly_fixed/g" ./xhloopfly.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopfly_sentence/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhloopfly.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhloopfly.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhloopfly.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhloopfly.schema.yaml

cp moran_aux.schema.yaml xhloopfly_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhloopfly_aux/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhloopfly輔篩/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhloopfly」方案不同。/g" ./xhloopfly_aux.schema.yaml

cp moran_bj.schema.yaml xhloopfly_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhloopfly_bj/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhloopfly並擊/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhloopfly = moran + xhloopfly + snow/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhloopfly_fixed/g" ./xhloopfly_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhloopfly_sentence/g" ./xhloopfly_bj.schema.yaml

cp moran_fixed.schema.yaml xhloopfly_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhloopfly_fixed/g" ./xhloopfly_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhloopfly字詞/g" ./xhloopfly_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_fixed.schema.yaml

cp moran_sentence.schema.yaml xhloopfly_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhloopfly_sentence/g" ./xhloopfly_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhloopfly整句/g" ./xhloopfly_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhloopfly_sentence.schema.yaml
cd ..
