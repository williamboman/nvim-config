colorscheme aurora

" =======================================
" colorscheme overrides
" =======================================
hi LineNr guifg=#888888

hi SpellBad gui=undercurl cterm=undercurl

hi rainbowcol1 guifg=#EBCB8B
hi Search guibg=#B48EAD
hi IncSearch guifg=#B48EAD

hi GitSignsAdd guifg=#A3BE8C gui=none
hi GitSignsChange guifg=#5E81AC gui=none
hi GitSignsDelete guifg=#BF616A gui=none

hi Comment guifg=#888888

hi DiagnosticVirtualTextError guifg=#BF616A gui=italic
hi DiagnosticVirtualTextWarn guifg=#D7BA7D gui=italic
hi DiagnosticVirtualTextInfo guifg=#B48EAD gui=italic
hi DiagnosticVirtualTextHint guifg=#B48EAD gui=italic

hi DiagnosticUnderlineError guisp=#BF616A gui=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn guisp=#D7BA7D gui=undercurl cterm=undercurl
hi DiagnosticUnderlineInfo guisp=#676767 gui=undercurl cterm=undercurl
hi DiagnosticUnderlineHint guisp=#676767 gui=undercurl cterm=undercurl

hi DiagnosticFloatingError guifg=#BF616A
hi DiagnosticFloatingWarn guifg=#D7BA7D
hi DiagnosticFloatingInfo guifg=#676767
hi DiagnosticFloatingHint guifg=#676767

hi MatchParen guifg=#EBCB8B gui=bold,underline

hi TabLine guibg=#1B1F28 guifg=#D8DEE9
hi TabLineFill guibg=#1B1F28
hi TabLineSel guibg=#88C0D0 guifg=#232731 gui=italic
hi TabNum gui=bold guifg=#D8DEE9 guibg=#1B1F28
hi TabNumSel gui=bold guifg=#8FBCBB guibg=#232731

hi TSType guifg=#88C0D0
hi TSTag guifg=#81A1C1
hi TSBoolean guifg=#569CD6 gui=italic
hi TSConstBuiltin guifg=#569CD6 gui=italic
hi TSConstant guifg=#B48EAD
hi TSConstructor gui=bold
hi TSProperty guifg=#8FBCBB
hi TSMethod guifg=#8FBCBB

hi VimspectorBreakpoint guifg=#BF616A
hi VimspectorBreakpointCond guifg=#EBCB8B
hi link VimspectorBreakpointDisabled LineNr
hi VimspectorProgramCounter guifg=#569CD6
hi VimspectorProgramCounterBreakpoint guifg=#569CD6
hi VimspectorProgramCounterLine guibg=#354154

hi clear TelescopeMatching
hi TelescopeMatching gui=inverse guifg=#B48EAD

hi IndentBlanklineChar guifg=#2f2f2f

hi OffscreenMatchPopup gui=underline guisp=#777777 guibg=#282c34

hi CopilotSuggestion gui=undercurl guisp=#777777

hi LualineGitAdd guifg=#A3BE8C guibg=#262a35
hi LualineGitChange guifg=#5E81AC guibg=#262a35
hi LualineGitDelete guifg=#BF616A guibg=#262a35
" =======================================
" end
" =======================================

" highlight yanked text
au TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=200 }

" highlight trailing whitespace
hi ExtraneousWhitespace guibg=red
match ExtraneousWhitespace /\(\s\+$\| \)/
autocmd BufWinEnter,CursorMovedI * highlight ExtraneousWhitespace ctermbg=red
