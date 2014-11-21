err-Fly
===========

handle callback err with node style

##node style callback

```js
function(err, data){
  if (err) {
    return cb(err);
  }
  //......
  cb(null, data);
}
```

##Usage

###Before

```js
async(arg1, arg2, function(err, data){
  if (err) {
    return cb(err);
  }
  //..........
  async2(arg11, arg22, function(err2, data2){
    if (err2){
      return cb(err2);
    }
    //.........
    cb(null, data2);
  });
});
```

###Now

```js
wrapper = errFly(cb);
async(arg1, arg2, wrapper(function(data){
  //.......
  async2(arg11, arg22, wrapper(function(data2){
    //.......
    cb(null, data2);
  }));
}));
```

if the callback could be called only once, then

```js
wrapper = errFly(cb);
async(arg1, arg2, wrapper(function(data){
  //.......
  wrapper.fn(null, data);
}));
async2(arg11, arg22, wrapper(function(data2){
  //.......
  wrapper.fn(null, data2);
}));
```
