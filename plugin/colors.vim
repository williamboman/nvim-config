colorscheme aurora

hi LineNr guifg=#888888

hi rainbowcol1 guifg=#EBCB8B
hi Search guibg=#B48EAD
hi IncSearch guifg=#B48EAD

hi GitSignsAdd guifg=#A3BE8C gui=none
hi GitSignsChange guifg=#5E81AC gui=none
hi GitSignsDelete guifg=#BF616A gui=none

hi Comment guifg=#888888
hi Pmenu guibg=#3A3E47

hi LspDiagnosticsVirtualTextError guifg=#BF616A gui=italic
hi LspDiagnosticsVirtualTextWarning guifg=#D7BA7D gui=italic
hi LspDiagnosticsVirtualTextInformation guifg=#B48EAD gui=italic
hi LspDiagnosticsVirtualTextHint guifg=#B48EAD gui=italic

hi LspDiagnosticsUnderlineError guibg=#BF616A gui=underline,bold
hi LspDiagnosticsUnderlineWarning gui=underline,bold
hi LspDiagnosticsUnderlineInformation gui=underline
hi LspDiagnosticsUnderlineHint gui=underline

hi LspDiagnosticsFloatingError guifg=#BF616A
hi LspDiagnosticsFloatingWarning guifg=#D7BA7D
hi LspDiagnosticsFloatingInformation guifg=#B48EAD
hi LspDiagnosticsFloatingHint guifg=#B48EAD

hi def link LspReferenceText CursorLine
hi def link LspReferenceRead CursorLine
hi def link LspReferenceWrite CursorLine

hi MatchParen guifg=#EBCB8B gui=bold,underline

hi TabLine guibg=#1B1F28 guifg=#D8DEE9
hi TabLineFill guibg=#1B1F28
hi TabLineSel guibg=#88C0D0 guifg=#232731

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
hi TelescopeMatching gui=underline guifg=#569CD6

hi TreesitterContext gui=bold guifg=#354154

" highlight yanked text
au TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=200 }

" highlight trailing whitespace
hi ExtraneousWhitespace guibg=red
match ExtraneousWhitespace /\(\s\+$\| \)/
autocmd BufWinEnter,CursorMovedI * highlight ExtraneousWhitespace ctermbg=red
