doctype

html
  head
    title "Webpack Workflow"
    meta (:charset utf-8)
    script (:defer)
      :src (@ main)
  body
    textarea#input.left
      :autofocus true
      :placeholder "\\ (x) y\n\nCommand Enter\t--\trun\nOption Enter\t--\tcompile"
    textarea#output.right
      :placeholder "logs"
      :placeholder "function (x) {\n  return y;\n}\n\nCompiled."
