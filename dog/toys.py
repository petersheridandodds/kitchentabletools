# import sys
# sys.path.append("/Users/andyreagan/work/2015/08-kitchentabletools/")
# from dog.toys import *

from subprocess import call
from datetime import datetime,timedelta
from matplotlib.pyplot import savefig
from jinja2 import Template
import codecs
from re import findall,UNICODE
from sys import version

# handle both pythons
if version < '3':
    import codecs
    def u(x):
        """Python 2/3 agnostic unicode function"""
        return codecs.unicode_escape_decode(x)[0]
else:
    def u(x):
        """Python 2/3 agnostic unicode function"""
        return x

letters = [x.upper() for x in ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","xx","yy","zz"]]

def pdftile(options,pdf_array,title_array,title):
    '''Light wrapper around pdftile.pl, to combine pdf files!'''
    # example call:
    # ~/work/2015/08-kitchentabletools/pdftile.pl 4 2 .3 3 3 l 10 "" "" MPQA-+1-LIWC-all-bin.pdf "" blank.pdf "" MPQA--1-LIWC-all-bin.pdf "" blank.pdf "" MPQA-+1-Liu-all-bin.pdf "" LIWC-+1-Liu-all-bin.pdf "" MPQA--1-Liu-all-bin.pdf "" LIWC--1-Liu-all-bin.pdf lower-right-vertical
    # pdftile m n widthfrac hspacepts vspacepts f fontsize maintitle title1 fig1.pdf [title2 fig2.pdf ...] outfile
    file_list = " ".join(map(lambda x: " ".join(x),zip(title_array,pdf_array)))
    command = "~/work/2015/08-kitchentabletools/pdftile.pl {0} {1} {2}".format(options,file_list,title)
    print(command)
    call(command,shell=True)
    # pdftile('4 2 .3 3 3 l 10 ""',['pdfone','pdftwo',],['titleone','titletwo',],'mytitle')
    # ~/work/2015/08-kitchentabletools/pdftile.pl 4 2 .3 3 3 l 10 "" pdfone titleone pdftwo titletwo mytitle

def tabletile(options,tex_array,title_array,title):
    '''Light wrapper around tabletia le.pl, to combine .tex tables into a bigger table.'''
    # example call to tabletile.pl
    # ~/work/2015/08-kitchentabletools/tabletile.pl 4 2 .3 1 1 "p{4cm}" 10 "" scriptsize "" MPQA-+1-LIWC-all-bin.pdf "" blank.pdf "" MPQA--1-LIWC-all-bin.pdf "" blank.pdf "" MPQA-+1-Liu-all-bin.pdf "" LIWC-+1-Liu-all-bin.pdf "" MPQA--1-Liu-all-bin.pdf "" LIWC--1-Liu-all-bin.pdf lower-right-vertical
    # notice there is just one extra input
    file_list = " ".join(map(lambda x: " ".join(x),zip(title_array,tex_array)))
    command = "~/work/2015/08-kitchentabletools/tabletile.pl {0} {1} {2}".format(options,file_list,title)
    print(command)
    call(command,shell=True)

def crop_shift_top(pdffile):
    '''Given a shift pdf, crop the top off.

    See pdfcrop-specific.pl for a more general version.'''
    
    command = "gs -o {0}-topcropped.pdf -sDEVICE=pdfwrite -c \"[/CropBox [0 0 800 425]\" -c \" /PAGES pdfmark\" -f {0}.pdf".format(pdffile.replace(".pdf",""))
    # 477

    call(command,shell=True)

    return "{0}-topcropped.pdf".format(pdffile.replace(".pdf",""))

def mysavefig(name,date=True,folder=".",openfig=True):
    '''Save a figure with timestamp.'''
    folder = folder+"/"
    if date:
        now = datetime.now()
        formatted_date = now.strftime("%Y-%m-%d-%H-%M-")
    else:
        formatted_date = ""
    savefig("{0}{1}{2}".format(folder,formatted_date,name),bbox_inches='tight')
    # savefig("{0}-{1}".format(now.strftime("%Y-%m-%d-%H-%M"),name))
    if openfig:
        call("echo {0}{1}{2} | pbcopy".format(folder,formatted_date,name),shell=True)
        call("open {0}{1}{2}".format(folder,formatted_date,name),shell=True)

def tabletex_file_to_pdf(fname):
    '''Given the filename of the .tex table, make a .pdf of that table.'''

    template = Template(
r'''\documentclass[8 pt]{extarticle}
\usepackage{graphics,rotating,color,array,amsmath}
\pagestyle{empty}
\begin{document}
\noindent
\input{ {{ texfilename }} }
\end{document}''')

    # # can't get the escape characters quite right
    # call(r"echo '{0}' | pdflatex".format(template.render(texfilename=fname)),shell=True)
    # call("echo '{0}' > tmptex-2.tex".format(template.render(texfilename=fname)),shell=True)
    # call("echo '{0}'".format(template.render(texfilename=fname)),shell=True)
    # call('pdfcrop texput.pdf',shell=True)
    # call('mv texput-crop.pdf {0}'.format(fname.replace('tex','pdf')),shell=True)
    # call(r'\rm texput.*',shell=True)

    f = codecs.open("tmptex.tex",'w','utf8')
    f.write(template.render(texfilename=fname))
    f.close()
    call('pdflatex tmptex.tex',shell=True)
    call('pdfcrop tmptex.pdf',shell=True)
    call('mv tmptex-crop.pdf {0}'.format(fname.replace('tex','pdf')),shell=True)
    call(r'\rm tmptex.*',shell=True)

def tabletex_to_pdf(table_string):
    '''Given the string of a tex formatted table, make a .pdf of that table.'''

    template = Template(
r'''\documentclass[8 pt]{extarticle}
\usepackage{graphics,rotating,color,array,amsmath}
\pagestyle{empty}
\begin{document}
\noindent
{{ full_table }}
\end{document}''')

    f = codecs.open("tmptex.tex",'w','utf8')
    f.write(template.render(full_table=table_string))
    f.close()
    call('pdflatex tmptex.tex',shell=True)
    call('pdfcrop tmptex.pdf',shell=True)
    call('mv tmptex-crop.pdf {0}'.format(fname.replace('tex','pdf')),shell=True)
    call(r'\rm tmptex.*',shell=True)    

def dictify(wordVec):
    '''Turn a word list into a word,count hash.'''
    thedict = dict()
    for word in wordVec:
        thedict[word] = 1
    return thedict

def listify(long_string,lang="en"):
    """Make a list of words from a string."""

    replaceStrings = ["---","--","''"]
    for replaceString in replaceStrings:
        long_string = long_string.replace(replaceString," ")
    words = [x.lower() for x in findall(r"[\w\@\#\'\&\]\*\-\/\[\=\;]+",long_string,flags=UNICODE)]

    return words

def dictify_general(something,my_dict,lang="en"):
    """Take either a list of words or a string, return word dict.

    Pass an empty dict if you want a new one to be made."""

    # check if it's already a list
    if not type(something) == list:
        something = listify(something,lang=lang)

    for word in something:
        if word in my_dict:
            my_dict[word] += 1
        else:
            my_dict[u(word)] = 1

    # return tmp_dict

def trim_dict(my_dict,num):
    """Keep only the top `num` words in the dict.

    Generates a list of all words to be deleted (not memory efficient)."""

    all_counts = [my_dict[word] for word in my_dict]
    all_counts.sort(reverse=True)
    min_count = all_counts[num]
    # doing this in batches would be better...
    del_list = []
    for word in my_dict:
        if my_dict[word] <= min_count:
            del_list.append(word)
    for word in del_list:
        del(my_dict[word])



