; Injects Go language into template syntax
(text) @injection.content
  (#set! injection.language "go")
  (#match? @injection.content "{{.*}}")

; Injects JavaScript into <script> tags
(script_element
  (raw_text) @injection.content
  (#set! injection.language "javascript"))

; Injects CSS into <style> tags
(style_element
  (raw_text) @injection.content
  (#set! injection.language "css"))
