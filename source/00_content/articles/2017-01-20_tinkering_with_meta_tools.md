# Tinkering with meta tools

If the contents of this website are of interest to you chances are that you also know how easy it is to spend large parts of one's leisure time tinkering with computer systems and _improving_ workflows while losing sight of what one actually wants to accomplish. I am going to use this article to document parts of my current personal computing setup in an attempt to summarize and refocus my efforts in this direction in addition to articulating some of my thoughts in this context.

Working with computers is my job to the extend that computers are the machines that my software developing self instructs to - hopefully - solve actual problems in _the real world™_. This means that configuring and optimizing my personal computing environments is not only a leisure time activity but can be considered a productive activity within certain boundaries[^0]. If I think of time consuming _optimization-activties_ that are definitely yielding payoff in my day to day work a few things come to mind: Learning and _mastering_ a single powerful text editor[^1], switching to an open operating system and using open source software wherever possible, using a tiling window manager, version control _everything_, maintaining a private internet archive, frequently experimenting with new programming languages and paradigms as well as studying mathematics. I am going to use the following sections to further explore some of these activities.

## Text editing

Plain text is still the most used format for expressing and storing program instructions for all common and nearly all uncommon languages out there. Although the simplicity and thus flexibility of plain text continues to cause _distracting_ discussions around topics such as _tabs-vs-spaces_[^2] there sadly are no usable alternative in the vein of e.g. generalized tree encodings available at this point in time. _S-Expressions_ could probably be used as a foundation for such an alternative but alas we don't live in the alternative time line where the adoption of a [_LISP_ as the internet's scripting language](https://brendaneich.com/2008/04/popularity/) instead of the quickly hacked together _thing_ that is _JavaScript_ caused a widespread rise of _LISP-like_ languages culminating in all common languages being _LISP-dialects_ and thus being expressible in _sexprs_.

To return the topic at hand: plain text it is and will continue to be for the foreseeable future. If one looks for powerful, widely available and extensible text editors the choice will in most cases come down to the still reigning giants _Vim_ and _Emacs_ [^3].  
When I stood before this decision nearly _half a lifetime ago_[^4] my choice fell on _Vim_. If one only considers the default editing interface this definitely was the right choice for me as I would not trade _Vim's_ modal text manipulation _language_ for overly long default _Emacs_ key chords. But I have to admit that I regularly take wistful looks at some of the applications available inside _Emacs_ such as _Org-mode_. Had I already discovered the joys of _LISP_ when I was trying to decide between the two editors I probably would have chosen _Emacs_. Luckily one can always alter such decisions - sooner or later I will probably settle on some kind of _Evil_ based setup just to be able to use the text based operating system that is _Emacs_.

![a Vim session in its natural environment](https://static.kummerlaender.eu/media/tinkering_with_meta_tools_screen_001.png)

Altough the 122 lines including comments that currently make up most of my _Vim_ [configuration](https://code.kummerlaender.eu/dotfiles/tree/vim/.vimrc) are not much by most standards I have invested quite some time in setting the editor up to my taste - not the least by writing my very [own color scheme](https://code.kummerlaender.eu/dotfiles/tree/vim/.vim/colors/akr.vim) to match the rest of my primary desktop environment.  

Over time I have [grown so accustomed](https://www.norfolkwinters.com/vim-creep/) to _Vim's_ keybindings that I now use them wherever possible including but not restricted to: my web browser, [PDF reader](https://pwmt.org/projects/zathura/), various IDEs, [image viewer](https://github.com/muennich/sxiv) and window manager of choice.

## Operating system and desktop environment

_ArchLinux_ continues to be the Linux distribution of choice for most of my computing devices. It offers most of the flexibility of _Gentoo_ if one needs it while preserving fast installation and frequent updates of most of the software I require. The only feature I currently miss and that will probably lead me switch distributions sooner or later is declarative package management as offered by [NixOS] or [GuixSD]. A fully declarative configuration of my Linux installation in a plain-text and thus easily version controllable file would be the logical conclusion of my current efforts in managing system configurations: `/etc` is tracked using [etckeeper], various [dotfiles] are tracked using plain git and [GNU stow] for symlink management.

![Example of a basic i3 session](https://static.kummerlaender.eu/media/tinkering_with_meta_tools_screen_002.png)

My choice of desktop environment has converged on a custom setup built around the _i3_ tiling window manager over the last couple of years. I have adopted the tiling concept to such a degree that I struggle to think of a single advantage a common - purely floating - window manager might hold over tiling window managers. This holds especially true if your workflow is similar to mine, i.e. you have lots and lots of terminals and a few full screen applications running at most times as well as a fondness for using the keyboard instead of shoving around a mouse.

![More complex unstaged example of a i3 session](https://static.kummerlaender.eu/media/tinkering_with_meta_tools_screen_003.png)

What I like about _i3_ in particular is that it doesn't enforce a set of layouts to toggle between like some other tiling WMs but allows you full control over the tree structure representing its layout. Another nice feature is that it lends itself to _Vim-style_ keybindings as well as offering good support for multi monitor setups.

Compared to a desktop environment such as _KDE_ a custom setup built around a window manager obviously requires much more configuration. In exchange for that I gained full control over my workflow in addition to basically instantaneous interaction with the system and its applications.

I find it very useful to have a certain set of information available at all times. Examples for such information are dictionary definitions, language and framework documentation, login credentials and notes. For this purpose I wrote a set of scripts that enable me to query a local [dict] daemon[^5], note folders and [passman] entries using the `dmenu`-replacement [Rofi]. In addition to that _i3's_ [scratchpad] feature is very useful for keeping [Zeal] and _Vim_ instances running in the background while preserving accessability in every context by displaying them in a floating window overlaying the current workspace.

[NixOS]:      https://nixos.org/
[GuixSD]:     https://www.gnu.org/software/guix/
[etckeeper]:  https://github.com/joeyh/etckeeper
[dotfiles]:   https://code.kummerlaender.eu/dotfiles/
[GNU stow]:   https://www.gnu.org/software/stow/
[dict]:       http://www.dict.org/links.html
[passman]:    https://github.com/dkellner/passman
[Rofi]:       https://github.com/DaveDavenport/rofi
[scratchpad]: http://build.i3wm.org/docs/userguide.html#_scratchpad
[Zeal]:       https://zealdocs.org/

## Archiving, web browsing and note taking

An important purpose of the tool we call _Computer_ is accessing information on the Internet. This task is achieved primarily using a web browser - in fact there is an argument to be made that web browsers are some of the most complex applications the average users comes into contact with.  
I sometimes frown at the wasteful complexity many of today's websites contain even if their actual contents still consist of mostly plaintext and some pictures. It is no longer the exception but the rule that a single load of common websites pulls more data over the wire than would be required to encode a whole book while often containing _far_ less content. These are the moments where I wish that [Gopher] had gained wider usage or that something in the vein of [ipfs] will grow to encompass most of the sources I commonly use[^6].

![Current Pentadactyl, TreeStyleTabs and ScrapBook X augmented Firefox setup](https://static.kummerlaender.eu/media/tinkering_with_meta_tools_screen_004.png)

As one can see in the screeshot above the current browser setup I use to deal with this rather unsatisfying state of things is a quite customized version of Firefox. This is achieved using [Pentadactyl], [TreeStyleTabs] and [ScrapBook X].

[Pentadactyl] transforms Firefox into a fully keyboard driven browser with _Vim-like_ keybindings and looks as well as the possibility of configuring the browser using a single dotfile [`.pentadactylrc`].

[TreeStyleTabs] allows me to better manage my workflow of keeping all tabs related to my current projects and interests opened as well as grouped in a tree structure. While _Vim-like_ keybindings can be configured in other browsers, usable _TreeStyleTabs_ like tab management is currently only available on Firefox.

[ScrapBook X] is my current answer to a question I have spent quite some time thinking about: How to best archive and organize interesting documents on the web. _ScrapBook_ allows reasonably good offline archival of websites, organizing archived pages in a folder structure and exporting a _HTML_ version of itself for hosting a private _Internet Archive_. It doesn't work perfectly on all websites and uses plain file mirroring instad of the more suitable [WARC] format but it is the best solution I was able to find short of investing most of my time into attemting to develop something more to my taste.  
For now it is good enough and fullfills my primary use cases: Having access to most of my sources independent of network availability[^7], preventing the unpleasant situation of wanting to consult a vaguely remembered source only to find that it is not available anymore as well as full text search over all interesting pages I visited.

Archiving the web ties into the last section of this article: note taking. While I write all my lecture notes and excercise sheet solutions using pen input on one of Microsoft's _Surface_[^8] devices I like to capture project and _research_ notes as well as general thoughts using a keyboard on my normal computer.  
When taking notes as plain text I preferably want to do so using _Vim_ which rules out most of the already relatively [limited](http://tiddlywiki.com/) [selection](http://www.zim-wiki.org/) [of](http://strlen.com/treesheets/) open source desktop wiki software. After quite some time using [VimWiki] I currently use markdown files stored in a flat directory structure. Desktop integration is solved using a background Vim instance running in a _i3_ scratchpad as well as a _Rofi_ based [note selection dialog](https://code.kummerlaender.eu/dotfiles/tree/bin/rofi_wiki) that communicates with _Vim_ using remote commands. Advanced markdown features, syntax highlighting and conversion is based on [pandoc] integration plugins.  
In addition to that I also now and then play around with _Emacs'_ [Org-mode] which can probably fulfill most of my requirements but requires considerable upfront configuration efforts to make it work consistently with _Evil_ for _Vim-style_ usage.

[Gopher]:           https://en.wikipedia.org/wiki/Gopher_(protocol)
[ipfs]:             https://ipfs.io/
[Pentadactyl]:      http://5digits.org/pentadactyl/
[TreeStyleTabs]:    https://github.com/piroor/treestyletab
[ScrapBook X]:      https://github.com/danny0838/firefox-scrapbook
[`.pentadactylrc`]: https://code.kummerlaender.eu/dotfiles/tree/pentadactyl/.pentadactylrc
[WARC]:             https://en.wikipedia.org/wiki/Web_ARChive
[VimWiki]:          http://vimwiki.github.io/
[pandoc]:           http://pandoc.org
[Memex]:            https://en.wikipedia.org/wiki/Memex
[Org-mode]:          http://orgmode.org/

## Vision

While the setup outlined above is workable I definitely do not consider it a permanent solution. Even more so I feel that there is much unexplored potential in augmenting not just note taking but formal and exploratory thinking in general using computers. What I mean by that are systems as they were envisioned in the form of the [Memex] or as described by Engelbart in _Augmenting Human Intellect_[^9].

Such a system would not only encompass note taking and knowledge management but form an intergral part of the user facing operating system. Everything you see on a screen should be explorable in the vein of _Lisp Machines_ or _Smalltalk_ instances, annotatable in a fully interlinkable and version controlled knowledge base that transparently integrates information from the Internet in a uniform fashion as well as shareable with other beings where required.  
Formal verification software could look over the figurative shoulder of the user and point out possible fallacies and formal errors. Even a single component of such a system like for example a math environment that pulls up appropriate definitions, theorems and examples depending on the current context or a literate development environment that automatically pulls up documentation, stackexchange threads and debugging output would be of great help.  
Usage tracking similar to _Gnome Zeitgeist_ in conjunction with full text archival of all visited websites and fully reproducible tracking of the desktop state would also complement such a system.

In conclusion: My current setup doesn't even scratch the surface of what should be possible. Tinkering with my computing systems and _workflow-optimization_ will continue to be an unbounded but at least somewhat productive leisure time sink.

[^0]: ...that I have probably crossed frequently
[^1]: Section 16, _Power Editing_, The Pragmatic Programmer.
[^2]: Tabs for indentation, spaces for alignment it is for me - this is probably the reason for my dislike of whitespace-dependent languages that tend to interfere with this personal preference of mine.
[^3]: Desktop-only text editors - especially those _Electron_ based ones written in HTML and JavaScript of all things - are not an alternative for my use cases. Although at least VSCode is developing nicely into a usable cross platform IDE.
[^4]: Luckily not that long in my case :-)
[^5]: Serving a collection of freely available dictionaries such as _Webster's 1913_ and _Wordnet_
[^6]: Note to self: Make the raw markdown sources (?) of this blog available on _ipfs_
[^7]: e.g. when riding the black forest train from Karlsruhe to my home village in the _Hegau_.
[^8]: The only non-Linux device I regularly use. Pen input on tablet devices has reached a point of general viability (concerning power usage and form factor) in recent years. I am actually very satisfied with my Surface 4 and Windows 10 as both a note taking and tablet device. For tinkering and security reasons I still hope to one day be able to use an open operating system and open note taking software on such a device but for now it is a workable solution for my use case of studying (mostly) paperless.
[^9]: [_AUGMENTING HUMAN INTELLECT : A Conceptual Framework._](http://www.1962paper.org/web.html), October 1962, D. C. Engelbart
