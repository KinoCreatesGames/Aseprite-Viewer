<h1 align="center">Aseprite File Viewer </h1>


## A tool that let's you look at Aseprite files and view them within the HaxeFlixel engine. Work in progress.

### 1. Install dependencies

```sh
npm i 
```

### 2. Build
It's recommended to run the [Haxe compilation server](https://youtu.be/3crCJlVXy-8) when developing to cache the compilation, this should be done in a separate terminal window/tab with the following command.
```sh
npm run comp-server
```

Your **.hx** files are watched with [Facebook's watman plugin](https://facebook.github.io/watchman/). Anytime you save a file it will trigger an automatic rebuild. 
```sh
npm start 
```
