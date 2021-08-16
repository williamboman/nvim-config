function! MyTabLine()
    let result = ""
    let index = 1
    let curtabpagenr = tabpagenr()

    while index <= tabpagenr("$")
        let winnr = tabpagewinnr(index)
        let buflist = tabpagebuflist(index)
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")
        let buftype = getbufvar(bufnr, "buftype")

        let result .= "%" .. index .. "T"
        let result .= (index == curtabpagenr ? "%1*" : "%2*")

        " tab index
        let result .= (index == curtabpagenr ? "%#TabNumSel#" : "%#TabNum#")
        if index == 1
            let result .= " " " add some extra padding before first tab
        endif
        let result .= " " .. index .. ":"

        let result .= (index == curtabpagenr ? "%#TabLineSel#" : "%#TabLine#")

        " buf name
        if buftype == "nofile" && file =~ "\/."
            let file = substitute(file, ".*\/\ze.", "", "")
        else
            let file = fnamemodify(file, ":p:t")
        endif
        if file == ""
            let file = "[A Buffer Has No Name]"
        endif

        if len(buflist) > 1
            let result .= " (" .. file .. ") "
        else
            let result .= " " .. file .. " "
        endif

        if bufmodified == 1
            let result .= "[+] "
        endif

        let index = index + 1
    endwhile
    let result .= "%T%#TabLineFill#%="
    return result
endfunction

set tabline=%!MyTabLine()
