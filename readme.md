
## React minimal 

A Bash script that generates a react project. It's like `npx create-react-app` without all the out of date dependencies.
In fact all it has is react-router-dom and axios. Thats it. 

clone the repo:
```
$ git clone https://github.com/ddcroft73/create-react-mini.git target-directory
```

Usage:
```
$ ./cra.sh project-name
```
Will create a project in project_name in the current directory.

```
$ ./cra.sh .
```
Will create a project in the current directory.

Thats pretty much it. If I haven't yet I am in the process of adding routing to App.js to give it a decent start and throwing in some basic components to build with. Box, Button, Paper, etc..
