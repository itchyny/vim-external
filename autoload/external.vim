" =============================================================================
" Filename: autoload/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/04/30 07:23:27.
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
  if s:ismac
    let cmd = 'open -a Finder .'
  elseif s:iswin
    let cmd = 'start .'
  elseif s:nautilus
    let cmd = 'nautilus .'
  else
    let cmd = ''
  endif
  if cmd !=# ''
    silent! call system(cmd . s:bg)
  endif
endfunction

function! external#browser(mode)
  if a:mode ==# 'n'
    let url = s:get_url_on_cursor()
    let url = url !=# '' ? url : expand('<cword>')
    let text = url
  else
    let text = s:get_selected_text()
  endif
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
function! s:get_url_on_cursor() "{{{
  let line = getline('.')
  let col = col('.')
  if line[col-1] !~# '\S'
    return ''
  endif
  let left = col <=# 1 ? '' : line[: col-2]
  let right = line[col-1 :]
  let nonspstr = matchstr(left, '\S\+$').matchstr(right, '^\S\+')
  let url = matchstr(nonspstr, s:re_url)
  if url =~ '^ttp:\/\/'
    let url = 'h' . url
  elseif url =~ '^git@github.com:'
    let url = 'https://github.com/' . substitute(url, '^git@github.com:\|\.git$', '', 'g')
  endif
  return url
endfunction

function! s:get_selected_text()
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
