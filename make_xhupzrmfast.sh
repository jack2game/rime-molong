#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf xhupzrmfast-chs
rm -rf xhupzrmfast-cht

# 生成繁體
cp -a ./rime-moran/. ./xhupzrmfast-cht

rm -rf ./xhupzrmfast-cht/.git
rm -rf ./xhupzrmfast-cht/.gitignore
rm -rf ./xhupzrmfast-cht/README.md
rm -rf ./xhupzrmfast-cht/README-en.md
rm -rf ./xhupzrmfast-cht/.github/
perl -CSAD -i -pe 's/(^.*ZRM-SPECIFIC)/# $1/' ./xhupzrmfast-cht/moran.yaml
# mv ./xhupzrmfast-cht/key_bindings.yaml ./schema
# mv ./xhupzrmfast-cht/punctuation.yaml ./schema
# cp ./rime-shuangpin-fuzhuma/opencc/moqi_chaifen.txt ./xhupzrmfast-cht/opencc/moran_chaifen.txt
# sed -i -E 's/^(\S+)\t(\S+)\t(.+)$/\1\t〔\3\2〕/' ./xhupzrmfast-cht/opencc/moran_chaifen.txt
# cp ./rime-shuangpin-fuzhuma/moqima8105.txt ./tools-additional/zrmfastdb.txt
# perl -CSAD -i -pe 's/(.\t[a-z]{2})\t.*/$1/' ./tools-additional/zrmfastdb.txt

# 生成簡體
cd ./xhupzrmfast-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a.*/cp -a .\/dist\/. ..\/xhupzrmfast-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# 轉換詞庫
cd ./tools-additional
# 轉換繁体詞庫
echo 轉換繁体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupzrmfast-cht/moran.chars.dict.yaml > ../xhupzrmfast-cht/moran.chars.dict.yaml.bak
mv ../xhupzrmfast-cht/moran.chars.dict.yaml{.bak,} && perl -CSAD -i -pe "s/([a-z]{2});[a-z]{2}/\1/g" ../xhupzrmfast-cht/moran.chars.dict.yaml
sed '/\.\.\./q' ../xhupzrmfast-cht/moran.chars.dict.yaml > ../xhupzrmfast-cht/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p static -x zrmfastdb -i ../xhupzrmfast-cht/moran.chars.dict.yaml -o ../xhupzrmfast-cht/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhupzrmfast-cht/temp.txt && sed -i '0,/\.\.\./d' ../xhupzrmfast-cht/temp.txt
awk 'NF >= 2 && /^[^\s]+\t[^\s]+/ && !seen[$1 FS $2]++ {print $0}' ../xhupzrmfast-cht/temp.txt > temp && mv temp ../xhupzrmfast-cht/temp.txt
echo "" >> ../xhupzrmfast-cht/moran.chars.dict.yaml.bak && cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhupzrmfast-cht/moran.base.dict.yaml > ../xhupzrmfast-cht/moran.base.dict.yaml.bak
cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupzrmfast-cht/ice.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhupzrmfast-cht/ice.base.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../xhupzrmfast-cht/ice.base.dict.yaml -o ../xhupzrmfast-cht/temp.txt
# echo "" >> ../xhupzrmfast-cht/moran.base.dict.yaml.bak
cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran.base.dict.yaml.bak
rm ../xhupzrmfast-cht/ice.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-cht/moran.tencent.dict.yaml > ../../xhupzrmfast-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-cht/moran.moe.dict.yaml > ../../xhupzrmfast-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-cht/moran.computer.dict.yaml > ../../xhupzrmfast-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-cht/moran.hanyu.dict.yaml > ../../xhupzrmfast-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-cht/moran.words.dict.yaml > ../../xhupzrmfast-cht/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupzrmfast-cht/zrlf.dict.yaml -o ../xhupzrmfast-cht/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupzrmfast-cht/moran_fixed.dict.yaml > ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupzrmfast.simpchars.txt ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt && opencc -i ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt -o ../xhupzrmfast-cht/temp.txt -c s2t
echo "" >> ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak
cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhup.simpwords.txt -o ../xhupzrmfast-cht/temp.txt -c s2t
echo ""  >> ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak && cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhupzrmfast-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhupzrmfast-cht/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupzrmfast-cht/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhupzrmfast-cht/moran_fixed.dict.yaml >> ../xhupzrmfast-cht/moran_fixed.dict.yaml.bak
rm ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt

sed '/#----------词库----------#/q' ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml > ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupzrmfast.simpchars.txt ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt && cp ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt ../xhupzrmfast-cht/temp.txt
echo "" >> ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak
cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhup.simpwords.txt ../xhupzrmfast-cht/temp.txt
echo "" >> ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak && cat ../xhupzrmfast-cht/temp.txt >> ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml >> ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml.bak
rm ../xhupzrmfast-cht/xhupzrmfast.simpchars.txt

mv ../xhupzrmfast-cht/moran.chars.dict.yaml{.bak,}
mv ../xhupzrmfast-cht/moran.base.dict.yaml{.bak,}
# mv ../xhupzrmfast-cht/moran.tencent.dict.yaml{.bak,}
# mv ../xhupzrmfast-cht/moran.moe.dict.yaml{.bak,}
# mv ../xhupzrmfast-cht/moran.computer.dict.yaml{.bak,}
# mv ../xhupzrmfast-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../xhupzrmfast-cht/moran.words.dict.yaml{.bak,}
mv ../xhupzrmfast-cht/moran_fixed.dict.yaml{.bak,}
mv ../xhupzrmfast-cht/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupzrmfast-cht/zrlf.dict.yaml{.bak,}

# 轉換简体詞庫
echo 轉換简体詞庫...
python3 ../rime-moran/tools/schemagen.py convert-sp --to=flypy --rime-dict=../xhupzrmfast-chs/moran.chars.dict.yaml > ../xhupzrmfast-chs/moran.chars.dict.yaml.bak
mv ../xhupzrmfast-chs/moran.chars.dict.yaml{.bak,} && perl -CSAD -i -pe "s/([a-z]{2});[a-z]{2}/\1/g" ../xhupzrmfast-chs/moran.chars.dict.yaml
sed '/\.\.\./q' ../xhupzrmfast-chs/moran.chars.dict.yaml > ../xhupzrmfast-chs/moran.chars.dict.yaml.bak
python3 gen_dict_with_shape.py -p static -x zrmfastdb -i ../xhupzrmfast-chs/moran.chars.dict.yaml -o ../xhupzrmfast-chs/temp.txt
perl -CSAD -i -pe "s/(.*);;/\1/g" ../xhupzrmfast-chs/temp.txt && sed -i '0,/\.\.\./d' ../xhupzrmfast-chs/temp.txt
awk 'NF >= 2 && /^[^\s]+\t[^\s]+/ && !seen[$1 FS $2]++ {print $0}' ../xhupzrmfast-chs/temp.txt > temp && mv temp ../xhupzrmfast-chs/temp.txt
echo "" >> ../xhupzrmfast-chs/moran.chars.dict.yaml.bak && cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran.chars.dict.yaml.bak

sed '/\.\.\./q' ../xhupzrmfast-chs/moran.base.dict.yaml > ../xhupzrmfast-chs/moran.base.dict.yaml.bak
cp ../rime-ice/cn_dicts/base.dict.yaml ../xhupzrmfast-chs/ice.base.dict.yaml
sed -i '0,/\.\.\./d' ../xhupzrmfast-chs/ice.base.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../xhupzrmfast-chs/ice.base.dict.yaml -o ../xhupzrmfast-chs/temp.txt
# echo "" >> ../xhupzrmfast-chs/moran.base.dict.yaml.bak
cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran.base.dict.yaml.bak
rm ../xhupzrmfast-chs/ice.base.dict.yaml

# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-chs/moran.tencent.dict.yaml > ../../xhupzrmfast-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-chs/moran.moe.dict.yaml > ../../xhupzrmfast-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-chs/moran.computer.dict.yaml > ../../xhupzrmfast-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-chs/moran.hanyu.dict.yaml > ../../xhupzrmfast-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../xhupzrmfast-chs/moran.words.dict.yaml > ../../xhupzrmfast-chs/moran.words.dict.yaml.bak
python3 convert_sp.py -i ../xhupzrmfast-chs/zrlf.dict.yaml -o ../xhupzrmfast-chs/zrlf.dict.yaml.bak

sed '/#----------詞庫----------#/q' ../xhupzrmfast-chs/moran_fixed.dict.yaml > ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupzrmfast.simpchars.txt ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt && opencc -i ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt -o ../xhupzrmfast-chs/temp.txt -c s2t
echo "" >> ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak
cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak
opencc -i ../data/assess.tiger-code.com/xhup.simpwords.txt -o ../xhupzrmfast-chs/temp.txt -c s2t
echo "" >> ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak && cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhupzrmfast-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhupzrmfast-chs/moran_fixed.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupzrmfast-chs/moran_fixed.dict.yaml
sed '0,/#----------詞庫----------#/d' ../xhupzrmfast-chs/moran_fixed.dict.yaml >> ../xhupzrmfast-chs/moran_fixed.dict.yaml.bak
rm ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt

sed '/#----------词库----------#/q' ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml > ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhupzrmfast.simpchars.txt ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt && cp ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt ../xhupzrmfast-chs/temp.txt
echo "" >> ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak
cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak
cp ../data/assess.tiger-code.com/xhup.simpwords.txt ../xhupzrmfast-chs/temp.txt
echo "" >> ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak && cat ../xhupzrmfast-chs/temp.txt >> ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{1}\t[A-Za-z]+.*\n//g" ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{3}\t[A-Za-z]{4}+\n//g" ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml
perl -CSAD -i -pe "s/^[\x{4e00}-\x{9fa5}\x{3007}\x{ff0c}-\x{ffee}]{2}\t[A-Za-z]{3,4}+\n//g" ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml
sed '0,/#----------词库----------#/d' ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml >> ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml.bak
rm ../xhupzrmfast-chs/xhupzrmfast.simpchars.txt

mv ../xhupzrmfast-chs/moran.chars.dict.yaml{.bak,}
mv ../xhupzrmfast-chs/moran.base.dict.yaml{.bak,}
# mv ../xhupzrmfast-chs/moran.tencent.dict.yaml{.bak,}
# mv ../xhupzrmfast-chs/moran.moe.dict.yaml{.bak,}
# mv ../xhupzrmfast-chs/moran.computer.dict.yaml{.bak,}
# mv ../xhupzrmfast-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../xhupzrmfast-chs/moran.words.dict.yaml{.bak,}
mv ../xhupzrmfast-chs/moran_fixed.dict.yaml{.bak,}
mv ../xhupzrmfast-chs/moran_fixed_simp.dict.yaml{.bak,}
mv ../xhupzrmfast-chs/zrlf.dict.yaml{.bak,}
cd ..

# 整理文件結構
rm -rf ./xhupzrmfast-cht/tools
rm -rf ./xhupzrmfast-cht/make_simp_dist.sh
mkdir -p ./xhupzrmfast-cht/ice-dicts/
mkdir -p ./xhupzrmfast-chs/ice-dicts/
# cp -a ./xhupzrmfast-cht/moran_fixed.dict.yaml ./schema/xhupzrmfast_fixed.dict.yaml
# cp -a ./xhupzrmfast-cht/moran_fixed_simp.dict.yaml ./schema/xhupzrmfast_fixed_simp.dict.yaml
cp -a ./schema/default.custom.xhupzrmfast.yaml ./xhupzrmfast-cht/default.custom.yaml
cp -a ./schema/default.custom.xhupzrmfast.yaml ./xhupzrmfast-chs/default.custom.yaml

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
# python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/others.dict.yaml  -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -t -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupzrmfast-cht/ice-dicts/xhupzrmfast_zrmfastdb_tencent.dict.yaml
# 生成簡體霧凇
# python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/8105.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_8105.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/41448.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/base.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_base.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/ext.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_ext.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/others.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_others.dict.yaml
python3 gen_dict_with_shape.py -p xhupzrmfast -x zrmfastdb -s -i ../rime-ice/cn_dicts/tencent.dict.yaml -o ../xhupzrmfast-chs/ice-dicts/xhupzrmfast_zrmfastdb_tencent.dict.yaml
cd ..

# 生成ocz
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupzrmfast-cht
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupzrmfast-cht
# cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupzrmfast-cht
# sed '/\.\.\./q' ./xhupzrmfast-cht/radical_flypy.dict.yaml > ./xhupzrmfast-cht/radical_flypy.dict.yaml.bak
# python3 ./tools-additional/prepare_chaizi.py -i ./chaizi-re/radical.yaml -o temp.txt -c ./xhupzrmfast-cht/moran.chars.dict.yaml
# echo "" >> ./xhupzrmfast-cht/radical_flypy.dict.yaml.bak
# cat temp.txt >> ./xhupzrmfast-cht/radical_flypy.dict.yaml.bak
cp ./rime-radical-pinyin/radical.schema.yaml ./xhupzrmfast-chs
cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./xhupzrmfast-chs

rm -f temp.txt
rm -f ./xhupzrmfast-cht/temp.txt
rm -f ./xhupzrmfast-chs/temp.txt

echo xhupzrmfast繁體設定檔...
cd xhupzrmfast-cht
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml && sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupzrmfast_zrmfastdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupzrmfast_zrmfastdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupzrmfast.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupzrmfast/g" ./xhupzrmfast.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupzrmfast/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupzrmfast = moran + xhup + moqi + ice/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupzrmfast_fixed/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupzrmfast_sentence/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupzrmfast.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupzrmfast.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupzrmfast.schema.yaml

cp moran_aux.schema.yaml xhupzrmfast_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupzrmfast_aux/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupzrmfast輔篩/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupzrmfast」方案不同。/g" ./xhupzrmfast_aux.schema.yaml

cp moran_bj.schema.yaml xhupzrmfast_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupzrmfast_bj/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupzrmfast並擊/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupzrmfast = moran + xhup + moqi + ice/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupzrmfast_fixed/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupzrmfast_sentence/g" ./xhupzrmfast_bj.schema.yaml

cp moran_fixed.schema.yaml xhupzrmfast_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupzrmfast_fixed/g" ./xhupzrmfast_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupzrmfast字詞/g" ./xhupzrmfast_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupzrmfast_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupzrmfast_sentence/g" ./xhupzrmfast_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupzrmfast整句/g" ./xhupzrmfast_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_sentence.schema.yaml
cd ..

echo xhupzrmfast简体設定檔...
cd xhupzrmfast-chs
cp recipe.yaml recipe.yaml.bak
sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml
rm recipe.yaml.bak

cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.tencent\)/# \1/g" ./moran.extended.dict.yaml && sed -i "s/\(  - moran\.moe\)/# \1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  - ice-dicts\/xhupzrmfast_zrmfastdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupzrmfast_zrmfastdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
sed -i "s/\(  - moran\.words  \)/  # - ice-dicts\/xhupzrmfast_zrmfastdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml
rm moran.extended.dict.yaml.bak

cp moran.schema.yaml xhupzrmfast.schema.yaml
sed -i "s/^  schema_id: moran$/  schema_id: xhupzrmfast/g" ./xhupzrmfast.schema.yaml
sed -i "s/^  name: 魔然$/  name: xhupzrmfast/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupzrmfast = moran + xhup + moqi + ice/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupzrmfast_fixed/g" ./xhupzrmfast.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupzrmfast_sentence/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./xhupzrmfast.schema.yaml
sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./xhupzrmfast.schema.yaml
sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./xhupzrmfast.schema.yaml
sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./xhupzrmfast.schema.yaml

cp moran_aux.schema.yaml xhupzrmfast_aux.schema.yaml
sed -i "s/^  schema_id: moran_aux$/  schema_id: xhupzrmfast_aux/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^  name: 魔然·輔篩$/  name: xhupzrmfast輔篩/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_aux.schema.yaml
sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「xhupzrmfast」方案不同。/g" ./xhupzrmfast_aux.schema.yaml

cp moran_bj.schema.yaml xhupzrmfast_bj.schema.yaml
sed -i "s/^  schema_id: moran_bj$/  schema_id: xhupzrmfast_bj/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^  name: 魔然·並擊G$/  name: xhupzrmfast並擊/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    xhupzrmfast = moran + xhup + moqi + ice/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    - moran_fixed$/    - xhupzrmfast_fixed/g" ./xhupzrmfast_bj.schema.yaml
sed -i "s/^    - moran_sentence$/    - xhupzrmfast_sentence/g" ./xhupzrmfast_bj.schema.yaml

cp moran_fixed.schema.yaml xhupzrmfast_fixed.schema.yaml
sed -i "s/^  schema_id: moran_fixed$/  schema_id: xhupzrmfast_fixed/g" ./xhupzrmfast_fixed.schema.yaml
sed -i "s/^  name: 魔然·字詞$/  name: xhupzrmfast字詞/g" ./xhupzrmfast_fixed.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_fixed.schema.yaml

cp moran_sentence.schema.yaml xhupzrmfast_sentence.schema.yaml
sed -i "s/^  schema_id: moran_sentence$/  schema_id: xhupzrmfast_sentence/g" ./xhupzrmfast_sentence.schema.yaml
sed -i "s/^  name: 魔然·整句$/  name: xhupzrmfast整句/g" ./xhupzrmfast_sentence.schema.yaml
sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./xhupzrmfast_sentence.schema.yaml
cd ..
