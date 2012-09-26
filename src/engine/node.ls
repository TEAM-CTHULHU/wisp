(import fs "fs")
(import [rest] "../list")
(import [read-from-string] "../reader")
(import [compile-program] "../compiler")


(defn transpile
  [source uri]
  (str (compile-program
        ;; Wrap program body into a list in order to to read
        ;; all of it.
        (rest (read-from-string (str "(do " source ")") uri))) "\n"))

;; Register `.ls` file extension so that `ls`
;; modules can be simply required.
(set! (get require.extensions ".ls")
  (fn [module uri]
    (._compile module
               (transpile (.read-file-sync fs uri :utf8))
               uri)))

(export transpile)