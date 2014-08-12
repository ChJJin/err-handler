errFly = require('../index')
expect = require('chai').expect
should = require('chai').should()

describe 'errFly', ()->
  asyncNormal = (args..., cb)->
    cb(null, 'foo')

  asyncNormalMulti = (args..., cb)->
    cb(null, 'foo', 'bar')

  asyncError = (args..., cb)->
    err = new Error('error')
    cb(err)

  describe 'do not throw err', ()->
    it 'with one value', (done)->
      cb = (err, data)->
        expect(err).to.not.exist
        expect(data).to.equal('foo')
        done()
      wrapper = errFly(cb)
      asyncNormal 'bar', wrapper (data)->
        cb(null, data)

    it 'with multi value', (done)->
      cb = (err, data1, data2)->
        expect(err).to.not.exist
        expect(data1).to.equal('foo')
        expect(data2).to.equal('bar')
        done()
      wrapper = errFly(cb)
      asyncNormalMulti 'bar', wrapper (data1, data2)->
        cb(null, data1, data2)

  describe 'throw err', ()->
    it 'once', (done)->
      cb = (err, data)->
        expect(err).to.exist
        expect(err.message).to.equal('error')
        expect(data).to.not.exist
        done()
      wrapper = errFly(cb)
      asyncError 'bar', wrapper (data)->
        cb(null, data)

    it 'multi times but only the first would be called', (done)->
      cb = (err, data)->
        expect(err).to.exist
        expect(err.message).to.equal('error')
        expect(data).to.not.exist
        done()

      wrapper = errFly(cb)
      asyncError 'bar', wrapper (data)->
        cb(null, data)
      asyncError 'baz', wrapper (data)->
        cb(null, data)

    it 'multi times with one error thrown and the other not', (done)->
      times = 0
      cb = (err, data)->
        if err
          expect(err).to.exist
          expect(err.message).to.equal('error')
        else
          expect(err).to.not.exist
          expect(data).to.equal('foo')
        times++
        expect(times).to.equal(1)
        if times is 1
          done() 

      wrapper = errFly(cb)
      asyncError 'bar', wrapper (data)->
        wrapper.fn(null, data)
      asyncNormal 'baz', wrapper (data)->
        wrapper.fn(null, data)

