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
    casper.die("Please set weibo username/password with cli options: --username=blabla --password=fixme")

casper.start 'http://www.dianping.com/login', ->
    # use weibo login, no captcha
    if @exists '#btSinaLogin'
        @log 'Found Weibo login link...', 'info'
        @click '#btSinaLogin'

casper.then ->
    if @exists 'a.WB_btn_login'
        @log 'Found login BUTTON, ready to login', 'info'
        @fill 'body', {
            'userId': username,
            'passwd': password
        }

        @wait 5000, ->
            @click '.WB_btn_login'

casper.wait 8000, ->
  @log 'Wait login done', 'debug'

casper.then ->
    @waitFor ->
        @exists('span.J_signbtn') or @exists('div.b-check')
    , ->
        if @exists('span.J_signbtn')
            @click 'span.J_signbtn > a.btn-txt'
            casper.wait 2000, ->
                require('utils').dump(this.getElementInfo('div.b-check'));
        else
            require('utils').dump(this.getElementInfo('div.b-check'));

casper.run()