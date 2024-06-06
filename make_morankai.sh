#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf morankai-chs
rm -rf morankai-cht

# 生成繁體
cp -a ./rime-moran/. ./morankai-cht

rm -rf ./morankai-cht/.git
rm -rf ./morankai-cht/.gitignore
rm -rf ./morankai-cht/README.md
rm -rf ./morankai-cht/README-en.md
rm -rf ./morankai-cht/.github/
# perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./morankai-cht/moran.yaml
# mv ./morankai-cht/key_bindings.yaml ./schema
# mv ./morankai-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./morankai-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/morankai-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
# cd ./tools-additional
# 轉換繁体詞庫
# echo 轉換繁体詞庫...
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.chars.dict.yaml > ../morankai-cht/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../morankai-cht/temp.txt && sed -i '0,/\.\.\./d' ../morankai-cht/temp.txt
# echo "" >> ../morankai-cht/moran.chars.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../morankai-cht/temp.txt && sed -i '0,/\.\.\./d' ../morankai-cht/temp.txt
# echo "" >> ../morankai-cht/moran.chars.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran.chars.dict.yaml.bak

# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.base.dict.yaml > ../morankai-cht/moran.base.dict.yaml.bak
# cp ../rime-ice/cn_dicts/base.dict.yaml ../morankai-cht/ice.base.dict.yaml
# sed -i '0,/\.\.\./d' ../morankai-cht/ice.base.dict.yaml
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../morankai-cht/ice.base.dict.yaml -o ../morankai-cht/temp.txt
# echo "" >> ../morankai-cht/moran.base.dict.yaml.bak
# cat ../morankai-cht/temp.txt >> ../morankai-cht/moran.base.dict.yaml.bak
# rm ../morankai-cht/ice.base.dict.yaml

# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.tencent.dict.yaml > ../morankai-cht/moran.tencent.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.moe.dict.yaml > ../morankai-cht/moran.moe.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.computer.dict.yaml > ../morankai-cht/moran.computer.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.hanyu.dict.yaml > ../morankai-cht/moran.hanyu.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-cht/moran.words.dict.yaml > ../morankai-cht/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../morankai-cht/zrlf.dict.yaml -o ../morankai-cht/zrlf.dict.yaml.bak

# sed '/#----------詞庫----------#/q' ../morankai-cht/moran_fixed.dict.yaml > ../morankai-cht/moran_fixed.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../morankai-cht/moran_fixed.dict.yaml > ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../morankai-cht/temp.txt
# sed -i '0,/#----------詞庫----------#/d' ../morankai-cht/temp.txt  &&  echo "" >> ../morankai-cht/moran_fixed.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran_fixed.dict.yaml.bak
# opencc -i ../data/assess.tiger-code.com/moran.simpwords.txt -o ../morankai-cht/temp.txt -c s2t
# echo "" >> ../morankai-cht/moran_fixed.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran_fixed.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../morankai-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../morankai-cht/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../morankai-cht/moran_fixed.dict.yaml
# sed '0,/#----------詞庫----------#/d' ../morankai-cht/moran_fixed.dict.yaml >> ../morankai-cht/moran_fixed.dict.yaml.bak

# sed '/#----------词库----------#/q' ../morankai-cht/moran_fixed_simp.dict.yaml > ../morankai-cht/moran_fixed_simp.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../morankai-cht/moran_fixed_simp.dict.yaml > ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../morankai-cht/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../morankai-cht/temp.txt
# sed -i '0,/#----------词库----------#/d' ../morankai-cht/temp.txt  &&  echo "" >> ../morankai-cht/moran_fixed_simp.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran_fixed_simp.dict.yaml.bak
# cp ../data/assess.tiger-code.com/moran.simpwords.txt ../morankai-cht/temp.txt
# echo "" >> ../morankai-cht/moran_fixed_simp.dict.yaml.bak && cat ../morankai-cht/temp.txt >> ../morankai-cht/moran_fixed_simp.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../morankai-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../morankai-cht/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../morankai-cht/moran_fixed_simp.dict.yaml
# sed '0,/#----------词库----------#/d' ../morankai-cht/moran_fixed_simp.dict.yaml >> ../morankai-cht/moran_fixed_simp.dict.yaml.bak

# mv ../morankai-cht/moran.chars.dict.yaml{.bak,}
# mv ../morankai-cht/moran.base.dict.yaml{.bak,}
# mv ../morankai-cht/moran.tencent.dict.yaml{.bak,}
# mv ../morankai-cht/moran.moe.dict.yaml{.bak,}
# mv ../morankai-cht/moran.computer.dict.yaml{.bak,}
# mv ../morankai-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../morankai-cht/moran.words.dict.yaml{.bak,}
# mv ../morankai-cht/moran_fixed.dict.yaml{.bak,}
# mv ../morankai-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../morankai-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
# echo 轉換简体詞庫...
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.chars.dict.yaml > ../morankai-chs/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../morankai-chs/temp.txt && sed -i '0,/\.\.\./d' ../morankai-chs/temp.txt
# echo "" >> ../morankai-chs/moran.chars.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../morankai-chs/temp.txt && sed -i '0,/\.\.\./d' ../morankai-chs/temp.txt
# echo "" >> ../morankai-chs/moran.chars.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran.chars.dict.yaml.bak

# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.base.dict.yaml > ../morankai-chs/moran.base.dict.yaml.bak
# cp ../rime-ice/cn_dicts/base.dict.yaml ../morankai-chs/ice.base.dict.yaml
# sed -i '0,/\.\.\./d' ../morankai-chs/ice.base.dict.yaml
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../morankai-chs/ice.base.dict.yaml -o ../morankai-chs/temp.txt
# echo "" >> ../morankai-chs/moran.base.dict.yaml.bak
# cat ../morankai-chs/temp.txt >> ../morankai-chs/moran.base.dict.yaml.bak
# rm ../morankai-chs/ice.base.dict.yaml

# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.tencent.dict.yaml > ../morankai-chs/moran.tencent.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.moe.dict.yaml > ../morankai-chs/moran.moe.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.computer.dict.yaml > ../morankai-chs/moran.computer.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.hanyu.dict.yaml > ../morankai-chs/moran.hanyu.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../morankai-chs/moran.words.dict.yaml > ../morankai-chs/moran.words.dict.yaml.bak
# python3 convert_sp.py -i ../morankai-chs/zrlf.dict.yaml -o ../morankai-chs/zrlf.dict.yaml.bak

# sed '/#----------詞庫----------#/q' ../morankai-chs/moran_fixed.dict.yaml > ../morankai-chs/moran_fixed.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../morankai-chs/moran_fixed.dict.yaml > ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../morankai-chs/temp.txt
# sed -i '0,/#----------詞庫----------#/d' ../morankai-chs/temp.txt  &&  echo "" >> ../morankai-chs/moran_fixed.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran_fixed.dict.yaml.bak
# opencc -i ../data/assess.tiger-code.com/moran.simpwords.txt -o ../morankai-chs/temp.txt -c s2t
# echo "" >> ../morankai-chs/moran_fixed.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran_fixed.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../morankai-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../morankai-chs/moran_fixed.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../morankai-chs/moran_fixed.dict.yaml
# sed '0,/#----------詞庫----------#/d' ../morankai-chs/moran_fixed.dict.yaml >> ../morankai-chs/moran_fixed.dict.yaml.bak

# sed '/#----------词库----------#/q' ../morankai-chs/moran_fixed_simp.dict.yaml > ../morankai-chs/moran_fixed_simp.dict.yaml.bak
# python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../morankai-chs/moran_fixed_simp.dict.yaml > ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../morankai-chs/temp.txt
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../morankai-chs/temp.txt
# sed -i '0,/#----------词库----------#/d' ../morankai-chs/temp.txt  &&  echo "" >> ../morankai-chs/moran_fixed_simp.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran_fixed_simp.dict.yaml.bak
# cp ../data/assess.tiger-code.com/moran.simpwords.txt ../morankai-chs/temp.txt
# echo "" >> ../morankai-chs/moran_fixed_simp.dict.yaml.bak && cat ../morankai-chs/temp.txt >> ../morankai-chs/moran_fixed_simp.dict.yaml.bak
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../morankai-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../morankai-chs/moran_fixed_simp.dict.yaml
# perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../morankai-chs/moran_fixed_simp.dict.yaml
# sed '0,/#----------词库----------#/d' ../morankai-chs/moran_fixed_simp.dict.yaml >> ../morankai-chs/moran_fixed_simp.dict.yaml.bak

# mv ../morankai-chs/moran.chars.dict.yaml{.bak,}
# mv ../morankai-chs/moran.base.dict.yaml{.bak,}
# mv ../morankai-chs/moran.tencent.dict.yaml{.bak,}
# mv ../morankai-chs/moran.moe.dict.yaml{.bak,}
# mv ../morankai-chs/moran.computer.dict.yaml{.bak,}
# mv ../morankai-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../morankai-chs/moran.words.dict.yaml{.bak,}
# mv ../morankai-chs/moran_fixed.dict.yaml{.bak,}
# mv ../morankai-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../morankai-chs/zrlf.dict.yaml{.bak,}
# cd ..

# 整理文件結構
rm -rf ./morankai-cht/tools
rm -rf ./morankai-cht/make_simp_dist.sh
mkdir -p ./morankai-cht/ice-dicts/
mkdir -p ./morankai-chs/ice-dicts/
# cp -a ./morankai-cht/moran_fixed.dict.yaml ./schema/morankai_fixed.dict.yaml
# cp -a ./morankai-cht/moran_fixed_simp.dict.yaml ./schema/morankai_fixed_simp.dict.yaml
cp -a ./schema/default.custom.morankai.yaml ./morankai-cht/default.custom.yaml
cp -a ./schema/default.custom.morankai.yaml ./morankai-chs/default.custom.yaml

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
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_41448.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/base.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_base.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/others.dict.yaml  -o ../morankai-cht/ice-dicts/morankai_zrmdb_others.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -t -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../morankai-cht/ice-dicts/morankai_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
# python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_41448.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/base.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_base.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/others.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_others.dict.yaml
python3 gen_dict_with_shape.py -p morankai -x zrmdb -s -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../morankai-chs/ice-dicts/morankai_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./morankai-chs
cp ./rime-radical-pinyin/radical.schema.yaml ./morankai-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./morankai-cht
sed '/\.\.\./q' ./morankai-cht/radical_flypy.dict.yaml > ./morankai-cht/radical_flypy.dict.yaml.bak
python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./morankai-cht/moran.chars.dict.yaml
echo "" >> ./morankai-cht/radical_flypy.dict.yaml.bak
cat temp.txt >> ./morankai-cht/radical_flypy.dict.yaml.bak
mv ./morankai-cht/radical_flypy.dict.yaml{.bak,}
cp ./morankai-cht/radical_flypy.dict.yaml ./morankai-chs

rm -f temp.txt
rm -f ./morankai-cht/temp.txt
rm -f ./morankai-chs/temp.txt

echo morankai繁體設定檔...
cd morankai-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/morankai_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/morankai_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml morankai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: morankai/g" ./morankai.schema.yaml
sed -i "s/^  name: 魔然$/  name: morankai/g" ./morankai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    morankai = moran + zrm + moranshape + ice/g" ./morankai.schema.yaml
sed -i "s/^    - moran_fixed$/    - morankai_fixed/g" ./morankai.schema.yaml
sed -i "s/^    - moran_sentence$/    - morankai_sentence/g" ./morankai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./morankai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./morankai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./morankai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./morankai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./morankai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./morankai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./morankai.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./morankai.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./morankai.schema.yaml

cp moran_aux.schema.yaml morankai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: morankai_aux/g" ./morankai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: morankai輔篩/g" ./morankai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「morankai」方案不同。/g" ./morankai_aux.schema.yaml

cp moran_bj.schema.yaml morankai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: morankai_bj/g" ./morankai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: morankai並擊/g" ./morankai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    morankai = moran + zrm + moranshape + ice/g" ./morankai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - morankai_fixed/g" ./morankai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - morankai_sentence/g" ./morankai_bj.schema.yaml

cp moran_fixed.schema.yaml morankai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: morankai_fixed/g" ./morankai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: morankai字詞/g" ./morankai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_fixed.schema.yaml

cp moran_sentence.schema.yaml morankai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: morankai_sentence/g" ./morankai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: morankai整句/g" ./morankai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_sentence.schema.yaml
cd ..

echo morankai简体設定檔...
cd morankai-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/morankai_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/morankai_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/morankai_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml morankai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: morankai/g" ./morankai.schema.yaml
sed -i "s/^  name: 魔然$/  name: morankai/g" ./morankai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    morankai = moran + zrm + moranshape + ice/g" ./morankai.schema.yaml
sed -i "s/^    - moran_fixed$/    - morankai_fixed/g" ./morankai.schema.yaml
sed -i "s/^    - moran_sentence$/    - morankai_sentence/g" ./morankai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./morankai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./morankai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./morankai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./morankai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./morankai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./morankai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./morankai.schema.yaml
sed -i "s/  alphabet: abcdefghijklmnopqrstuvwxyz/  alphabet: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/g" ./morankai.schema.yaml
sed -i "s/\( - moran:\/key_bindings\/moran_capital_for_last_syllable\)/#\1/g" ./morankai.schema.yaml

cp moran_aux.schema.yaml morankai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: morankai_aux/g" ./morankai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: morankai輔篩/g" ./morankai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「morankai」方案不同。/g" ./morankai_aux.schema.yaml

cp moran_bj.schema.yaml morankai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: morankai_bj/g" ./morankai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: morankai並擊/g" ./morankai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    morankai = moran + zrm + moranshape + ice/g" ./morankai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - morankai_fixed/g" ./morankai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - morankai_sentence/g" ./morankai_bj.schema.yaml

cp moran_fixed.schema.yaml morankai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: morankai_fixed/g" ./morankai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: morankai字詞/g" ./morankai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_fixed.schema.yaml

cp moran_sentence.schema.yaml morankai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: morankai_sentence/g" ./morankai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: morankai整句/g" ./morankai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./morankai_sentence.schema.yaml
cd ..
