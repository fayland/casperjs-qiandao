casper = require('casper').create({
	verbose: true,
	pageSettings: {
        loadImages: true,
        loadPlugins: false,
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
    },
    # clientScripts: ["includes/jquery.min.js"]
	logLevel: 'debug'
})
xpath  = require('casper').selectXPath

username = casper.cli.get("username")
password = casper.cli.get("password")

if (username == undefined || password == undefined)
	casper.die("Please set username/password with cli options: --username=blabla --password=fixme")

casper.start 'http://vip.taobao.com/vip_home.htm?auto_take=true', ->
	@viewport(800, 600)
	@click 'a.J_GetCoinBtn'
casper.wait 2000

casper.withFrame 'J_loginiframe', ->
	@waitFor ->
		@exists('#J_StaticForm')
	, ->
		@fill 'form#J_StaticForm', {
			TPL_username: username,
			TPL_password: password
		}
		@click 'button#J_SubmitStatic'
casper.wait 4000

casper.then ->
	@waitFor ->
		@exists('div.have-take-panel')
	, ->
		require('utils').dump(this.getElementInfo('div.have-take-panel'));

casper.then ->
	@capture 'done.png', {top: 0, left: 0, width: 800, height: 600 }

casper.run()