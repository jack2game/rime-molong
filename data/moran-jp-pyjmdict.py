import json
import csv
from pykakasi import kakasi

# Initialize kakasi with the new API
kks = kakasi()

# Function to convert kana to romaji
def kana_to_romaji_converter(kana):
    return kks.convert(kana)

# Load the JSON file
with open('jmdict-eng-3.5.0.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Open a TSV file for writing
with open('output.tsv', 'w', encoding='utf-8', newline='') as tsvfile:
    tsv_writer = csv.writer(tsvfile, delimiter='\t')

    # Loop through each word in the JSON
    for word in data['words']:
        # Initialize variables to store common kanji and kana
        common_kanji = ''
        common_kana = ''
        romaji = ''

        # Check for kanji
        if word['kanji']:
            non_common_kanji = None
            for kanji in word['kanji']:
                if kanji['common']:
                    common_kanji = kanji['text']
                    break  # Stop once we find the first common kanji
                non_common_kanji = kanji['text']
            # If no common kanji found, use the last non-common kanji
            if not common_kanji and non_common_kanji:
                common_kanji = non_common_kanji

        # Check for kana
        if word['kana']:
            non_common_kana = None
            for kana in word['kana']:
                if kana['common']:
                    common_kana = kana['text']
                    break  # Stop once we find the first common kana
                non_common_kana = kana['text']
            # If no common kana found, use the last non-common kana
            if not common_kana and non_common_kana:
                common_kana = non_common_kana

        # Convert kana to romaji
        if common_kana:
            romaji = kana_to_romaji_converter(common_kana)

        # Join all the 'hepburn' values together
        romaji_hepburn = ''.join([r['hepburn'] for r in romaji])

        # Join all the 'kunrei' values together
        romaji_kunrei = ''.join([r['kunrei'] for r in romaji])

        # Write the row to the TSV file, even if common_kanji or common_kana is empty
        tsv_writer.writerow([common_kanji, common_kana, romaji_hepburn, romaji_kunrei])
