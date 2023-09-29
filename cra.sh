#!/bin/bash

# bash script that creates a minimalistic React app. Just what you need to run React and react-router-dom.
# Any other dependencies can be installed by hand. 

 function check_and_install_jq {
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        echo "jq is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y jq
    else
        echo "jq is already installed."
    fi
}
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
import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";

// Import your components here
import Home from "./components/Home";
import About from "./components/About"; // Just an example
import './App.css'

const App = () => {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<About />} /> // Just an example
            </Routes>
        </Router>
    );
};

export default App;
EOF
}
function write_app_css {
   cat << EOF > src/App.css
body {
    font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New';
    color: rgb(60, 64, 32);
    background-color: rgb(163, 140, 140);
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
    port: 3000,
        historyApiFallback: true
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
function write_Box_js {
    cat << EOF > src/components/elements/Box.js
import React from "react";

const Box = ({ children, style }) => {
    
    const defaultStyle = {
        width: 'auto',
        height: 'auto',
        border: '1px solid black',
        borderRadius: '8px',
        padding: 10,
    };

    return (
        <div style={{ ...defaultStyle, ...style }}>
            {children}
        </div>
    );
}

export default Box;
EOF
}
function write_Home_js {
    cat << EOF > src/components/Home.js
import Box from "./elements/Box";
import React from "react";

function Home() {
    return (
        <Box
            style={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                marginTop: "50px",
            }}
        >
            <Box>
                <h1>Home</h1>
            </Box>
        </Box>
    );
};

export default Home;
EOF
}
function write_About_js {
    cat << EOF > src/components/About.js
import Box from "./elements/Box";
import React from "react";

function About() {
    return (
        <Box
            style={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                marginTop: "50px",
            }}
        >
            <Box>
                <h1>About</h1>
            </Box>
        </Box>
    );
};

export default About;
EOF
}
function install_react_and_dependencies {
    # Install React and ReactDOM
    npm install react react-dom react-router-dom
    # Install Webpack, Babel, and loaders
    npm install --save-dev webpack webpack-cli webpack-dev-server @babel/core @babel/preset-env @babel/preset-react babel-loader css-loader style-loader mini-css-extract-plugin
    npm install axios 
}
function create_directories_and_files {      
    # Create a new directory and initialize it
    mkdir $PROJECT_DIR
    cd $PROJECT_DIR
    npm init -y

    # Create basic directory structure
    mkdir public src src/components src/components/elements

    # Files
    touch public/index.html 
    touch public/manifest.json 
    touch src/App.js src/index.js src/App.css 
    touch src/components/readme.md 
    touch src/components/elements/Box.js
    touch src/components/Home.js src/components/About.js

    # files in project root
    touch TODO.txt readme.md 
    touch webpack.config.js
    touch .babelrc
}

# START SCRIPT 

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

check_and_install_jq
install_react_and_dependencies
create_directories_and_files
# Add scripts to package.json
jq '.scripts += {"start": "webpack serve", "build": "webpack --mode production"}' package.json > temp.json && mv temp.json package.json

# edit all the files needed to build the project
write_webpack_config_js
write_babel_rc
write_index_html
write_manifest_json
write_app_js
write_app_css
write_index_js
write_Box_js
write_Home_js
write_About_js