# SML Indentation is broken on so many levels
## SML Comments
## SML let in end, if then else
fun fact x = 
let
  val y = 2
in
  y
end

should be changed to: 

fun fact x = 
  let
    val y = 2
  in
    y
  end

# vim-better-sml

> A complete interactive development environment for Standard ML

`vim-better-sml` makes working with Standard ML in Vim delightful. Compared the
SML support built-in to Vim, `vim-better-sml` has better syntax highlighting,
better indenting, and better interop with external plugins. It also has features
that set it apart, like go to definition, get type of idenifier, a built-in
REPL, and more.

Here's a quick screencast to show off some of it's best features:

[![thumbnail](sample/thumbnail.png)](https://youtu.be/Z5FsPZ5cm8Y)

- - -

The main features are:

- **Built-in REPL** (requires SML/NJ)

  Launch and control an SML/NJ REPL process from Vim. Use it to reload a file,
  rebuild your with `CM.make`, and more. Supports creating a new REPL with
  either [Neovim] terminal buffers or [Vimux] tmux panes. When using terminal
  buffers, the output is syntax highlighted!

- **Type lookup** (requires MLton)

  Reveal the type of any variable under your cursor, even those in the Basis
  Library. This works using MLton's support for [def-use] files, which are
  indices of type information about your project.

- **Jump to Definition** (requires MLton)

  Reveal the type of any variable under your cursor, even those in the Basis
  Library. This works using MLton's support for [def-use] files, which are
  indices of type information about your project.

- **Automatic Setup**

  MLton's [def-use] files are built in the background for you and kept up to
  date. You just worry about editing--if something needs to be built, we'll
  handle building it.

- **Expansive syntax highlighting**

  Corrects syntax highlighting in `*.sml` files, and adds optional concealing
  (for example, `'a` becomes `α`, and `fn` becomes `λ.`).

  Adds syntax highlighting support for many SML-related files types, including
  `*.sig`, `*.fun`, `*.cm`, `*.mlb`, `*.lex`, `*.grm`, and `*.smackspec` files.

There are also a whole host of other features to round off sharp edges in Vim's
default SML filetype support, including tweaks to how indentation works and
setting the `'iskeyword'` and `'commentstring'` settings. The best part is that
it's always improving!


## Install

1.  Install this plugin using your preferred plugin manager. For example, to
    install using [vim-plug]:

    ```vim
    Plug 'jez/vim-better-sml'
    ```

    If you're unfamiliar using Vim plugins, check out [Vim as an IDE][vim-ide]
    which will get you up to speed.

2.  Check if you're missing any dependencies:

    ```shell
    vim +SMLCheckHealth
    ```

3.  Follow the instructions in the output you see. If you see that all health
    checks are `OK`, you're all set!

4.  Otherwise, you might need to install or upgrade some tools on your system.
    In total, `vim-better-sml` depends on:

    - For the embedded REPL:
        - [Neovim], or [Vimux] with tmux
        - SML/NJ (`brew install smlnj`)
    - For language-aware features like type information and go to def:
        - MLton (`brew install mlton`)
        - (optional) [Neovim] or Vim 8 for automatically rebuilding indices
    - For showing errors alongside your code:
        - [ALE]
        - (in fact, `vim-better-sml` is not required for ALE to show SML errors)


## Quickstart

- To guide you through the setup process:
  - `:SMLCheckHealth`

<!---->

- To ask for the type of a variable:
  - `:SMLTypeQuery`
- To jump to a definition:
  - `:SMLJumpToDef`

<!---->

- To open a REPL for the current project:
  - `:SMLReplStart`
- To load (or reload) the current file or CM project:
  - `:SMLReplBuild`
- To `open` the current `structure` into the REPL top-level:
  - `:SMLReplOpen`
- To clear the screen on the REPL:
  - `:SMLReplClear`
- To set the print depth to 100 (or custom `<depth>`):
  - `:SMLReplPrintDepth [<depth>]`


## Configuration

Complete usage and configuration can be found in the help:

> [**`:help vim-better-sml`**](doc/vim-better-sml.txt).

This plugin sets up no keybindings by default. We suggest that you add these
settings to your vimrc, but feel free to change them:

```vim
augroup vimbettersml
  au!

  " ----- Keybindings -----

  au FileType sml nnoremap <silent> <buffer> <leader>t :SMLTypeQuery<CR>
  au FileType sml nnoremap <silent> <buffer> gd :SMLJumpToDef<CR>

  " open the REPL terminal buffer
  au FileType sml nnoremap <silent> <buffer> <leader>is :SMLReplStart<CR>
  " close the REPL (mnemonic: k -> kill)
  au FileType sml nnoremap <silent> <buffer> <leader>ik :SMLReplStop<CR>
  " build the project (using CM if possible)
  au FileType sml nnoremap <silent> <buffer> <leader>ib :SMLReplBuild<CR>
  " for opening a structure, not a file
  au FileType sml nnoremap <silent> <buffer> <leader>io :SMLReplOpen<CR>
  " use the current file into the REPL (even if using CM)
  au FileType sml nnoremap <silent> <buffer> <leader>iu :SMLReplUse<CR>
  " clear the REPL screen
  au FileType sml nnoremap <silent> <buffer> <leader>ic :SMLReplClear<CR>
  " set the print depth to 100
  au FileType sml nnoremap <silent> <buffer> <leader>ip :SMLReplPrintDepth<CR>

  " ----- Other settings -----

  " Uncomment to try out conceal characters
  "au FileType sml setlocal conceallevel=2

  " Uncomment to try out same-width conceal characters
  "let g:sml_greek_tyvar_show_tick = 1
augroup END
```

## Future Features

> None of these are currently in progress. If you're interested in seeing these
> worked on, let me know!

- [ ] Support Vim 8 terminal buffer for the REPL
- [ ] Make an ALE unused variable linter using def-use information
- [ ] Highlight all uses for a definition
  - Can probably do this with a quickfix window (think: vim-grepper)
- [ ] Refactoring tool
  - Rename variable under cursor, and all uses of that variable
- [ ] Support sending a visual selection to the REPL
- [ ] Refactor most functionality into a standalone language server executable
  - type of ident / go-to-def / etc.
- [ ] Make it easier to get started porting CM to MLBasis
- [ ] Generate a tags file from the def-use files

## License

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://jez.io/MIT-LICENSE.txt)

<!-- References -->

[def-use]: http://mlton.org/EmacsDefUseMode#_usage
[vim-plug]: https://github.com/junegunn/vim-plug
[vim-ide]: https://github.com/jez/vim-as-an-ide
[Neovim]: https://neovim.io
[Vimux]: https://github.com/benmills/vimux
[ALE]: https://github.com/w0rp/ale
