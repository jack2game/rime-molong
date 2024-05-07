#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
r"""
Convert quanpin dictionary files
You need to convert input file to UTF-8 before running
"""

import csv
import re
import argparse

def rewrite_row(row: list, libs: list):
    # print(row)
    if len(row) < 2:
        return ''
    if row[0] == '':
        return ''
    if row[0][0] == "#":
        return row
    zh_chars = row[0]
    py_chars = row[1]
    if len(zh_chars) != 1 or len(py_chars) < 4 or py_chars[0] == 'o': # 非单字或简码
        # print(row)
        # row[0] = "#" + zh_chars
        return ''
    regex = r'[\u4e00-\u9fa5\u3040-\u309f\u30a0-\u30ff]' # 非中文
    if not re.match(regex, zh_chars):
        # print(row)
        # row[0] = "#" + row[0]
        return ''
    if zh_chars in libs:
        # print(row)
        # row[0] = "#" + zh_chars
        return ''
    row[1] = py_chars[-2:]
    return row


def get_cli_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input_file", "-i", type=str,
                        default="小鹤音形for手机搜狗百度自定义方案.txt",
                        help="input dictionary file")
    parser.add_argument("--output_file", "-o", type=str, default="output.txt",
                        help="output dictionary file")
    parser.add_argument("--current_library", "-c", type=str, default="flypy.txt",
                        help="current library file")
    args = parser.parse_args()
    return args


def main():
    args = get_cli_args()
    with open(args.input_file, newline="", encoding='UTF-8') as f:
        rows = list(csv.reader(f, delimiter="\t", quotechar="`"))
    with open(args.current_library, newline="", encoding='UTF-8') as f:
        libs = [row.split('\t')[0] for row in f]

    out_rows = [rewrite_row(row, libs) for row in rows]
    out_rows = list(filter(None, out_rows)) # remove empty
    out_rows = [list(t) for t in set(tuple(element) for element in out_rows)] # remove duplicate
    
    output_file = args.output_file
    with open(output_file, "w", newline="", encoding='UTF-8') as f:
        my_tsv = csv.writer(f, delimiter="\t",
                            quotechar="`", lineterminator="\n")
        my_tsv.writerows(out_rows)

if __name__ == "__main__":
    main()
