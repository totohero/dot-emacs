;; 작성: 임성택

(server-start)

(when noninteractive
  (setq load-path (remove-duplicates (remove-if-not #'file-exists-p load-path)
                                     :test #'string-equal))
  (defadvice command-line (around prohibit-init-file-load activate)
    (flet ((user-login-name () nil))
      ad-do-it)))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacswikicode"))

(dolist (p (list
	    ""
	    "emhacks"
	    "llvm"
            "rscope-master"))
  (add-to-list 'load-path (expand-file-name (concat "~/.emacs.d/site-lisp/" p))))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/my-lisp"))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when nil
  (load
   (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(setq Info-additional-directory-list
      '("~/.emacs.d/my-info"))

;; byte-compile .emacs after saving
(when nil
  (defun byte-compile-init-file ()
    (when (equal user-init-file buffer-file-name)
      (when (file-exists-p (concat user-init-file ".elc"))
	(delete-file (concat user-init-file ".elc")))
      (byte-compile-file user-init-file)))

  (add-hook 'after-save-hook 'byte-compile-init-file))

;; mark된 region을 눈으로 확인할 수 있게 한다.
(transient-mark-mode t)

;; 매치되는 괄호를 보여준다.
(show-paren-mode 1)

;; 매치되는 괄호가 화면에 없는 경우, 해당 라인을 미니버퍼에 보여준다.
;; (defadvice show-paren-function (after show-matching-paren-offscreen
;;                                       activate)
;;   "If the matching paren is offscreen, show the matching line in the                              
;; echo area. Has no effect if the character before point is not of                                   
;; the syntax class ')'."
;;   (interactive)
;;   (let ((matching-text nil))
;;     ;; Only call `blink-matching-open' if the character before point                               
;;     ;; is a close parentheses type character. Otherwise, there's not                               
;;     ;; really any point, and `blink-matching-open' would just echo                                 
;;     ;; "Mismatched parentheses", which gets really annoying.                                       
;;     (if (char-equal (char-syntax (char-before (point))) ?\))
;;         (setq matching-text (blink-matching-open)))
;;     (if (not (null matching-text))
;;         (message matching-text))))

;; 프레임 상단 문자열에 서버 이름 및 파일 이름 보인다.
(setq frame-title-format (list "emacs@" system-name ": " '(buffer-file-name "%f" "%b")))

;; 버퍼가 외부에서 바뀌면 바로 업데이트한다.
(global-auto-revert-mode t)
 
;;(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
(when t
  (require 'bs)
  (global-set-key (kbd "C-x C-b") 'bs-show))

(when t
  (global-set-key (kbd "C-<f12>") 'calculator))

;; comment, uncomment 키
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;; 툴바 및 메뉴바를 사용하지 않는다.
(tool-bar-mode -1)
(menu-bar-mode -1)

;; 히스토리를 파일로 저장한다.
(savehist-mode t)

(recentf-mode t)
;; (when (recentf-mode t)
;;   (global-set-key (kbd "<f3>") 'recentf-open-files))
;; (when (load "recentf-buffer")
;;   (global-set-key (kbd "<f3>") 'recentf-open-files-in-simply-buffer))

;; 백업 파일을 만들지 않겠다.
(setq make-backup-files nil)

;; 스플래쉬 스크린 감춘다.
(setq inhibit-splash-screen t)

;; 윈도우즈에서 실행시에 프레임을 최대로 키운다.
(when (equal system-type 'windows-nt)
  (defun w32-maximize-frame ()
    "Maximize the current frame"
    (interactive)
    (w32-send-sys-command 61488))
 
  (add-hook 'window-setup-hook 'w32-maximize-frame t)

  ;; 프레임 크기를 원래대로 되돌리는 함수
  (defun w32-restore-frame ()
    "Restore a minimized/maximized frame"
    (interactive)
    (w32-send-sys-command 61728)))

;; shift키와 화살표키를 조합하여 윈도우 간에 이동할 수 있다.
(windmove-default-keybindings 'shift)

;; 컴파일 관련 확장 기능
;; (require 'compile+)
(require 'compile)

(setq
 compile-list
 '(
   "(cd /home/stk.lim/0-zero/buildscript && ./build -oa -teng -rXXXXXXX -mk -w 02 -d mid -A -S -T -L3 -C 3.0 zerolte_eur_open)"
   "(cd /home/stk.lim/0-dream/buildscript && ./build -oa -teng -rXXXXXXX -mk -w 00 -q -S -G dream2lte_eur_open OXA)"
   "(cd /home/stk.lim/0-setup_N/buildscript && ./build -oa -teng -r9914747 -mk hero2lte_eur_open)"
   "(cd /home/stk.lim/0-hero2/buildscript && ./build -oa -tuser -r10211359 -mk -d mid -i G935FXXU1ZPLN -j 1ZPLN -A -s -T -L3 -C 3.0 -Wf -G hero2lte_eur_open OXA)"
   "~/tmp/aosp-hero2/buildscript/build -mk -p hero2"
   "CROSS_COMPILE=/home/stk.lim/p4-1716/android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android- make -C /home/stk.lim/l-work/zero/android-uboot-exynos btype7420_aarch64_evt1"))0000000000000000
;; 	"make -C /home/stk.lim/down/irqbalance-0.56 AM_LDFLAGS=-all-static"
;; 	"make -C /home/stk.lim/ics/kernel_git clean && \
;;	 make -j16 -C /home/stk.lim/ics/kernel_git \
;;	 CROSS_COMPILE=/opt/toolchains/arm-2009q3/bin/arm-none-linux-gnueabi- \
;;	 CHECK=\"~/down/smatch/smatch -p=kernel\" C=1"
;;	"(cd ~/ics/u1/buildscript/ && ./build.sh U1_EUR_OPEN k eng 02)"

(defun my-compile ()
  "Run compile and resize the compile window"
  (interactive)
  (progn
    (compile 
     (completing-read
      "What do you want to compile? "
      compile-list) nil)
    (setq cur (selected-window))
    (setq w (get-buffer-window "*compilation*"))
    (select-window w)
    (setq h (window-height w))
    (shrink-window (- h 20))
    (select-window cur)))

(defun my-compilation-hook () 
  "Make sure that the compile window is splitting vertically"
  (progn
    (if (not (get-buffer-window "*compilation*"))
	(progn
	  (split-window-vertically)))))

(add-hook 'compilation-mode-hook 'my-compilation-hook)

(global-set-key [f7] 'my-compile)

(global-set-key (kbd "C-<f7>") 'recompile)

(global-set-key (kbd "M-<f7>") 'smart-compile)

(global-set-key [f6] (lambda () (interactive)
		       (progn
		(delete-other-windows)
		(split-window-vertically)
		(dired "."))))

(eval-after-load "compile"
  '(progn
     (setq
      compile-command (car compile-list)
      compilation-scroll-output t
      compilation-window-height 20)
     (progn
       (add-to-list 'compilation-error-regexp-alist
		    '(
		      "^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) \
: \\(?:\\(fatal \\)error\\|warnin\\(g\\)\\) [AC][0-9]+:" 2 3 nil (4)))
       (add-to-list 'compilation-error-regexp-alist ; smatch error expression
		    '("^\\([^: \t\n]+\\) \\+\\([0-9]+\\) \\([^: (\t\n]+\\)(\\([0-9]+\\)) \\(?:inf\\(o\\)\\|war\\(n\\)\\|error\\):" 1 2 nil (6 . 5))))
     (define-key compilation-mode-map (kbd "C-g") 'kill-compilation)))

;; Some code that will make it so the background color of the lines
;; that gcc found errors on, should be in another color.

(when nil
  (defun checkpatch ()
    "checkpatch current file"
    (interactive)
    (progn
      (compile (concat "checkpatch.pl --terse --emacs --no-tree -f " (buffer-file-name)))
      (setq cur (selected-window))
      (setq w (get-buffer-window "*compilation*"))
      (select-window w)
      (setq h (window-height w))
      (shrink-window (- h 20))
      (select-window cur)))

  (global-set-key (kbd "S-<f7>") 'checkpatch))

(when t
  (defun checkpatch ()
    "checkpatch current file"
    (interactive)
    (progn
      (compile (concat "(cd `git rev-parse --show-toplevel` && git show | checkpatch.pl --terse --emacs -)"))
      (setq cur (selected-window))
      (setq w (get-buffer-window "*compilation*"))
      (select-window w)
      (setq h (window-height w))
      (shrink-window (- h 20))
      (select-window cur)))

  (global-set-key (kbd "S-<f7>") 'checkpatch))

(when nil  
  (require 'custom)
  
  (defvar all-overlays ())
  
  (defun delete-this-overlay(overlay is-after begin end &optional len)
    (delete-overlay overlay))
  
  (defun highlight-current-line()
    (interactive)
    (setq current-point (point))
    (beginning-of-line)
    (setq beg (point))
    (forward-line 1)
    (setq end (point))
    ;; Create and place the overlay
    (setq error-line-overlay (make-overlay 1 1))
  
    ;; Append to list of all overlays
    (setq all-overlays (cons error-line-overlay all-overlays))
  
    (overlay-put error-line-overlay
		 'face '(background-color . "pink"))
    (overlay-put error-line-overlay
		 'modification-hooks (list 'delete-this-overlay))
    (move-overlay error-line-overlay beg end)
    (goto-char current-point))
  
  (defun delete-all-overlays()
    (while all-overlays
      (delete-overlay (car all-overlays))
      (setq all-overlays (cdr all-overlays))))
  
  (defun highlight-error-lines(compilation-buffer, process-result)
    (interactive)
    (delete-all-overlays)
    (condition-case nil
	(while t
	  (next-error)
	  (highlight-current-line))
      (error nil)))
  
  (setq compilation-finish-function 'highlight-error-lines))

;;(eval-after-load "vc" '(require 'vc+))

;;(eval-after-load "vc" '(require 'vc-hg+))

;; 윈도우즈에서 실행시에 clearcase 관련 기능 설정
(when (equal system-type 'windows-nt)
  ;; clearcase 관련 기능
  (when nil (require 'clearcase))

  (when nil
    (progn
      (require 'vc-clearcase+)
      ;;(load "vc-clearcase-auto")
      (setq clearcase-checkout-comment-type 'none)
      (setq clearcase-checkout-policy 'unreserved)
      (defun ctdiffr ()
	"Find any difference with ClearCase VOB"
	(interactive)
	(progn
	  (let((buf-name "*diffr*"))
	    (if (get-buffer buf-name)
		(kill-buffer buf-name) t)
	    ;;    (cdp)
	    (start-process "ctdiff" buf-name "ctdiff.bat" "-r")
	    (switch-to-buffer buf-name)
	    (diff-mode))))
      (defun ctdiff ()
	"Find any difference with predecessor"
	(interactive)
	(progn
	  (let((buf-name "*diff*"))
	    (if (get-buffer buf-name)
		(kill-buffer buf-name) 'very-false)
	    (start-process "ctdiff" buf-name "ctdiff.bat" (buffer-name))
	    (split-window)
	    (switch-to-buffer buf-name)
	    (diff-mode)))))))

(when t
  (defun hgdiffr()
    "Find any difference with Mercurial Repo"
    (interactive)
    (progn
      (let((buf-name "*diffr*"))
	(if (get-buffer buf-name)
	    (kill-buffer buf-name) t)
	(require 'vc-hg)
	(dired (vc-hg-root default-directory))
	(start-process "hg" buf-name "hg" "diff" "-bw")
	(switch-to-buffer buf-name)
	(diff-mode))))

  (defun hgqdiffr ()
    "Find any difference with Mercurial Repo"
    (interactive)
    (progn
      (let ((buf-name "*diffr*"))
	(if (get-buffer buf-name)
	    (kill-buffer buf-name) t)
	(require ' vc-hg)
	(dired(vc-hg-root default-directory))
	(start-process "hg" buf-name "hg" "qdiff" "")
	(switch-to-buffer buf-name)
	(diff-mode))))

  (defun svndiffr()
    "Find any changes in local repo"
    (interactive)
    (progn
      (let ((buf-name "*diffr*"))
	(if (get-buffer buf-name)
	    (kill-buffer buf-name) t);; (cdb)
	(start-process "svn" buf-name "svn" "diff")
	(switch-to-buffer buf-name)
	(diff-mode)))))

;; diff 폰트 설정
(eval-after-load "diff-mode"
  '(progn
     (setq diff-default-read-only t)
     (set-face-attribute 'diff-added nil
			 :inherit 'diff-changed :foreground "blue")
     (set-face-attribute 'diff-added-face nil
			 :foreground "blue")
     (set-face-attribute 'diff-changed-face nil
			 :foreground "green")
     (set-face-attribute 'diff-file-header nil
			 :inherit 'diff-header)
     (set-face-attribute 'diff-header nil
			 ;:background "yellow" 
			 :foreground "black" :weight 'bold :family "Helv")
     (set-face-attribute 'diff-hunk-header nil
			 ;:background "grey40" 
			 :foreground "white" :weight 'bold)
     (set-face-attribute 'diff-index nil
			 :inherit 'diff-file-header)
     (set-face-attribute 'diff-removed nil
			 :inherit 'diff-changed :foreground "#ff8888")
     (set-face-attribute 'diff-removed-face nil
			 :foreground "red")))

;; VIM에서 쓰던 *, #키 비슷한 기능
(when t
  ;; (defun isearch-yank-regexp (regexp)
  ;;   "Pull REGEXP into search regexp."
  ;;   (let ((isearch-regexp nil)) ;; Dynamic binding of global.
  ;;     (isearch-yank-string regexp))
  ;;   (isearch-search-and-update))

  ;; (defun isearch-yank-symbol (&optional partialp)
  ;;   "Put symbol at current point into search string.  If PARTIALP is non-nil, find all partial matches."
  ;;   (interactive "P")
  ;;   (let* ((sym (find-tag-default))
  ;; 	   ;; Use call of `re-search-forward' by `find-tag-default' to
  ;; 	   ;; retrieve the end point of the symbol.
  ;; 	   (sym-end (match-end 0))
  ;; 	   (sym-start (- sym-end (length sym))))
  ;;     (if (null sym)
  ;; 	  (message "No symbol at point")
  ;; 	(goto-char sym-start)
  ;; 	;; For consistent behavior, restart Isearch from starting point
  ;; 	;; (or end point if using `isearch-backward') of symbol.
  ;; 	(isearch-search)
  ;; 	(if partialp
  ;; 	    (isearch-yank-string sym)
  ;; 	  (isearch-yank-regexp
  ;; 	   (concat "\\<" (regexp-quote sym) "\\>"))))))
  ;; (defun isearch-current-symbol (&optional partialp)
  ;;   "Incremental search forward with symbol under point.  Prefixed with \\[universal-argument] will find all partial
  ;; matches."
  ;;   (interactive "P")
  ;;   (let ((start (point)))
  ;;     (isearch-forward-regexp nil 1)
  ;;     (isearch-yank-symbol partialp)
  ;;     (isearch-repeat-forward)))
  ;; (defun isearch-backward-current-symbol (&optional partialp)
  ;;   "Incremental search backward with symbol under point.  Prefixed with \\[universal-argument] will find all partial
  ;; matches."
  ;;   (interactive "P")
  ;;   (let ((start (point)))
  ;;     (isearch-backward-regexp nil 1)
  ;;     (isearch-yank-symbol partialp)))
  (global-set-key (kbd "C-8") 'isearch-symbol-at-point)
  (global-set-key (kbd "C-3") 'isearch-backward-symbol-at-point)
  ;; ;; Subsequent hitting of the keys will increment to the next
  ;; ;; match--duplicating `C-s' and `C-r', respectively.
  (define-key isearch-mode-map (kbd "C-8") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-3") 'isearch-repeat-backward))

;; Windows Mobile developer's setting ^^;
(when (equal system-type 'windows-nt)
  (defun cdw ()
    "Change to _WINCEROOT directory"
    (interactive)
    (progn (dired (getenv "_WINCEROOT"))
	   (pwd)))
  (defun cdp ()
    "Change to _TARGETPLATROOT directory"
    (interactive)
    (progn (dired (getenv "_TARGETPLATROOT"))
	   (pwd)))
  (defun cdt ()
    "Change to target directory"
    (interactive)
    (progn (dired (concat
		   (getenv "_TARGETPLATROOT")
		   "\\target\\"
		   (getenv "_TGTCPU")
		   "\\"
		   (getenv "WINCEDEBUG")))
	   (pwd))))

;; DOS 배치 파일 모드
(when (autoload 'cmd-mode "cmd-mode" "CMD mode." t)
  (setq auto-mode-alist (append '(("\\.\\(cmd\\|bat\\)$" . cmd-mode))
				auto-mode-alist)))

;; ediff에서 기본적으로 좌/우로 화면 분할
(setq ediff-split-window-function 'split-window-horizontally)

;; 묻지않고 버퍼 없애기
(defun volatile-kill-buffer ()
  "Kill current buffer unconditionally."
  (interactive)
  (let ((buffer-modified-p nil))
    (kill-buffer (current-buffer))))

(global-set-key (kbd "\C-x k") 'volatile-kill-buffer)

(defun delete-window-or-bury-buffer ()
  "Close current window or bury buffer"
  (interactive)
  (condition-case nil
      (delete-window)
    (error (bury-buffer))))

(defun volatile-kill-buffer-and-window ()
  "Kill current buffer and windows unconditionally."
  (interactive)
  (let ((buffer-modified-p nil))
    (kill-buffer (current-buffer))
    (delete-window-or-bury-buffer)))

;;(global-set-key (kbd "<f4>") 'delete-window-or-bury-buffer)
;;(global-set-key (kbd "S-<f4>") 'volatile-kill-buffer)
;;(global-set-key (kbd "M-<f4>") 'volatile-kill-buffer-and-window)
(global-set-key (kbd "<f4>") 'volatile-kill-buffer-and-window)

;; 현재 버퍼를 제외하고 모든 버퍼 없애기
(defun kill-all-dired-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
	(set-buffer buffer)
	(when (equal major-mode 'dired-mode)
	  (setq count (1+ count))
	  (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count ))))

(defun kill-other-buffers ()
  (interactive)
  (dolist (b (buffer-list))
    (unless (or (eq b (current-buffer))
		(and (buffer-name b)
                     (eq ? (aref (buffer-name b) 0))))
      (kill-buffer b)))
  (delete-other-windows))

(global-set-key (kbd "C-<f4>") 'kill-other-buffers)

;; tabbar를 사용한다!
;; (when (and t (require 'tabbar nil t))
;;   (setq tabbar-buffer-groups-function
;; 	(lambda (b) (list
;; 		     ;; 1. 각 버퍼의 major mode 문자열을 그 버퍼의 첫번째 tabbar 그룹 이름으로 삼는다.
;; 		     ;;(prin1-to-string (buffer-local-value 'major-mode (get-buffer b)))
;; 		     ;; 2. 각 버퍼가 특수 버퍼인지 아닌지를 체크하여 두번째 tabbar 그룹 이름으로 삼는다.
;; 		     (cond ((let ((fc (aref b 0))) (or (char-equal fc ? ) (char-equal fc ?*)))
;; 			    "Special Buffers")
;; 			   ((eq (buffer-local-value 'major-mode (get-buffer b)) 'dired-mode)
;; 			    "Dired Buffers")
;; 			   (t "Normal Buffers")))))

;;   ;;  (setq tabbar-buffer-groups-function
;;   ;; 	 (lambda (b) (if (let ((fc (aref b 0)))
;;   ;; 			   (or (char-equal fc ? ) (char-equal fc ?*)))
;;   ;; 			 (list "Special Buffers")
;;   ;; 		       (list "Normal Buffers"))))

;;   ;; (setq tabbar-buffer-groups-function
;;   ;; 	(lambda (b) (list "All Buffers")))

;;   ;; (setq tabbar-buffer-list-function
;;   ;; 	(lambda ()
;;   ;; 	  (remove-if nil
;;   ;; 	   (lambda (buffer)
;;   ;; 	     (find (aref (buffer-name buffer) 0) " *")) ;; 버퍼 이름의 첫글자가 공백 혹은 *인지 체크한다.
;;   ;; 	   (buffer-list))))

;;   (set-face-attribute 'tabbar-default-face nil
;;   		      :background "gray80" :foreground "black")
;;   (set-face-attribute 'tabbar-unselected-face nil
;;   		      :background "grey80" :foreground "black"
;;   		      :box '(:line-width 1 :color "gray80" :style release-button))
;;   (set-face-attribute 'tabbar-selected-face nil
;;   		      :background "white" :foreground "black"
;;   		      :box '(:line-width 1 :color "gray80" :style pressed-button))
;;   (set-face-attribute 'tabbar-button-face nil
;;   		      :box '(:line-width 1 :color "gray80" :style released-button))
;;   (set-face-attribute 'tabbar-separator-face nil
;;   		      :box '(:line-width 3 :color "gray80")) ;;:height 1)
;;   (setq tabbar-cycling-scope (quote groups))
;;   (tabbar-mode)
;;   (global-set-key (kbd "<f11>") 'tabbar-backward-group)
;;   (global-set-key (kbd "<f12>") 'tabbar-forward-group)
;;   (global-set-key (kbd "<f1>") 'tabbar-backward-tab)
;;   (global-set-key (kbd "<f2>") 'tabbar-forward-tab))

(when t
  (require 'tabbar)
  (tabbar-mode)
  (global-set-key (kbd "<f11>") 'tabbar-backward-group)
  (global-set-key (kbd "<f12>") 'tabbar-forward-group)
  (global-set-key (kbd "<f1>") 'tabbar-backward-tab)
  (global-set-key (kbd "<f2>") 'tabbar-forward-tab)
  (setq tabbar-buffer-groups-function
	(lambda () (list (cond 
			  ((string-equal
			    "*"
			    (substring (buffer-name) 0 1))
			   "emacs")
			  ((eq major-mode 'dired-mode) "emacs")
			  (t "user"))))))

(when t
  (autoload 'global-replace-lines "globrep"
    "Put back grepped lines" t)
  (autoload 'global-replace "globrep"
    "query-replace across files" t)
  (autoload 'global-grep-and-replace "globrep"
    "grep and query-replace across files" t))

;; occur 버퍼에서 p, n키 정의
(when nil
  (require 'replace+)
  (global-set-key (kbd "C-c o") 'occur)
  (define-key occur-mode-map "p" '(lambda () (interactive) (occur-prev) (occur-mode-display-occurrence)))
  (define-key occur-mode-map "n" '(lambda () (interactive) (occur-next) (occur-mode-display-occurrence))))

;; w32-find-dired!
(when (equal system-type 'windows-nt)
  (require 'w32-find-dired)
  (global-set-key (kbd "C-x M-f") 'w32-find-dired))
(when (equal system-type 'gnu/linux)
  (global-set-key (kbd "C-x M-f") 'find-dired))

;; w32-findstr (kind of grep)
(when (equal system-type 'windows-nt)
  (defvar findstr-cmd-history)

  (defvar findstr-files-history)

  (defun findstr (cmd files)
    ""
    (interactive
     (progn
       (list (read-from-minibuffer "Run find using following command and string: "
				   "findstr /sni " nil nil
				   'findstr-cmd-history)
	     (read-from-minibuffer "Run find on following file patterns: "
				   "*.bat *.bib *.reg *.xml sources* makefile* *.h *.cpp *.c *.s *.inc" nil nil
				   'findstr-files-history))))
    (grep-find (concat cmd " " files)))
  (global-set-key (kbd "C-x M-g") 'findstr))

(when (equal system-type 'gnu/linux)
  (global-set-key (kbd "C-x M-g") 'grep-find))

;; backspace 동작 정의 : white space, new line, tab 모조리 지운다.
(setq backward-delete-char-untabify-method 'hungry)

;; dired 디렉토리 이름은 굵게 표시
(eval-after-load "dired"
  '(set-face-attribute 'dired-directory nil
		       :weight 'bold))

(put 'dired-find-alternate-file 'disabled nil)

;; kill ring에서 가져올 텍스트를 선택할 수 있다!
(when t
  (require 'browse-kill-ring)
  (browse-kill-ring-default-keybindings)
  (require 'browse-kill-ring+))

;; #if, #else, #endif로 빠르게 이동한다.
(when t
  (require 'if-jump nil t)
  (global-set-key [M-up]   '(lambda() (interactive) (if-jump-jump 'backward)))
  (global-set-key [M-down] '(lambda() (interactive) (if-jump-jump 'forward))))

(when nil
  (require 'if-jump-ms nil t)
  (global-set-key [M-up]   '(lambda() (interactive) (if-jump-ms-jump 'backward)))
  (global-set-key [M-down] '(lambda() (interactive) (if-jump-ms-jump 'forward))))

(when t
  (require 'org)
  ;; use org mode for .org files
  (setq auto-mode-alist (append '(("\\.org\\'" . org-mode))
				auto-mode-alist)))

(global-set-key (kbd "M-+") 'join-line)

(when t
  (defun c-set-linux-style () "" (interactive) (c-set-style "linux"))
  (add-hook 'c-mode-hook 'c-set-linux-style)
  (add-hook 'cc-mode-hook 'c-set-linux-style)
  (add-hook 'c++-mode-hook 'c-set-linux-style))

(when nil
  (defun ted-tab-dwim ()
    "If point is before the code on this line, indent this line.
 Otherwise, insert a TAB."
    (interactive)
    (let ((pivot (save-excursion (back-to-indentation) (point))))
      (if (< pivot (point))
	  ;;    (call-interactively 'self-insert-command)
	  (insert "\t")
	(call-interactively 'indent-for-tab-command))))
  ;; (global-set-key (kbd "<tab>") 'ted-tab-dwim)
  (defun my-tab-key ()
    (local-set-key [(tab)] 'ted-tab-dwim))
  (add-hook 'c-mode-hook 'my-tab-key)
  (add-hook 'cc-mode-hook 'my-tab-key)
  (add-hook 'c++-mode-hook 'my-tab-key)
  (add-hook 'text-mode-hook 'my-tab-key))
(add-hook 'emacs-lisp-mode-hook
	  '(lambda () (local-set-key (kbd "<f5>") 'eval-current-buffer)))
(add-hook 'dired-mode-hook
	  '(lambda () (local-set-key (kbd "<f5>") 'eval-current-buffer)))

(when nil
  (require 'tempbuf)
  (add-hook 'custom-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'w3-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'Man-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'view-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'log-edit-mode-hook 'turn-on-tempbuf-mode))

(when nil
  (global-set-key (kbd "<left>") '(lambda () (interactive)
				     (condition-case nil
					 (if (eq (point) (point-at-bol))
					     (signal 'beginning-of-line nil)
					   (backward-char)))))
  (global-set-key (kbd "<right>") '(lambda () (interactive)
				     (condition-case nil 
					 (if (eq (point) (point-at-eol))
					     (signal 'end-of-line nil)
					   (forward-char))))))

;;; for Smooth Scrolling
(when nil
  (setq truncate-lines t)
  (defun point-of-beginning-of-bottom-line ()
    (save-excursion
      (move-to-window-line -1)
      (point)))
  (defun next-one-line (cnt)
    "next-one-line scrolls only 1 line unlike next-line when bottom line reached"
    (interactive "p")
    (if (> cnt 1)
	(next-line cnt)
      (if (= (point-of-beginning-of-bottom-line) (point-at-bol))
	  (if (equal (point-at-eol) (point-max))
	      (next-line 1)
	    (progn (scroll-up 1)
		   (next-line 1)))
	(next-line 1))))
  (defun point-of-beginning-of-top-line ()
    (save-excursion
      (move-to-window-line 0)
      (point)))
  (defun previous-one-line () (interactive)
    "previous-one-line scrolls only 1 line unlike previous-line when top line reached"
    (if (= (point-of-beginning-of-top-line) (point-at-bol))
	(progn (scroll-down 1)
	       (previous-line 1))
      (previous-line 1)))
  (global-set-key (kbd "<down>") 'next-one-line)
  (global-set-key (kbd "<up>") 'previous-one-line))

;; Graphviz mode
(when t
  (load-library "graphviz-dot-mode")
  ;; compile & preview graph every time it's saved
  (eval-after-load "graphviz-dot-mode"
    '(progn
       (define-key graphviz-dot-mode-map (kbd "<f5>")
	 '(lambda () (interactive)
	    (progn
	      (shell-command compile-command)
	      (graphviz-dot-preview)))))))


(defun cthist2diffbat ()
  ""
  (interactive)
  (query-replace-regexp
   ".*create version \"\\(.*@@\\\\main\\\\\\)\\([0-9]+\\).*"
   (quote (replace-eval-replacement concat "call ctdiff \\1" (replace-quote (- (string-to-number (match-string 2)) 1)) " \\1\\2"))
   nil
   (if (and transient-mark-mode mark-active) (region-beginning))
   (if (and transient-mark-mode mark-active) (region-end))))

(when nil
  (defun cedet-ecb-toggle ()
    (interactive)
    (when
	(and
	 (load "cedet-1.0pre4/common/cedet.el")
	 (require 'ecb nil t))
      (if (not ecb-minor-mode)
	  (ecb-activate)
	(ecb-deactivate))))
  
  (global-set-key (kbd "<f12>") 'cedet-ecb-toggle))

;; cscope or xgtags or gtags
(when t
  (require 'xcscope+ nil t)
  (progn
    (define-key cscope-list-entry-keymap "q" 'volatile-kill-buffer-and-window)
    ;; VIM-like C-] Key
    (global-set-key (kbd "M-.") 'cscope-find-global-definition)
    (global-set-key (kbd "M-]") 'cscope-find-functions-calling-this-function)
    (global-set-key (kbd "M-}") 'cscope-find-this-symbol)
    (global-set-key (kbd "M-\"") 'cscope-find-this-text-string)

    (setq cscope-kernel-mode t)
    (setq cscope-reuse-list-file t)))

(when nil
  (require 'ascope+ nil t)
  (progn
    (define-key ascope-list-entry-keymap "q" 'volatile-kill-buffer-and-window)
    ;; VIM-like C-] Key
    (global-set-key (kbd "M-.") 'ascope-find-global-definition)
    (global-set-key (kbd "M-]") 'ascope-find-functions-calling-this-function)
    (global-set-key (kbd "M-}") 'ascope-find-this-symbol)))

(when nil
  (require 'xgtags)
  (global-set-key (kbd "M-.") 'xgtags-find-tag)
  (global-set-key (kbd "M-]") 'xgtags-find-rtag)
  (global-set-key (kbd "M-}") 'xgtags-find-symbol)
  (xgtags-mode))

(when nil
  (setq load-path (cons "d:/root/usr/local/share/gtags" load-path))
  (autoload 'gtags-mode "gtags" "" t)
  (setq c-mode-hook '(lambda () (gtags-mode 1)))

  (require 'company-mode)
  (require 'gtags)
  (require 'company-bundled-completions)

;;; gtags ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					; adapted version from gtags.el
  (defun gtags-completion-list (prefix)
    (let ((option "-c")
	  (prev-buffer (current-buffer))
	  (all-expansions nil)
	  expansion)
					; build completion list
      (set-buffer (generate-new-buffer "*Completions*"))
					;(setq option (concat option "s")))
      (call-process "global" nil t nil option prefix)
      (goto-char (point-min))
      (while (looking-at gtags-symbol-regexp)
	(setq expansion (gtags-match-string 0))
	(setq all-expansions (cons expansion all-expansions))
	(forward-line))
      (kill-buffer (current-buffer))
					; recover current buffer
      (set-buffer prev-buffer)
      all-expansions))

  (defun company-gtags-completion-func (prefix)
    (gtags-completion-list prefix))

  (defun company-grab-gtags-prefix ()
    (or (thing-at-point 'symbol) ""))

  (defun company-install-gtags-completions ()
    (dolist (mode '(c++-mode c-mode))
      (company-add-completion-rule
       mode
       'company-grab-gtags-prefix
       'company-gtags-completion-func)))

  (provide 'company-gtags-completions))

;; ;; Java mode
;; (when nil
;;   (add-hook 'java-mode-hook
;; 	    (lambda ()
;; 	      (unless (or (file-exists-p "makefile")
;; 			  (file-exists-p "Makefile"))
;; 		(set (make-local-variable 'compile-command)
;; 		     (concat "javac -g " (buffer-file-name))))))
;;   (eval-after-load "cc-mode"
;;     '(progn
;;        (define-key java-mode-map (kbd "<f11>") 'jdb))))

;; ;; use c++ mode for .h files
;; (setq auto-mode-alist (append '(("\\.h\\'" . c++-mode))
;; 			      auto-mode-alist))

;; ;; use conf mode for .bib files
;; (setq auto-mode-alist (append '(("\\.bib\\'" . conf-windows-mode))
;; 				auto-mode-alist))

;; (global-set-key (kbd "S-<f5>") 'revert-buffer)

;; (when (equal system-type 'windows-nt)
;;   (defun diffa () "compare audio driver source file with corresponding one in i210" (interactive)
;;     (ediff
;;      buffer-file-name
;;      (concat "x:/views/vibeq/MITS_VIBEQ_WM/Vibe/Src/Drivers/Wavedev"
;; 	     (car (last 
;; 		   (split-string 
;; 		    buffer-file-name
;; 		    "VibeQ"))))))

;;   (defun diffv () "compare file with corresponding one in i210" (interactive)
;;     (ediff
;;      buffer-file-name
;;      (concat "x:/views/vibeq/MITS_VIBEQ_WM/Vibe"
;; 	     (car (last 
;; 		   (split-string 
;; 		    buffer-file-name
;; 		    "MitsS3C6xxx"))))))

;;   (defun difft () "compare current file with corresponding one in Tjet" (interactive)
;;     (ediff
;;      buffer-file-name
;;      (concat "x:/views/Tjet/Tjet_LGT/SRC/SYSTEM/MitsS3C6xxx"
;; 	     (car (last 
;; 		   (split-string 
;; 		    buffer-file-name
;; 		    "MitsS3C6xxx"))))))

;;   (defun diffs () "compare current file with corresponding one in SMDK" (interactive)
;;     (ediff
;;      buffer-file-name
;;      (concat "x:/views/SMDK6410"
;; 	     (car (last 
;; 		   (split-string 
;; 		    buffer-file-name
;; 		    "MitsS3C6xxx")))))))

(when t
  (defun indent-defun () "indent current defun" (interactive)
    (mark-defun)
    (shell-command-on-region
     (region-beginning) (region-end)
     "indent -linux" t t "*Messages*" nil))
  (global-set-key (kbd "C-c C-i") 'indent-defun))

;; 소리 나는 알람 대신 메시지 사용
(when nil
  (setq alarm-counter 0)
  (setq ring-bell-function
	(lambda () (interactive)
	  (progn (setq alarm-counter (+ alarm-counter 1))
		 (message
		  (concat (case (% alarm-counter 10)
			    (1 "%dst") (2 "%dnd") (3 "%drd") (otherwise "%dth"))
			  " silent alarm") alarm-counter)))))

(setq ring-bell-function nil)

;; icicles-download.el를 사용하면 icicles library를 쉽게 다운로드 받을 수 있다. 자세한 내용은 google 검색!
(when t
  (require 'two-column)
  (require 'icicles nil t)
  (icy-mode)

  (setq icicle-test-for-remote-files-flag nil)

  ;; 최근 열어본 파일 리스트
  (global-set-key (kbd "C-x C-r") 'icicle-recent-file)
  (global-set-key (kbd "C-x C-l") 'icicle-locate-file)
  (global-set-key (kbd "<f8>") 'icicle-locate-file)

  ;; 제외할 패턴 - mercurial 메타 파일들
  (setq icicle-file-no-match-regexp ".*/\.hg/.*"))

(when nil
  (require 'helm)
  (helm-mode 1))

(require 'yasnippet nil t) ;; not yasnippet-bundle

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-fit-frame-flag nil)
 '(bmkp-last-as-first-bookmark-file "/home/stk.lim/.emacs.d/bookmarks")
 '(c++-indent-level 2)
 '(c-basic-offset 2)
 '(clearcase-use-external-diff t)
 '(cscope-do-not-update-database t)
 '(custom-safe-themes
   (quote
    ("b34636117b62837b3c0c149260dfebe12c5dad3d1177a758bb41c4b15259ed7e" default)))
 '(debug-on-error nil)
 '(ecb-options-version "2.32")
 '(ecb-tip-of-the-day nil)
 '(egg-mode-key-prefix "C-x g")
 '(enable-recursive-minibuffers t)
 '(fill-column 80)
 '(icicle-reminder-prompt-flag 0)
 '(indent-tabs-mode t)
 '(org-startup-folded nil)
 '(p4-default-diff-options "-duw")
 '(p4-my-clients
   (quote
    ("SYSTEM-SW_Kernel_stlim_ZERO-NILE_marimo" "SYSTEM-SW_Kernel_stlim_SLSI_marimo" "SYSTEM-SW_Kernel_stlim_ZERO-DEV_marimo")))
 '(paradox-automatically-star t)
 '(paradox-github-token "0c0b2addd105096a1ed466005a333c612c93da99")
 '(tail-max-size 100)
 '(track-eol t)
 '(vc-clearcase-diff-switches "-diff_format")
 '(vc-diff-switches "-bwu")
 '(vc-handled-backends (quote (RCS CVS SCCS Bzr Git Hg Arch SVN)))
 '(vc-hg-diff-switches "-bw"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :foreground "#9999ff" :weight bold))))
 '(diff-changed ((t (:foreground "blue"))))
 '(diff-header ((t (:background "white" :foreground "black" :weight bold :family "Helv"))))
 '(diff-hunk-header ((t (:inherit diff-header :background "darkred" :foreground "white" :weight bold))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red" :weight bold))))
 '(diredp-dir-priv ((t (:foreground "blue" :weight bold))))
 '(diredp-file-name ((t nil)))
 '(diredp-file-suffix ((t (:foreground "Magenta"))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light)) (:foreground "CadetBlue" :weight bold))))
 '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "Blue1" :weight bold))))
 '(font-lock-keyword-face ((((class color) (min-colors 88) (background light)) (:foreground "Purple" :weight bold))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-builtin-face :weight bold))))
 '(font-lock-type-face ((((class color) (min-colors 88) (background light)) (:foreground "ForestGreen" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (min-colors 88) (background light)) (:foreground "DarkGoldenrod" :weight bold))))
 '(info-quoted-name ((t (:inherit font-lock-constant-face)))))

(put 'set-goal-column 'disabled nil)
(put 'scroll-left 'disabled nil)

;;(color-theme-ld-dark)
;;(color-theme-vim-colors)
;;(color-theme-xp)
;;(color-theme-aliceblue)

(when nil
  ;;(set-default-font "Consolas-16")
  ;;(set-default-font "Bitstream Vera Sans Mono-20")
  ;;(set-default-font "Bitstream Vera Sans Mono-18")
  (set-fontset-font "fontset-default" '(#x1100 . #xffdc)  '("나눔고딕_코딩" . "unicode-bmp")) ;;; 유니코드 한글영역
  (set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  '("나눔고딕_코딩" . "unicode-bmp")) ;;; 유니코드 사용자 영역
  (set-fontset-font "fontset-default" 'kana '("Meiryo" . "unicode-bmp"))
  (set-fontset-font "fontset-default" 'han '("Microsoft YaHei" . "unicode-bmp")))

;; 기본 글꼴 선택
;;(insert (prin1-to-string (w32-select-font)))
;;(set-default-font "-outline-돋움체-normal-r-normal-normal-15-112-96-96-c-*-iso8859-1" t)
;;(set-default-font "-outline-굴림체-normal-r-normal-normal-15-112-96-96-c-*-iso8859-1" t)
;;(set-default-font "-outline-굴림체-normal-r-normal-normal-16-120-96-96-c-*-iso8859-1" t)
;;(set-default-font "-outline-굴림체-normal-r-normal-normal-17-127-96-96-c-*-iso8859-1" t)
;;(set-default-font "-outline-맑은 고딕-normal-r-normal-normal-16-120-96-96-p-*-iso8859-1" t)
;;(set-default-font "-outline-맑은 고딕-normal-r-normal-normal-16-120-96-96-p-*-ksc5601.1987-*" t)
;;(set-default-font "-outline-Consolas-normal-r-normal-normal-16-120-96-96-p-*-iso8859-1" t)
;;(set-default-font "-outline-Consolas-normal-r-normal-normal-20-120-96-96-p-*-iso8859-1" t)
;;(set-default-font "-microsoft-cambria-medium-r-normal--20-0-0-0-p-0-iso8859-1" t)
;;(set-default-font "-microsoft-tahoma-medium-r-normal--20-0-0-0-p-0-iso8859-1" t)
;;(set-default-font "-microsoft-candara-medium-r-normal--20-0-0-0-p-0-iso8859-1" t)
;;(set-default-font "-microsoft-constantia-medium-r-normal--20-0-0-0-p-0-iso8859-1" t)
;;(set-default-font "-microsoft-malgun gothic-medium-r-normal--18-0-0-0-p-0-iso8859-1" t)
;;(set-default-font "-microsoft-consolas-medium-r-normal--20-0-0-0-m-0-iso8859-1" t)
;;(set-default-font "-misc-nanumgothic_coding-medium-r-normal--21-0-0-0-c-0-iso10646-1" t)
;;(set-default-font "-misc-nanumgothic_coding-medium-r-normal--22-0-0-0-c-0-koi8-r" t)
(when t
  (if (equal system-type 'windows-nt)
      (set-default-font "-outline-굴림체-normal-r-normal-normal-17-127-96-96-c-*-iso8859-1" t)
    ;; (set-default-font "-outline-Consolas-normal-r-normal-normal-19-142-96-96-c-*-iso8859-1" t)
    (if (< emacs-major-version 23)
	(set-default-font "-misc-dejavu sans mono-medium-r-normal--18-0-0-0-m-0-iso8859-1" t)
      (set-default-font "Monospace-14"))))

(put 'narrow-to-region 'disabled nil)

(when nil
  (when (equal system-type 'gnu/linux)
    (defvar my-fullscreen-p t "Check if fullscreen is on or off")

    (defun my-non-fullscreen ()
      (interactive)
      (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND restore #xf120
	  (w32-send-sys-command 61728)
	(progn (set-frame-parameter nil 'width 82)
	       (set-frame-parameter nil 'fullscreen 'fullheight))))

    (defun my-fullscreen ()
      (interactive)
      (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND maximaze #xf030
	  (w32-send-sys-command 61488)
	(set-frame-parameter nil 'fullscreen 'fullboth)))

    (defun my-toggle-fullscreen ()
      (interactive)
      (setq my-fullscreen-p (not my-fullscreen-p))
      (if my-fullscreen-p
	  (my-non-fullscreen)
	(my-fullscreen)))

    (my-fullscreen)))

(when t
  (require 'auto-complete)
  (global-auto-complete-mode))

;;(filesets-init)

;;(server-start)

(when nil
  ;;(require 'vc-p4)
  (require 'p4)
  (defun p4diffr()
    "Find differences between P4 depot and workspace"
    (interactive)
    (progn
      (let((buf-name "*diffr*"))
	(if (get-buffer buf-name)
	    (kill-buffer buf-name) t)
	(start-process "p4" buf-name "p4diffr")
	(switch-to-buffer buf-name)
	(diff-mode)))))

(when (require 'idle-highlight nil t)
  (idle-highlight))

;; ;; *** BEGIN highlight checkpatch.pl warnings and errors ***
;; (add-hook 'c-mode-common-hook
;;     (lambda ()
;;       ;; this sets defaults to match many checkpatch.pl guidelines
;;       (c-set-style "linux")))
;; ;; but doesn't warn us about violations these regexp catch common ones
;; (custom-set-faces
;;     '(my-warning-face ((((class color)) (:background "red"))) t))
;; (add-hook 'font-lock-mode-hook
;;     (function
;;         (lambda ()
;;             (setq font-lock-keywords
;;                 (append font-lock-keywords
;; 		    '(("^.\\{81\\}" (0 'my-warning-face t)))
;;                     '(("\\/\\/.*" (0 'my-warning-face t)))
;;                     '((";[_A-Za-z0-9]+" (0 'my-warning-face t)))
;;                     '((",[_A-Za-z0-9]+" (0 'my-warning-face t)))
;;                     '(("return[[:blank:]]*(.+);" (0 'my-warning-face t)))
;;                     '(("([_A-Za-z0-9]+[\\*]+)" (0 'my-warning-face t)))
;;                     '(("[[:blank:]]+\)"(0 'my-warning-face t)))
;; 		    '(("^[[:blank:]]+{[[:blank:]]*$" (0 'my-warning-face t)))
;; 		    '(("[_A-Za-z0-9]+\\*[[:blank:]]" (0 'my-warning-face t)))
;; 		)))))
;; ;; exercise to reader - move regexps into c hook
;; ;; *** END highlight checkpatch.pl warnings and errors ***

(when (and (require 'vc-git nil t)
	   (require 'vc-dispatcher nil t)) ;; for vc-setup-buffer
  (defun git-show ()
    (interactive)
    (vc-setup-buffer "*git-show*")
    (vc-git-command "*git-show*" 'async nil "stash" "show" "-p" "HEAD")
    (set-buffer "*git-show*")
    (diff-mode)
    (setq buffer-read-only t)
    (let ((git-root-dir 
	   (car (split-string 
		 (shell-command-to-string "git rev-parse --show-toplevel")
		 "\n" t))))
      (if (char-equal (aref git-root-dir 0) ?/)
	  (cd git-root-dir) (message "Not valid .git directory")))
    (pop-to-buffer (current-buffer)))

  (defun git-grep (pattern)
    (interactive (list (completing-read "What to you want to grep? " nil)))
    (let ((git-root-dir 
	   (car (split-string 
		 (shell-command-to-string "git rev-parse --show-toplevel")
		 "\n" t))))
      (if (char-equal (aref git-root-dir 0) ?/)
	  ;; repeat grep here to invoke grep highlighting function
	  (grep (concat "cd " git-root-dir " && git grep -n \"" pattern "\" | grep \"" pattern "\""))
	(message "Not valid .git directory")))
    (pop-to-buffer (current-buffer))))

(setq tramp-default-method "ssh")

(when t
  (require 'egg))

;; Make *scratch* and *compilation* buffer unkillable
(when t
  (defun unkillable-buffer ()
    (if (let ((f (buffer-name (current-buffer))))
	  (or (equal f "*scratch*") (equal f "*compilation*")))
	(progn
	  ;; (delete-region (point-min) (point-max))
	  nil)
      t))

  (add-hook 'kill-buffer-query-functions 'unkillable-buffer))

(column-number-mode)

;; Recognize _ as word constituent

(when t
  (defun handle-_as-word-constituent () "" (interactive) (modify-syntax-entry ?_ "w"))
  (add-hook 'c-mode-hook 'handle-_as-word-constituent)
  (add-hook 'cc-mode-hook 'handle-_as-word-constituent)
  (add-hook 'c++-mode-hook 'handle-_as-word-constituent)
  (add-hook 'emacs-lisp-mode-hook 'handle-_as-word-constituent)
  (add-hook 'text-mode-hook 'handle-_as-word-constituent))

;; stk.lim: Pasted from llvm/utils/emacs/emacs.el
;;
(require 'llvm-mode)
(require 'tablegen-mode)

;; LLVM coding style guidelines in emacs
;; Maintainer: LLVM Team, http://llvm.org/
;; Modified:   2009-07-28

;; Max 80 cols per line, indent by two spaces, no tabs.
;; Apparently, this does not affect tabs in Makefiles.



;; Alternative to setting the global style.  Only files with "llvm" in
;; their names will automatically set to the llvm.org coding style.
(c-add-style "llvm.org"
             '((fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)
               (c-offsets-alist . ((innamespace 0)))))

(add-hook 'c-mode-hook
	  (function
	   (lambda nil 
	     (if (string-match "llvm" buffer-file-name)
		 (progn
		   (c-set-style "llvm.org")
		   )
	       ))))

(add-hook 'c++-mode-hook
	  (function
	   (lambda nil 
	     (if (string-match "llvm" buffer-file-name)
		 (progn
		   (c-set-style "llvm.org")
		   )
	       ))))

;; (desktop-save-mode 0)

(global-set-key
 (kbd "C-x C-g")
 '(lambda (pattern)
    (interactive (list (completing-read "What to you want to grep? " nil)))
    (grep (concat "grep -Rn " pattern))))

(require 'smart-compile)


(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(when (require 'p4)
  (p4-set-client-name "SYSTEM-SW_Kernel_stlim_DREAM-NILE_marimo"))

;; 2017-01-06
(load-theme 'subatomic t)
