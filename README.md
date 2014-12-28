# FavDir - favorite directories
====

## Overview

Save favorite directories and jump to it.

## Description

The `favdir.sh` is a plugin that save your favorite directorie and jump to it. If you have deep directory structure having a directory in a lower-level layer of a directory, this plugin exerts great power. Saving preliminarily, easily refer to that directory. First of all, try to experience.

![](http://cl.ly/image/2l1R1E3Z1H1P/favdir.gif)

It was heavily inspired by [bashmark](https://github.com/b4b4r07/bashmark) and the likes.

## Requirement

Tested in both.

- Bash 3.2
- Zsh 5.0.2

## Usage

If you install this script, you will be able to run the following command.

Once you have to be troubled in how to use this script, it is recommended that you type the following command.

	$ favdir

By doing so, the use of all commands will be displayed on the screen.

### reg

	$ reg [name]

Register current directory path as `{name}`. If `{name}` is omitted, `{name}` is set current directory name.

	$ pwd
	/home/testuser/work/myproject
	$ reg
	$ show
	bin            ~/.local/bin
	work           ~/work
	myproject      ~/work/myproject
	$ reg abc
	bin            ~/.local/bin
	work           ~/work
	myproject      ~/work/myproject
	abc            ~/work/myproject

### show

	$ show [name]

Output `g:favdir_filepath`. If `{name}` is not omitted, show filepath of `{name}`.

	$ show
	bin            ~/.local/bin
	work           ~/work
	
### gg

	$ gg name

Jump to `{name}` if `{name}`'s path is available.

	$ pwd
	/home/testuser
	$ gg abc
	$ pwd
	/home/testuser/work/myproject

### del

	$ del name...

Delete the `{name}`s from favdir's filelist.

	$ del myproject abc
	$ show
	bin            ~/.local/bin
	work           ~/work

### p

	$ p name

Print `{name}`'path

	$ p bin
	/home/testuser/.local/bin
	
## Installation

Download favdir.sh by git

	git clone https://github.com/b4b4r07/favdir.git

Put something like this in your `$HOME/.bashrc` or `$HOME/.zshrc`:

	source /path/to/favdir.sh

## Licence

>Copyright (c) 2014 "BABAROT" b4b4r07
>Licensed under the [MIT](http://opensource.org/licenses/MIT) license.

## Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07](http://github.com/b4b4r07/ "b4b4r07 on GitHub") |

## See also

The favdir written in Vim script.

- [vim-favdir](https://github.com/b4b4r07/vim-favdir)
