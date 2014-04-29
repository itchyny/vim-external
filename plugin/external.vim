" =============================================================================
" Filename: plugin/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/04/29 12:19:11.
" =============================================================================

if exists('g:loaded_external') && g:loaded_external
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

inoremap <silent> <Plug>(external-editor) <ESC>:call external#editor()<CR>
nnoremap <silent> <Plug>(external-editor) :call external#editor()<CR>
vnoremap <silent> <Plug>(external-editor) :call external#editor()<CR>

inoremap <silent> <Plug>(external-explorer) <ESC>:call external#explorer()<CR>
nnoremap <silent> <Plug>(external-explorer) :call external#explorer()<CR>
vnoremap <silent> <Plug>(external-explorer) :call external#explorer()<CR>

inoremap <silent> <Plug>(external-browser) <ESC>:call external#browser('i')<CR>
nnoremap <silent> <Plug>(external-browser) :call external#browser('n')<CR>
vnoremap <silent> <Plug>(external-browser) :call external#browser('v')<CR>

let g:loaded_external = 1

let &cpo = s:save_cpo
unlet s:save_cpo
