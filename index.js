module.exports = function errHandler(callback) {
  if (!callback || typeof callback !== 'function') {
    throw new Error('the first argument must be a function');
  }
  var called = false;
  _callback = function() {
    var args = [].slice.call(arguments, 0);
    if (!called) {
      called = true;
      return callback.apply(null, args);
    }
  };

  function wrapper(handler) {
    return function(err, data) {
      if (err) {
        return _callback(err);
      }
      var args = [].slice.call(arguments, 1);
      return handler.apply(null, args);
    };
  }

  wrapper.fn = _callback;

  return wrapper;
};
