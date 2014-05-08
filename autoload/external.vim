" =============================================================================
" Filename: autoload/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/05/08 14:57:27.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix') || has('guimacvim'))
let s:gedit = executable('gedit')
let s:nautilus = executable('nautilus')
let s:xdgopen = executable('xdg-open')
let s:bg = s:iswin ? '' : ' &'

function! external#editor()
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
    silent! call system(cmd . fnameescape(expand('%:p')) . s:bg)
  endif
endfunction

function! external#explorer()
  let path = expand('%:p:h')
  let file = expand('%:p')
  let select = ''
  if s:ismac
    let cmd = 'open -a Finder '
    if isdirectory(path) && filereadable(file)
      let select = ' -R ' . fnameescape(file)
    endif
  elseif s:iswin
    let cmd = 'start '
  elseif s:nautilus
    let cmd = 'nautilus '
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd  . (select == '' ? fnameescape(path) : select) . s:bg)
  endif
endfunction

function! external#browser(mode)
  let text = a:mode ==# 'n' ? s:get_url() : s:get_text()
  let text = text !=# '' ? text : expand('<cword>')
  if text !~ '^\%(https\?\|ftp\|git\):\/\/'
    let text = 'http://google.com/search?q=' . substitute(text, '\n$', '', '')
  endif
  if s:ismac
    let cmd = 'open ''' . text . ''''
  elseif s:iswin
    let cmd = 'cmd /c start "" "' . text . '"'
  elseif s:xdgopen
    let cmd = 'xdg-open ''' . text . ''''
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd . s:bg)
  endif
endfunction

let s:re_url =
      \'\%(\%(h\?ttps\?\|ftp\|git\):\/\/\|git@github.com:\)\%('
      \.'[&:#*@~%_\-=?/.0-9A-Za-z]*'
      \.'\%(([&:#*@~%_\-=?/.0-9A-Za-z]*)\)\?'
      \.'\%({\%([&:#*@~%_\-=?/.0-9A-Za-z]*\|{[&:#*@~%_\-=?/.0-9A-Za-z]*}\)}\)\?'
      \.'\%(\[[&:#*@~%_\-=?/.0-9A-Za-z]*\]\)\?'
      \.'\)*[/0-9A-Za-z]*\%(:\d\d*\/\?\)\?'
function! s:get_url() "{{{
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
