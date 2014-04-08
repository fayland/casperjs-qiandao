casper = require('casper').create({
    verbose: true,
    pageSettings: {
        loadImages: true,
        loadPlugins: false,
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
    },
    logLevel: 'debug'
})

username = casper.cli.get("username")
password = casper.cli.get("password")
if (username == undefined || password == undefined)
    casper.die("Please set suning username/password with cli options: --username=blabla --password=fixme")

casper.start 'https://passport.suning.com/ids/login', ->
    @fill 'body', {
        'username': username,
        'password': password
    }

    @wait 5000, ->
        @click '#submit'

casper.wait 8000, ->
  @log 'Wait login done', 'debug'
  # @capture 'done.png', {top: 0, left: 0, width: 1200, height: 800 }

casper.thenOpen 'http://vip.suning.com/ams-web/world/pointSign.htm?r=1', ->
    require('utils').dump(this.page);

casper.run()