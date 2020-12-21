build:
	hugo --gc --minify

serve:
	npx serve public/

start:
	hugo server

clean:
	rm -rf public/
