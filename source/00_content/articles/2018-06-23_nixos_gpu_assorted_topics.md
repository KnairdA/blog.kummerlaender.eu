# On NixOS, GPU programming and other assorted topics

So I recently acquired a reasonably priced second-hand CAD workstation computer featuring a Xeon CPU, plenty of RAM as well as a nice Nvidia K2200 GPU with 4 GiB of memory and 640 cores as the heart of the matter. The plan was that this would enable me to realize my long hedged plans of diving into GPU programming - specifically using compute shaders to implement mathematical simulation type stuff. True to my [previously described](/article/tinkering_with_meta_tools) inclination to procrastinate interesting projects by delving into other interesting topics my first step to realizing this plan was of course acquainting myself with a new Linux distribution: [NixOS](https://nixos.org).

So after weeks of configuring I am now in the position of working inside a fully reproducible environment declaratively described by a set of version controlled textfiles[^0]. The main benefit of this is that my project-specific development environments are now easily portable and consistent between all my machines: Spending the morning working on something using the workstation and continuing said work on the laptop between lectures in the afternoon is as easy as syncing the Nix environments. This is in turn easily achieved by including the corresponding `shell.nix` files in the project's repository.

As an example this is the environment I use to generate this very website, declaratively described in the Nix language:

```haskell
with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "blog-env";
  env = buildEnv { name = name; paths = buildInputs; };

  buildInputs = let
    generate  = pkgs.callPackage ./pkgs/generate.nix {};
    preview   = pkgs.callPackage ./pkgs/preview.nix {};
    katex     = pkgs.callPackage ./pkgs/KaTeX.nix {};
  in [
    generate
    preview
    pandoc
    highlight
    katex
  ];
}
```

Using this `shell.nix` file the blog can be generated using my mostly custom XSLT-based setup[^1] by issuing a simple `nix-shell --command "generate"` in the repository root. All dependencies - be it pandoc for markup transformation, a custom [KaTeX](https://khan.github.io/KaTeX/) wrapper for server-side math expression typesetting or my very own [InputXSLT](https://tree.kummerlaender.eu/projects/xslt/input_xslt/) - will be fetched and compiled as necessary by Nix.

```haskell
{ stdenv, fetchFromGitHub, cmake, boost, xalanc, xercesc, discount }:

stdenv.mkDerivation rec {
  name = "InputXSLT";

  src = fetchFromGitHub {
    owner = "KnairdA";
    repo = "InputXSLT";
    rev = "master";
    sha256 = "1j9fld3sh1jyscnsx6ab9jn5x6q67rjh9p3bgsh5na1qrs40dql0";
  };

  buildInputs = [ cmake boost xalanc xercesc discount ];

  meta = with stdenv.lib; {
    description = "InputXSLT";
    homepage    = https://github.com/KnairdA/InputXSLT/;
    license     = stdenv.lib.licenses.asl20;
  };
}
```

This will work on any system where the Nix package manager is installed without any further manual intervention by the user. So where in the past I had to manually guarantee that all dependencies are available which included compiling and installing my [custom site generator stack](https://tree.kummerlaender.eu/projects/xslt/) I can now simply clone the repository and generate the website in a single command[^2].

It can not be overstated how powerful the system management paradigm implemented by Nix and NixOS is. On NixOS I am finally free to try out anything I desire without fear of polluting my system and creating an unmaintainable mess as everything can be isolated and garbage collected when I don't need it anymore. Sure it is some additional effort to maintain Nix environments and write a custom derivation here and there for software that is not yet available[^3] in [nixpkgs](https://nixos.org/nixpkgs/) but when your program works or your project compiles you can be sure that it does so because the system is configured correctly and all dependencies are accounted for - nothing works by accident[^4].

Note that the `nix-shell` based example presented above is only a small subset of what NixOS offers. Besides shell environments the whole system configuration consisting of systemd services, the networking setup, my user GUI environment and so on is also configured in the Nix language. i.e. the whole system from top to bottom is declaratively described in a consistent fashion.

NixOS is the first destribution I am truly excited for since my initial stint of distro-hopping when I first got into Linux a decade ago. Its declarative package manager and configuration model is true innovation and one of those rare things where you already know that you will never go back to the old way of doing things after barely catching a climpse of it. Sure, other distros can be nice and I greatly enjoyed my nights of compiling Gentoo as well as years spent tinkering with my ArchLinux systems but NixOS offers something truely distinct and incredibly useful. At first I thought about using the Nix and Scheme based [GuixSD](https://www.gnu.org/software/guix/) distribution instead but I got used to the Nix language quickly and do not think that the switch to Guile Scheme as the configuration language adds enough to offset having to deal with GNU's free software fundamentalism[^5].

Of course I was not satisfied merely porting my workflows onto a new superior distribution but also had to switch from [i3](https://i3wm.org/) to [XMonad](https://xmonad.org/) in the same breath. By streamlining my tiling window setup on top of this Haskell-based window manager my setup has reached a new level of minimalism. Layouts are now restricted to either fullscreen, tabbed or simple side by side tiling and everything is controlled using [Rofi](https://github.com/DaveDavenport/rofi) instances and keybindings. My constant need of checking battery level, fan speed and system performance was fixed by removing all bars and showing only minimally styled windows. And due to the reproducibility[^6] of NixOS the interested reader can check out the full system herself if he so desires ! :-) See the [home-manager](https://github.com/rycee/home-manager/) based user [environment](https://github.com/KnairdA/nixos_home) or specifically the [XMonad config](https://github.com/KnairdA/nixos_home/blob/master/gui/conf/xmonad.hs) for further details.

After getting settled in this new working environment I finally was out of distractions and moved on to my original wish of familiarizing myself with delegating non-graphical work to the GPU. The first presentable result of this undertaking is my minimalistic [fieldplay](https://anvaka.github.io/fieldplay/) clone [computicle](https://github.com/KnairdA/computicle).

![computicle impression](https://code.kummerlaender.eu/adrian/computicle/raw/branch/master/screenshot/computicle_1.png)

What computicle does is simulate many particles moving according to a vector field described by a function $f : \mathbb{R}^2 \to \mathbb{R}^2$ that is interpreted as a ordinary differential equation to be solved using classical Runge-Kutta methods. As this problem translates into many similiar calculations performed per particle without any communication to other particles it is an ideal candidate for massive parallelization using GLSL compute shaders on the GPU.

```cpp
#version 430

layout (local_size_x = 1) in;
layout (std430, binding=1) buffer bufferA{ float data[]; };

vec2 f(vec2 v) {
	return vec2(
		cos(v.x*sin(v.y)),
		sin(v.x-v.y)
	);
}

vec2 classicalRungeKutta(float h, vec2 v) {
	const vec2 k1 = f(v);
	const vec2 k2 = f(v + h/2. * k1);
	const vec2 k3 = f(v + h/2. * k2);
	const vec2 k4 = f(v + h    * k3);

	return v + h * (1./6.*k1 + 1./3.*k2 + 1./3.*k3 + 1./6.*k4);
}

[...]

void main() {
	const uint i = 3*gl_GlobalInvocationID.x;
	const vec2 v = vec2(data[i+0], data[i+1]);
	const vec2 w = classicalRungeKutta(0.01, v);

	data[i+0]  = w.x;  // particle x position
	data[i+1]  = w.y;  // particle y position
	data[i+2] += 0.01; // particle age
}
```

As illustrated by this simplified extract of computicle's compute shader, writing code for the GPU can look and feel quite similar to to targeting the CPU in the C language. It fits that my main gripes during development were not with the GPU code itself but rather with the surrounding C++ code required to pass the data back an forth and talk to the OpenGL state machine in a sensible manner.

The first issue was how to include GLSL shader source into my C++ application. While the way OpenGL accepts shaders as raw strings and compiles them for the GPU on the fly is not without benefits (e.g. switching shaders generated at runtime is trivial) it can quickly turn ugly and doesn't feel well integrated into the overall language. Reading shader source from text files at runtime was not the way I wanted to go as this would feel even more clunky and unstable. What I settled on until the committee comes through with something like [`std::embed`](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1040r0.html) is to include the shader source as multi-line string literals stored in static constants placed in separate headers. This _works_ for now and offers at least syntax highlighting in terms of editor support.

What would be really nice is if the shaders could be generated from a domain-specific language and statically verified at compile time. Such a solution could also offer unified tools for handling uniform variables and data buffer bindings. While something like that doesn't seem to be available for C++[^7] I stumbled upon the very interesting [LambdaCube 3D](http://lambdacube3d.com/) and [varjo](https://github.com/cbaggers/varjo) projects. The former promises to become a Haskell-like purely functional language for GPU programming and the latter is an interesting GLSL generating framework for LISP.

I also could not find any nice and reasonably lightweight library for interfacing with the OpenGL API in a modern fashion. I ended up creating my own scope-guard type wrappers around the OpenGL functionality required by computicle but while what I ended up with looks nice it is probably of limited portability to other applications.

```cpp
// simplified extract of computicle's update loop
window.render([&]() {
	[...]
	if ( timer::millisecondsSince(last_frame) >= 1000/max_ups ) {
		auto guard = compute_shader->use();

		compute_shader->setUniform("world", world_width, world_height);
		compute_shader->dispatch(particle_count);

		last_frame = timer::now();
	}
	[...]
	{
		auto texGuard = texture_framebuffers[0]->use();
		auto sdrGuard = scene_shader->use();

		scene_shader->setUniform("MVP", MVP);
		[...]
		particle_buffer->draw();
	}

	{
		auto guard = display_shader->use();

		display_shader->setUniform("screen_textures",      textures);
		display_shader->setUniform("screen_textures_size", textures.size());

		glClear(GL_COLOR_BUFFER_BIT);

		display_buffer->draw(textures);
	}
});
```

One idea that I am currently toying with in respect to my future GPU-based projects is to abandon C++ as the host language and instead use a more flexible[^8] language such as Scheme or Haskell for generating the shader code and communicating with the GPU. This could work out well as the performance of CPU code doesn't matter as much when the bulk of the work is performed by shaders. At least this is the impression I got from my field visualization experiment - the CPU load was minimal independent of how many kiloparticles were simulated.

![computicle impression](https://code.kummerlaender.eu/adrian/computicle/raw/branch/master/screenshot/computicle_0.png)

[^0]: See [nixos_system](https://github.com/KnairdA/nixos_system) and [nixos_home](https://github.com/KnairdA/nixos_home)
[^1]: See the [summary node](http://tree.kummerlaender.eu/projects/xslt/) or [Expanding XSLT using Xalan and C++](/article/expanding_xslt_using_xalan_and_cpp/)
[^2]: And this works on all my systems, including my Surface 4 tablet where I installed Nix on top of Debian running in WSL
[^3]: Which is not a big problem in practice as the repository already provides a vast set of software and builders for many common build systems and adapters for language specific package managers. For example my [Vim configuration](https://github.com/KnairdA/nixos_system/tree/master/pkgs/vim) including plugin management is also handled by Nix. The clunky custom texlive installation I maintained on my ArchLinux system was replaced by nice, self-contained shell environments that only [provide](https://nixos.org/nixpkgs/manual/#sec-language-texlive) the $\LaTeX$ packages that are actually needed for the document at hand.
[^4]: At least if you are careful about what is installed imperatively using `nix-env` or if you use the `pure` flag in `nix-shell`
[^5]: Which I admire greatly - but I also want to use the full power of my GPU and run proprietary software when necessary
[^6]: And the system really is fully reproducible: I now tested this two times, once when moving the experimental setup onto a new SSD and once when installing the workstation config on my laptop. Each time I was up and running with the full configuration as I left it in under half an hour. Where before NixOS a full system failure would have incurred days of restoring backups, reconstructing my specific configuration and reinstalling software I can now be confident that I can be up and running on a replacement machine simply by cloning a couple of repositories and restoring a home directory backup.
[^7]: At least when one wants to work with compute shaders - I am sure there are solutions in this direction for handling graphic shaders for gaming and CAD type stuff.
[^8]: Flexible as in better support for domain-specific languages
