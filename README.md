# processing-3-mode

A minimalist major mode for Processing 3, leveraging the [p3 command line tools.](https://github.com/processing/processing/wiki/Command-Line)
It provides convenient access to compiler features and some basic development 
niceties, such as p3-aware keyword font locking.


## Installation 

The mode requires Processing 3 with CLI tools enabled. [For more
information on those, read the official documentation.](https://github.com/processing/processing/wiki/Command-Line)

Until the package is published on melpa, I recommend using [straight.el](https://github.com/raxod502/straight.el).

If you want p3-mode to automatically start when opening `.pde` files, 
add the following snippet to your init file.

```elisp
(add-to-list 'auto-mode-alist '("\\.pde$" . p3-mode))
```


## Customization

You can enable any of the flags supported by `processing-java`.

| Flag                                 | Values                                            |
| ---                                  | ---                                               |
| `processing-3-no-java`               | `nil` (default), `t`                              |
| `processing-3-force`                 | `nil` (default), `t`                              |
| `processing-3-platform`              | `nil` (default), `'linux`, `'macosx`, `'windows`  |
| `processing-3-compile-key`           | `'run` (default), `'build`, `'present`, `'export` |


## Keymap

The following keybindings are provided out of the box.

| Function                | Keymap    |
| ---                     | ---       |
| run                     | `C-c C-r` |
| build                   | `C-c C-b` |
| present                 | `C-c C-p` |
| export                  | `C-c C-e` |
| compile-cmd             | `C-c C-c` |

`compile-cmd` (`C-c C-c`) is meant as a convenience bind to whatever build function you use the most. 
It is controlled by `processing-3-compile-cmd` and defaults to `'run`.


## Limitations

* Unlike ptrv’s processing-mode, processing-3-mode does not currently come with Company support nor snippets.
* It is not a fork off, or comparable with, ptrv’s richer [processing2-mode](https://github.com/ptrv/processing2-emacs).
* The mode does not explicitly interact with Processing’s sketchbook, which means you can run .pde files freely on the file system, pre-supposing that you follow their limitations (a sketch has to have a valid file name, mirrored in its dir).
* There is currently no way to install libraries from the cli tool, and thus no way to do that from within Emacs.
* Outputting to a directory other than the current one is not supported.
* There is only support for running Processing in Java mode (I could make it a minor mode for `processeing-mode` comparability, if that would be of use to anyone, open an issue!).
