import './App.css';

function App() {

  return (
    <div>
    <header>
      <h1>My Simple React Home Page</h1>
    </header>
    <main>
      <p>Welcome to my simple React home page! This is a basic example of a React project.</p>
      <img src="https://picsum.photos/200" alt="Placeholder" />
      <button onClick={() => {window.location.href="/"}}>New Image</button>
    </main>
  </div>
);

}

export default App;
