" =============================================================================
" Filename: plugin/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/03/13 00:26:33.
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

let g:loaded_external = 1

let &cpo = s:save_cpo
unlet s:save_cpo
