# ParadoxTableBrowser
Browse paradox table data and save it to .csv file. No need of BDE. Using pxlib (http://pxlib.sourceforge.net/).

Compilation instructions:

Windows: Lazarus, fpc trunk, win32 compiler (pxlib.dll is 32 bit)

Linux: Lazarus, fpc trunc, x86_64 compiler. pxlib-0.6.8.tar.gz (compiled via make), https://sourceforge.net/projects/pxlib/files/pxlib/0.6.8/

Requirenmets: Please, install paradox table component into lazarus IDE. Component is into {YOUR_FPCUP_FOLDER}/lazarus/components/paradox, and lazdbexport, before loading of a project.

If you need a different code page convertaion, you can handle by replacing a " CP1251ToUTF8( S ) " with a proper code page convertion function into umain.pas.

Please, compile the project with a paradox.pp from the project dir, because of the "Short integer" bug, which is fixed by me into this file.
