#!/bin/bash

# bash script that creates a minimalistic React app. Just what you need to run React and react-router-dom.
# Any other dependencies can be installed by hand. 

function write_index_html {
    echo "<!DOCTYPE html>" >> public/index.html
    echo '<html lang="en">' >> public/index.html
    echo " <head>" >> public/index.html
    echo '  <meta charset="UTF-8">' >> public/index.html
    echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> public/index.html 
    echo '  <title>Minimilistic React App</title>' >> public/index.html
    echo " </head>"  >> public/index.html
    echo " <body>" >> public/index.html
    echo '   <div id="root"></div>' >> public/index.html
    echo " </body>" >> public/index.html
    echo "</html>" >> public/index.html
}
function  write_manifest_json {
    # $1 == 
    echo "" >> public/manifest.json 
    echo "{" >> public/manifest.json 
    echo '  "short_name": "short name",'  >> public/manifest.json 
    echo '  "name": "project name",' >>public/manifest.json
    echo '  "icons": [],' >> public/manifest.json
    echo '  "start_url": ".",' >> public/manifest.json
    echo '  "display": "standalone",' >> public/manifest.json
    echo '  "theme_color": "#000000",' >> public/manifest.json
    echo '  "background_color": "#ffffff"' >> public/manifest.json
    echo '}' >> public/manifest.json
}
function write_app_js {
    # $1 == 
    echo "" >> src/App.js
    echo "import React from 'react';" >> src/App.js
    echo "import styles from './App.css';" >> src/App.js
    echo "" >> src/App.js
    echo "function App() {" >> src/App.js
    echo "   return <div className={styles.app}>Hello, React!</div>;" >> src/App.js
    echo "}"  >> src/App.js
    echo "" >> src/App.js
    echo 'export default App;' >> src/App.js
}
function write_app_css {
    echo "" >> src/App.css
    echo '.app {' >> src/App.css
    echo '    font-family: Arial, sans-serif;' >> src/App.css
    echo '    color: blue;' >> src/App.css
    echo '}' >> src/App.css
}
function write_index_js {
    echo '' >> src/index.js
    echo "import React from 'react';" >> src/index.js
    echo "import ReactDOM from 'react-dom';"  >> src/index.js
    echo "import App from './App';"  >> src/index.js
    echo ""  >> src/index.js
    echo "ReactDOM.render(<App />, document.getElementById('root'));"  >> src/index.js
}
function write_webpack_config_js {
    echo "" >> webpack.config.js
    echo "const path = require('path');" >> webpack.config.js
    echo "const MiniCssExtractPlugin = require('mini-css-extract-plugin');" >> webpack.config.js
    echo "" >> webpack.config.js
    echo "module.exports = {" >> webpack.config.js
    echo "  entry: './src/index.js'," >> webpack.config.js
    echo "  output: {" >> webpack.config.js
    echo "    path: path.resolve(__dirname, 'build')," >> webpack.config.js
    echo "    filename: 'bundle.js'" >> webpack.config.js
    echo "  }," >> webpack.config.js
    echo "  module: {" >> webpack.config.js
    echo "    rules: [" >> webpack.config.js
    echo "      {" >> webpack.config.js
    echo "        test: /\.(js|jsx)$/," >> webpack.config.js
    echo "        exclude: /node_modules/," >> webpack.config.js
    echo "        use: {" >> webpack.config.js
    echo "          loader: 'babel-loader'," >> webpack.config.js
    echo "          options: {" >> webpack.config.js
    echo "            presets: ['@babel/preset-env', '@babel/preset-react']" >> webpack.config.js
    echo "          }" >> webpack.config.js
    echo "        }" >> webpack.config.js
    echo "      }," >> webpack.config.js
    echo "      {" >> webpack.config.js
    echo "        test: /\.css$/," >> webpack.config.js
    echo "        use: [MiniCssExtractPlugin.loader, {" >> webpack.config.js
    echo "          loader: 'css-loader'," >> webpack.config.js
    echo "          options: {" >> webpack.config.js
    echo "            modules: true" >> webpack.config.js
    echo "          }" >> webpack.config.js
    echo "        }]" >> webpack.config.js
    echo "      }" >> webpack.config.js
    echo "    ]" >> webpack.config.js
    echo "  }," >> webpack.config.js
    echo "  plugins: [new MiniCssExtractPlugin()]," >> webpack.config.js
    echo "  devServer: {" >> webpack.config.js
    echo "    contentBase: path.join(__dirname, 'build')," >> webpack.config.js
    echo "    compress: true," >> webpack.config.js
    echo "    port: 3000" >> webpack.config.js
    echo "  }" >> webpack.config.js
    echo "};" >> webpack.config.js
}
function write_babel_rc {
    echo "" >> .babelrc
    echo '{' >> .babelrc
    echo '  "presets": ["@babel/preset-env", "@babel/preset-react"]' >> .babelrc
    echo '}' >> .babelrc
}

# check for command line arg. Should be a valid directory or . for cwd
# get the input if any and assign it to a var
if [[ -n "$1" ]]; then
    PROJECT_DIR="$1"
    if [[ "$PROJECT_DIR" == "." ]]; then
       project_dir=$(pwd)      
    fi
else   
    echo "Usage: $0 <project_name>"
    echo "Script will build a directory: <project_name> in the current working directory."
    echo "Or just enter a path and project name."
    exit 1
fi

# Create a new directory and initialize it
mkdir $PROJECT_DIR
cd $PROJECT_DIR
npm init -y

# Install React and ReactDOM
npm install react react-dom react-router-dom

# Install Webpack, Babel, and loaders
npm install --save-dev webpack webpack-cli webpack-dev-server @babel/core @babel/preset-env @babel/preset-react babel-loader css-loader style-loader mini-css-extract-plugin

npm install axios 
# Create basic directory structure
mkdir public src src/components
touch public/index.html public/manifest.json src/App.js src/index.js src/App.css src/components/readme.md TODO.txt readme.md 
touch webpack.config.js
touch .babelrc

# Add scripts to package.json
jq '.scripts += {"start": "webpack serve", "build": "webpack --mode production"}' package.json > temp.json && mv temp.json package.json

write_webpack_config_js
write_babel_rc
write_index_html
write_manifest_json
write_app_js
write_app_css
write_index_js