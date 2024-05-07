#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
r"""
Convert quanpin dictionary files to pinyin+shape for Rime input method.
"""

import csv
import re
import argparse
import os

def zrm2fly(shuangpin):
    yunmu_dict = {
        "a": "a",
        "e": "e",
        "o": "o",
        "i": "i",
        "u": "u",
        "b": "z",
        "c": "n",
        "d": "l",
        "f": "f",
        "g": "g",
        "h": "h",
        "j": "j",
        "k": "c",
        "l": "d",
        "m": "m",
        "n": "b",
        "o": "o",
        "p": "y",
        "q": "q",
        "r": "r",
        "s": "s",
        "t": "t",
        "v": "v",
        "w": "x",
        "x": "p",
        "y": "k",
        "z": "w",
    }
    newcode = []
    for i, code in enumerate(shuangpin):
        if i%2 == 1 and shuangpin[i-1] not in "aoe":
            # print(shuangpin)
            newcode.append(yunmu_dict[code])
        else:
            newcode.append(code)
    return "".join(newcode)


def rewrite_row(row, input_sp, output_sp):
    if len(row) < 2 or row[0][0] == "#":
        return row
    if len(row) == 2 and row[1][0].isnumeric():  # ['三觭龍', '1']
        return row
    zh_chars = row[0]
    pinyin_list = row[1]
    if input_sp == 'zrm' and output_sp == 'flypy':
        row[1] = zrm2fly(row[1])
    return row


def get_cli_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input_file", "-i", type=str,
                        default="luna_pinyin.dict.yaml",
                        help="Input file")
    parser.add_argument("--output_file", "-o", type=str, default="",
                        help="Output file")
    parser.add_argument("--input_sp", type=str, default="zrm",
                        choices=["flypy", "zrm"],
                        help="Input Shuangpin scheme")
    parser.add_argument("--output_sp", type=str, default="flypy",
                        choices=["flypy", "zrm"],
                        help="Output Shuangpin scheme")
    parser.add_argument("--delimiter", "-d", type=str, default=";",
                        help="Delimiter to seperate pinyin and shape")
    args = parser.parse_args()
    return args


def main():
    args = get_cli_args()
    input_sp = args.input_sp
    output_sp = args.output_sp
    delim = args.delimiter
    with open(os.path.realpath(args.input_file), newline="", encoding='UTF-8') as f:
        rows = list(csv.reader(f, delimiter="\t", quotechar="`"))
    out_rows = [rewrite_row(row, input_sp, output_sp) for row in rows]

    output_file = os.path.realpath(args.output_file)
    if output_file == "":
        _, input_postfix = args.input_file.split(".", maxsplit=1)
        output_file = f"{args.input_sp}_{args.output_sp}.{input_postfix}"
    with open(output_file, "w", newline="", encoding='UTF-8') as f:
        my_tsv = csv.writer(f, delimiter="\t",
                            quotechar="`", lineterminator="\n")
        my_tsv.writerows(out_rows)


if __name__ == "__main__":
    main()
