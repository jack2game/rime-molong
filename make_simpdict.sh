#!/bin/bash

set -x

sed 's/\/$//' ./data/assess.tiger-code.com/common.simp2.words.txt      >  ./data/assess.tiger-code.com/common.simp.words.txt
sed 's/\/$//' ./data/assess.tiger-code.com/common.simp3.words.txt      >> ./data/assess.tiger-code.com/common.simp.words.txt
sed 's/\/$//' ./data/assess.tiger-code.com/common.simp4.words.txt      >> ./data/assess.tiger-code.com/common.simp.words.txt
sed 's/\/$//' ./data/assess.tiger-code.com/common.simpothers.words.txt >> ./data/assess.tiger-code.com/common.simp.words.txt