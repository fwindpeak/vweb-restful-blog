module main

import vweb

struct App {
	vweb.Context
}

fn init_server(mut app App) {
	app.handle_static('../dist', true)
	app.serve_static('/', '../dist/index.html')
}

fn main() {
	port := 5051
	mut app := App{}
	init_server(mut app)
	vweb.run(app, port)
}

// ['/index']
// fn (mut app App) index() vweb.Result {
// 	return app.html('hello vweb api')
// }
