" =============================================================================
" Filename: autoload/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/03/13 00:24:24.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix') || has('guimacvim'))
let s:gedit = executable('gedit')
let s:nautilus = executable('nautilus')
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

let &cpo = s:save_cpo
unlet s:save_cpo
