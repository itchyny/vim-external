" =============================================================================
" Filename: autoload/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/10/04 00:51:06.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix'))
let s:gedit = executable('gedit')
let s:nautilus = executable('nautilus')
let s:xdgopen = executable('xdg-open')
let s:bg = s:iswin ? '' : ' &'

let s:editor = s:ismac ? 'open -a TextEdit ' : s:iswin ?  'notepad ' : s:gedit ?  'gedit ' : ''
function! external#editor(...) abort
  let file = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  if s:editor !=# '' && filereadable(file)
    silent! call system(s:editor . shellescape(file) . s:bg)
  endif
endfunction

let s:explorer = s:ismac ? 'open -a Finder ' : s:iswin ?  'explorer ' : s:nautilus ?  'nautilus ' : ''
function! external#explorer(...) abort
  let file = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  let path = fnamemodify(file, ':h')
  let select = ''
  if isdirectory(path) && filereadable(file)
    let select = (s:ismac ? ' -R ' : s:iswin ? ' /SELECT,' : '') . shellescape(file)
  endif
  if s:explorer !=# ''
    silent! call system(s:explorer  . (select ==# '' ? shellescape(path) : select) . s:bg)
  endif
endfunction

let s:browser = s:ismac ? 'open ' : s:iswin ?  'cmd /c start "" ' : s:xdgopen ?  'xdg-open ' : ''
function! external#browser(...) abort
  let text = a:0 ? a:1 : external#get_text()
  if text ==# ''
    return
  endif
  if text !~# '\m\c^\%(https\?\|ftp\|git\|file\):\/\/'
    let text = 'http://google.com/search?q=' . text
  endif
  if s:browser !=# ''
    silent! call system(s:browser . shellescape(text) . s:bg)
  endif
endfunction

function! external#get_text(...) abort
  if get(a:000, 0, 'n') ==# 'v'
    let text = substitute(substitute(s:get_text(), '[\n\r]\+', ' ', 'g'), '^\s*\|\s*$', '', 'g')
  else
    let text = s:get_url()
  endif
  let text = text !=# '' ? text : expand('<cword>')
  return text
endfunction

function! external#url_pattern() abort
  return  '\m\c\%(\%(h\?ttps\?\|ftp\|file\|ssh\|git\):\/\/\|[a-z]\+@[a-z]\+.[a-z]\+:\)\%('
        \.'\%([&:#*@~%_\-=?!+;/.0-9A-Za-z]*\%(\%([.,][&:#*@~%_\-=?!+;/0-9A-Za-z]\+\)\+\|\%(:\d\+\)\?\)\)\?'
        \.'\%(([&:#*@~%_\-=?!+;/.0-9A-Za-z]*)\)\?'
        \.'\%({\%([&:#*@~%_\-=?!+;/.0-9A-Za-z]*\|{[&:#*@~%_\-=?!+;/.0-9A-Za-z]*}\)}\)\?'
        \.'\%(\[[&:#*@~%_\-=?!+;/.0-9A-Za-z]*\]\)\?'
        \.'\)*[-/0-9A-Za-z]*'
endfunction

function! s:get_url() abort
  let line = getline('.')
  let col = col('.')
  let left = col <=# 1 ? '' : line[: col-2]
  let right = line[col-1 :]
  let re = '[-(){}[\]&:#*@~%_\-=?!+;/.,0-9A-Za-z]\+'
  let str = matchstr(left, re . '$') . matchstr(right, '^[- \\\t#()[\]{}<>"'':;,+=*/@%]*' . re)
  let pattern = get(g:, 'external_url_pattern', external#url_pattern())
  let url = substitute(matchstr(str, pattern), '!!!$', '', '')
  if url =~? '\m\c^ttp:\/\/'
    let url = 'h' . url
  elseif url =~? '\m\c^\%(ssh:\/\/\)\?git@github.com:'
    let url = 'https://github.com/' . substitute(url, '^\%(ssh:\/\/\)\?git@github.com:\d*\/\?\|\.git$', '', 'g')
  endif
  return url
endfunction

" The following function was copied from vital.vim, which is NYSL (almost public domain).
function! s:get_text() abort
  let save_z = getreg('z', 1)
  let save_z_type = getregtype('z')
  try
    normal! gv"zy
    return @z
  finally
    call setreg('z', save_z, save_z_type)
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
