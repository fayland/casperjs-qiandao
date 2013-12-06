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
	casper.die("Please set username/password with cli options: --username=blabla --password=fixme")

casper.start 'https://login.taobao.com/member/login.jhtml', ->
	@viewport(800, 600)
	# login
	@fill 'form#J_StaticForm', {
		TPL_username: username,
		TPL_password: password
	}
	@click 'button#J_SubmitStatic'
casper.wait 4000

casper.thenOpen 'http://vip.taobao.com/vip_home.htm?auto_take=true', ->
	@wait 4000
	# require('utils').dump(this.page)
	@waitFor ->
		@exists('div.J_UserCoinPanel')
	, ->
		require('utils').dump(this.getElementInfo('div.J_UserCoinPanel'));

# casper.then ->
# 	@capture 'done.png', {top: 0, left: 0, width: 800, height: 600 }

casper.thenOpen 'http://jf.etao.com/getCredit.htm', ->
	require('utils').dump(this.getElementInfo('p.news'));

casper.run()