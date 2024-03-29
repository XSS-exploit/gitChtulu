get:
	go get
run:
	go run server.go
build-ui:
	git clone https://github.com/neel1996/gitcthulu-ui.git ui/
	cd ui
	npm install
	export NODE_ENV=production
	npm i -g create-react-app tailwindcss@1.6.0
	npm run build:tailwind
	npm run build
	mv ./build ../
build-server:
	mkdir -p ./dist
	go build -o ./dist

build:
	@echo "⚒️ Initiating gitcthulu build"
	@echo "🗑️ Cleaning up old directories"
	@rm -rf ui/ dist/ build/
	@echo "⏬ Cloning gitcthulu react repo"
	@git clone -q https://github.com/neel1996/gitcthulu-ui.git ui/ && \
	cd ui && \
	echo "⏳ Installing UI dependencies..." && \
	npm install --silent && \
	export NODE_ENV=production && \
	npm install tailwindcss postcss autoprefixer && \
	npx tailwindcss build -o ./src/index.css -c ./src/tailwind.config.js && \
	rm package-*.json && \
	rm -rf .git/ && \
	echo "🔧 Building react UI bundle" && \
	npm run build && \
	mv ./build ../ && \
	cd .. && \
	mkdir -p ./dist && \
	mv build/ ./dist/ && \
	mv ./dist/build ./dist/gitcthulu-ui
	echo "🚀 Building final go source with UI bundle" && \
	go build -v -a -o ./dist && \
	echo "gitcthulu build completed!" && \
	mv ./dist/gitcthulu-server ./dist/gitcthulu 
	@echo "Installing libs"
	@echo "✅ gitcthulu Build Completed successfully!"
	@echo "📬 Use ./dist/gitcthulu to start gitcthulu on port 9001"
	@echo "📬 Try ./dist/gitcthulu --port PORT_NUMBER to run gitcthulu on the desired port"
test:
	go test -tags static -v ./...
start:
	./dist/gitcthulu
