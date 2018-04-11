set nocompatible              " be iMproved, required
filetype off                  " required

let s:rtpath='/opt/vim-bundle/bundles'
" set the runtime path to include Vundle and initialize
"set rtp+=/opt/vim-bundle/bundles/Vundle.vim
let &rtp.=',' . s:rtpath . '/Vundle.vim'

if !empty(glob(s:rtpath . '/Vundle.vim'))
call vundle#begin(s:rtpath)

Plugin 'VundleVim/Vundle.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'WolfgangMehner/bash-support'
Plugin 'WolfgangMehner/lua-support'
Plugin 'WolfgangMehner/perl-support'
Plugin 'WolfgangMehner/awk-support'
"Plugin 'WolfgangMehner/c-support' "load slow
Plugin 'WolfgangMehner/python-support'
"Plugin 'WolfgangMehner/git-support' "load slow
Plugin 'WolfgangMehner/vim-do'
Plugin 'winmanager'
"Plugin 'taglist.vim'
"Plugin 'cscope.vim'
Plugin 'bufexplorer.zip'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tomasr/molokai'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'syntastic'
Plugin 'l9' "for vim-autocomplpop
Plugin 'othree/vim-autocomplpop'
Plugin 'bronson/vim-visual-star-search'
"Plugin 'ervandew/supertab'
Plugin 'diabloneo/cscope_maps.vim'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'nelsyeung/twig.vim'
Plugin 'yggdroot/indentline'
"Plugin 'wincent/command-t' "need ruby
Plugin 'tomtom/tcomment_vim'
"Plugin 'junegunn/vim-easy-align'
call vundle#end() 
endif

"filetype plugin indent on     " required!

set backspace=indent,eol,start

"set nocp   " 禁止兼容模式
set history=20  " 历史纪录
set ruler		" show the cursor position all the time
set cursorline  " 当前行加下划线
set showcmd		" display incomplete commands
set incsearch   " do incremental searching
set nobackup    " 关闭备份
set shiftwidth=4 " 取消缩进
set cinoptions=(0,:0
set expandtab   " tab转换为空格
set tabstop=4   " 缩进
set uc=0        " do not use swap file when editing
set nu          " 显示行号
set hid         " 不保存可以切换buffer
set ignorecase  " 搜索时忽略大小写
set smartcase   " 搜索模式包含大写字符不使用ignorecase
set magic       " 设置正则表达式中.*不用转义
set showmatch   " 显示配置到括号
set nowb        " 写入前备份 
set noswapfile  " 不使用swp文件
set ai          " 自动缩进
set si          " 智能缩进
set laststatus=2 " 显示状态栏
if has('syntax')
set fdl=0       " 折叠层级
set fdc=0       " 折叠宽度
set fdm=syntax  " 折叠方式
"set fdm=indent
set foldenable  " 启用代码折叠
set foldopen-=search    " 搜索时打开折叠
set foldopen-=undo      " 恢复时打开折叠
endif
"set autochdir   " 自动切换当前目录为当前文件所在的目录
set showmatch   " 插入括号时，短暂地跳转到匹配的对应括号
set clipboard=unnamed "剪贴板名称
"set mouse=a  " use mouse everywhere
set encoding=utf-8      " 字符编码
set fileencoding=utf-8  " 文件编码
set fileencodings=ucs-bom,utf-8,gbk,gb2312,chinese  " 用于检测的文件编码
set shortmess=atI
set lazyredraw  

if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if has("autocmd")
    filetype plugin indent on
    autocmd FileType text setlocal tabstop=4
    autocmd FileType text setlocal textwidth=78
    autocmd FileType html setlocal shiftwidth=2
    autocmd FileType xml  setlocal shiftwidth=2
    autocmd FileType make setlocal noexpandtab
else
    set autoindent		" always set autoindenting on
endif

if has("gui_running")
    set guifont=Monaco\ 9
    colorscheme railscasts
else
    set t_Co=256
    "colorscheme blue
    "colorscheme darkblue
    "colorscheme default
    "let g:molokai_original = 1
    "let g:rehash256 = 1
    if !empty(glob(s:rtpath . '/molokai'))
        colorscheme molokai
    endif
endif
"settings for bash_support
let g:BASH_GlobalTemplateFile = ''
let g:BASH_LocalTemplateFile  = ''
let g:BASH_CustomTemplateFile = ''
"settings for taglist
nnoremap <silent> <F6> :TlistToggle<CR>
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window=1
let Tlist_WinWidth = 25

"settings for tagbar
nnoremap <silent> <F5> :TagbarToggle<CR>
let g:tagbar_width = 25

"settings for minibuffer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
"settings for autocomplpop
let g:AutoComplPop_NotEnableAtStartup = 1

"winmanager
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
map <c-w><c-t> :WMToggle<cr> 

nnoremap <silent> <F2> :WMToggle<CR>
"nnoremap <silent> <F3> :FirstExplorerWindow<CR>
"nnoremap <silent> <F4> :BottomExplorerWindow<CR>
"nnoremap <silent> <F7> :bf<CR>
nnoremap <silent> <F3> :bp<CR>
nnoremap <silent> <F4> :bn<CR>
let g:winManagerWidth = 25

"map <F6> <C-W><C-W>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

set pastetoggle=<F9>

ab bh BufExplorerHorizontalSplit
ab bv BufExplorerVerticalSplit

"settings for cscope
if has("cscope")
    set cst
endif


"""""""""""""""""""""""""""""""
" TAGS
"""""""""""""""""""""""""""""""
set tags=tags,.tags

"let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
"let g:DoxygenToolkit_paramTag_pre="@Param "
"let g:DoxygenToolkit_returnTag="@Returns   "
"let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
"let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
"let g:DoxygenToolkit_authorName=""
"let g:DoxygenToolkit_licenseTag=""
"let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1

nnoremap <silent> <F8> :IndentLinesToggle<CR>
let g:indentLine_color_term = 239
let g:indentLine_char = '|'
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_loc_list_height = 3

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = ''
let g:airline#extensions#whitespace#trailing_format = '%s'
let g:airline#extensions#whitespace#mixed_indent_format = '[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = '{%s}'
let g:airline#extensions#whitespace#show_message = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline_section_c="%t"

"let g:airline_left_sep = '>'
"let g:airline_right_sep = '<'

"vnoremap <silent> <Enter> :EasyAlign<cr>
let g:acp_enableAtStartup = 0

let g:go_fmt_autosave = 0
let g:go_asmfmt_autosave = 0
