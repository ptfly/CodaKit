CodaKit
=======

A bunch of commands to speed up your workflow while working with Coda 2.

- Compile DustJS template (needs node & dustc installed and two symlinks*)
- * sudo ln -s /usr/local/bin/node /usr/bin/node
- * sudo ln -s /usr/local/bin/dustc /usr/bin/dustc
- Flip Quotes (replace single with double quotes and reverse)
- Capitalize Selection
- Uncapitalize Selection
- Delete Selection / Current Line
- Duplicate Selection / Current Line
- Wrap selection with: h1, h2, h3, h4, h5, h6, div, span, p, strong, em


####Download####
Compiled plugin can be found in the <b>Plugin</b> directory.


#### LinkedIn DustJS Compiler Notes ###
- In the site root, create a file dust.config in JSON format
```js
{
	"compileDir":"/_cache", // path where the compiled "JS" file goes
	"templateDir":"/templates", // main directory where all your templates are stored
	"compileFilesWithExtension":"dust", // which files (determined by the extension) will be compiled on save
	"preserveDirectoryStructure":true // mirror the structure of the templates directory to the _cache (in this case)
}
```