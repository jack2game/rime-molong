#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
r"""
Convert quanpin dictionary files to pinyin+shape for Rime input method.
"""

import csv
import re
import argparse
import opencc
import os

opencc_t2s = opencc.OpenCC('t2s.json')
opencc_s2t = opencc.OpenCC('s2t.json')

def snow2molong(pinyin: str):
    shengmu_dict = {"zh": "v", "ch": "i", "sh": "u"}
    yunmu_dict = {
        "a5": "l",
        "a1": "l",
        "a2": "u",
        "a3": "m",
        "a4": "i",
        "ai5": "b",
        "ai1": "b",
        "ai2": "d",
        "ai3": "u",
        "ai4": "o",
        "an5": "n",
        "an1": "n",
        "an2": "p",
        "an3": "o",
        "an4": "a",
        "ang5": "u",
        "ang1": "u",
        "ang2": "w",
        "ang3": "p",
        "ang4": "d",
        "ao5": "q",
        "ao1": "q",
        "ao2": "i",
        "ao3": "x",
        "ao4": "v",
        "e5": "r",
        "e1": "r",
        "e2": "e",
        "e3": "l",
        "e4": "i",
        "ei5": "i",
        "ei1": "i",
        "ei2": "r",
        "ei3": "j",
        "ei4": "k",
        "en5": "e",
        "en1": "e",
        "en2": "s",
        "en3": "o",
        "en4": "o",
        "eng5": "c",
        "eng1": "c",
        "eng2": "f",
        "eng3": "y",
        "eng4": "f",
        "er5": "r",
        "er1": "r",
        "er2": "k",
        "er3": "u",
        "er4": "h",
        "i5": "j",
        "i1": "j",
        "i2": "b",
        "i3": "g",
        "i4": "t",
        "ia5": "d",
        "ia1": "d",
        "ia2": "c",
        "ia3": "n",
        "ia4": "x",
        "ian5": "r",
        "ian1": "r",
        "ian2": "v",
        "ian3": "p",
        "ian4": "a",
        "iang5": "y",
        "iang1": "y",
        "iang2": "i",
        "iang3": "u",
        "iang4": "e",
        "iao5": "m",
        "iao1": "m",
        "iao2": "u",
        "iao3": "l",
        "iao4": "l",
        "ie5": "k",
        "ie1": "k",
        "ie2": "s",
        "ie3": "c",
        "ie4": "q",
        "in5": "h",
        "in1": "h",
        "in2": "c",
        "in3": "x",
        "in4": "v",
        "ing5": "e",
        "ing1": "e",
        "ing2": "n",
        "ing3": "w",
        "ing4": "w",
        "iong5": "p",
        "iong1": "p",
        "iong2": "k",
        "iong3": "e",
        "iong4": "h",
        "iu5": "z",
        "iu1": "z",
        "iu2": "m",
        "iu3": "z",
        "iu4": "o",
        "o5": "p",
        "o1": "p",
        "o2": "e",
        "o3": "i",
        "o4": "g",
        "ong5": "k",
        "ong1": "k",
        "ong2": "j",
        "ong3": "n",
        "ong4": "y",
        "ou5": "x",
        "ou1": "x",
        "ou2": "a",
        "ou3": "z",
        "ou4": "r",
        "u5": "a",
        "u1": "a",
        "u2": "l",
        "u3": "m",
        "u4": "h",
        "ua5": "s",
        "ua1": "s",
        "ua2": "t",
        "ua3": "g",
        "ua4": "g",
        "uai5": "g",
        "uai1": "g",
        "uai2": "s",
        "uai3": "p",
        "uai4": "f",
        "uan5": "d",
        "uan1": "d",
        "uan2": "o",
        "uan3": "s",
        "uan4": "c",
        "uang5": "w",
        "uang1": "w",
        "uang2": "b",
        "uang3": "u",
        "uang4": "e",
        "ue5": "u",
        "ue1": "u",
        "ue2": "i",
        "ue3": "o",
        "ue4": "d",
        "ui5": "t",
        "ui1": "t",
        "ui2": "w",
        "ui3": "v",
        "ui4": "f",
        "un5": "g",
        "un1": "g",
        "un2": "f",
        "un3": "o",
        "un4": "r",
        "uo5": "s",
        "uo1": "s",
        "uo2": "l",
        "uo3": "l",
        "uo4": "p",
        "v5": "h",
        "v1": "h",
        "v2": "m",
        "v3": "s",
        "v4": "f",
        "ve5": "u",
        "ve1": "u",
        "ve2": "i",
        "ve3": "o",
        "ve4": "d",
    }
    zero = {
        "a5": "al",
        "a1": "al",
        "a2": "au",
        "a3": "am",
        "a4": "ai",
        "ai5": "ab",
        "ai1": "ab",
        "ai2": "ad",
        "ai3": "au",
        "ai4": "ao",
        "an5": "an",
        "an1": "an",
        "an2": "ap",
        "an3": "ao",
        "an4": "aa",
        "ang5": "au",
        "ang1": "au",
        "ang2": "aw",
        "ang3": "ap",
        "ang4": "ad",
        "ao5": "aq",
        "ao1": "aq",
        "ao2": "ai",
        "ao3": "ax",
        "ao4": "av",
        "e5": "er",
        "e1": "er",
        "e2": "ee",
        "e3": "el",
        "e4": "ei",
        "ei5": "ei",
        "ei1": "ei",
        "ei2": "er",
        "ei3": "ej",
        "ei4": "ek",
        "en5": "ee",
        "en1": "ee",
        "en2": "es",
        "en3": "eo",
        "en4": "eo",
        "eng5": "ec",
        "eng1": "ec",
        "eng2": "ef",
        "eng3": "ey",
        "eng4": "ef",
        "er5": "er",
        "er1": "er",
        "er2": "ek",
        "er3": "eu",
        "er4": "eh",
        "o5": "op",
        "o1": "op",
        "o2": "oe",
        "o3": "oi",
        "o4": "og",
        "ou5": "ox",
        "ou1": "ox",
        "ou2": "oa",
        "ou3": "oz",
        "ou4": "or",
    }
    if pinyin in zero:
        return zero[pinyin]
    if pinyin[1] == "h" and len(pinyin) > 2:
        shengmu, yunmu = pinyin[:2], pinyin[2:]
        shengmu = shengmu_dict[shengmu]
    else:
        shengmu, yunmu = pinyin[:1], pinyin[1:]
    return shengmu + yunmu_dict.get(yunmu, yunmu)

def snow2zrlong(pinyin: str):
    shengmu_dict = {"zh": "v", "ch": "i", "sh": "u"}
    yunmu_dict = {
        "a5": "l",
        "a1": "l",
        "a2": "u",
        "a3": "m",
        "a4": "i",
        "ai5": "b",
        "ai1": "b",
        "ai2": "d",
        "ai3": "u",
        "ai4": "o",
        "an5": "n",
        "an1": "n",
        "an2": "p",
        "an3": "o",
        "an4": "a",
        "ang5": "u",
        "ang1": "u",
        "ang2": "w",
        "ang3": "p",
        "ang4": "d",
        "ao5": "q",
        "ao1": "q",
        "ao2": "i",
        "ao3": "x",
        "ao4": "v",
        "e5": "r",
        "e1": "r",
        "e2": "e",
        "e3": "l",
        "e4": "i",
        "ei5": "i",
        "ei1": "i",
        "ei2": "r",
        "ei3": "j",
        "ei4": "k",
        "en5": "e",
        "en1": "e",
        "en2": "s",
        "en3": "o",
        "en4": "o",
        "eng5": "c",
        "eng1": "c",
        "eng2": "f",
        "eng3": "y",
        "eng4": "f",
        "er5": "r",
        "er1": "r",
        "er2": "k",
        "er3": "u",
        "er4": "h",
        "i5": "j",
        "i1": "j",
        "i2": "b",
        "i3": "g",
        "i4": "t",
        "ia5": "d",
        "ia1": "d",
        "ia2": "c",
        "ia3": "n",
        "ia4": "x",
        "ian5": "r",
        "ian1": "r",
        "ian2": "v",
        "ian3": "p",
        "ian4": "a",
        "iang5": "y",
        "iang1": "y",
        "iang2": "i",
        "iang3": "u",
        "iang4": "e",
        "iao5": "m",
        "iao1": "m",
        "iao2": "u",
        "iao3": "l",
        "iao4": "l",
        "ie5": "k",
        "ie1": "k",
        "ie2": "s",
        "ie3": "c",
        "ie4": "q",
        "in5": "h",
        "in1": "h",
        "in2": "c",
        "in3": "x",
        "in4": "v",
        "ing5": "e",
        "ing1": "e",
        "ing2": "n",
        "ing3": "w",
        "ing4": "w",
        "iong5": "p",
        "iong1": "p",
        "iong2": "k",
        "iong3": "e",
        "iong4": "h",
        "iu5": "z",
        "iu1": "z",
        "iu2": "m",
        "iu3": "z",
        "iu4": "o",
        "o5": "p",
        "o1": "p",
        "o2": "e",
        "o3": "i",
        "o4": "g",
        "ong5": "k",
        "ong1": "k",
        "ong2": "j",
        "ong3": "n",
        "ong4": "y",
        "ou5": "x",
        "ou1": "x",
        "ou2": "a",
        "ou3": "z",
        "ou4": "r",
        "u5": "a",
        "u1": "a",
        "u2": "l",
        "u3": "m",
        "u4": "h",
        "ua5": "s",
        "ua1": "s",
        "ua2": "t",
        "ua3": "g",
        "ua4": "g",
        "uai5": "g",
        "uai1": "g",
        "uai2": "s",
        "uai3": "p",
        "uai4": "f",
        "uan5": "d",
        "uan1": "d",
        "uan2": "o",
        "uan3": "s",
        "uan4": "c",
        "uang5": "w",
        "uang1": "w",
        "uang2": "b",
        "uang3": "u",
        "uang4": "e",
        "ue5": "u",
        "ue1": "u",
        "ue2": "i",
        "ue3": "o",
        "ue4": "d",
        "ui5": "t",
        "ui1": "t",
        "ui2": "w",
        "ui3": "v",
        "ui4": "f",
        "un5": "g",
        "un1": "g",
        "un2": "f",
        "un3": "o",
        "un4": "r",
        "uo5": "s",
        "uo1": "s",
        "uo2": "l",
        "uo3": "l",
        "uo4": "p",
        "v5": "h",
        "v1": "h",
        "v2": "m",
        "v3": "s",
        "v4": "f",
        "ve5": "u",
        "ve1": "u",
        "ve2": "i",
        "ve3": "o",
        "ve4": "d",
    }
    zero = {
        "a5": "al",
        "a1": "al",
        "a2": "au",
        "a3": "am",
        "a4": "ai",
        "ai5": "ab",
        "ai1": "ab",
        "ai2": "ad",
        "ai3": "au",
        "ai4": "ao",
        "an5": "an",
        "an1": "an",
        "an2": "ap",
        "an3": "ao",
        "an4": "aa",
        "ang5": "au",
        "ang1": "au",
        "ang2": "aw",
        "ang3": "ap",
        "ang4": "ad",
        "ao5": "aq",
        "ao1": "aq",
        "ao2": "ai",
        "ao3": "ax",
        "ao4": "av",
        "e5": "er",
        "e1": "er",
        "e2": "ee",
        "e3": "el",
        "e4": "ei",
        "ei5": "ei",
        "ei1": "ei",
        "ei2": "er",
        "ei3": "ej",
        "ei4": "ek",
        "en5": "ee",
        "en1": "ee",
        "en2": "es",
        "en3": "eo",
        "en4": "eo",
        "eng5": "ec",
        "eng1": "ec",
        "eng2": "ef",
        "eng3": "ey",
        "eng4": "ef",
        "er5": "er",
        "er1": "er",
        "er2": "ek",
        "er3": "eu",
        "er4": "eh",
        "o5": "op",
        "o1": "op",
        "o2": "oe",
        "o3": "oi",
        "o4": "og",
        "ou5": "ox",
        "ou1": "ox",
        "ou2": "oa",
        "ou3": "oz",
        "ou4": "or",
    }
    if pinyin in zero:
        return zero[pinyin]
    if pinyin[1] == "h" and len(pinyin) > 2:
        shengmu, yunmu = pinyin[:2], pinyin[2:]
        shengmu = shengmu_dict[shengmu]
    else:
        shengmu, yunmu = pinyin[:1], pinyin[1:]
    return shengmu + yunmu_dict.get(yunmu, yunmu)


def lunapy2flypy(pinyin: str):
    r""" 全拼拼音转为小鹤双拼码, 如果转自然码等请自行替换双拼映射
    adapted from: https://github.com/boomker/rime-flypy-xhfast/blob/15664c597644bd41410ec4595cece88a6452a1bf/scripts/flypy_dict_generator_new.py
    """
    shengmu_dict = {"zh": "v", "ch": "i", "sh": "u"}
    yunmu_dict = {
        "ou": "z",
        "iao": "n",
        "uang": "l",
        "iang": "l",
        "en": "f",
        "eng": "g",
        "ang": "h",
        "an": "j",
        "ao": "c",
        "ai": "d",
        "ian": "m",
        "in": "b",
        "uo": "o",
        "un": "y",
        "iu": "q",
        "uan": "r",
        "van": "r",
        "iong": "s",
        "ong": "s",
        "ue": "t",
        "ve": "t",
        "ui": "v",
        "ua": "x",
        "ia": "x",
        "ie": "p",
        "uai": "k",
        "ing": "k",
        "ei": "w",
    }
    zero = {
        "a": "aa",
        "an": "an",
        "ai": "ai",
        "ang": "ah",
        "ao": "ao",
        "o": "oo",
        "ou": "ou",
        "e": "ee",
        "ei": "ei",
        "n": "en",
        "en": "en",
        "eng": "eg",
        "er": "er",
    }
    if pinyin in zero:
        return zero[pinyin]
    if pinyin[1] == "h" and len(pinyin) > 2:
        shengmu, yunmu = pinyin[:2], pinyin[2:]
        shengmu = shengmu_dict[shengmu]
    else:
        shengmu, yunmu = pinyin[:1], pinyin[1:]
    return shengmu + yunmu_dict.get(yunmu, yunmu)


def lunapy2zrm(pinyin: str):
    r""" 全拼拼音转为自然双拼码
    adapted from: https://github.com/boomker/rime-flypy-xhfast/blob/15664c597644bd41410ec4595cece88a6452a1bf/scripts/flypy_dict_generator_new.py
    """
    shengmu_dict = {"zh": "v", "ch": "i", "sh": "u"}
    yunmu_dict = {
        "ou": "b",
        "iao": "c",
        "uang": "d",
        "iang": "d",
        "en": "f",
        "eng": "g",
        "ang": "h",
        "an": "j",
        "ao": "k",
        "ai": "l",
        "ian": "m",
        "in": "n",
        "uo": "o",
        "un": "p",
        "iu": "q",
        "uan": "r",
        "van": "r",
        "iong": "s",
        "ong": "s",
        "ue": "t",
        "ve": "t",
        "ui": "v",
        "ua": "w",
        "ia": "w",
        "ie": "x",
        "uai": "y",
        "ing": "y",
        "ei": "z",
    }
    zero = {
        "a": "aa",
        "an": "an",
        "ai": "ai",
        "ang": "ah",
        "ao": "ao",
        "o": "oo",
        "ou": "ou",
        "e": "ee",
        "ei": "ei",
        "n": "en",
        "en": "en",
        "eng": "eg",
        "er": "er",
    }
    if pinyin in zero:
        return zero[pinyin]
    if pinyin[1] == "h" and len(pinyin) > 2:
        shengmu, yunmu = pinyin[:2], pinyin[2:]
        shengmu = shengmu_dict[shengmu]
    else:
        shengmu, yunmu = pinyin[:1], pinyin[1:]
    return shengmu + yunmu_dict.get(yunmu, yunmu)

def get_pinyin_fn(schema: str):
    schema = schema.lower()
    if schema == "quanpin":
        def do_nothing(pinyin: str):
            return pinyin
        return do_nothing
    if schema == "flypy":
        return lunapy2flypy
    if schema == "zrm":
        return lunapy2zrm
    if schema == "zrlong":
        return snow2zrlong
    if schema == "molong":
        return snow2molong


def get_shape_dict(schema: str):
    with open(f"{schema}.txt", newline="", encoding='UTF-8') as f:
        rows = list(csv.reader(f, delimiter="\t", quotechar="`"))
    shape_dict = {row[0]: row[1] for row in rows if len(row) >= 2}
    return shape_dict


def rewrite_row(row: list, code_fn: callable, traditional: bool, simplified: bool):
    # print(row)
    if len(row) < 2 or row[0][0] == "#":
        return row
    if len(row) == 2 and row[1][0].isnumeric():  # ['三觭龍', '1']
        return row
    # row == ['三觭龍', 'san ji long'] or ['三觭龍', 'san ji long', '1']
    zh_chars = row[0]
    # eg. '安娜·卡列尼娜' -> '安娜卡列尼娜'
    zh_chars = re.sub("[;·，。；：“”‘’《》（）！？、…—–]", "", zh_chars)
    if traditional and not simplified:
        zh_chars = opencc_s2t.convert(zh_chars)
    if simplified and not traditional:
        zh_chars = opencc_t2s.convert(zh_chars)  # '三觭龍' -> '三觭龙'
    pinyin_list = row[1].split()  # ['san', 'ji', 'long']
    if len(zh_chars) != len(pinyin_list):  # failure case
        print(row)
        row[0] = "#" + row[0]
        return row
    new_zh_chars = []
    for i, char in enumerate(zh_chars):
        if char == "干" and "qian" in pinyin_list[i]:
            new_zh_chars.append("乾")
        else:
            new_zh_chars.append(char)
    new_zh_chars = "".join(new_zh_chars)
    code_list = [code_fn(py, zi) for (py, zi) in zip(pinyin_list, new_zh_chars)]
    row[0] = new_zh_chars
    row[1] = " ".join(code_list)
    return row


def get_cli_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input_file", "-i", type=str,
                        default="luna_pinyin.dict.yaml",
                        help="Input file")
    parser.add_argument("--output_file", "-o", type=str, default="",
                        help="Output file")
    parser.add_argument("--pinyin", "-p", type=str, default="flypy",
                        choices=["flypy", "quanpin", "zrm", "zrlong", "molong"],
                        help="Pinyin scheme")
    parser.add_argument("--shape", "-x", type=str, default="zrmdb",
                        choices=["flypy", "zrmfast", "zrmdb"], help="shape schema")
    parser.add_argument("--delimiter", "-d", type=str, default=";",
                        help="Delimiter to seperate pinyin and shape")
    parser.add_argument('--traditional', "-t", action='store_true', help='Generate traditional characters')
    parser.add_argument('--simplified', "-s", action='store_true', help='Generate simplified characters')
    args = parser.parse_args()
    return args


def main():
    args = get_cli_args()
    pinyin_fn = get_pinyin_fn(args.pinyin)
    shape_dict = get_shape_dict(args.shape)
    delim = args.delimiter
    traditional = args.traditional
    simplified = args.simplified
    with open(os.path.realpath(args.input_file), newline="", encoding='UTF-8') as f:
        rows = list(csv.reader(f, delimiter="\t", quotechar="`"))

    def code_fn(pinyin, hanzi):
        return pinyin_fn(pinyin) + delim + shape_dict.get(hanzi, delim)
    out_rows = [rewrite_row(row, code_fn, traditional, simplified) for row in rows]

    output_file = os.path.realpath(args.output_file)
    if output_file == "":
        _, input_postfix = args.input_file.split(".", maxsplit=1)
        output_file = f"{args.pinyin}_{args.shape}.{input_postfix}"
    with open(output_file, "w", newline="", encoding='UTF-8') as f:
        my_tsv = csv.writer(f, delimiter="\t",
                            quotechar="`", lineterminator="\n")
        my_tsv.writerows(out_rows)


if __name__ == "__main__":
    main()
