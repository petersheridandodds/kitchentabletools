from subprocess import call
from datetime import datetime
from matplotlib.pyplot import savefig
from jinja2 import Template

def pdftile(options,pdf_array,title_array,title):
    '''Light wrapper around pdftile.pl, to combine pdf files!'''
    # example call:
    # ~/work/2015/08-kitchentabletools/pdftile.pl 4 2 .3 3 3 l 10 "" "" MPQA-+1-LIWC-all-bin.pdf "" blank.pdf "" MPQA--1-LIWC-all-bin.pdf "" blank.pdf "" MPQA-+1-Liu-all-bin.pdf "" LIWC-+1-Liu-all-bin.pdf "" MPQA--1-Liu-all-bin.pdf "" LIWC--1-Liu-all-bin.pdf lower-right-vertical
    # pdftile m n widthfrac hspacepts vspacepts f fontsize maintitle title1 fig1.pdf [title2 fig2.pdf ...] outfile
    file_list = " ".join(map(lambda x: " ".join(x),zip(title_array,pdf_array)))
    command = "~/work/2015/08-kitchentabletools/pdftile.pl {0} {1} {2}".format(options,file_list,title)
    call(command)
    # print(command)
    # pdftile('4 2 .3 3 3 l 10 ""',['pdfone','pdftwo',],['titleone','titletwo',],'mytitle')
    # ~/work/2015/08-kitchentabletools/pdftile.pl 4 2 .3 3 3 l 10 "" pdfone titleone pdftwo titletwo mytitle

def tabletile(options,pdf_array,title_array,title):
    '''Light wrapper around tabletile.pl, to combine .tex tables into a bigger table.'''
    # example call to tabletile.pl
    # ~/work/2015/08-kitchentabletools/tabletile.pl 4 2 .3 1 1 "p{4cm}" 10 "" "" MPQA-+1-LIWC-all-bin.pdf "" blank.pdf "" MPQA--1-LIWC-all-bin.pdf "" blank.pdf "" MPQA-+1-Liu-all-bin.pdf "" LIWC-+1-Liu-all-bin.pdf "" MPQA--1-Liu-all-bin.pdf "" LIWC--1-Liu-all-bin.pdf lower-right-vertical
    # notice there is just one extra input
    file_list = " ".join(map(lambda x: " ".join(x),zip(title_array,pdf_array)))
    command = "~/work/2015/08-kitchentabletools/tabletile.pl {0} {1} {2}".format(options,file_list,title)
    call(command)

def crop_shift_top(pdffile):
    '''Given a shift pdf, crop the top off.

    See pdfcrop-specific.pl for a more general version.'''
    
    command = "gs -o {0}-topcropped.pdf -sDEVICE=pdfwrite -c \"[/CropBox [0 0 800 425]\" -c \" /PAGES pdfmark\" -f {0}.pdf".format(pdffile.replace(".pdf",""))
    # 477

    call($command,shell=True)

    return "{0}-topcropped.pdf".format(pdffile.replace(".pdf",""))

def mysavefig(name,date=True):
    '''Save a figure with timestamp.'''
    if date:
        now = datetime.now()
        savefig("{0}-{1}".format(now.strftime("%Y-%m-%d-%H-%M"),name),bbox_inches='tight')
        call("echo {0}-{1} | pbcopy".format(now.strftime("%Y-%m-%d-%H-%M"),name),shell=True)
        call("open {0}-{1}".format(now.strftime("%Y-%m-%d-%H-%M"),name),shell=True)
    else:
        savefig("{0}".format(name),bbox_inches='tight')

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
