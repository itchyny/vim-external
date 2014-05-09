" =============================================================================
" Filename: autoload/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/05/09 09:17:37.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix') || has('guimacvim'))
let s:gedit = executable('gedit')
let s:nautilus = executable('nautilus')
let s:xdgopen = executable('xdg-open')
let s:bg = s:iswin ? '' : ' &'

function! external#editor(...)
  let file = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  if s:ismac
    let cmd = 'open -a TextEdit '
  elseif s:iswin
    let cmd = 'notepad '
  elseif s:gedit
    let cmd = 'gedit '
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd . shellescape(file) . s:bg)
  endif
endfunction

function! external#explorer(...)
  let file = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  let path = fnamemodify(file, ':h')
  let select = ''
  if s:ismac
    let cmd = 'open -a Finder '
    if isdirectory(path) && filereadable(file)
      let select = ' -R ' . shellescape(file)
    endif
  elseif s:iswin
    let cmd = 'start '
  elseif s:nautilus
    let cmd = 'nautilus '
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd  . (select == '' ? shellescape(path) : select) . s:bg)
  endif
endfunction

function! external#browser(...)
  let text = a:0 ? a:1 : external#get_text()
  if text == ''
    return
  endif
  if text !~ '^\%(https\?\|ftp\|git\):\/\/'
    let text = 'http://google.com/search?q=' . text
  endif
  if s:ismac
    let cmd = 'open '
  elseif s:iswin
    let cmd = 'cmd /c start "" '
  elseif s:xdgopen
    let cmd = 'xdg-open '
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd . shellescape(text) . s:bg)
  endif
endfunction

function! external#get_text(...)
  if get(a:000, 0, 'n') ==# 'v'
    let text = substitute(substitute(s:get_text(), '[\n\r]\+', ' ', 'g'), '^\s*\|\s*$', '', 'g')
  else
    let text = s:get_url()
  endif
  let text = text !=# '' ? text : expand('<cword>')
  return text
endfunction

let s:re_url =
      \'\%(\%(h\?ttps\?\|ftp\|git\):\/\/\|git@github.com:\)\%('
      \.'[&:#*@~%_\-=?/.0-9A-Za-z]*'
      \.'\%(([&:#*@~%_\-=?/.0-9A-Za-z]*)\)\?'
      \.'\%({\%([&:#*@~%_\-=?/.0-9A-Za-z]*\|{[&:#*@~%_\-=?/.0-9A-Za-z]*}\)}\)\?'
      \.'\%(\[[&:#*@~%_\-=?/.0-9A-Za-z]*\]\)\?'
      \.'\)*[/0-9A-Za-z]*\%(:\d\d*\/\?\)\?'
function! s:get_url()
  let line = getline('.')
  let col = col('.')
  let left = col <=# 1 ? '' : line[: col-2]
  let right = line[col-1 :]
  let re = '[-(){}[\]&:#*@~%_\-=?/.0-9A-Za-z]\+'
  let str = matchstr(left, re . '$') . matchstr(right, '^[- \\\t#()[\]{}<>":;,+=*/@]*' . re)
  let url = matchstr(str, s:re_url)
  if url =~ '^ttp:\/\/'
    let url = 'h' . url
  elseif url =~ '^git@github.com:'
    let url = 'https://github.com/' . substitute(url, '^git@github.com:\|\.git$', '', 'g')
  endif
  return url
endfunction

" The following function was copied from vital.vim, which is NYSL (almost public domain).
function! s:get_text()
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
