module.exports = function errHandler(callback) {
  var _callback = callback || function(err) {
    throw err;
  };
  var called = false;
  callback = function(err) {
    if (!called){
      called = true;
      _callback(err);
    }
  };

  return function wrapper(handler, context) {
    if (!context){
      context = this;
    }
    return function(err, data) {
      if (err){
        return callback(err);
      }
      var args = [].slice.call(arguments, 1);
      return handler.apply(context, args);
    };
  };
};
