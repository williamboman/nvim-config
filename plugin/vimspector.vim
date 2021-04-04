func! AddToWatch()
    let word = expand("<cexpr>")
    call vimspector#AddWatch(word)
endfunction

function! JestStrategy(cmd)
    let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
    call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
endfunction

let g:test#custom_strategies = {'jest': function('JestStrategy')}
nnoremap <leader>dd :TestNearest -strategy=jest<CR>

let g:vimspector_sign_priority = {
  \    'vimspectorBP':         11,
  \    'vimspectorBPCond':     11,
  \    'vimspectorBPDisabled': 11,
  \    'vimspectorPC':         11,
  \ }

nnoremap <leader>dA :call vimspector#Launch()<CR>
nnoremap <leader>dr :call vimspector#Restart()<CR>
nnoremap <leader>dX :call vimspector#Reset()<CR>

nnoremap <leader>dk :call vimspector#StepOut()<CR>
nnoremap <leader>dl :call vimspector#StepOver()<CR>
nnoremap <leader>dj :call vimspector#StepInto()<CR>

nnoremap <leader>dc :call vimspector#Continue()<CR>
nnoremap <leader>d. :call vimspector#RunToCursor()<CR>

nnoremap <leader>da :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dL :call vimspector#ListBreakpoints()<CR>
nnoremap <leader>db :call vimspector#ToggleConditionalBreakpoint()<CR>
nnoremap <leader>dx :call vimspector#ClearBreakpoints()<CR>

nnoremap <leader>d? :call AddToWatch()<CR>
