" =============================================================================
" Filename: plugin/external.vim
" Author: itchyny
" License: MIT License
" Last Change: 2014/12/14 00:51:14.
" =============================================================================

if exists('g:loaded_external') || v:version < 700
  finish
endif
let g:loaded_external = 1

let s:save_cpo = &cpo
set cpo&vim

inoremap <silent> <Plug>(external-editor) <ESC>:call external#editor()<CR>
nnoremap <silent> <Plug>(external-editor) :<C-u>call external#editor()<CR>
vnoremap <silent> <Plug>(external-editor) :<C-u>call external#editor()<CR>

inoremap <silent> <Plug>(external-explorer) <ESC>:call external#explorer()<CR>
nnoremap <silent> <Plug>(external-explorer) :<C-u>call external#explorer()<CR>
vnoremap <silent> <Plug>(external-explorer) :<C-u>call external#explorer()<CR>

inoremap <silent> <Plug>(external-browser) <ESC>:call external#browser()<CR>
nnoremap <silent> <Plug>(external-browser) :<C-u>call external#browser()<CR>
vnoremap <silent> <Plug>(external-browser) :<C-u>call external#browser(external#get_text('v'))<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
