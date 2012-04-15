" Vim syntax file
" Language:	po (gettext)
" Maintainer:	Dwayne Bailey <dwayne@translate.org.za>
" Patchedby:	Sung-Hyun Nam <namsh@kldp.org>
" Last Change:	2008 Jan 08
" Contributors: Dwayne Bailey (Most advanced syntax highlighting)
"               Leonardo Fontenelle (Spell checking)
"               Nam SungHyun <namsh@kldp.org> (Original maintainer)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn sync minlines=10

" Identifiers
syn match  poStatementMsgCTxt "^msgctxt"
syn match  poStatementMsgidplural "^msgid_plural" contained
syn match  poPluralCaseN "[0-9]" contained
syn match  poStatementMsgstr "^msgstr\(\[[0-9]\]\)" contains=poPluralCaseN

" Simple HTML and XML highlighting
syn match  poHtml "<\_[^<>]\+>" contains=poHtmlTranslatables,poLineBreak
syn match  poHtmlNot +"<[^<]\+>"+ms=s+1,me=e-1
syn region poHtmlTranslatables start=+\(abbr\|alt\|content\|summary\|standby\|title\)=\\"+ms=e-1 end=+\\"+ contained contains=@Spell
syn match poLineBreak +"\n"+ contained

" Translation blocks
syn region     poMsgCTxt	matchgroup=poStatementMsgCTxt start=+^msgctxt "+rs=e-1 matchgroup=poStringCTxt end=+^msgid "+me=s-1 contains=poStringCTxt
syn region     poMsgID	matchgroup=poStatementMsgid start=+^msgid "+rs=e-1 matchgroup=poStringID end=+^msgstr\(\|\[[\]0\[]\]\) "+me=s-1 contains=poStringID,poStatementMsgidplural,poStatementMsgid
syn region     poMsgSTR	matchgroup=poStatementMsgstr start=+^msgstr\(\|\[[\]0\[]\]\) "+rs=e-1 matchgroup=poStringSTR end=+\n\n+me=s-1 contains=poStringSTR,poStatementMsgstr
syn region poStringCTxt	start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region poStringID	start=+"+ skip=+\\\\\|\\"+ end=+"+ contained 
                            \ contains=poSpecial,poFormat,poCommentKDE,poPluralKDE,poKDEdesktopFile,poHtml,poAcceleratorId,poHtmlNot,poVariable
syn region poStringSTR	start=+"+ skip=+\\\\\|\\"+ end=+"+ contained 
                            \ contains=@Spell,poSpecial,poFormat,poHeaderItem,poCommentKDEError,poHeaderUndefined,poPluralKDEError,poMsguniqError,poKDEdesktopFile,poHtml,poAcceleratorStr,poHtmlNot,poVariable

" Header and Copyright
syn match     poHeaderItem "\(Project-Id-Version\|Report-Msgid-Bugs-To\|POT-Creation-Date\|PO-Revision-Date\|Last-Translator\|Language-Team\|MIME-Version\|Content-Type\|Content-Transfer-Encoding\|Plural-Forms\|X-Generator\): " contained
syn match     poHeaderUndefined "\(PACKAGE VERSION\|YEAR-MO-DA HO:MI+ZONE\|FULL NAME <EMAIL@ADDRESS>\|LANGUAGE <LL@li.org>\|CHARSET\|ENCODING\|INTEGER\|EXPRESSION\)" contained
syn match     poCopyrightUnset "SOME DESCRIPTIVE TITLE\|FIRST AUTHOR <EMAIL@ADDRESS>, YEAR\|Copyright (C) YEAR Free Software Foundation, Inc\|YEAR THE PACKAGE\'S COPYRIGHT HOLDER\|PACKAGE" contained

" Translation comment block including: translator comment, automatic coments, flags and locations
syn match     poComment "^#.*$"
syn keyword   poFlagFuzzy fuzzy contained
syn match     poCommentTranslator "^# .*$" contains=poCopyrightUnset
syn match     poCommentAutomatic "^#\..*$" 
syn match     poCommentSources	"^#:.*$"
syn match     poCommentFlags "^#,.*$" contains=poFlagFuzzy

" Translations (also includes header fields as they appear in a translation msgstr)
syn region poCommentKDE	  start=+"_: +ms=s+1 end="\\n" end="\"\n^msgstr"me=s-1 contained
syn region poCommentKDEError  start=+"\(\|\s\+\)_:+ms=s+1 end="\\n" end=+"\n\n+me=s-1 contained
syn match  poPluralKDE   +"_n: +ms=s+1 contained
syn region poPluralKDEError   start=+"\(\|\s\+\)_n:+ms=s+1 end="\"\n\n"me=s-1 contained
syn match  poSpecial	contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match  poFormat	"%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([diuoxXfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match  poFormat	"%%" contained

" msguniq and msgcat conflicts
syn region poMsguniqError matchgroup=poMsguniqErrorMarkers  start="#-#-#-#-#"  end='#\("\n"\|\)-\("\n"\|\)#\("\n"\|\)-\("\n"\|\)#\("\n"\|\)-\("\n"\|\)#\("\n"\|\)-\("\n"\|\)#\("\n"\|\)\\n' contained

" Obsolete messages
syn match poObsolete "^#\~.*$" 

" KDE Name= handling
syn match poKDEdesktopFile "\"\(Name\|Comment\|GenericName\|Description\|Keywords\|About\)="ms=s+1,me=e-1

" Accelerator keys - this messes up if the preceding or following char is a multibyte unicode char
syn match poAcceleratorId  contained "[^&_~][&_~]\(\a\|\d\)[^:]"ms=s+1,me=e-1 
syn match poAcceleratorStr  contained "[^&_~][&_~]\(\a\|\d\)[^:]"ms=s+1,me=e-1 contains=@Spell

" Variables simple
syn match poVariable contained "%\d"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_po_syn_inits")
  if version < 508
    let did_po_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink poCommentSources    PreProc
  HiLink poComment	     Comment
  HiLink poCommentAutomatic  Comment
  HiLink poCommentTranslator Comment
  HiLink poCommentFlags      Special
  HiLink poCopyrightUnset    Todo
  HiLink poFlagFuzzy         Todo
  HiLink poObsolete         Comment

  HiLink poStatementMsgid   Statement
  HiLink poStatementMsgstr  Statement
  HiLink poStatementMsgidplural  Statement
  HiLink poStatementMsgCTxt Statement
  HiLink poPluralCaseN      Constant

  HiLink poStringCTxt	    Comment
  HiLink poStringID	    String
  HiLink poStringSTR	    String
  HiLink poCommentKDE       Comment
  HiLink poCommentKDEError  Error
  HiLink poPluralKDE        Comment
  HiLink poPluralKDEError   Error
  HiLink poHeaderItem       Identifier
  HiLink poHeaderUndefined  Todo
  HiLink poKDEdesktopFile   Identifier

  HiLink poHtml              Identifier
  HiLink poHtmlNot           String
  HiLink poHtmlTranslatables String
  HiLink poLineBreak         String

  HiLink poFormat	    poSpecial
  HiLink poSpecial	    Special
  HiLink poAcceleratorId    Special
  HiLink poAcceleratorStr   Special
  HiLink poVariable         Special

  HiLink poMsguniqError        Special
  HiLink poMsguniqErrorMarkers Comment

  delcommand HiLink
endif

let b:current_syntax = "po"

" vim:set ts=8 sts=2 sw=2 noet:

"
" ###########
"


" po.vimrc: VIM resource for 'po' file editing.

set   com=
set   path=.,..,../src,,

" find a non-translated msg string
nmap,fm :call FindNonTransMsg()<CR>z.
imap<C-G> <ESC>:call FindNonTransMsg()<CR>z.$i

" find fuzzy and remove
nmap,ff :call FindFuzzyErase()<CR>

" duplicate the original msg.
nmap,fd }?^msgstr<CR>f"ld}?^msgid<CR>f"ly/^msgstr<CR>nf"pNf"l

" erase the translated message
nmap,fe }?^msgstr<CR>f"lc}"<ESC>

" perform language dependent checks on strings
nmap,fc :!msgfmt --check %<CR>

" show statistics
nmap,fs :!msgfmt --statistics %<CR>

" commit current file
nmap,ci :!cvs ci -m '' %<LEFT><LEFT><LEFT>

" goto file which contains the current string
nmap,gf  {/^#: <CR>02f:l"aye0f w<C-W><C-F>:<C-R>a<CR>

function! FindNonTransMsg()
  let lnum = line(".") + 1
  let enum = line("$")
  let found = 0
  while lnum < enum
    let line = getline(lnum)
    let lnum = lnum + 1
    if line == "msgstr \"\""
      let blank = getline(lnum)
      if blank == ""
        let found = found + 1
        exec "normal " . lnum . "ggk"
        let lnum = enum
      endif
      let lnum = lnum + 1
    endif
  endwhile
  if found < 1
    echo "Cannot find non-translated msg"
  endif
endfun

func! FindFuzzyErase()
  let lnum = line(".") + 1
  let enum = line("$")
  while lnum < enum
    let line = getline(lnum)
    if line =~ "#, fuzzy"
      exec "normal " .lnum. "gg"
      if line =~ "#, fuzzy, "
	exec "normal ^ldt,"
      else
	exec "normal dd"
      endif
      /^msgstr
      exec "norm z.f\"l"
      echohl WarningMsg | echo "You may want to edit this" | echohl None
      return
    endif
    let lnum = lnum + 1
  endwhile
  echo "There's no fuzzy"
endfun

