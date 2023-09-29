#!/bin/bash

# bash script that creates a minimalistic React app. Just what you need to run React and react-router-dom.
# Any other dependencies can be installed by hand. 

function write_index_html {
   cat << EOF > public/index.html
<!DOCTYPE html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
  <link rel="stylesheet" href="main.css">
  <title>Minimilistic React App</title>
 </head>
 <body>
   <div id="root"></div>
   <script src="bundle.js"></script>
 </body>
</html>
EOF

}
function  write_manifest_json {
   cat << EOF > public/manifest.json
{
  "short_name": "short name",
  "name": "project name",
  "icons": [],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOF

}
function write_app_js {
   cat << EOF > src/App.js
import React from 'react';
import './App.css';

function App() {
   return <div className="app">Hello, React!</div>;
}

export default App;
EOF
}
function write_app_css {
   cat << EOF > src/App.css
.app {
    font-family: Arial, sans-serif;
    color: blue;
}
EOF
}
function write_index_js {
   cat << EOF > src/index.js
import React from 'react';
import ReactDOM from "react-dom/client";
import App from './App';

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
);
EOF
}
function write_webpack_config_js {
    cat << EOF > webpack.config.js
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  mode: "development",  
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react']
          }
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, {
          loader: 'css-loader',
          options: {
            modules: false
          }
        }]
      }
    ]
  },
  plugins: [new MiniCssExtractPlugin()],
  devServer: {
    static: {
        directory: path.join(__dirname, 'public'),
    },
    compress: true,
    port: 3000
    }
};
EOF
}
function write_babel_rc {
    cat << EOF > .babelrc
{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}
EOF

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