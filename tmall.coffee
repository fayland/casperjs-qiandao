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

username = casper.cli.get("username")
password = casper.cli.get("password")
if (username == undefined || password == undefined)
	casper.die("Please set username/password with cli options: --username=blabla --password=fixme")

casper.start 'https://login.taobao.com/member/login.jhtml?tpl_redirect_url=https%3A%2F%2Fauth.alipay.com%2Flogin%2FtrustLoginResultDispatch.htm%3FredirectType%3D%26sign_from%3D3000%26goto%3Dhttp%253A%252F%252Ffun.alipay.com%252Fmx1111%252Findex.htm%253Fnull&from_alipay=1', ->
	@viewport(800, 600)
	@fill 'form#J_StaticForm', {
		TPL_username: username,
		TPL_password: password
	}
	@click 'button#J_SubmitStatic'
casper.wait 4000

casper.then ->
	@waitFor ->
		@exists('.right_button')
	, ->
		@click '.right_button'
casper.wait 4000

## tmall
casper.then ->
	if @visible('div.qd_fail2')
        @echo 'ALREADY GOT IT!'
    else if @visible('div.qd_fail')
        @echo 'FAILED!'
    else if @visible('div.qd_success')
        @echo 'SUCCESS!'
    else
    	@echo 'UNKNOWN!!!!'

casper.run()