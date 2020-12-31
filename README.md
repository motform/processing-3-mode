# processing-3-mode

A very simple major mode for Processing 3, using the p3 command line tools. 
It is not based of ptrv’s far more sophisticated [processing2-mode](https://github.com/ptrv/processing2-emacs),
as it was not to keen on working with Processing 3. 


## Installation 

The mode requires Processing 3 with CLI tools enabled. [For more
information on those, read the official documentation.](https://github.com/processing/processing/wiki/Command-Line)

Until the package is published on melpa, I recommend using [straight.el](https://github.com/raxod502/straight.el).


## Customization

If you want p3-mode to automatically start when opening `.pde` files, 
add the following snippet to your init file.

```elisp
(add-to-list 'auto-mode-alist '("\\.pde$" . p3-mode))
```


## Keymap

The default keymap prefix is `C-c C-p`.

The following keybindings are provided out of the box.

| Function                | Keymap      |
| ---                     | ---         |
| Run                     | `C-c C-p r` |
| Compile                 | `C-c C-p b` |
| Build                   | `C-c C-p p` |
| Present                 | `C-c C-p e` |

## Limitations

* Unlike ptrv’s processing-mode, processing-3-mode does not currently come with Company support nor snippets.
* The mode does not explicitly interact with Processing’s sketchbook, which means you can run .pde files freely on the file system, pre-supposing that you follow their limitations (a sketch has to have a valid file name, mirrored in its dir).
* There is currently no way to install libraries from the cli tool, and thus no way to do that from within Emacs.
* Outputting to a directory other than the current one is not supported.
* There is only support for running Processing in Java mode (I could make it a minor mode for `processeing-mode` comparability, if that would be of use to anyone, open an issue!).
