command! -buffer MarkdownPreview silent !npx marked "%" | base64 -w0 | awk '{print "data:text/html;base64," $0}' | xargs "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
