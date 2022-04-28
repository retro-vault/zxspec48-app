![status.badge] [![language.badge]][language.url] [![standard.badge]][standard.url] [![license.badge]][license.url]

# zxspec48-app

The *zxspec48-app* is an empty *SDCC* application template for ZX Spectrum 48K.

Add your `.c` and `.s` source files into the `src` directory and run 

~~~
make 
~~~

This will create the `app.bin` inside your `build` folder.

Pass the `APP` and `ADDR` parameters to change the name of your application and compile it to a different address. 

~~~
make APP=myapp ADDR=0x9000`
~~~

[language.url]:   https://en.wikipedia.org/wiki/ANSI_C
[language.badge]: https://img.shields.io/badge/language-C-blue.svg

[standard.url]:   https://en.wikipedia.org/wiki/C11_(C_standard_revision)
[standard.badge]: https://img.shields.io/badge/standard-C11-blue.svg

[license.url]:    https://github.com/tstih/nice/blob/master/LICENSE
[license.badge]:  https://img.shields.io/badge/license-MIT-blue.svg

[status.badge]:  https://img.shields.io/badge/status-stable-darkgreen.svg