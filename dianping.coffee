casper = require('casper').create({
    verbose: true,
    pageSettings: {
        loadImages: true,
        loadPlugins: false,
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
    },
    logLevel: 'debug'
})
{spawn, execFile} = require "child_process"

username = casper.cli.get("username")
password = casper.cli.get("password")
if (username == undefined || password == undefined)
    casper.die("Please set weibo username/password with cli options: --username=blabla --password=fixme")

casper.start 'http://weibo.com/', ->
    if @exists 'div.login_btn'
        console.log 'Login ...'
        @fillSelectors 'body', {
            'input[name="username"]': username,
            'input[name="password"]': password
        }
        @click 'a.W_btn_g'
    else
        console.log 'It seems we have logined.'
casper.wait 4000

casper.thenOpen 'http://www.dianping.com/login?redir=http%3A%2F%2Fwww.dianping.com%2F', ->
    # use weibo login, no captcha
    @click '#btSinaLogin'
casper.wait 4000

casper.then ->
    @waitFor ->
        @exists('span.J_signbtn') or @exists('div.b-check')
    , ->
        if @exists('span.J_signbtn')
            @click 'span.J_signbtn > a.btn-txt'
        else
            require('utils').dump(this.getElementInfo('div.b-check'));

casper.run()