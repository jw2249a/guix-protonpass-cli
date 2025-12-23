(define-module (jw2249a packages password-utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)      
  #:use-module (ice-9 match)
  #:use-module (nonguix licenses)
  #:use-module (nonguix build-system binary))

(define-public protonpass-cli
  (package
    (name "protonpass-cli")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri
        (string-append "https://proton.me/download/pass-cli/"
                       version "/pass-cli" (match (or (%current-target-system) (%current-system))
                         ("x86_64-linux" "-linux-x86_64") ; x86_64 does not have any special indication
                         ("aarch64-linux" "linux-aarch64")
                         ;; We should provide a default case.
                         (_ "unsupported"))))
       (file-name "pass-cli")
       (sha256
        (base32
         (match (or (%current-target-system) (%current-system))
           ("x86_64-linux" "07dss990ffaslvdwhh22pgq12iqa2hbbl09bh53f0jiyvpb4mcaz")
           ("aarch64-linux" "0p004fa8qxrm36kxq52cggqnkicik13bsgiyxls0ba10hinv16f3")
           ;; We need a valid base case for base32
           (_ "0000000000000000000000000000000000000000000000000000"))))))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan
       '(("./pass-cli" "bin/"))
       #:patchelf-plan
       '(("pass-cli"
	  ("glibc" "gcc:lib")))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chmod
           (lambda _
             (chmod "pass-cli" #o755))))))
     (inputs
      `(("gcc:lib" ,gcc "lib")
	("glibc" ,glibc)))
    (synopsis
     "Currently in Beta. Proton Pass CLI allows you to manage your Proton Pass vaults and items from the command line.")    
    (description
     "With the CLI, you can create, list, view, and delete vaults and items seamlessly, making it an great tool for developers and system administrators who prefer working in the command line.")
    (home-page "protonpass.github.io/pass-cli/")
    (license (nonfree ""))))
