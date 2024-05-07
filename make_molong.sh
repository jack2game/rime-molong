#!/bin/bash

set -e
set -x

# BUILD_TYPE="$1"

rm -rf molong-chs
rm -rf molong-cht

# 生成繁體
cp -a ./rime-moran/. ./molong-cht
# cp ./rime-radical-pinyin/radical.schema.yaml ./molong-cht
# cp ./rime-radical-pinyin/radical_flypy.dict.yaml ./molong-cht

rm -rf ./molong-cht/.git
rm -rf ./molong-cht/.gitignore
rm -rf ./molong-cht/README.md
rm -rf ./molong-cht/README-en.md
rm -rf ./molong-cht/.github/
mv ./molong-cht/default.yaml ./schema
mv ./molong-cht/key_bindings.yaml ./schema
mv ./molong-cht/punctuation.yaml ./schema


cp ./rime-moran/tools/data/zrmdb.txt ./rime-moflice/tools-additional
sed -i 's/ /\t/g' ./rime-moflice/tools-additional/zrmdb.txt

# 生成簡體
cd ./molong-cht/
sed -i "s/^git archive HEAD -o archive.tar/tar -cvf archive.tar .\//g" ./make_simp_dist.sh
sed -i "s/^cp 下载与安装说明/# cp 下载与安装说明/g" ./make_simp_dist.sh
sed -i "s/^sedi 's\/MORAN_VARIANT\/简体\/'/# sedi 's\/MORAN_VARIANT\/简体\/'/g" ./make_simp_dist.sh
sed -i 's/^7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "MoranSimplified-$(date +%Y%m%d).7z" dist/cp -a .\/dist\/. ..\/molong-chs/g' ./make_simp_dist.sh
bash -x ./make_simp_dist.sh
cd ..

# # 轉換詞庫
# cd ./rime-moran/tools
# # 轉換繁体詞庫
# echo 轉換繁体詞庫...
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.chars.dict.yaml > ../../molong-cht/moran.chars.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.base.dict.yaml > ../../molong-cht/moran.base.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.tencent.dict.yaml > ../../molong-cht/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.moe.dict.yaml > ../../molong-cht/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.computer.dict.yaml > ../../molong-cht/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.hanyu.dict.yaml > ../../molong-cht/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-cht/moran.words.dict.yaml > ../../molong-cht/moran.words.dict.yaml.bak
# python3 schemagen.py convert-fixed-sp --to=flypy --rime-dict=../../molong-cht/moran_fixed.dict.yaml > ../../molong-cht/moran_fixed.dict.yaml.bak
# python3 schemagen.py convert-fixed-sp --to=flypy --rime-dict=../../molong-cht/moran_fixed_simp.dict.yaml > ../../molong-cht/moran_fixed_simp.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../molong-cht/zrlf.dict.yaml -o ../../molong-cht/zrlf.dict.yaml.bak
# mv ../../molong-cht/moran.chars.dict.yaml{.bak,}
# mv ../../molong-cht/moran.computer.dict.yaml{.bak,}
# mv ../../molong-cht/moran.base.dict.yaml{.bak,}
# mv ../../molong-cht/moran.hanyu.dict.yaml{.bak,}
# mv ../../molong-cht/moran.moe.dict.yaml{.bak,}
# mv ../../molong-cht/moran.tencent.dict.yaml{.bak,}
# mv ../../molong-cht/moran.words.dict.yaml{.bak,}
# mv ../../molong-cht/moran_fixed.dict.yaml{.bak,}
# mv ../../molong-cht/moran_fixed_simp.dict.yaml{.bak,}
# mv ../../molong-cht/zrlf.dict.yaml{.bak,}
# # 轉換简体詞庫
# echo 轉換简体詞庫...
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.chars.dict.yaml > ../../molong-chs/moran.chars.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.base.dict.yaml > ../../molong-chs/moran.base.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.tencent.dict.yaml > ../../molong-chs/moran.tencent.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.moe.dict.yaml > ../../molong-chs/moran.moe.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.computer.dict.yaml > ../../molong-chs/moran.computer.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.hanyu.dict.yaml > ../../molong-chs/moran.hanyu.dict.yaml.bak
# python3 schemagen.py convert-sp --to=flypy --rime-dict=../../molong-chs/moran.words.dict.yaml > ../../molong-chs/moran.words.dict.yaml.bak
# python3 schemagen.py convert-fixed-sp --to=flypy --rime-dict=../../molong-chs/moran_fixed.dict.yaml > ../../molong-chs/moran_fixed.dict.yaml.bak
# python3 schemagen.py convert-fixed-sp --to=flypy --rime-dict=../../molong-chs/moran_fixed_simp.dict.yaml > ../../molong-chs/moran_fixed_simp.dict.yaml.bak
# python3 ../../tools-additional/convert_sp.py -i ../../molong-chs/zrlf.dict.yaml -o ../../molong-chs/zrlf.dict.yaml.bak
# mv ../../molong-chs/moran.chars.dict.yaml{.bak,}
# mv ../../molong-chs/moran.computer.dict.yaml{.bak,}
# mv ../../molong-chs/moran.base.dict.yaml{.bak,}
# mv ../../molong-chs/moran.hanyu.dict.yaml{.bak,}
# mv ../../molong-chs/moran.moe.dict.yaml{.bak,}
# mv ../../molong-chs/moran.tencent.dict.yaml{.bak,}
# mv ../../molong-chs/moran.words.dict.yaml{.bak,}
# mv ../../molong-chs/moran_fixed.dict.yaml{.bak,}
# mv ../../molong-chs/moran_fixed_simp.dict.yaml{.bak,}
# mv ../../molong-chs/zrlf.dict.yaml{.bak,}
# cd ..
# cd ..

# 整理文件結構
rm -rf ./molong-cht/tools
rm -rf ./molong-cht/make_simp_dist.sh
mkdir -p ./molong-cht/ice-dicts/
mkdir -p ./molong-chs/ice-dicts/
# cp -a ./schema/moran_fixed.dict.yaml ./molong-cht
# cp -a ./schema/moran_fixed.dict.yaml ./molong-chs
# cp -a ./schema/moran_fixed_simp.dict.yaml ./molong-cht
# cp -a ./schema/moran_fixed_simp.dict.yaml ./molong-chs
# cp -a ./schema/default.custom.yaml ./molong-cht
# cp -a ./schema/default.custom.yaml ./molong-chs

# cd ./tools-additional
# # 生成繁體霧凇
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/8105.dict.yaml    -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/41448.dict.yaml   -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/base.dict.yaml    -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/ext.dict.yaml     -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/others.dict.yaml  -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/tencent.dict.yaml -x zrmdb -t -o ../molong-cht/ice-dicts/flypy_zrmdb_tencent.dict.yaml
# # 生成簡體霧凇
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/8105.dict.yaml    -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_8105.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/41448.dict.yaml   -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_41448.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/base.dict.yaml    -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_base.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/ext.dict.yaml     -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_ext.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/others.dict.yaml  -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_others.dict.yaml
# python3 gen_dict_with_shape.py -i ../rime-ice/cn_dicts/tencent.dict.yaml -x zrmdb -o ../molong-chs/ice-dicts/flypy_zrmdb_tencent.dict.yaml
# cd ..

# echo molong繁體設定檔...
# cd molong-cht
# cp recipe.yaml recipe.yaml.bak
# sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml

# cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml

# cp moran.schema.yaml molong.schema.yaml
# sed -i "s/^  schema_id: moran$/  schema_id: molong/g" ./molong.schema.yaml
# sed -i "s/^  name: 魔然$/  name: molong/g" ./molong.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = Moran + Flypy + Ice/g" ./molong.schema.yaml
# sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong.schema.yaml
# sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong.schema.yaml
# sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molong.schema.yaml
# sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molong.schema.yaml
# sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molong.schema.yaml
# sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molong.schema.yaml
# sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molong.schema.yaml
# sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molong.schema.yaml
# sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molong.schema.yaml

# cp moran_aux.schema.yaml molong_aux.schema.yaml
# sed -i "s/^  schema_id: moran_aux$/  schema_id: molong_aux/g" ./molong_aux.schema.yaml
# sed -i "s/^  name: 魔然·輔篩$/  name: molong輔篩/g" ./molong_aux.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_aux.schema.yaml
# sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molong」方案不同。/g" ./molong_aux.schema.yaml

# cp moran_bj.schema.yaml molong_bj.schema.yaml
# sed -i "s/^  schema_id: moran_bj$/  schema_id: molong_bj/g" ./molong_bj.schema.yaml
# sed -i "s/^  name: 魔然·並擊G$/  name: molong並擊/g" ./molong_bj.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_bj.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = Moran + Flypy + Ice/g" ./molong_bj.schema.yaml
# sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong_bj.schema.yaml
# sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong_bj.schema.yaml

# cp moran_fixed.schema.yaml molong_fixed.schema.yaml
# sed -i "s/^  schema_id: moran_fixed$/  schema_id: molong_fixed/g" ./molong_fixed.schema.yaml
# sed -i "s/^  name: 魔然·字詞$/  name: molong字詞/g" ./molong_fixed.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_fixed.schema.yaml

# cp moran_sentence.schema.yaml molong_sentence.schema.yaml
# sed -i "s/^  schema_id: moran_sentence$/  schema_id: molong_sentence/g" ./molong_sentence.schema.yaml
# sed -i "s/^  name: 魔然·整句$/  name: molong整句/g" ./molong_sentence.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_sentence.schema.yaml
# cd ..

# echo molong简体設定檔...
# cd molong-chs
# cp recipe.yaml recipe.yaml.bak
# sed -i "s/^\(  zrlf\*\)$/\1\n  radical*/g" ./recipe.yaml

# cp moran.extended.dict.yaml moran.extended.dict.yaml.bak
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_8105      # 8105字表\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_41448     # 41448字表\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_base     # 基础词库\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  - ice-dicts\/flypy_zrmdb_ext      # 扩展词库\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_tencent  # 腾讯词向量（大词库，部署时间较长）\n\1/g" ./moran.extended.dict.yaml
# sed -i "s/\(  - moran\.base  \)/  # - ice-dicts\/flypy_zrmdb_others   # 一些杂项 容错音和错字 可以不开\n\1/g" ./moran.extended.dict.yaml

# cp moran.schema.yaml molong.schema.yaml
# sed -i "s/^  schema_id: moran$/  schema_id: molong/g" ./molong.schema.yaml
# sed -i "s/^  name: 魔然$/  name: molong/g" ./molong.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = Moran + Flypy + Ice/g" ./molong.schema.yaml
# sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong.schema.yaml
# sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong.schema.yaml
# sed -i "s/^\(    - zrlf\)$/\1\n    - radical/g" ./molong.schema.yaml
# sed -i "s/^\(    - reverse_lookup_translator@reverse_zrlf\)$/\1\n    - reverse_lookup_translator@reverse_radical/g" ./molong.schema.yaml
# sed -i "s/^\(reverse_lookup:\)$/reverse_radical:\n  tag: reverse_radical\n  dictionary: radical_flypy\n  enable_completion: true\n  prefix: \"ocz\"\n  tips: 〔拆字〕\n  __include: reverse_format\n\n\1/g" ./molong.schema.yaml
# sed -i "s/^\(    - reverse_zrlf\)$/\1\n    - reverse_radical/g" ./molong.schema.yaml
# sed -i "s/^\(    reverse_zrlf: \"\^olf\[A-Za-z\]\*\$\"\)$/\1\n    reverse_radical: \"^ocz[A-Za-z]*$\"/g" ./molong.schema.yaml
# sed -i 's/\(    - xform\/^o(lf\)/\1|cz/g' ./molong.schema.yaml
# sed -i "s/^  enable_quick_code_hint: false$/  enable_quick_code_hint: true/g" ./molong.schema.yaml

# cp moran_aux.schema.yaml molong_aux.schema.yaml
# sed -i "s/^  schema_id: moran_aux$/  schema_id: molong_aux/g" ./molong_aux.schema.yaml
# sed -i "s/^  name: 魔然·輔篩$/  name: molong輔篩/g" ./molong_aux.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_aux.schema.yaml
# sed -i "s/^    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「魔然」方案不同。$/    在輸入完畢雙拼碼後，可以輸入輔助碼篩選候選項，與「molong」方案不同。/g" ./molong_aux.schema.yaml

# cp moran_bj.schema.yaml molong_bj.schema.yaml
# sed -i "s/^  schema_id: moran_bj$/  schema_id: molong_bj/g" ./molong_bj.schema.yaml
# sed -i "s/^  name: 魔然·並擊G$/  name: molong並擊/g" ./molong_bj.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_bj.schema.yaml
# sed -i "s/^    爲傳承字設計的自然碼及輔助碼智能整句輸入方案。$/    molong = Moran + Flypy + Ice/g" ./molong_bj.schema.yaml
# sed -i "s/^    - moran_fixed$/    - molong_fixed/g" ./molong_bj.schema.yaml
# sed -i "s/^    - moran_sentence$/    - molong_sentence/g" ./molong_bj.schema.yaml

# cp moran_fixed.schema.yaml molong_fixed.schema.yaml
# sed -i "s/^  schema_id: moran_fixed$/  schema_id: molong_fixed/g" ./molong_fixed.schema.yaml
# sed -i "s/^  name: 魔然·字詞$/  name: molong字詞/g" ./molong_fixed.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_fixed.schema.yaml

# cp moran_sentence.schema.yaml molong_sentence.schema.yaml
# sed -i "s/^  schema_id: moran_sentence$/  schema_id: molong_sentence/g" ./molong_sentence.schema.yaml
# sed -i "s/^  name: 魔然·整句$/  name: molong整句/g" ./molong_sentence.schema.yaml
# sed -i "s/^\(    - 方案製作：ksqsf\)$/\1\n    - Integrator：jack2game/g" ./molong_sentence.schema.yaml
# cd ..
