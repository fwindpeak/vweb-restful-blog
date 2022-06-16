module main

import vweb
import sqlite
import json

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

struct Blog {
	id      int    [primary; sql: serial]
	title   string
	content string
}

fn static_server(mut app App) {
	app.handle_static('../dist', true)
	app.serve_static('/', '../dist/index.html')
}

fn init_db(mut app App) {
	sql app.db {
		create table Blog
	}
}

['/api/blog'; get]
fn (mut app App) blog_list() vweb.Result {
	blog_list := sql app.db {
		select from Blog
	}
	return app.json(blog_list)
}

['/api/blog/:id'; get]
fn (mut app App) blog_get(id int) vweb.Result {
	blog := sql app.db {
		select from Blog where id == id
	}
	return app.json(blog)
}

['/api/blog/:id'; delete]
fn (mut app App) blog_delete(id int) vweb.Result {
	sql app.db {
		delete from Blog where id == id
	}
	return app.json({
		'result':  '0'
		'message': 'success'
	})
}

['/api/blog'; post]
fn (mut app App) blog_create() vweb.Result {
	body := app.req.data
	println('ponst body:$body')

	blog := json.decode(Blog, app.req.data) or {
		return app.json({
			'result':  '1'
			'message': 'json decode error'
		})
	}

	if blog.title == '' || blog.content == '' {
		return app.json({
			'result':  '1'
			'message': 'title or content is empty'
		})
	}

	// println('posting blog')
	// println(blog)
	sql app.db {
		insert blog into Blog
	}
	return app.json({
		'result':  '0'
		'message': 'success'
	})
}

// ['/api/blog'; put]
// fn (mut app App)blog_update() vweb.Result{
// 	blog := Blog{
// 		id:app.req.data.id
// 		title:app.req.data.title
// 		content:app.req.data.content
// 	}
// 	if title == '' || content == '' {
// 		return app.json({
// 			"result": "1",
// 			"message": "title or content is empty"
// 		})
// 	}

// 	println('posting blog')
// 	println(blog)
// 	sql app.db {
// 		update Blog set title = title, content = content where id == id
// 	}

// 	return app.redirect('/')
// }

fn main() {
	port := 5052
	mut app := App{
		db: sqlite.connect('blog.db') or { panic(err) }
	}
	// static_server(mut app)
	init_db(mut app)
	vweb.run(app, port)
}

// ['/index']
// fn (mut app App) index() vweb.Result {
// 	return app.html('hello vweb api')
// }
