#!/home/gperaza/anaconda3/bin/python

import os
import bibtexparser
from bibtexparser.bparser import BibTexParser
from bibtexparser.customization import convert_to_unicode


def get_fields(entry):
    title = entry['title'] if 'title' in entry else " "
    title = title.replace("{{", "").replace("}}", "")
    title = title.replace("\\textendash", "-")
    title = title.replace("\\textemdash", "—")
    title = title.replace("{", "").replace("}", "")
    title = title.replace("$\mkern1mu$", " ")

    author = entry['author'] if 'author' in entry else " "
    author = author.replace("{", "").replace("}", "").replace("\,", ",")
    author = author.replace(' and ', '|')

    year = entry['year'] if 'year' in entry else " "

    entry_type = entry['ENTRYTYPE']

    bib_key = entry['ID']

    if 'file' in entry and entry['file']:
        has_pdf = "⌘"
        pdf_path = entry['file']
        note_path = os.path.splitext(pdf_path.split(':')[1])[0]+'.org'
        if os.path.isfile(note_path):
            has_notes = "✎"
        else:
            has_notes = " "
    else:
        has_pdf = " "
        pdf_path = ""
        has_notes = " "

    if 'doi' in entry and entry['doi']:
        doi = entry['doi']
    else:
        doi = ""
    return (bib_key, entry_type, title, author, year,
            has_pdf, has_notes, pdf_path, doi)


def build_fzf_line(entry):
    (bib_key, entry_type,
     title, author, year,
     has_pdf, has_notes,
     pdf_path, doi) = get_fields(entry)

    hidden_line = "{%s{%s{%s{%s{%s" % (author, title, bib_key,
                                       pdf_path, doi)
    author = "{:<36}".format(author[:36])
    year = "{:<4}".format(year[:4])
    entry_type = "{:<7}".format(entry_type[:7])
    title_length = int(columns) - (36 + 4 + 7 + 12)
    title = ("{:<"+str(title_length)+"}").format(title[:title_length])

    return "%s %s %s %s %s %s %s" % (author, title, year, has_pdf,
                                     has_notes, entry_type, hidden_line)


bib_input_file = '/home/gperaza/Documents/Library/bibliography.bib'
notes_dir = "/home/gperaza/Documents/SortedResources/Notes/"
rows, columns = os.popen('stty size', 'r').read().split()

with open(bib_input_file) as bibtex_file:
    parser = BibTexParser(common_strings=True)
    # parser.customization = convert_to_unicode
    bib_database = bibtexparser.load(bibtex_file, parser=parser)

for entry in bib_database.entries:
    print(build_fzf_line(entry))
