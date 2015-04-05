
require :./layout.css
var
  cirru $ require :cirru-script
  input $ document.getElementById :input
  output $ document.getElementById :output

input.addEventListener :keydown $ \ (event)
  switch event.keyCode
    13
      if (or event.ctrlKey event.metaKey) $ do
        event.preventDefault
        compile true
        return undefined

      if event.altKey $ do
        event.preventDefault
        compile false
        return undefined

      if (not event.shiftKey event.altKey) $ do
        event.preventDefault
        manualLineBreak

var
  compile $ \ (isRun)
    var (code input.value)
    try
      do
        var $ js
          cirru.compile code (object (:relativePath :eval))
        = output.value js
        if isRun
          do $ chrome.devtools.inspectedWindow.eval js $ \ (response err)
            if (? err) $ do
              = output.value $ + ":Runtime Error:\n\n" err.value
      error
        var $ log ":Compile Error:\n\n"
        = log $ + log error
        = output.value log

var
  formatLine $ \ (several)
    var
      results $ several.map (\ (x) $ JSON.stringify x)
    return $ results.join ":, "

  formatRes $ \ (res)
    var
      results $ res.map formatLine
    return $ results.join ":\n"

  getHeadSpace $ \ (text head)
    if (is (. text 0) ": ")
      do $ return $ getHeadSpace (text.substr 1) (+ head ": ")
      do $ return head

  manualLineBreak $ \ ()
    var
      start input.selectionStart
      code input.value
      before $ code.substr 0 start
      after $ code.substr start
      lines $ before.split ":\n"
      lastLine $ . lines $ - lines.length 1
      headSpace $ getHeadSpace lastLine :

    = input.value $ + before ":\n" headSpace after
    = input.selectionStart $ = input.selectionEnd $ + start headSpace.length 1
