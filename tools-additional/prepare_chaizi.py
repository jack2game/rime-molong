#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
r"""
Convert quanpin dictionary files
You need to convert input file to UTF-8 before running
"""

import csv
import re
import argparse
import opencc

opencc_t2s = opencc.OpenCC('t2s.json')
opencc_s2t = opencc.OpenCC('s2t.json')

def replace_characters(text, replacement_dict):
    # Create a translation table for str.translate()
    translation_table = str.maketrans(replacement_dict)
    # Replace characters using the translation table
    return text.translate(translation_table)

def generate_chaizi(list1, list2):
    list3 = []
    mapping_dict = dict(list2)
    missing_chars_seen = set()  # Set to keep track of missing chars seen so far
    for item in list1:
        key = item[0]
        value = ''
        for char in item[1].split():
            try:
                value += mapping_dict[char]
                list3.append([key, value])
            except:
                if char not in missing_chars_seen:
                    missing_chars_seen.add(char)  # Add the missing char to the set
                    print('No code for: ' + char)
    return list3

def remove_dupe(input_lists):
    seen = set()
    output_lists = []
    for sublist in input_lists:
        sublist_tuple = tuple(sublist)
        if sublist_tuple not in seen:
            output_lists.append(sublist)
            seen.add(sublist_tuple)
    return output_lists

def rewrite_row(rows, currentlib, simplib):
    replacement_dict = {
        '⺆': '越',
        '行': '形',
        '一': '横',
        '丨': '竖',
        '丿': '撇',
        '乁': '捺',
        '㇏': '捺',
        '乀': '捺',
        '乚': '钩',
        '𠄌': '钩',
        '亅': '钩',
        '𠃌': '折',
        '㇉': '折',
        '𠃊': '折',
        '□': '折',
        '𠃍': '折',
        '乛': '折',
        '𠃋': '折',
        '丶': '点',
        '卜': '补',
        '厶': '丝',
        '爿': '片',
        '乂': '义',
        '亠': '头',
        '廾': '工',
        '灬': '火',
        '⺄': '以',
        '疋': '定',
        '长': '常',
        '凵': '砍',
        '冖': '蜜',
        '攵': '文',
        '夂': '文',
        '冂': '童',
        '𡗗': '春',
        '龴': '思',
        '鳥': '鸟',
        '倉': '苍',
        '龍': '龙',
        '屮': '草',
        '參': '餐',
        '□': '哥',
        '': '衣',
        '卩': '耳',
        '廴': '键',
        '宀': '宝',
        '龷': '贡',
        '罒': '四',
        '癶': '蹬',
        '爫': '爪',
        '彳': '人',
        '阝': '耳',
        '匚': '方',
        '彐': '山',
        '刂': '刀',
        '丬': '江',
        '囗': '口',
        '辶': '只',
        '彡': '山',
        '糸': '蜜',
        '蟲': '虫',
        '孱': '蝉',
        '𡕩': '满',
        '曰': '约',
        '𠙽': '快',
        '𦉼': '辣',
        '將': '江',
        '𭕘': '梅',
        '𣥚': '走',
        '𤽄': '全',
        '𦣞': '疑',
        '𪩲': '市',
        '朩': '木',
        '𡿨': '折',
        '𠁁': '豆',
        '𠂤': '堆',
        '𢀖': '惊',
        '𠂢': '派',
        '𦥯': '学',
        '𡙎': '渺',
        '𦥑': '举',
        '耎': '软',
        '亻': '人',
        '耴': '哲',
        '灷': '赚',
    }
    newrows = []
    for i, row in enumerate(rows):
        if len(row) > 1:
            original_text = row[1]
            replaced_text = ''.join(replacement_dict.get(char, char) for char in original_text)
            # if currentlib in simplib:
                # replaced_text = opencc_t2s.convert(replaced_text)
            row[1] = replaced_text
            if len(row) > 2:
                rows[i] = [row[0], row[1]]
                del row[1]
                rows.insert(i+1, row) # 將不同拆法寫到另外一行
            newrows.append(row)
    return newrows


def get_cli_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input_file", "-i", type=str,
                        default="chaizi-chs.txt",
                        help="input dictionary file")
    parser.add_argument("--output_file", "-o", type=str, default="output.txt",
                        help="output dictionary file")
    parser.add_argument("--current_library", "-c", type=str, default="moran.chars.dict.yaml",
                        help="current library file")
    args = parser.parse_args()
    return args


def main():
    simplib = ['./xhloopfly-cht/moran.chars.dict.yaml']
    args = get_cli_args()
    currentlib = args.current_library
    with open(args.input_file, newline="", encoding='UTF-8') as f:
        rows = list(csv.reader(f, delimiter="\t", quotechar="`"))
    with open(args.current_library, newline="", encoding='UTF-8') as f:
        libs = list(csv.reader(f, delimiter="\t", quotechar="`"))

    rows = rewrite_row(rows, currentlib, simplib)
    rows = list(filter(None, rows)) # remove empty
    rows = remove_dupe(rows)

    # clean up current_library
    newlibs = []
    keys_seen = set()  # Set to keep track of keys seen so far
    for i, lib in enumerate(libs):
        if len(lib) > 1:
            lib[1] = lib[1][0:2]
            if len(lib) > 2:
                libs[i] = lib[0:3]+[i] # add index to the sublist 有词频时
            elif len(lib) == 2:
                libs[i] = lib[0:2]+[0]+[i]
            key = lib[0]
            if key not in keys_seen:
                keys_seen.add(key)  # Add the key to the set
                newlibs.append(libs[i])
    libs = [sublist for sublist in newlibs if len(sublist) == 4 and len(sublist[0]) == 1] # 有词频时
    # libs = [sublist for sublist in newlibs if len(sublist) == 3 and len(sublist[0]) == 1]
    libs = sorted(libs, key=lambda x: (x[0], -int(x[2]), int(x[3]))) # 有词频时
    # libs = sorted(libs, key=lambda x: (x[0], int(x[2])))
    for i, lib in enumerate(libs):
        libs[i] = lib[0:2]

    # remove dupe
    libs = remove_dupe(libs)

    out_rows = generate_chaizi(rows, libs)
    out_rows = remove_dupe(out_rows)
    # out_rows = libs

    output_file = args.output_file
    with open(output_file, "w", newline="", encoding='UTF-8') as f:
        my_tsv = csv.writer(f, delimiter="\t",
                            quotechar="`", lineterminator="\n")
        my_tsv.writerows(out_rows)

if __name__ == "__main__":
    main()
