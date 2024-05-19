#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhupkai-chs
rm -rf xhupkai-cht

# 生成繁體
cp -a ./rime-moran/. ./xhupkai-cht

rm -rf ./xhupkai-cht/.git
rm -rf ./xhupkai-cht/.gitignore
rm -rf ./xhupkai-cht/README.md
rm -rf ./xhupkai-cht/README-en.md
rm -rf ./xhupkai-cht/.github/
# mv ./xhupkai-cht/default.yaml ./schema
# mv ./xhupkai-cht/key_bindings.yaml ./schema
# mv ./xhupkai-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./tools-additional
sed -i 's/ /\t/g' ./tools-additional/zrmdb.txt

# 生成簡體
cd ./xhupkai-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhupkai-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.chars.dict.yaml > ../xhupkai-cht/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupkai-cht/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../xhupkai-cht/temp.txt && sed -i '0,/\.\.\./d' ../xhupkai-cht/temp.txt
# echo "" >> ../xhupkai-cht/moran.chars.dict.yaml.bak && cat ../xhupkai-cht/temp.txt >> ../xhupkai-cht/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupkai-cht/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../xhupkai-cht/temp.txt && sed -i '0,/\.\.\./d' ../xhupkai-cht/temp.txt
# echo "" >> ../xhupkai-cht/moran.chars.dict.yaml.bak && cat ../xhupkai-cht/temp.txt >> ../xhupkai-cht/moran.chars.dict.yaml.bak

python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.base.dict.yaml > ../xhupkai-cht/moran.base.dict.yaml.bak
# cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupkai-cht/ice.base.dict.yaml
# sed -i '0,/\.\.\./d' ../xhupkai-cht/ice.base.dict.yaml
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../xhupkai-cht/ice.base.dict.yaml -o ../xhupkai-cht/temp.txt
# echo "" >> ../xhupkai-cht/moran.base.dict.yaml.bak
# cat ../xhupkai-cht/temp.txt >> ../xhupkai-cht/moran.base.dict.yaml.bak
# rm ../xhupkai-cht/ice.base.dict.yaml

python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.tencent.dict.yaml > ../xhupkai-cht/moran.tencent.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.moe.dict.yaml > ../xhupkai-cht/moran.moe.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.computer.dict.yaml > ../xhupkai-cht/moran.computer.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.hanyu.dict.yaml > ../xhupkai-cht/moran.hanyu.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-cht/moran.words.dict.yaml > ../xhupkai-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupkai-cht/zrlf.dict.yaml -o ../xhupkai-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupkai-cht/moran_fixed.dict.yaml > ../xhupkai-cht/moran_fixed.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../xhupkai-cht/moran_fixed.dict.yaml > ../xhupkai-cht/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../xhupkai-cht/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../xhupkai-cht/temp.txt
sed -i '0,/#----------詞庫----------#/d' ../xhupkai-cht/temp.txt  &&  echo "" >> ../xhupkai-cht/moran_fixed.dict.yaml.bak
cat ../xhupkai-cht/temp.txt >> ../xhupkai-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../xhupkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../xhupkai-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupkai-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhupkai-cht/moran_fixed.dict.yaml >> ../xhupkai-cht/moran_fixed.dict.yaml.bak
# rm ../xhupkai-cht/xhupkai.simpchars.txt

sed '/#----------词库----------#/q' ../xhupkai-cht/moran_fixed_simp.dict.yaml > ../xhupkai-cht/moran_fixed_simp.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../xhupkai-cht/moran_fixed_simp.dict.yaml > ../xhupkai-cht/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../xhupkai-cht/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../xhupkai-cht/temp.txt
sed -i '0,/#----------词库----------#/d' ../xhupkai-cht/temp.txt  &&  echo "" >> ../xhupkai-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhupkai-cht/temp.txt >> ../xhupkai-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../xhupkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../xhupkai-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupkai-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhupkai-cht/moran_fixed_simp.dict.yaml >> ../xhupkai-cht/moran_fixed_simp.dict.yaml.bak
# rm ../xhupkai-cht/xhupkai.simpchars.txt

mv ../xhupkai-cht/moran.chars.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.base.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.tencent.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.moe.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.computer.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.hanyu.dict.yaml{.bak,}
mv ../xhupkai-cht/moran.words.dict.yaml{.bak,}
mv ../xhupkai-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhupkai-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupkai-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.chars.dict.yaml > ../xhupkai-chs/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupkai-chs/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../xhupkai-chs/temp.txt && sed -i '0,/\.\.\./d' ../xhupkai-chs/temp.txt
# echo "" >> ../xhupkai-chs/moran.chars.dict.yaml.bak && cat ../xhupkai-chs/temp.txt >> ../xhupkai-chs/moran.chars.dict.yaml.bak
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupkai-chs/temp.txt
# perl -CSAD -i -pe "s/.\t[a-z]{2};;(\t[0-9]+)?\n//g" ../xhupkai-chs/temp.txt && sed -i '0,/\.\.\./d' ../xhupkai-chs/temp.txt
# echo "" >> ../xhupkai-chs/moran.chars.dict.yaml.bak && cat ../xhupkai-chs/temp.txt >> ../xhupkai-chs/moran.chars.dict.yaml.bak

python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.base.dict.yaml > ../xhupkai-chs/moran.base.dict.yaml.bak
# cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupkai-chs/ice.base.dict.yaml
# sed -i '0,/\.\.\./d' ../xhupkai-chs/ice.base.dict.yaml
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../xhupkai-chs/ice.base.dict.yaml -o ../xhupkai-chs/temp.txt
# echo "" >> ../xhupkai-chs/moran.base.dict.yaml.bak
# cat ../xhupkai-chs/temp.txt >> ../xhupkai-chs/moran.base.dict.yaml.bak
# rm ../xhupkai-chs/ice.base.dict.yaml

python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.tencent.dict.yaml > ../xhupkai-chs/moran.tencent.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.moe.dict.yaml > ../xhupkai-chs/moran.moe.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.computer.dict.yaml > ../xhupkai-chs/moran.computer.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.hanyu.dict.yaml > ../xhupkai-chs/moran.hanyu.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupkai-chs/moran.words.dict.yaml > ../xhupkai-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupkai-chs/zrlf.dict.yaml -o ../xhupkai-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupkai-chs/moran_fixed.dict.yaml > ../xhupkai-chs/moran_fixed.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../xhupkai-chs/moran_fixed.dict.yaml > ../xhupkai-chs/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../xhupkai-chs/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../xhupkai-chs/temp.txt
sed -i '0,/#----------詞庫----------#/d' ../xhupkai-chs/temp.txt  &&  echo "" >> ../xhupkai-chs/moran_fixed.dict.yaml.bak
cat ../xhupkai-chs/temp.txt >> ../xhupkai-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../xhupkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../xhupkai-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupkai-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhupkai-chs/moran_fixed.dict.yaml >> ../xhupkai-chs/moran_fixed.dict.yaml.bak
# rm ../xhupkai-chs/xhupkai.simpchars.txt

sed '/#----------词库----------#/q' ../xhupkai-chs/moran_fixed_simp.dict.yaml > ../xhupkai-chs/moran_fixed_simp.dict.yaml.bak
python3 ../rime-moran/tools/schemagen.py convert-fixed-sp --to=flypy --rime-dict=../xhupkai-chs/moran_fixed_simp.dict.yaml > ../xhupkai-chs/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2,100}\t[A-Za-z]+.*\n//g" ../xhupkai-chs/temp.txt
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]{4}.*\n//g" ../xhupkai-chs/temp.txt
sed -i '0,/#----------词库----------#/d' ../xhupkai-chs/temp.txt  &&  echo "" >> ../xhupkai-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhupkai-chs/temp.txt >> ../xhupkai-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{1}\t[A-Za-z]+.*\n//g" ../xhupkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{3}\t[A-Za-z]{4}+\n//g" ../xhupkai-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}a-zA-Z0-9]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupkai-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhupkai-chs/moran_fixed_simp.dict.yaml >> ../xhupkai-chs/moran_fixed_simp.dict.yaml.bak
# rm ../xhupkai-chs/xhupkai.simpchars.txt

mv ../xhupkai-chs/moran.chars.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.base.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.tencent.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.moe.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.computer.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.hanyu.dict.yaml{.bak,}
mv ../xhupkai-chs/moran.words.dict.yaml{.bak,}
mv ../xhupkai-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhupkai-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupkai-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhupkai-cht/tools
rm -rf ./xhupkai-cht/make_simp_dist.sh
mkdir -p ./xhupkai-cht/ice-dicts/
mkdir -p ./xhupkai-chs/ice-dicts/
# cp -a ./xhupkai-cht/moran_fixed.dict.yaml ./schema/xhupkai_fixed.dict.yaml
# cp -a ./xhupkai-cht/moran_fixed_simp.dict.yaml ./schema/xhupkai_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhupkai.yaml ./xhupkai-cht/default.custom.yaml
cp -a ./schema/default.custom.xhupkai.yaml ./xhupkai-chs/default.custom.yaml

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
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_41448.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/others.dict.yaml  -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -t -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupkai-cht/ice-dicts/xhupkai_zrmdb_tencent.dict.yaml
# 生成簡體霧凇
# python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_41448.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/others.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupkai -x zrmdb -s -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupkai-chs/ice-dicts/xhupkai_zrmdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupkai-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupkai-cht
# cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupkai-cht
# sed '/\.\.\./q' ./xhupkai-cht/radical_flypy.dict.yaml > ./xhupkai-cht/radical_flypy.dict.yaml.bak
# python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhupkai-cht/moran.chars.dict.yaml
# echo "" >> ./xhupkai-cht/radical_flypy.dict.yaml.bak
# cat temp.txt >> ./xhupkai-cht/radical_flypy.dict.yaml.bak
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupkai-chs
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupkai-chs

rm -f temp.txt
rm -f ./xhupkai-cht/temp.txt
rm -f ./xhupkai-chs/temp.txt

echo xhupkai繁體設定檔...
cd xhupkai-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml && 
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupkai/g" ./xhupkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupkai/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupkai = moran + xhup + moranshape + ice/g" ./xhupkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupkai_fixed/g" ./xhupkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupkai_sentence/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupkai.schema.yaml

cp moran_aux.schema.yaml xhupkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupkai_aux/g" ./xhupkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupkai輔篩/g" ./xhupkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupkai」方案不同。/g" ./xhupkai_aux.schema.yaml

cp moran_bj.schema.yaml xhupkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupkai_bj/g" ./xhupkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupkai並擊/g" ./xhupkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupkai = moran + xhup + moranshape + ice/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupkai_fixed/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupkai_sentence/g" ./xhupkai_bj.schema.yaml

cp moran_fixed.schema.yaml xhupkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupkai_fixed/g" ./xhupkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupkai字詞/g" ./xhupkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupkai_sentence/g" ./xhupkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupkai整句/g" ./xhupkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_sentence.schema.yaml
cd ..

echo xhupkai简体設定檔...
cd xhupkai-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupkai.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupkai/g" ./xhupkai.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupkai/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupkai = moran + xhup + moranshape + ice/g" ./xhupkai.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupkai_fixed/g" ./xhupkai.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupkai_sentence/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupkai.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupkai.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupkai.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupkai.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupkai.schema.yaml

cp moran_aux.schema.yaml xhupkai_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupkai_aux/g" ./xhupkai_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupkai輔篩/g" ./xhupkai_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupkai」方案不同。/g" ./xhupkai_aux.schema.yaml

cp moran_bj.schema.yaml xhupkai_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupkai_bj/g" ./xhupkai_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupkai並擊/g" ./xhupkai_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupkai = moran + xhup + moranshape + ice/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupkai_fixed/g" ./xhupkai_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupkai_sentence/g" ./xhupkai_bj.schema.yaml

cp moran_fixed.schema.yaml xhupkai_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupkai_fixed/g" ./xhupkai_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupkai字詞/g" ./xhupkai_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupkai_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupkai_sentence/g" ./xhupkai_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupkai整句/g" ./xhupkai_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupkai_sentence.schema.yaml
cd ..
