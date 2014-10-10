favdir
====

**Overview**

Save favorite directories and jump to it

## Description

The `favdir.sh` is a plugin that save your favorite directorie and jump to it. If you have deep directory structure having a directory in a lower-level layer of a directory, this plugin exerts great power. Saving preliminarily, easily refer to that directory. First of all, try to experience.

![](http://cl.ly/image/2l1R1E3Z1H1P/favdir.gif)

## Requirement

either

- Bash 3.2+
- Zsh 5.0.2+

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

Put `favdir.sh` under `$PATH`.

### Git install

You can clone the repository wherever you want. I like to keep it in `~/github/favdir`.

	git clone https://github.com/b4b4r07/favdir.git && cd favdir && ./install.sh

To update, cd into your local dotfiles repository and then:

	git pull origin master

### Git-free install

To install these dotfiles without Git:

	cd; wget -O - https://github.com/b4b4r07/favdir/tarball/master | tar xvf -

To update later on, just run that command again.

## Licence

>The MIT License ([MIT](http://opensource.org/licenses/MIT))
>
>Copyright (c) 2014 b4b4r07
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07](http://github.com/b4b4r07/ "b4b4r07 on GitHub") |

## See also

- [vim-favdir](https://github.com/b4b4r07/vim-favdir)
