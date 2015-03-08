
require :./layout.css
= cirru $ require :cirru-script

= input $ document.getElementById :input
= output $ document.getElementById :output

input.addEventListener :keydown $ \ (event)
  switch event.keyCode
    13
      if (or event.ctrlKey event.metaKey)
        do
          event.preventDefault
          compile true
          return undefined
      if event.altKey
        do
          event.preventDefault
          compile false
          return undefined

= compile $ \ (isRun)
  = code input.value
  try
    do
      = res $ cirru.compile code (object (:relativePath :eval))
      = output.value res.js
      if isRun
        do $ chrome.devtools.inspectedWindow.eval res.js $ \ (res err)
          if (? err)
            do
              = output.value err.value
    , error
    do
      = log ":Compile error:\n\n"
      = log $ ++: log error
      console.log error
      = output.value log


= formatLine $ \ (several)
  = results $ several.map (\ (x) $ JSON.stringify x)
  return $ results.join ":, "

= formatRes $ \ (res)
  = results $ res.map formatLine
  return $ results.join ":\n"
