@ECHO off
set ip=%1

set INSTALL="install"
set BUILD="build"
set RUN="run"
set TEST="test"
set START="start"

if "%ip%"==%INSTALL% (
    echo "Installing Go Dependencies..."
    go get
)

if "%ip%"==%BUILD% (
	echo ⚒ Initiating gitcthulu build for windows
	echo 🗑 Cleaning up unwanted folders
	rd /s /q ui
	rd /s /q dist
	rd /s /q build
    echo ⏳ Cloning UI package from github gitcthulu-ui/master
    git clone -q https://github.com/neel1996/gitcthulu-ui.git ui/
    cd ui
    echo ⏳ Installing UI dependencies
	del package-lock.json
    npm install --silent
    echo ⚒ Building UI bundle
    set NODE_ENV=production
    npm install tailwindcss postcss autoprefixer
    npx tailwindcss build -o src/index.css -c src/tailwind.config.js
    npm run build
	echo 🔹 Moving react bundle to gitcthulu-ui
    move .\build gitcthulu-ui
    move .\gitcthulu-ui ..\
    cd ..
    mkdir .\dist
	echo 🔹 Moving UI artifacts to dist folder
    move .\gitcthulu-ui .\dist\
    echo 🔹 Copying etc content to dist
    xcopy /E /I .\etc\ .\dist\etc\
    copy .\etc\git2.dll .\dist\
	echo 🔸 Removing intermediary folder ui/
	rd /s /q ui
    echo 🚀 Building gitcthulu bundle
    go build -o ./dist/gitcthulu.exe
	cd .\dist
    rename gitcthulu-server.exe gitcthulu.exe
    echo ✅ gitcthulu Build Completed successfully!
	echo 📬 Run ./dist/gitcthulu.exe to start gitcthulu on port 9001
	echo 📬 Try ./dist/gitcthulu.exe --port PORT_NUMBER to run gitcthulu on the desired port
	cd ..
)

if "%ip%"==%TEST% (
    go test -tags static -v ./...
)

if "%ip%"==%RUN% (
    go run server.go
)

if "%ip%"==%START% (
	.\dist\gitcthulu.exe
)
