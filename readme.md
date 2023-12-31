
# 🚀 Minimal React App

Create a minimal React project with just the essentials.I got tired of dealing with outdated dependencies that i probably don't even need when using `npx create-react-app`. This script provides a lean setup with only `react-router-dom` and `axios`, along with a basic routing structure to navigate around the app client-side.

Interested in learning more about routing? Check out the [React Router Overview](https://reactrouter.com/en/main/start/overview).

## 📌 Installation

To get started, first clone the repository:

```
$ git clone https://github.com/ddcroft73/create-react-mini.git target-directory
```

## 🛠 Usage

To create a project in a new directory:

```
$ ./min-react-app.sh project-name
```

To create a project in the current directory:

```
$ ./min-react-app.sh .
```

## 🚴‍♂️ Getting Started

Once you've created your app, navigate into the new project directory:

```
$ cd project_directory
$ npm install
$ npm start
```

This will serve your app on `http://localhost:3000`.

## 🌟 Future Enhancements

If not already done,  I'll  introduce some basic components like `Box`, `Button`, `Paper`, and more to kickstart the app development.
I plan to beef up the components to demo the `<Link>` component and the use of `useNavigate`.

## Notes:

As is, you can test it by appending `/about` to the URL in the browser to go to about, and then `/` to go back, or the `back` button. 