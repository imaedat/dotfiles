#!/usr/bin/env gosh

(use rfc.http)
(use sxml.ssax)
(use sxml.sxpath)
;(http-proxy "proxy.example.com:8080")

(define dejizo-server "public.dejizo.jp")
(define search-path "/NetDicV09.asmx/SearchDicItemLite")
(define get-path "/NetDicV09.asmx/GetDicItemLite")
(define e->j "EJdict")
(define j->e "EdictJE")

(define-constant immutable-params
                 '((Scope "HEADWORD") (Match "EXACT") (Merge "AND") (Prof "XHTML") (PageSize 100) (PageIndex 0)))

(define get-word-id-list
  (lambda (word)
    (let ([dict (if (rxmatch #/^[a-zA-Z]/ word) e->j j->e)])
      (let-values ([(status header body)
                    (http-get dejizo-server `(,search-path (Dic ,dict) (Word ,word) ,@immutable-params))])
                  (let* ([sbody (ssax:xml->sxml (open-input-string body) '())]
                         [id-list ((sxpath '(// http://btonic.est.co.jp/NetDic/NetDicV09:ItemID *text*)) sbody)])
                    (values dict #?=id-list))))))

(define get-translation
  (lambda (dict word-id)
    (let-values ([(status header body)
                  (http-get dejizo-server `(,get-path (Dic ,dict) (Item ,word-id) (Loc "") (Prof "XHTML")))])
                (let ([sbody (ssax:xml->sxml (open-input-string body) '())])
                  (if (string=? dict e->j)
                    ;; 英和の場合は最後の div
                    (last ((sxpath '(// div *text*)) sbody))
                    ;; 和英の場合は //Body/div/div/div の階層に複数並んでいる
                    (string-join
                      (map (lambda (sxml)
                             (let ([text ((sxpath '(*text*)) sxml)])
                               (if (pair? text) (car text) "")))
                           ((sxpath '(// http://btonic.est.co.jp/NetDic/NetDicV09:Body div div div)) sbody))
                      "\n" 'infix))))))
                    ;(fold-right
                    ;  (lambda (sxml knil)
                    ;    (let* ([text ((sxpath '(*text*)) sxml)]
                    ;           [str (if (pair? text) (car text) "")])
                    ;      #"~|str|\n~|knil|")) ""
                    ;  ((sxpath '(// http://btonic.est.co.jp/NetDic/NetDicV09:Body div div div)) sbody)))))))

(define main
  (lambda (args)
    (let ([word (cadr args)])
      (let-values ([(dict id-list) (get-word-id-list word)])
                  (for-each (cut $ print $ get-translation dict <>) id-list)))))
