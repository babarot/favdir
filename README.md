# Description

*This is a shell script that allows you to save and jump to commonly used directories. Now supports tab completion.  
Please try it for a day, and you will find it very effective.*

*This script was made ​​by fork from [bashmark](https://github.com/b4b4r07/bashmark). The bashmark has supported only bash. This time, the favdir will also support zsh not only bash.*

# Features

* a special directory bookmarker on bash and zsh like web browser
* supports 3.2 or more bash version
* supports 5.0.2 or more zsh version

# Installation

**Enable favdir.sh requires restart your bash**

## Git install

You can clone the repository wherever you want. I like to keep it in `~/github/favdir`.

	git clone https://github.com/b4b4r07/favdir.git && cd favdir && ./install.sh

To update, cd into your local dotfiles repository and then:

	git pull origin master

## Git-free install

To install these dotfiles without Git:

	cd; wget -O - https://github.com/b4b4r07/favdir/tarball/master | tar xvf -

To update later on, just run that command again.

# Usage

If you install this script, you will be able to run the following command.

Once you have to be troubled in how to use this script, it is recommended that you type the following command.

	$ favdir

By doing so, the use of all commands will be displayed on the screen.

### show - display your bookmark

	$ show
	bin            ~/.local/bin
	work           ~/work

### reg - save 

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

### go - jump to registered directories

	$ pwd
	/home/testuser
	$ go abc
	$ pwd
	/home/testuser/work/myproject

### p - print to registered directories (look like 'go' command)

	$ p bin
	/home/testuser/.local/bin

### del

	$ del myproject abc
	$ show
	bin            ~/.local/bin
	work           ~/work

# Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07's Qiita](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |

# Licence

> The MIT License (MIT)
> 
> Copyright (c) 2014 b4b4r07
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
